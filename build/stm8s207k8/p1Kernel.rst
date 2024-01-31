ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 1.
Hexadecimal [24-Bits]



                                      1 ;;
                                      2 ; Copyright Jacques Deschênes 2019,2022  
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
                                     19 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     20 ;;; hardware initialisation
                                     21 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
                                     22 
                                     23 ;------------------------
                                     24 ; if unified compilation 
                                     25 ; must be first in list 
                                     26 ;-----------------------
                                     27 
                                     28     .module HW_INIT 
                                     29 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 2.
Hexadecimal [24-Bits]



                                     30     .include "config.inc"
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



                                     31 
                           000004    32 SYS_VARS_ORG=4 
                                     33 
                                     34 ;;-----------------------------------
                                     35     .area SSEG (ABS)
                                     36 ;; working buffers and stack at end of RAM. 	
                                     37 ;;-----------------------------------
      001680                         38     .org RAM_SIZE-STACK_SIZE-TIB_SIZE-PAD_SIZE 
      001680                         39 tib:: .ds TIB_SIZE             ; terminal input buffer
      001700                         40 block_buffer::                 ; use to write FLASH block (alias for pad )
      001700                         41 pad:: .ds PAD_SIZE             ; working buffer
      001780                         42 stack_full:: .ds STACK_SIZE   ; control stack 
      001800                         43 stack_unf:: ; stack underflow ; control_stack underflow 
                                     44 
                                     45 
                                     46 ;--------------------------------
                                     47 	.area DATA (REL,CON) 
                                     48 ;	.org SYS_VARS_ORG  
                                     49 ;---------------------------------
                                     50 
                                     51 ; kernel variables 
      000001                         52 ticks:: .blkw 1 ; millisecond system ticks 
      000003                         53 timer:: .blkw 1 ; msec count down timer 
      000005                         54 tone_ms:: .blkw 1 ; tone duration msec 
      000007                         55 sys_flags:: .blkb 1; system boolean flags 
      000008                         56 seedx:: .blkw 1  ; bits 31...15 used by 'prng' function
      00000A                         57 seedy:: .blkw 1  ; bits 15...0 used by 'prng' function 
      00000C                         58 base:: .blkb 1 ;  numeric base used by 'print_int' 
      00000D                         59 fmstr:: .blkb 1 ; Fmaster frequency in Mhz
      00000E                         60 farptr:: .blkb 1 ; 24 bits pointer used by file system, upper-byte
      00000F                         61 ptr16::  .blkb 1 ; 16 bits pointer , farptr high-byte 
      000010                         62 ptr8::   .blkb 1 ; 8 bits pointer, farptr low-byte  
      000011                         63 trap_ret:: .blkw 1 ; trap return address 
      000013                         64 kvars_end:: 
                           000012    65 SYS_VARS_SIZE==kvars_end-ticks   
                                     66 
                                     67 ; system boolean flags 
                           000000    68 FSYS_TIMER==0 
                           000001    69 FSYS_TONE==1 
                           000002    70 FSYS_UPPER==2 ; getc uppercase all letters 
                                     71   
                                     72 ;;--------------------------------------
                                     73     .area HOME
                                     74 ;; interrupt vector table at 0x8000
                                     75 ;;--------------------------------------
                                     76 
      008000 82 00 81 22             77     int cold_start			; RESET vector 
      008004 82 00 82 2D             78 	int TrapHandler         ; trap instruction 
      008008 82 00 80 80             79 	int NonHandledInterrupt ;int0 TLI   external top level interrupt
      00800C 82 00 80 80             80 	int NonHandledInterrupt ;int1 AWU   auto wake up from halt
      008010 82 00 80 80             81 	int NonHandledInterrupt ;int2 CLK   clock controller
      008014 82 00 80 80             82 	int NonHandledInterrupt ;int3 EXTI0 gpio A external interrupts
      008018 82 00 80 80             83 	int NonHandledInterrupt ;int4 EXTI1 gpio B external interrupts
      00801C 82 00 80 80             84 	int NonHandledInterrupt ;int5 EXTI2 gpio C external interrupts
      008020 82 00 80 80             85 	int NonHandledInterrupt ;int6 EXTI3 gpio D external interrupts
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 39.
Hexadecimal [24-Bits]



      008024 82 00 80 80             86 	int NonHandledInterrupt ;int7 EXTI4 gpio E external interrupt 
      008028 82 00 80 80             87 	int NonHandledInterrupt ;int8 beCAN RX interrupt
      00802C 82 00 80 80             88 	int NonHandledInterrupt ;int9 beCAN TX/ER/SC interrupt
      008030 82 00 80 80             89 	int NonHandledInterrupt ;int10 SPI End of transfer
      008034 82 00 80 80             90 	int NonHandledInterrupt ;int11 TIM1 update/overflow/underflow/trigger/break
      008038 82 00 80 80             91 	int NonHandledInterrupt ;int12 TIM1 ; TIM1 capture/compare
      00803C 82 00 80 80             92 	int NonHandledInterrupt ;int13 TIM2 update /overflow
      008040 82 00 80 80             93 	int NonHandledInterrupt ;int14 TIM2 capture/compare
      008044 82 00 80 80             94 	int NonHandledInterrupt ;int15 TIM3 Update/overflow
      008048 82 00 80 80             95 	int NonHandledInterrupt ;int16 TIM3 Capture/compare
      00804C 82 00 80 80             96 	int NonHandledInterrupt ;int17 UART1 TX completed
                           000000    97 .if NUCLEO_8S208RB  
                                     98 	int UartRxHandler		;int18 UART1 RX full 
                           000001    99 .else 
      008050 82 00 80 80            100 	int NonHandledInterrupt ;int18 UART1 RX full 
                                    101 .endif 
      008054 82 00 80 80            102 	int NonHandledInterrupt ; int19 i2c
      008058 82 00 80 80            103 	int NonHandledInterrupt ;int20 UART3 TX completed
                           000001   104 .if NUCLEO_8S207K8  
      00805C 82 00 84 DF            105 	int UartRxHandler 		;int21 UART3 RX full
                           000000   106 .else 
                                    107 	int NonHandledInterrupt ;int21 UART3 RX full
                                    108 .endif 
      008060 82 00 80 80            109 	int NonHandledInterrupt ;int22 ADC2 end of conversion
      008064 82 00 82 C6            110 	int Timer4UpdateHandler	;int23 TIM4 update/overflow ; used as msec ticks counter
      008068 82 00 80 80            111 	int NonHandledInterrupt ;int24 flash writing EOP/WR_PG_DIS
      00806C 82 00 80 80            112 	int NonHandledInterrupt ;int25  not used
      008070 82 00 80 80            113 	int NonHandledInterrupt ;int26  not used
      008074 82 00 80 80            114 	int NonHandledInterrupt ;int27  not used
      008078 82 00 80 80            115 	int NonHandledInterrupt ;int28  not used
      00807C 82 00 80 80            116 	int NonHandledInterrupt ;int29  not used
                                    117 
                                    118 
                                    119 	.area CODE 
                                    120 ;	.org 0x8080 
                                    121 
                                    122 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    123 ; non handled interrupt 
                                    124 ;;;;;;;;;;;;;;;;;;;;;;;;;;;
      008080                        125 NonHandledInterrupt::
      008080 80               [11]  126 	iret 
                                    127 
                                    128 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    129 ;    peripherals initialization
                                    130 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    131 
                                    132 ;----------------------------------------
                                    133 ; inialize MCU clock 
                                    134 ; input:
                                    135 ;   A       fmstr Mhz 
                                    136 ;   XL      CLK_CKDIVR , clock divisor
                                    137 ;   XH     HSI|HSE   
                                    138 ; output:
                                    139 ;   none 
                                    140 ;----------------------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 40.
Hexadecimal [24-Bits]



      008081                        141 clock_init:	
      000001                        142 	_straz fmstr
      008081 B7 0D                    1     .byte 0xb7,fmstr 
      008083 9E               [ 1]  143 	ld a,xh ; clock source HSI|HSE 
      008084 72 17 50 C5      [ 1]  144 	bres CLK_SWCR,#CLK_SWCR_SWIF 
      008088 C1 50 C3         [ 1]  145 	cp a,CLK_CMSR 
      00808B 27 0C            [ 1]  146 	jreq 2$ ; no switching required 
                                    147 ; select clock source 
      00808D C7 50 C4         [ 1]  148 	ld CLK_SWR,a
      008090 72 07 50 C5 FB   [ 2]  149 	btjf CLK_SWCR,#CLK_SWCR_SWIF,. 
      008095 72 12 50 C5      [ 1]  150 	bset CLK_SWCR,#CLK_SWCR_SWEN
      008099                        151 2$: 	
                                    152 ; cpu clock divisor 
      008099 9F               [ 1]  153 	ld a,xl 
      00809A C7 50 C6         [ 1]  154 	ld CLK_CKDIVR,a  
      00809D 72 5F 50 C6      [ 1]  155 	clr CLK_CKDIVR 
      0080A1 81               [ 4]  156 	ret
                                    157 
                                    158 ;----------------------------------
                                    159 ; TIMER2 used as audio tone output 
                                    160 ; on port D:5. CN9-6
                                    161 ; channel 1 configured as PWM mode 1 
                                    162 ;-----------------------------------  
      0080A2                        163 timer2_init:
      0080A2 72 1A 50 C7      [ 1]  164 	bset CLK_PCKENR1,#CLK_PCKENR1_TIM2 ; enable TIMER2 clock 
      0080A6 35 60 53 05      [ 1]  165  	mov TIM2_CCMR1,#(6<<TIM2_CCMR_OCM) ; PWM mode 1 
      0080AA 35 06 53 0C      [ 1]  166 	mov TIM2_PSCR,#6 ; fmstr/64
      0080AE 81               [ 4]  167 	ret 
                                    168 
                                    169 ;---------------------------------
                                    170 ; TIM4 is configured to generate an 
                                    171 ; interrupt every millisecond 
                                    172 ;----------------------------------
      0080AF                        173 timer4_init:
      0080AF 72 18 50 C7      [ 1]  174 	bset CLK_PCKENR1,#CLK_PCKENR1_TIM4
      0080B3 72 11 53 40      [ 1]  175 	bres TIM4_CR1,#TIM4_CR1_CEN 
      0080B7 C6 00 0D         [ 1]  176 	ld a,fmstr 
      0080BA AE 00 E8         [ 2]  177 	ldw x,#0xe8 
      0080BD 42               [ 4]  178 	mul x,a
      0080BE 89               [ 2]  179 	pushw x 
      0080BF AE 00 03         [ 2]  180 	ldw x,#3 
      0080C2 42               [ 4]  181 	mul x,a 
      0080C3 5E               [ 1]  182 	swapw x 
      0080C4 72 FB 01         [ 2]  183 	addw x,(1,sp) 
      000047                        184 	_drop 2  
      0080C7 5B 02            [ 2]    1     addw sp,#2 
      0080C9 4F               [ 1]  185 	clr a 
      0080CA                        186 0$:	 
      0080CA A3 01 00         [ 2]  187 	cpw x,#256 
      0080CD 2B 04            [ 1]  188 	jrmi 1$ 
      0080CF 4C               [ 1]  189 	inc a 
      0080D0 54               [ 2]  190 	srlw x 
      0080D1 20 F7            [ 2]  191 	jra 0$ 
      0080D3                        192 1$:
      0080D3 C7 53 45         [ 1]  193 	ld TIM4_PSCR,a 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 41.
Hexadecimal [24-Bits]



      0080D6 9F               [ 1]  194 	ld a,xl 
      0080D7 C7 53 46         [ 1]  195 	ld TIM4_ARR,a
      0080DA 35 05 53 40      [ 1]  196 	mov TIM4_CR1,#((1<<TIM4_CR1_CEN)|(1<<TIM4_CR1_URS))
      0080DE 72 10 53 41      [ 1]  197 	bset TIM4_IER,#TIM4_IER_UIE
                                    198 ; set int level to 1 
      0080E2 A6 01            [ 1]  199 	ld a,#ITC_SPR_LEVEL1 
      0080E4 AE 00 17         [ 2]  200 	ldw x,#INT_TIM4_OVF 
      0080E7 CD 80 EB         [ 4]  201 	call set_int_priority
      0080EA 81               [ 4]  202 	ret
                                    203 
                                    204 
                                    205 ;--------------------------
                                    206 ; set software interrupt 
                                    207 ; priority 
                                    208 ; input:
                                    209 ;   A    priority 1,2,3 
                                    210 ;   X    vector 
                                    211 ;---------------------------
                           000001   212 	SPR_ADDR=1 
                           000003   213 	PRIORITY=3
                           000004   214 	SLOT=4
                           000005   215 	MASKED=5  
                           000005   216 	VSIZE=5
      0080EB                        217 set_int_priority::
      00006B                        218 	_vars VSIZE
      0080EB 52 05            [ 2]    1     sub sp,#VSIZE 
      0080ED A4 03            [ 1]  219 	and a,#3  
      0080EF 6B 03            [ 1]  220 	ld (PRIORITY,sp),a 
      0080F1 A6 04            [ 1]  221 	ld a,#4 
      0080F3 62               [ 2]  222 	div x,a 
      0080F4 48               [ 1]  223 	sll a  ; slot*2 
      0080F5 6B 04            [ 1]  224 	ld (SLOT,sp),a
      0080F7 1C 7F 70         [ 2]  225 	addw x,#ITC_SPR1 
      0080FA 1F 01            [ 2]  226 	ldw (SPR_ADDR,sp),x 
                                    227 ; build mask
      0080FC AE FF FC         [ 2]  228 	ldw x,#0xfffc 	
      0080FF 7B 04            [ 1]  229 	ld a,(SLOT,sp)
      008101 27 05            [ 1]  230 	jreq 2$ 
      008103 99               [ 1]  231 	scf 
      008104 59               [ 2]  232 1$:	rlcw x 
      008105 4A               [ 1]  233 	dec a 
      008106 26 FC            [ 1]  234 	jrne 1$
      008108 9F               [ 1]  235 2$:	ld a,xl 
                                    236 ; apply mask to slot 
      008109 1E 01            [ 2]  237 	ldw x,(SPR_ADDR,sp)
      00810B F4               [ 1]  238 	and a,(x)
      00810C 6B 05            [ 1]  239 	ld (MASKED,sp),a 
                                    240 ; shift priority to slot 
      00810E 7B 03            [ 1]  241 	ld a,(PRIORITY,sp)
      008110 97               [ 1]  242 	ld xl,a 
      008111 7B 04            [ 1]  243 	ld a,(SLOT,sp)
      008113 27 04            [ 1]  244 	jreq 4$
      008115 58               [ 2]  245 3$:	sllw x 
      008116 4A               [ 1]  246 	dec a 
      008117 26 FC            [ 1]  247 	jrne 3$
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 42.
Hexadecimal [24-Bits]



      008119 9F               [ 1]  248 4$:	ld a,xl 
      00811A 1A 05            [ 1]  249 	or a,(MASKED,sp)
      00811C 1E 01            [ 2]  250 	ldw x,(SPR_ADDR,sp)
      00811E F7               [ 1]  251 	ld (x),a 
      00009F                        252 	_drop VSIZE 
      00811F 5B 05            [ 2]    1     addw sp,#VSIZE 
      008121 81               [ 4]  253 	ret 
                                    254 
                                    255 ;-------------------------------------
                                    256 ;  initialization entry point 
                                    257 ;-------------------------------------
      008122                        258 cold_start:
                                    259 ;at reset stack pointer is at RAM_END  
                                    260 ; clear all ram
      008122 96               [ 1]  261 	ldw x,sp 
                           000000   262 .if 0	
                                    263 0$: clr (x)
                                    264 	decw x 
                                    265 	jrne 0$
                                    266 .endif 	
                                    267 ; activate pull up on all inputs 
      008123 A6 FF            [ 1]  268 	ld a,#255 
      008125 C7 50 03         [ 1]  269 	ld PA_CR1,a 
      008128 C7 50 08         [ 1]  270 	ld PB_CR1,a 
      00812B C7 50 0D         [ 1]  271 	ld PC_CR1,a 
      00812E C7 50 12         [ 1]  272 	ld PD_CR1,a 
      008131 C7 50 17         [ 1]  273 	ld PE_CR1,a 
      008134 C7 50 1C         [ 1]  274 	ld PF_CR1,a 
      008137 C7 50 21         [ 1]  275 	ld PG_CR1,a 
      00813A C7 50 2B         [ 1]  276 	ld PI_CR1,a
                                    277 ; set user LED pin as output 
      00813D 72 1A 50 0D      [ 1]  278     bset LED_PORT+GPIO_CR1,#LED_BIT
      008141 72 1A 50 0E      [ 1]  279     bset LED_PORT+GPIO_CR2,#LED_BIT
      008145 72 1A 50 0C      [ 1]  280     bset LED_PORT+ GPIO_DDR,#LED_BIT
      008149 72 1B 50 0A      [ 1]  281 	bres LED_PORT+GPIO_ODR,#LED_BIT ; turn on user LED  
                                    282 ; disable schmitt triggers on Arduino CN4 analog inputs
      00814D 55 00 3F 54 07   [ 1]  283 	mov ADC_TDRL,0x3f
                                    284 ; select internal clock no divisor: 16 Mhz 	
      008152 A6 10            [ 1]  285 	ld a,#16 ; Mhz 
      008154 AE E1 00         [ 2]  286 	ldw x,#CLK_SWR_HSI<<8   ; high speed internal oscillator 
      008157 CD 80 81         [ 4]  287     call clock_init 
                                    288 ; UART at 115200 BAUD
                                    289 ; used for user interface 
      00815A AE 85 98         [ 2]  290 	ldw x,#uart_putc 
      00815D CF 00 17         [ 2]  291 	ldw out,x 
      008160 CD 85 10         [ 4]  292 	call uart_init
      008163 CD 80 AF         [ 4]  293 	call timer4_init ; msec ticks timer 
      008166 CD 80 A2         [ 4]  294 	call timer2_init ; tone generator 	
      008169 9A               [ 1]  295 	rim ; enable interrupts 
      00816A 35 0A 00 0C      [ 1]  296 	mov base,#10
      0000EE                        297 	_clrz sys_flags 
      00816E 3F 07                    1     .byte 0x3f, sys_flags 
      008170 CD 82 EB         [ 4]  298 	call beep_1khz  ;
      008173 AE FF FF         [ 2]  299 	ldw x,#-1
      008176 CD 83 91         [ 4]  300 	call set_seed 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 43.
Hexadecimal [24-Bits]



                                    301 
                                    302 ;jp spi_ram_test 
                                    303 ;jp eeprom_test 
                                    304 
      008179 CD 82 17         [ 4]  305     call kernel_show_version  	
      00817C CC 8C 04         [ 2]  306 	jp WOZMON
                                    307 
                           000001   308 .if 1
      00817F 72 14 00 07      [ 1]  309 	bset sys_flags,#FSYS_UPPER 
      008183 CD 85 EA         [ 4]  310 call new_line 	
      008186                        311 test: ; test compiler 
      008186 A6 3E            [ 1]  312 	ld a,#'> 
      008188 CD 85 81         [ 4]  313 	call putc 
      00818B CD 86 0D         [ 4]  314 	call readln 
      00818E CD 91 A2         [ 4]  315 	call compile 
      008191 CD 81 96         [ 4]  316 	call dump_code 
      008194 20 F0            [ 2]  317 	jra test 
                                    318 
      008196                        319 dump_code: 
      008196 90 AE 17 00      [ 2]  320 	ldw y,#pad 
      00819A 4B 10            [ 1]  321 	push #16  
      00819C 90 E6 02         [ 1]  322 	ld a,(2,y)
      00819F 88               [ 1]  323 	push a
      0081A0 90 9E            [ 1]  324 	ld a,yh 
      0081A2 CD 88 2A         [ 4]  325 	call print_hex 
      0081A5 90 9F            [ 1]  326 	ld a,yl  
      0081A7 CD 88 2A         [ 4]  327 	call print_hex
      0081AA AE 00 02         [ 2]  328 	ldw x,#2 
      0081AD CD 86 01         [ 4]  329 	call spaces 
      0081B0                        330 1$: 
      0081B0 90 F6            [ 1]  331 	ld a,(y)
      0081B2 CD 88 2A         [ 4]  332 	call print_hex 
      0081B5 CD 85 FB         [ 4]  333 	call space 
      0081B8 90 5C            [ 1]  334 	incw y
      0081BA 0A 02            [ 1]  335 	dec (2,sp)
      0081BC 26 17            [ 1]  336 	jrne 2$ 
      0081BE CD 85 EA         [ 4]  337 	call new_line 
      0081C1 90 9E            [ 1]  338 	ld a,yh 
      0081C3 CD 88 2A         [ 4]  339 	call print_hex 
      0081C6 90 9F            [ 1]  340 	ld a,yl  
      0081C8 CD 88 2A         [ 4]  341 	call print_hex
      0081CB AE 00 02         [ 2]  342 	ldw x,#2 
      0081CE CD 86 01         [ 4]  343 	call spaces 
      0081D1 A6 10            [ 1]  344 	ld a,#16
      0081D3 6B 02            [ 1]  345 	ld (2,sp),a 
      0081D5                        346 2$:
      0081D5 0A 01            [ 1]  347 	dec (1,sp) 
      0081D7 26 D7            [ 1]  348 	jrne 1$ 
      000159                        349 9$: _drop 2 
      0081D9 5B 02            [ 2]    1     addw sp,#2 
      0081DB CD 85 EA         [ 4]  350 	call new_line 
      0081DE AE 17 00         [ 2]  351 	ldw x,#pad   
      0081E1 E6 02            [ 1]  352 	ld a,(2,x)
      0081E3 CD 9E FF         [ 4]  353 	call prt_basic_line 
      0081E6 81               [ 4]  354 	ret 	
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 44.
Hexadecimal [24-Bits]



                                    355 .endif 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 45.
Hexadecimal [24-Bits]



                                      1 ;;
                                      2 ; Copyright Jacques Deschênes 2023  
                                      3 ; This file is part of pomme-1 
                                      4 ;
                                      5 ;     pomme-1 is free software: you can redistribute it and/or modify
                                      6 ;     it under the terms of the GNU General Public License as published by
                                      7 ;     the Free Software Foundation, either version 3 of the License, or
                                      8 ;     (at your option) any later version.
                                      9 ;
                                     10 ;     pomme-1 is distributed in the hope that it will be useful,
                                     11 ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                     12 ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                     13 ;     GNU General Public License for more details.
                                     14 ;
                                     15 ;     You should have received a copy of the GNU General Public License
                                     16 ;     along with pomme-1.  If not, see <http://www.gnu.org/licenses/>.
                                     17 ;;
                                     18 
                                     19     .module KERNEL 
                                     20 
                                     21 ;    .include "config.inc" 
                                     22 
                                     23 ;-----------------------
                                     24 ; a little kernel 
                                     25 ; to access TERMIOS 
                                     26 ; functions using 
                                     27 ; STM8 TRAP instruction
                                     28 ;------------------------
                                     29 
                           000001    30 KERNEL_MAJOR = 1
                           000000    31 KERNEL_MINOR = 0 
                           000002    32 KERNEL_REV = 2 
                                     33 
      0081E7 70 31 4B 65 72 6E 65    34 kernel_name: .asciz "p1Kernel\n" 
             6C 0A 00
      0081F1 43 6F 70 79 72 69 67    35 kernel_cpr: .asciz "Copyright Jacques Deschênes 2023,24\n"
             68 74 20 4A 61 63 71
             75 65 73 20 44 65 73
             63 68 C3 AA 6E 65 73
             20 32 30 32 33 2C 32
             34 0A 00
                                     36 
      008217                         37 kernel_show_version:
      008217 CD 85 F0         [ 4]   38     call clr_screen
      00821A AE 81 E7         [ 2]   39     ldw x,#kernel_name 
      00821D 90 AE 81 F1      [ 2]   40     ldw y,#kernel_cpr
      008221 4B 02            [ 1]   41     push #KERNEL_REV 
      008223 4B 00            [ 1]   42     push #KERNEL_MINOR 
      008225 4B 01            [ 1]   43     push #KERNEL_MAJOR  
      008227 CD 89 47         [ 4]   44     call app_info 
      0001AA                         45     _drop 3 
      00822A 5B 03            [ 2]    1     addw sp,#3 
      00822C 81               [ 4]   46     ret 
                                     47 
                                     48 ;---------------------------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 46.
Hexadecimal [24-Bits]



                                     49 ;  kernel functions table 
                                     50 ;  functions code is passed in A 
                                     51 ;  parameters are passed in X,Y
                                     52 ;  output returned in A,X,Y,CC  
                                     53 ;
                                     54 ;  code |  function      | input    |  output
                                     55 ;  -----|----------------|----------|---------
                                     56 ;    0  | reset system   | none     | none 
                                     57 ;    1  | ticks          | none     | X=msec ticker 
                                     58 ;    2  | putchar        | X=char   | none 
                                     59 ;    3  | getchar        | none     | A=char
                                     60 ;    4  | querychar      | none     | A=0,-1
                                     61 ;    5  | clr_screen     | none     | none 
                                     62 ;    6  | delback        | none     | none 
                                     63 ;    7  | getline        | xl=buflen | A= line length
                                     64 ;       |                | xh=lnlen  |  
                                     65 ;       |                | y=bufadr | 
                                     66 ;    8  | puts           | X=*str   | none 
                                     67 ;    9  | print_int      | X=int16  | none 
                                     68 ;       |                | A=unsigned| A=string length 
                                     69 ;    10 | set timer      | X=value  | none 
                                     70 ;   11  | check time out | none     | A=0|-1 
                                     71 ;   12  | génère une     | X=msec   | 
                                     72 ;       | tonalité audio | Y=Freq   | none
                                     73 ;   13  | stop tone      |  none    | none
                                     74 ;   14  | get random #   | none     | X = random value 
                                     75 ;   15  | seed prgn      | X=param  | none  
                                     76 ;----------------------------------------------
                                     77 ; syscall codes  
                                     78 ; global constants 
                           000000    79     SYS_RST==0
                           000001    80     SYS_TICKS=1 
                           000002    81     PUTC==2
                           000003    82     GETC==3 
                           000004    83     QCHAR==4
                           000005    84     CLS==5
                           000006    85     DELBK==6
                           000007    86     GETLN==7 
                           000008    87     PRT_STR==8
                           000009    88     PRT_INT==9 
                           00000A    89     SET_TIMER==10
                           00000B    90     CHK_TIMOUT==11 
                           00000C    91     START_TONE==12 
                           00000D    92     GET_RND==13
                           00000E    93     SEED_PRNG==14 
                                     94 
                                     95 ;;-------------------------------
                                     96     .area CODE
                                     97 
                                     98 ;;--------------------------------
                                     99 
                                    100 
                                    101 ;-------------------------
                                    102 ;  software interrupt handler 
                                    103 ;-------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 47.
Hexadecimal [24-Bits]



                                    104 
                                    105     .macro _syscode n, t 
                                    106     cp a,#n 
                                    107     jrne t   
                                    108     .endm 
                                    109 
      00822D                        110 TrapHandler::
                                    111 ; enable interrupts
                                    112 ; set I1:I0==1:0
                                    113 ; i.e. main level  
      00822D 8A               [ 1]  114     push cc 
      00822E 84               [ 1]  115     pop a 
      00822F A4 F7            [ 1]  116     and a,#~8
      008231 AA 20            [ 1]  117     or a,#32
      008233 88               [ 1]  118     push a 
      008234 86               [ 1]  119     pop cc 
                                    120 
                                    121 ;------------------------
                                    122 ; kernel services 
                                    123 ; switch 
                                    124 ;------------------------
      008235                        125 syscall_handler:      
      0001B5                        126     _syscode SYS_RST, 0$ 
      008235 A1 00            [ 1]    1     cp a,#SYS_RST 
      008237 26 04            [ 1]    2     jrne 0$   
      0001B9                        127     _swreset
      008239 35 80 50 D1      [ 1]    1     mov WWDG_CR,#0X80
      00823D                        128 0$:
      0001BD                        129     _syscode SYS_TICKS,1$
      00823D A1 01            [ 1]    1     cp a,#SYS_TICKS 
      00823F 26 05            [ 1]    2     jrne 1$   
      0001C1                        130     _ldxz ticks 
      008241 BE 01                    1     .byte 0xbe,ticks 
      008243 CC 82 C5         [ 2]  131     jp syscall_exit      
      008246                        132 1$:
      0001C6                        133     _syscode PUTC, 2$  
      008246 A1 02            [ 1]    1     cp a,#PUTC 
      008248 26 07            [ 1]    2     jrne 2$   
      00824A 9F               [ 1]  134     ld a,xl 
      00824B CD 85 98         [ 4]  135     call uart_putc
      00824E CC 82 C5         [ 2]  136     jp syscall_exit 
      008251                        137 2$:
      0001D1                        138     _syscode GETC,3$ 
      008251 A1 03            [ 1]    1     cp a,#GETC 
      008253 26 06            [ 1]    2     jrne 3$   
      008255 CD 85 AC         [ 4]  139     call uart_getc 
      008258 CC 82 C5         [ 2]  140     jp syscall_exit
      00825B                        141 3$:
      0001DB                        142     _syscode QCHAR,4$ 
      00825B A1 04            [ 1]    1     cp a,#QCHAR 
      00825D 26 05            [ 1]    2     jrne 4$   
      00825F CD 85 A6         [ 4]  143     call qgetc  
      008262 20 61            [ 2]  144     jra syscall_exit
      008264                        145 4$:
      0001E4                        146     _syscode CLS,5$ 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 48.
Hexadecimal [24-Bits]



      008264 A1 05            [ 1]    1     cp a,#CLS 
      008266 26 05            [ 1]    2     jrne 5$   
      008268 CD 85 F0         [ 4]  147     call clr_screen
      00826B 20 58            [ 2]  148     jra syscall_exit 
      00826D                        149 5$: 
      0001ED                        150     _syscode DELBK,6$ 
      00826D A1 06            [ 1]    1     cp a,#DELBK 
      00826F 26 05            [ 1]    2     jrne 6$   
      008271 CD 85 D8         [ 4]  151     call bksp  
      008274 20 4F            [ 2]  152     jra syscall_exit 
      008276                        153 6$: 
      0001F6                        154     _syscode GETLN , 7$
      008276 A1 07            [ 1]    1     cp a,#GETLN 
      008278 26 05            [ 1]    2     jrne 7$   
      00827A CD 86 0D         [ 4]  155     call readln  
      00827D 20 46            [ 2]  156     jra syscall_exit 
      00827F                        157 7$: 
      0001FF                        158     _syscode PRT_STR , 8$
      00827F A1 08            [ 1]    1     cp a,#PRT_STR 
      008281 26 05            [ 1]    2     jrne 8$   
      008283 CD 85 CD         [ 4]  159     call puts 
      008286 20 3D            [ 2]  160     jra syscall_exit
      008288                        161 8$: 
      000208                        162     _syscode PRT_INT , 9$
      008288 A1 09            [ 1]    1     cp a,#PRT_INT 
      00828A 26 05            [ 1]    2     jrne 9$   
      00828C CD 88 3C         [ 4]  163     call print_int
      00828F 20 34            [ 2]  164     jra syscall_exit      
      008291                        165 9$: 
      000211                        166     _syscode SET_TIMER , 10$
      008291 A1 0A            [ 1]    1     cp a,#SET_TIMER 
      008293 26 08            [ 1]    2     jrne 10$   
      008295 72 11 00 07      [ 1]  167     bres sys_flags,#FSYS_TIMER 
      000219                        168     _strxz timer 
      008299 BF 03                    1     .byte 0xbf,timer 
      00829B 20 28            [ 2]  169     jra syscall_exit 
      00829D                        170 10$:
      00021D                        171     _syscode CHK_TIMOUT, 11$
      00829D A1 0B            [ 1]    1     cp a,#CHK_TIMOUT 
      00829F 26 09            [ 1]    2     jrne 11$   
      0082A1 4F               [ 1]  172     clr a 
      0082A2 72 01 00 07 1E   [ 2]  173     btjf sys_flags,#FSYS_TIMER,syscall_exit  
      0082A7 43               [ 1]  174     cpl a 
      0082A8 20 1B            [ 2]  175     jra syscall_exit
      0082AA                        176 11$: 
      00022A                        177     _syscode START_TONE , 12$    
      0082AA A1 0C            [ 1]    1     cp a,#START_TONE 
      0082AC 26 05            [ 1]    2     jrne 12$   
      0082AE CD 82 FA         [ 4]  178     call tone 
      0082B1 20 12            [ 2]  179     jra syscall_exit 
      0082B3                        180 12$: 
      000233                        181     _syscode GET_RND , 13$
      0082B3 A1 0D            [ 1]    1     cp a,#GET_RND 
      0082B5 26 05            [ 1]    2     jrne 13$   
      0082B7 CD 83 6F         [ 4]  182     call prng 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 49.
Hexadecimal [24-Bits]



      0082BA 20 09            [ 2]  183     jra syscall_exit 
      0082BC                        184 13$: 
      00023C                        185     _syscode SEED_PRNG , 14$
      0082BC A1 0E            [ 1]    1     cp a,#SEED_PRNG 
      0082BE 26 05            [ 1]    2     jrne 14$   
      0082C0 CD 83 91         [ 4]  186     call set_seed 
      0082C3 20 00            [ 2]  187     jra syscall_exit 
      0082C5                        188 14$: 
                                    189 
                                    190 ; bad codes ignored 
      0082C5                        191 syscall_exit:
      0082C5 80               [11]  192 iret 
                                    193 
                                    194 
                                    195 ;------------------------------
                                    196 ; TIMER 4 is used to maintain 
                                    197 ; a milliseconds 'ticks' counter
                                    198 ; and decrement 'timer' varaiable
                                    199 ; and 'tone_ms' variable .
                                    200 ; these 3 variables are unsigned  
                                    201 ; ticks range {0..65535}
                                    202 ; timer range {0..65535}
                                    203 ; tone_ms range {0..65535}
                                    204 ;--------------------------------
      0082C6                        205 Timer4UpdateHandler:
      0082C6 72 5F 53 42      [ 1]  206 	clr TIM4_SR 
      00024A                        207 	_incz ticks+1 
      0082CA 3C 02                    1     .byte 0x3c, ticks+1 
      0082CC 26 02            [ 1]  208 	jrne 0$ 
      00024E                        209 	_incz ticks
      0082CE 3C 01                    1     .byte 0x3c, ticks 
      0082D0                        210 0$:
      000250                        211 	_ldxz timer
      0082D0 BE 03                    1     .byte 0xbe,timer 
      0082D2 27 09            [ 1]  212 	jreq 1$
      0082D4 5A               [ 2]  213 	decw x 
      000255                        214 	_strxz timer 
      0082D5 BF 03                    1     .byte 0xbf,timer 
      0082D7 26 04            [ 1]  215 	jrne 1$ 
      0082D9 72 10 00 07      [ 1]  216 	bset sys_flags,#FSYS_TIMER  
      0082DD                        217 1$:
      00025D                        218     _ldxz tone_ms 
      0082DD BE 05                    1     .byte 0xbe,tone_ms 
      0082DF 27 09            [ 1]  219     jreq 2$ 
      0082E1 5A               [ 2]  220     decw x 
      000262                        221     _strxz tone_ms 
      0082E2 BF 05                    1     .byte 0xbf,tone_ms 
      0082E4 26 04            [ 1]  222     jrne 2$ 
      0082E6 72 13 00 07      [ 1]  223     bres sys_flags,#FSYS_TONE   
      0082EA                        224 2$: 
      0082EA 80               [11]  225 	iret 
                                    226 
                                    227 
                                    228 ;-----------------
                                    229 ; 1 Khz beep 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 50.
Hexadecimal [24-Bits]



                                    230 ;-----------------
      0082EB                        231 beep_1khz::
      0082EB 90 89            [ 2]  232 	pushw y 
      0082ED AE 00 64         [ 2]  233 	ldw x,#100
      0082F0 90 AE 03 E8      [ 2]  234 	ldw y,#1000
      0082F4 CD 82 FA         [ 4]  235 	call tone
      0082F7 90 85            [ 2]  236 	popw y
      0082F9 81               [ 4]  237 	ret 
                                    238 
                                    239 ;---------------------
                                    240 ; input:
                                    241 ;   Y   frequency 
                                    242 ;   x   duration 
                                    243 ;---------------------
                           000001   244 	DIVDHI=1   ; dividend 31..16 
                           000003   245 	DIVDLO=DIVDHI+INT_SIZE ; dividend 15..0 
                           000005   246 	DIVR=DIVDLO+INT_SIZE  ; divisor 
                           000006   247 	VSIZE=3*INT_SIZE  
      0082FA                        248 tone:: 
      00027A                        249 	_vars VSIZE 
      0082FA 52 06            [ 2]    1     sub sp,#VSIZE 
      00027C                        250 	_strxz tone_ms 
      0082FC BF 05                    1     .byte 0xbf,tone_ms 
      0082FE 72 12 00 07      [ 1]  251 	bset sys_flags,#FSYS_TONE    
      008302 17 05            [ 2]  252 	ldw (DIVR,sp),y  ; divisor  
      008304 90 AE 00 0D      [ 2]  253 	ldw y,#fmstr 
      008308 AE 3D 09         [ 2]  254 	ldw x,#15625 ; ftimer=fmstr*1e6/64
      00830B CD 83 C4         [ 4]  255 	call umstar    ; x product 15..0 , y=product 31..16 
      00028E                        256 	_i16_store DIVDLO  
      00830E 1F 03            [ 2]    1     ldw (DIVDLO,sp),x 
      008310 17 01            [ 2]  257 	ldw (DIVDHI,sp),y 
      000292                        258 	_i16_fetch DIVR ; DIVR=freq audio   
      008312 1E 05            [ 2]    1     ldw x,(DIVR,sp)
      008314 CD 84 2D         [ 4]  259 	call udiv32_16 
      008317 9E               [ 1]  260 	ld a,xh 
      008318 C7 53 0D         [ 1]  261 	ld TIM2_ARRH,a 
      00831B 9F               [ 1]  262 	ld a,xl 
      00831C C7 53 0E         [ 1]  263 	ld TIM2_ARRL,a 
                                    264 ; 50% duty cycle 
      00831F 54               [ 2]  265 	srlw x  
      008320 9E               [ 1]  266 	ld a,xh 
      008321 C7 53 0F         [ 1]  267 	ld TIM2_CCR1H,a 
      008324 9F               [ 1]  268 	ld a,xl
      008325 C7 53 10         [ 1]  269 	ld TIM2_CCR1L,a
      008328 72 10 53 08      [ 1]  270 	bset TIM2_CCER1,#TIM2_CCER1_CC1E
      00832C 72 10 53 00      [ 1]  271 	bset TIM2_CR1,#TIM2_CR1_CEN
      008330 72 10 53 04      [ 1]  272 	bset TIM2_EGR,#TIM2_EGR_UG 	
      008334                        273 0$: ; wait end of tone 
      008334 8F               [10]  274     wfi 
      008335 72 02 00 07 FA   [ 2]  275     btjt sys_flags,#FSYS_TONE ,0$    
      00833A                        276 tone_off: 
      00833A 72 11 53 08      [ 1]  277 	bres TIM2_CCER1,#TIM2_CCER1_CC1E
      00833E 72 11 53 00      [ 1]  278 	bres TIM2_CR1,#TIM2_CR1_CEN 
      0002C2                        279      _drop VSIZE 
      008342 5B 06            [ 2]    1     addw sp,#VSIZE 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 51.
Hexadecimal [24-Bits]



      008344 81               [ 4]  280 	ret 
                                    281 
                                    282 
                                    283 ;---------------------------------
                                    284 ; Pseudo Random Number Generator 
                                    285 ; XORShift algorithm.
                                    286 ;---------------------------------
                                    287 
                                    288 ;---------------------------------
                                    289 ;  seedx:seedy= x:y ^ seedx:seedy
                                    290 ; output:
                                    291 ;  X:Y   seedx:seedy new value   
                                    292 ;---------------------------------
      008345                        293 xor_seed32:
      008345 9E               [ 1]  294     ld a,xh 
      0002C6                        295     _xorz seedx 
      008346 B8 08                    1     .byte 0xb8,seedx 
      0002C8                        296     _straz seedx
      008348 B7 08                    1     .byte 0xb7,seedx 
      00834A 9F               [ 1]  297     ld a,xl 
      0002CB                        298     _xorz seedx+1 
      00834B B8 09                    1     .byte 0xb8,seedx+1 
      0002CD                        299     _straz seedx+1 
      00834D B7 09                    1     .byte 0xb7,seedx+1 
      00834F 90 9E            [ 1]  300     ld a,yh 
      0002D1                        301     _xorz seedy
      008351 B8 0A                    1     .byte 0xb8,seedy 
      0002D3                        302     _straz seedy 
      008353 B7 0A                    1     .byte 0xb7,seedy 
      008355 90 9F            [ 1]  303     ld a,yl 
      0002D7                        304     _xorz seedy+1 
      008357 B8 0B                    1     .byte 0xb8,seedy+1 
      0002D9                        305     _straz seedy+1 
      008359 B7 0B                    1     .byte 0xb7,seedy+1 
      0002DB                        306     _ldxz seedx  
      00835B BE 08                    1     .byte 0xbe,seedx 
      0002DD                        307     _ldyz seedy 
      00835D 90 BE 0A                 1     .byte 0x90,0xbe,seedy 
      008360 81               [ 4]  308     ret 
                                    309 
                                    310 ;-----------------------------------
                                    311 ;   x:y= x:y << a 
                                    312 ;  input:
                                    313 ;    A     shift count 
                                    314 ;    X:Y   uint32 value 
                                    315 ;  output:
                                    316 ;    X:Y   uint32 shifted value   
                                    317 ;-----------------------------------
      008361                        318 sll_xy_32: 
      008361 90 58            [ 2]  319     sllw y 
      008363 59               [ 2]  320     rlcw x
      008364 4A               [ 1]  321     dec a 
      008365 26 FA            [ 1]  322     jrne sll_xy_32 
      008367 81               [ 4]  323     ret 
                                    324 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 52.
Hexadecimal [24-Bits]



                                    325 ;-----------------------------------
                                    326 ;   x:y= x:y >> a 
                                    327 ;  input:
                                    328 ;    A     shift count 
                                    329 ;    X:Y   uint32 value 
                                    330 ;  output:
                                    331 ;    X:Y   uint32 shifted value   
                                    332 ;-----------------------------------
      008368                        333 srl_xy_32: 
      008368 54               [ 2]  334     srlw x 
      008369 90 56            [ 2]  335     rrcw y 
      00836B 4A               [ 1]  336     dec a 
      00836C 26 FA            [ 1]  337     jrne srl_xy_32 
      00836E 81               [ 4]  338     ret 
                                    339 
                                    340 ;-------------------------------------
                                    341 ;  PRNG generator proper 
                                    342 ; input:
                                    343 ;   none 
                                    344 ; ouput:
                                    345 ;   X     bits 31...16  PRNG seed  
                                    346 ;  use: 
                                    347 ;   seedx:seedy   system variables   
                                    348 ;--------------------------------------
      00836F                        349 prng::
      00836F 90 89            [ 2]  350 	pushw y   
      0002F1                        351     _ldxz seedx
      008371 BE 08                    1     .byte 0xbe,seedx 
      0002F3                        352 	_ldyz seedy  
      008373 90 BE 0A                 1     .byte 0x90,0xbe,seedy 
      008376 A6 0D            [ 1]  353 	ld a,#13
      008378 CD 83 61         [ 4]  354     call sll_xy_32 
      00837B CD 83 45         [ 4]  355     call xor_seed32
      00837E A6 11            [ 1]  356     ld a,#17 
      008380 CD 83 68         [ 4]  357     call srl_xy_32
      008383 CD 83 45         [ 4]  358     call xor_seed32 
      008386 A6 05            [ 1]  359     ld a,#5 
      008388 CD 83 61         [ 4]  360     call sll_xy_32
      00838B CD 83 45         [ 4]  361     call xor_seed32
      00838E 90 85            [ 2]  362     popw y 
      008390 81               [ 4]  363     ret 
                                    364 
                                    365 
                                    366 ;---------------------------------
                                    367 ; initialize seedx:seedy 
                                    368 ; input:
                                    369 ;    X    0 -> seedx=ticks, seedy=tib[0..1] 
                                    370 ;    X    !0 -> seedx=X, seedy=[0x60<<8|XL]
                                    371 ;-------------------------------------------
      008391                        372 set_seed::
      008391 5D               [ 2]  373     tnzw x 
      008392 26 0B            [ 1]  374     jrne 1$ 
      008394 CE 00 01         [ 2]  375     ldw x,ticks 
      000317                        376     _strxz seedx
      008397 BF 08                    1     .byte 0xbf,seedx 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 53.
Hexadecimal [24-Bits]



      008399 CE 16 80         [ 2]  377     ldw x,tib 
      00031C                        378     _strxz seedy  
      00839C BF 0A                    1     .byte 0xbf,seedy 
      00839E 81               [ 4]  379     ret 
      00839F                        380 1$:  
      00031F                        381     _strxz seedx
      00839F BF 08                    1     .byte 0xbf,seedx 
      000321                        382     _clrz seedy 
      0083A1 3F 0A                    1     .byte 0x3f, seedy 
      000323                        383     _clrz seedy+1
      0083A3 3F 0B                    1     .byte 0x3f, seedy+1 
      0083A5 81               [ 4]  384     ret 
                                    385 
                                    386  
                                    387      
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 54.
Hexadecimal [24-Bits]



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
                                     22 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     23 ;;  Arithmetic operators
                                     24 ;;  16/32 bits integers
                                     25 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     26 
                                     27 ;	.include "config.inc"
                                     28 
                                     29 ;-------------------------------------
                                     30 	.area DATA
                                     31 ;---------------------------------------
                                     32 
      000013                         33 acc32: .blkb 1 ; 32 bit accumalator upper-byte 
      000014                         34 acc24: .blkb 1 ; 24 bits accumulator upper-byte 
      000015                         35 acc16:: .blkb 1 ; 16 bits accumulator, acc24 high-byte
      000016                         36 acc8::  .blkb 1 ;  8 bits accumulator, acc24 low-byte  
      000017                         37 arithm_vars_end:
                           000004    38 ARITHM_VARS_SIZE=arithm_vars_end-acc32 
                                     39 
                                     40 ;----------------------------------
                                     41 	.area CODE
                                     42 ;----------------------------------
                                     43 
                                     44 ;-------------------------------
                                     45 ; acc16 2's complement 
                                     46 ;-------------------------------
      0083A6                         47 neg_acc16:
      0083A6 72 53 00 15      [ 1]   48 	cpl acc16 
      0083AA 72 53 00 16      [ 1]   49 	cpl acc8 
      00032E                         50 	_incz acc8
      0083AE 3C 16                    1     .byte 0x3c, acc8 
      0083B0 26 02            [ 1]   51 	jrne 1$ 
      000332                         52 	_incz acc16 
      0083B2 3C 15                    1     .byte 0x3c, acc16 
      0083B4 81               [ 4]   53 1$: ret 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 55.
Hexadecimal [24-Bits]



                                     54 
                                     55 ;----------------------------------------
                                     56 ;  unsigned multiply uint16*uint8 
                                     57 ;  input:
                                     58 ;     X     uint16 
                                     59 ;     A     uint8
                                     60 ;  output:
                                     61 ;     X     product 
                                     62 ;-----------------------------------------
      0083B5                         63 umul16_8::
      0083B5 89               [ 2]   64 	pushw x 
      0083B6 42               [ 4]   65 	mul x,a
      0083B7 89               [ 2]   66 	pushw x 
      0083B8 1E 03            [ 2]   67 	ldw x,(3,SP)
      0083BA 5E               [ 1]   68 	swapw x 
      0083BB 42               [ 4]   69 	mul x,a
      0083BC 4F               [ 1]   70 	clr a 
      0083BD 02               [ 1]   71 	rlwa x ; if a<>0 then overlflow  
      0083BE 72 FB 01         [ 2]   72 	addw x,(1,sp)
      000341                         73 	_drop 4 
      0083C1 5B 04            [ 2]    1     addw sp,#4 
      0083C3 81               [ 4]   74 	ret 
                                     75 
                                     76 ;--------------------------------------
                                     77 ;  multiply 2 uint16_t return uint32_t
                                     78 ;  input:
                                     79 ;     x       uint16_t 
                                     80 ;     y       uint16_t 
                                     81 ;  output:
                                     82 ;     x       product bits 15..0
                                     83 ;     y       product bits 31..16 
                                     84 ;---------------------------------------
                           000001    85 		U1=1  ; uint16_t 
                           000003    86 		DPROD=U1+INT_SIZE ; uint32_t
                           000006    87 		VSIZE=3*INT_SIZE 
      0083C4                         88 umstar:
      000344                         89 	_vars VSIZE 
      0083C4 52 06            [ 2]    1     sub sp,#VSIZE 
      0083C6 1F 01            [ 2]   90 	ldw (U1,sp),x
      0083C8 0F 05            [ 1]   91 	clr (DPROD+2,sp)
      0083CA 0F 06            [ 1]   92 	clr (DPROD+3,sp) 
                                     93 ; DPROD=u1hi*u2hi
      0083CC 90 9E            [ 1]   94 	ld a,yh 
      0083CE 5E               [ 1]   95 	swapw x 
      0083CF 42               [ 4]   96 	mul x,a 
      0083D0 1F 03            [ 2]   97 	ldw (DPROD,sp),x
                                     98 ; DPROD+1 +=u1hi*u2lo 
      0083D2 7B 01            [ 1]   99 	ld a,(U1,sp)
      0083D4 97               [ 1]  100 	ld xl,a 
      0083D5 90 9F            [ 1]  101 	ld a,yl 
      0083D7 42               [ 4]  102 	mul x,a 
      0083D8 72 FB 04         [ 2]  103 	addw x,(DPROD+1,sp)
      0083DB 24 02            [ 1]  104 	jrnc 1$ 
      0083DD 0C 03            [ 1]  105 	inc (DPROD,sp)
      0083DF 1F 04            [ 2]  106 1$: ldw (DPROD+1,sp),x 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 56.
Hexadecimal [24-Bits]



                                    107 ; DPROD+1 += u1lo*u2hi 
      0083E1 7B 02            [ 1]  108 	ld a,(U1+1,sp)
      0083E3 97               [ 1]  109 	ld xl,a 
      0083E4 90 9E            [ 1]  110 	ld a,yh 
      0083E6 42               [ 4]  111 	mul x,a 
      0083E7 72 FB 04         [ 2]  112 	addw x,(DPROD+1,sp)
      0083EA 24 02            [ 1]  113 	jrnc 2$ 
      0083EC 0C 03            [ 1]  114 	inc (DPROD,sp)
      0083EE 1F 04            [ 2]  115 2$: ldw (DPROD+1,sp),x 
                                    116 ; DPROD+2+=u1lo*u2lo 
      0083F0 93               [ 1]  117 	ldw x,y  
      0083F1 7B 02            [ 1]  118 	ld a,(U1+1,sp)
      0083F3 42               [ 4]  119 	mul x,a 
      0083F4 72 FB 05         [ 2]  120 	addw x,(DPROD+2,sp)
      0083F7 24 06            [ 1]  121 	jrnc 3$
      0083F9 0C 04            [ 1]  122 	inc (DPROD+1,sp)
      0083FB 26 02            [ 1]  123 	jrne 3$
      0083FD 0C 03            [ 1]  124 	inc (DPROD,sp)
      0083FF                        125 3$:
      0083FF 16 03            [ 2]  126 	ldw y,(DPROD,sp)
      000381                        127 	_drop VSIZE 
      008401 5B 06            [ 2]    1     addw sp,#VSIZE 
      008403 81               [ 4]  128 	ret
                                    129 
                                    130 
                                    131 ;-------------------------------------
                                    132 ; multiply 2 integers
                                    133 ; input:
                                    134 ;  	x       n1 
                                    135 ;   y 		n2 
                                    136 ; output:
                                    137 ;   A       overflow error code 
                                    138 ;	Y:X     double product
                                    139 ;-------------------------------------
                           000001   140 	SIGN=1
                           000001   141 	VSIZE=1
      008404                        142 multiply::
      000384                        143 	_vars VSIZE 
      008404 52 01            [ 2]    1     sub sp,#VSIZE 
      008406 0F 01            [ 1]  144 	clr (SIGN,sp)
      008408 5D               [ 2]  145 	tnzw x 
      008409 2A 03            [ 1]  146 	jrpl 1$
      00840B 03 01            [ 1]  147 	cpl (SIGN,sp)
      00840D 50               [ 2]  148 	negw x 
      00840E                        149 1$:	
      00840E 90 5D            [ 2]  150 	tnzw y   
      008410 2A 04            [ 1]  151 	jrpl 2$ 
      008412 03 01            [ 1]  152 	cpl (SIGN,sp)
      008414 90 50            [ 2]  153 	negw y 
      008416                        154 2$:	
      008416 CD 83 C4         [ 4]  155 	call umstar
      008419 4F               [ 1]  156 	clr a 
      00841A 90 5D            [ 2]  157 	tnzw y 
      00841C 26 03            [ 1]  158 	jrne 3$
      00841E 5D               [ 2]  159 	tnzw x 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 57.
Hexadecimal [24-Bits]



      00841F 2A 02            [ 1]  160 	jrpl 4$
      008421                        161 3$:
      008421 A6 02            [ 1]  162 	ld a,#ERR_GT32767
      008423                        163 4$:
      008423 0D 01            [ 1]  164 	tnz (SIGN,sp)
      008425 27 03            [ 1]  165 	jreq 5$
      008427 CD 84 5D         [ 4]  166 	call dneg 
      00842A                        167 5$:	
      0003AA                        168 	_drop VSIZE 
      00842A 5B 01            [ 2]    1     addw sp,#VSIZE 
      00842C 81               [ 4]  169 	ret
                                    170 
                                    171 
                                    172 ;--------------------------------------
                                    173 ; divide uint32_t/uint16_t
                                    174 ; return:  quotient and remainder 
                                    175 ; quotient expected to be uint16_t 
                                    176 ; input:
                                    177 ;   DBLDIVDND    on stack 
                                    178 ;   X            divisor 
                                    179 ; output:
                                    180 ;   X            quotient 
                                    181 ;   Y            remainder 
                                    182 ;---------------------------------------
                           000002   183 	VSIZE=2
      00842D                        184 	_argofs VSIZE 
                           000004     1     ARG_OFS=2+VSIZE 
      0003AD                        185 	_arg DBLDIVDND 1
                           000005     1     DBLDIVDND=ARG_OFS+1 
                                    186 	; local variables 
                           000001   187 	DIVISOR=1 
      0003AD                        188 udiv32_16:
      0003AD                        189 	_vars VSIZE 
      00842D 52 02            [ 2]    1     sub sp,#VSIZE 
      00842F 1F 01            [ 2]  190 	ldw (DIVISOR,sp),x	; save divisor 
      008431 1E 07            [ 2]  191 	ldw x,(DBLDIVDND+2,sp)  ; bits 15..0
      008433 16 05            [ 2]  192 	ldw y,(DBLDIVDND,sp) ; bits 31..16
      008435 90 5D            [ 2]  193 	tnzw y
      008437 26 06            [ 1]  194 	jrne long_division 
      008439 16 01            [ 2]  195 	ldw y,(DIVISOR,sp)
      00843B 65               [ 2]  196 	divw x,y
      0003BC                        197 	_drop VSIZE 
      00843C 5B 02            [ 2]    1     addw sp,#VSIZE 
      00843E 81               [ 4]  198 	ret
      00843F                        199 long_division:
      00843F 51               [ 1]  200 	exgw x,y ; hi in x, lo in y 
      008440 13 01            [ 2]  201 	cpw x,(DIVISOR,sp)
      008442 2B 05            [ 1]  202 	jrmi 0$
      008444 A6 02            [ 1]  203 	ld a,#ERR_GT32767
      008446 CC 96 75         [ 2]  204 	jp tb_error 
      008449                        205 0$:
      008449 A6 11            [ 1]  206 	ld a,#17 
      00844B                        207 1$:
      00844B 13 01            [ 2]  208 	cpw x,(DIVISOR,sp)
      00844D 25 03            [ 1]  209 	jrc 2$
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 58.
Hexadecimal [24-Bits]



      00844F 72 F0 01         [ 2]  210 	subw x,(DIVISOR,sp)
      008452 8C               [ 1]  211 2$:	ccf 
      008453 90 59            [ 2]  212 	rlcw y 
      008455 59               [ 2]  213 	rlcw x 
      008456 4A               [ 1]  214 	dec a
      008457 26 F2            [ 1]  215 	jrne 1$
      008459 51               [ 1]  216 	exgw x,y 
      0003DA                        217 	_drop VSIZE 
      00845A 5B 02            [ 2]    1     addw sp,#VSIZE 
      00845C 81               [ 4]  218 	ret
                                    219 
                                    220 ;-----------------------------
                                    221 ; negate double int.
                                    222 ; input:
                                    223 ;   x     bits 15..0
                                    224 ;   y     bits 31..16
                                    225 ; output: 
                                    226 ;   x     bits 15..0
                                    227 ;   y     bits 31..16
                                    228 ;-----------------------------
      00845D                        229 dneg:
      00845D 53               [ 2]  230 	cplw x 
      00845E 90 53            [ 2]  231 	cplw y 
      008460 5C               [ 1]  232 	incw x 
      008461 26 02            [ 1]  233 	jrne 1$  
      008463 90 5C            [ 1]  234 	incw y 
      008465 81               [ 4]  235 1$: ret 
                                    236 
                                    237 
                                    238 ;--------------------------------
                                    239 ; sign extend single to double
                                    240 ; input:
                                    241 ;   x    int16_t
                                    242 ; output:
                                    243 ;   x    int32_t bits 15..0
                                    244 ;   y    int32_t bits 31..16
                                    245 ;--------------------------------
      008466                        246 dbl_sign_extend:
      008466 90 5F            [ 1]  247 	clrw y
      008468 9E               [ 1]  248 	ld a,xh 
      008469 A4 80            [ 1]  249 	and a,#0x80 
      00846B 27 02            [ 1]  250 	jreq 1$
      00846D 90 53            [ 2]  251 	cplw y
      00846F 81               [ 4]  252 1$: ret 	
                                    253 
                                    254 
                                    255 ;----------------------------------F
                                    256 ; input:
                                    257 ;    dbl    int32_t on stack 
                                    258 ;    x 		n1   int16_t  divisor  
                                    259 ; output:
                                    260 ;    X      dbl/x  int16_t 
                                    261 ;    Y      remainder int16_t 
                                    262 ;----------------------------------
                           000008   263 	VSIZE=8
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 59.
Hexadecimal [24-Bits]



      008470                        264 	_argofs VSIZE 
                           00000A     1     ARG_OFS=2+VSIZE 
      0003F0                        265 	_arg DIVDNDHI 1 
                           00000B     1     DIVDNDHI=ARG_OFS+1 
      0003F0                        266 	_arg DIVDNDLO 3
                           00000D     1     DIVDNDLO=ARG_OFS+3 
                                    267 	; local variables
                           000001   268 	DBLHI=1
                           000003   269 	DBLLO=3 
                           000005   270 	SREMDR=5 ; sign remainder 
                           000006   271 	SQUOT=6 ; sign quotient 
                           000007   272 	DIVISR=7 ; divisor 
      0003F0                        273 div32_16::
                                    274 ; check for 0 divisor
      008470 5D               [ 2]  275 	tnzw x 
      008471 26 05            [ 1]  276     jrne 0$
      008473 A6 12            [ 1]  277 	ld a,#ERR_DIV0 
      008475 CC 96 75         [ 2]  278 	jp tb_error
      008478                        279 0$:
      0003F8                        280 	_vars VSIZE 
      008478 52 08            [ 2]    1     sub sp,#VSIZE 
      00847A 0F 05            [ 1]  281 	clr (SREMDR,sp)
      00847C 0F 06            [ 1]  282 	clr (SQUOT,sp)
                                    283 ; check divisor sign 	
      00847E 5D               [ 2]  284 	tnzw x 
      00847F 2A 03            [ 1]  285 	jrpl 1$
      008481 03 06            [ 1]  286 	cpl (SQUOT,sp)
      008483 50               [ 2]  287 	negw x
      008484 1F 07            [ 2]  288 1$:	ldw (DIVISR,sp),x
                                    289 ; copy arguments 
      008486 16 0B            [ 2]  290 	ldw y,(DIVDNDHI,sp)
      008488 1E 0D            [ 2]  291 	ldw x,(DIVDNDLO,sp)
      00848A 90 5D            [ 2]  292 	tnzw y 
      00848C 2A 07            [ 1]  293 	jrpl 2$ 
      00848E 03 06            [ 1]  294 	cpl (SQUOT,sp)
      008490 03 05            [ 1]  295 	cpl (SREMDR,sp)
      008492 CD 84 5D         [ 4]  296 	call dneg 
      008495                        297 2$:
      008495 1F 03            [ 2]  298 	ldw (DBLLO,sp),x 
      008497 17 01            [ 2]  299 	ldw (DBLHI,sp),y 
      008499 1E 07            [ 2]  300 	ldw x,(DIVISR,sp)
      00849B CD 84 2D         [ 4]  301 	call udiv32_16
                                    302 ; x=quotient 
                                    303 ; y=remainder 
                                    304 ; sign quotient
      00849E 0D 06            [ 1]  305 	tnz (SQUOT,sp)
      0084A0 2A 01            [ 1]  306 	jrpl 3$ 
      0084A2 50               [ 2]  307 	negw x 
      0084A3                        308 3$: ; sign remainder 
      0084A3 0D 05            [ 1]  309 	tnz (SREMDR,sp) 
      0084A5 2A 02            [ 1]  310 	jrpl 4$
      0084A7 90 50            [ 2]  311 	negw y 
      0084A9                        312 4$:	
      000429                        313 	_drop VSIZE 
      0084A9 5B 08            [ 2]    1     addw sp,#VSIZE 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 60.
Hexadecimal [24-Bits]



      0084AB 81               [ 4]  314 	ret 
                                    315 
                                    316 
                                    317 
                                    318 ;----------------------------------
                                    319 ; division x/y 
                                    320 ; input:
                                    321 ;    X       dividend
                                    322 ;    Y       divisor 
                                    323 ; output:
                                    324 ;    X       quotient
                                    325 ;    Y       remainder 
                                    326 ;-----------------------------------
                                    327 	; local variables 
                           000001   328 	DBLHI=1
                           000003   329 	DBLLO=3
                           000005   330 	DIVISR=5
                           000006   331 	VSIZE=6 
      0084AC                        332 divide:: 
      00042C                        333 	_vars VSIZE
      0084AC 52 06            [ 2]    1     sub sp,#VSIZE 
      0084AE 90 5D            [ 2]  334 	tnzw y 
      0084B0 26 05            [ 1]  335 	jrne 1$
      0084B2 A6 12            [ 1]  336 	ld a,#ERR_DIV0 
      0084B4 CC 96 75         [ 2]  337 	jp tb_error
      0084B7                        338 1$: 
      0084B7 17 05            [ 2]  339 	ldw (DIVISR,sp),y
      0084B9 CD 84 66         [ 4]  340 	call dbl_sign_extend
      0084BC 1F 03            [ 2]  341 	ldw (DBLLO,sp),x 
      0084BE 17 01            [ 2]  342 	ldw (DBLHI,sp),y 
      0084C0 1E 05            [ 2]  343 	ldw x,(DIVISR,sp)
      0084C2 CD 84 70         [ 4]  344 	call div32_16 
      000445                        345 	_drop VSIZE 
      0084C5 5B 06            [ 2]    1     addw sp,#VSIZE 
      0084C7 81               [ 4]  346 	ret
                                    347 
                                    348 
                                    349 ;----------------------------------
                                    350 ;  remainder resulting from euclidian 
                                    351 ;  division of x/y 
                                    352 ; input:
                                    353 ;   x   	dividend int16_t 
                                    354 ;   y 		divisor int16_t
                                    355 ; output:
                                    356 ;   X       n1%n2 
                                    357 ;----------------------------------
      0084C8                        358 modulo:
      0084C8 CD 84 AC         [ 4]  359 	call divide
      0084CB 93               [ 1]  360 	ldw x,y 
      0084CC 81               [ 4]  361 	ret 
                                    362 
                                    363 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 61.
Hexadecimal [24-Bits]



                                      1 ;;
                                      2 ; Copyright Jacques Deschênes 2019,2022 
                                      3 ; This file is part of PABasic 
                                      4 ;
                                      5 ;     PABasic is free software: you can redistribute it and/or modify
                                      6 ;     it under the terms of the GNU General Public License as published by
                                      7 ;     the Free Software Foundation, either version 3 of the License, or
                                      8 ;     (at your option) any later version.
                                      9 ;
                                     10 ;     PABasic is distributed in the hope that it will be useful,
                                     11 ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                     12 ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                     13 ;     GNU General Public License for more details.
                                     14 ;
                                     15 ;     You should have received a copy of the GNU General Public License
                                     16 ;     along with PABasic.  If not, see <http://www.gnu.org/licenses/>.
                                     17 ;;
                                     18 ;------------------------------
                                     19 ; This file is for functions 
                                     20 ; interfacing with VT100 terminal
                                     21 ; emulator.
                                     22 ; defined functions:
                                     23 ;   getc   wait for a character 
                                     24 ;   qgetc  check if char available 
                                     25 ;   putc   send a char to terminal
                                     26 ;   puts   print a string to terminal
                                     27 ;   readln  read text line from terminal 
                                     28 ;   spaces  print n spaces on terminal 
                                     29 ;   print_hex  print hex value from A 
                                     30 ;------------------------------
                                     31 
                           000000    32 ANSI=0
                                     33 
                                     34     .module TERMINAL  
                                     35 
                                     36 ;    .include "config.inc"
                                     37 
                                     38     .area CODE 
                                     39 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 62.
Hexadecimal [24-Bits]



                                     40 	.include "inc/ps2_codes.inc"
                                      1 
                                      2 ;;
                                      3 ; Copyright Jacques Deschênes 2023  
                                      4 ; This file is part of stm8_terminal 
                                      5 ;
                                      6 ;     stm8_terminal is free software: you can redistribute it and/or modify
                                      7 ;     it under the terms of the GNU General Public License as published by
                                      8 ;     the Free Software Foundation, either version 3 of the License, or
                                      9 ;     (at your option) any later version.
                                     10 ;
                                     11 ;     stm8_terminal is distributed in the hope that it will be useful,
                                     12 ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                     13 ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                     14 ;     GNU General Public License for more details.
                                     15 ;
                                     16 ;     You should have received a copy of the GNU General Public License
                                     17 ;     along with stm8_terminal.  If not, see <http://www.gnu.org/licenses/>.
                                     18 ;;
                                     19 
                                     20 ; PS/2 keyaboard scancode
                                     21     
                                     22 ; keyboard control codes 
                           0000FF    23 KBD_RESET =	0xFF  ; commande RAZ clavier
                           0000ED    24 KBD_LED =	0xED  ; commande de contr�le des LEDS du clavier
                           0000FE    25 KBD_RESEND =  0xFE  ; demande de renvoie de la commande ou le code clavier
                                     26  
                                     27 ; keyboard state codes 
                           0000AA    28 BAT_OK =	0xAA ; basic test ok 
                           0000FA    29 KBD_ACK =	0xFA ; keyboard acknowledge 
                           0000F0    30 KEY_REL =	0xF0 ; key released prefix 
                           0000E0    31 XT_KEY =	0xE0 ; extended key prefix 
                           0000E1    32 XT2_KEY =	0xE1 ; PAUSE key sequence introducer 8 characters 
                                     33  
                                     34 ; control keys 
                           00000D    35 SC_TAB =	    0x0D    ;standard
                           00005A    36 SC_ENTER =	    0x5A    ;standard
                           000058    37 SC_CAPS =	    0x58    ;standard
                           000077    38 SC_NUM =	    0x77    ;standard
                           00007E    39 SC_SCROLL   =	    0x7E    ;standard
                           000012    40 SC_LSHIFT =	    0x12    ;standard
                           000059    41 SC_RSHIFT =	    0x59    ;standard
                           000014    42 SC_LCTRL =	    0x14    ;standard
                           000011    43 SC_LALT =	    0x11    ;standard
                           000066    44 SC_BKSP =	    0x66    ;standard
                           000076    45 SC_ESC =	    0x76    ;standard
                           000005    46 SC_F1 =	    0x05    ;standard
                           000006    47 SC_F2 =	    0x06    ;standard
                           000004    48 SC_F3 =	    0x04    ;standard
                           00000C    49 SC_F4 =	    0x0c    ;standard
                           000003    50 SC_F5 =	    0x03    ;standard
                           00000B    51 SC_F6 =	    0x0b    ;standard
                           000083    52 SC_F7 =	    0x83    ;standard
                           00000A    53 SC_F8 =	    0x0a    ;standard
                           000001    54 SC_F9 =	    0x01    ;standard
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 63.
Hexadecimal [24-Bits]



                           000009    55 SC_F10 =	    0x09    ;standard
                           000078    56 SC_F11 =	    0x78    ;standard
                           000007    57 SC_F12 =	    0x07    ;standard
                           00007C    58 SC_KPMUL =	    0x7c    ;standard
                           00007B    59 SC_KPMINUS =	    0x7b    ;standard
                           000079    60 SC_KPPLUS =	    0x79    ;standard
                           000071    61 SC_KPDOT =	    0x71    ;standard
                           000070    62 SC_KP0 =	    0x70    ;standard
                           000069    63 SC_KP1 =	    0x69    ;standard
                           000072    64 SC_KP2 =	    0x72    ;standard
                           00007A    65 SC_KP3 =	    0x7a    ;standard
                           00006B    66 SC_KP4 =	    0x6b    ;standard
                           000073    67 SC_KP5 =	    0x73    ;standard
                           000074    68 SC_KP6 =	    0x74    ;standard
                           00006C    69 SC_KP7 =	    0x6c    ;standard
                           000075    70 SC_KP8 =	    0x75    ;standard
                           00007D    71 SC_KP9 =	    0x7d    ;standard
                                     72 
                                     73 ; extended codes, i.e. preceded by 0xe0 code. 
                           000014    74 SC_RCTRL =   0x14
                           00001F    75 SC_LGUI =    0x1f
                           000027    76 SC_RGUI =    0x27 
                           000011    77 SC_RALT =    0x11
                           00002F    78 SC_APPS =    0x2f
                           000075    79 SC_UP	 =    0x75
                           000072    80 SC_DOWN =    0x72
                           00006B    81 SC_LEFT =    0x6B
                           000074    82 SC_RIGHT =   0x74
                           000070    83 SC_INSERT =  0x70
                           00006C    84 SC_HOME =    0x6c
                           00007D    85 SC_PGUP =    0x7d
                           00007A    86 SC_PGDN =    0x7a
                           000071    87 SC_DEL	 =    0x71
                           000069    88 SC_END	 =    0x69
                           00004A    89 SC_KPDIV =   0x4a
                           00005A    90 SC_KPENTER = 0x5a
                           00001F    91 SC_LWINDOW = 0x1f
                           000027    92 SC_RWINDOW = 0x27
                           00005D    93 SC_MENU = 0x5d 
                                     94  
                                     95 ;special codes sequences  
      0084CD E0 12 E0 7C             96 SC_PRN: .byte 	    0xe0,0x12,0xe0,0x7c
      0084D1 E0 F0 7C E0 F0 12       97 SC_PRN_REL: .byte  0xe0,0xf0,0x7c,0xe0,0xf0,0x12 
      0084D7 E1 14 77 E1 F0 14 F0    98 SC_PAUSE: .byte    0xe1,0x14,0x77,0xe1,0xf0,0x14,0xf0,0x77
             77
                                     99 
                                    100  
                                    101 ;virtual keys 
                           000008   102 VK_BACK =	8
                           000009   103 VK_TAB =	9
                           00001B   104 VK_ESC =	27
                           00000D   105 VK_ENTER =	'\r'
                           000020   106 VK_SPACE =	' ' 
                           00007F   107 VK_DELETE =	127 
                           000080   108 VK_F1 =	128
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 64.
Hexadecimal [24-Bits]



                           000081   109 VK_F2 =	129
                           000082   110 VK_F3 =	130
                           000083   111 VK_F4 =	131
                           000084   112 VK_F5 =	132
                           000085   113 VK_F6 =	133
                           000086   114 VK_F7 =	134
                           000087   115 VK_F8 =	135
                           000088   116 VK_F9 =	136
                           00008A   117 VK_F10 =	138
                           00008B   118 VK_F11 =	139
                           00008C   119 VK_F12 =	140
                           00008D   120 VK_UP =	141
                           00008E   121 VK_DOWN =	142
                           00008F   122 VK_LEFT =	143
                           000090   123 VK_RIGHT =	144
                           000091   124 VK_HOME =	145
                           000092   125 VK_END =	146
                           000093   126 VK_PGUP =	147
                           000094   127 VK_PGDN =	148
                           000095   128 VK_INSERT =	149
                           000097   129 VK_APPS =	151
                           000098   130 VK_PRN	=	152
                           000099   131 VK_PAUSE =	153
                           00009A   132 VK_NLOCK =    154 ; numlock
                           00009B   133 VK_CLOCK =	155 ; capslock
                           00009C   134 VK_LSHIFT =	156
                           00009D   135 VK_LCTRL =	157
                           00009E   136 VK_LALT =	158
                           00009F   137 VK_RSHIFT =	159
                           0000A0   138 VK_LGUI =	160
                           0000A1   139 VK_RCTRL =	161
                           0000A2   140 VK_RGUI =	162
                           0000A3   141 VK_RALT =	163
                           0000A4   142 VK_SCROLL =	164
                           0000A5   143 VK_NUM	=	165 
                           0000A8   144 VK_CAPS =	168
                                    145 ;<SHIFT>-<KEY> 
                           0000A9   146 VK_SUP	=	169
                           0000AA   147 VK_SDOWN =	170
                           0000AB   148 VK_SLEFT =	171
                           0000AC   149 VK_SRIGHT =	172
                           0000AD   150 VK_SHOME =	173
                           0000AE   151 VK_SEND	=	174
                           0000AF   152 VK_SPGUP =	175
                           0000B0   153 VK_SPGDN =	176
                           0000BF   154 VK_SDEL  =    191
                                    155 ;<CTRL>-<KEY>
                           0000B1   156 VK_CUP	=	177
                           0000B2   157 VK_CDOWN =	178	
                           0000B3   158 VK_CLEFT =	179
                           0000B4   159 VK_CRIGHT =	180
                           0000B5   160 VK_CHOME =	181
                           0000B6   161 VK_CEND =	182
                           0000B7   162 VK_CPGUP =	183
                           0000B8   163 VK_CPGDN =	184
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 65.
Hexadecimal [24-Bits]



                           0000B9   164 VK_CDEL  =    185
                           0000BA   165 VK_CBACK =    186
                           0000BB   166 VK_LWINDOW =  187
                           0000BC   167 VK_RWINDOW =  188
                           0000BD   168 VK_MENU	=     189
                           0000BE   169 VK_SLEEP =	190	
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 66.
Hexadecimal [24-Bits]



                                     41 
                                     42 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     43 ;;   UART subroutines
                                     44 ;;   used for user interface 
                                     45 ;;   communication channel.
                                     46 ;;   settings: 
                                     47 ;;		115200 8N1 no flow control
                                     48 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     49 
                           000010    50 RX_QUEUE_SIZE==16 ; UART receive queue size 
                                     51 
                           000000    52 DTR=0 ; pin D2 received DTR signal from terminaal 
                                     53 
                                     54 	.area DATA 
                                     55 ; TERMIO variables 
      000017                         56 out:: .blkw 1 ; output char routine address 
      000019                         57 ctrl_c_vector:: .blkw 1 ; application can set a routine address here to be executed when CTTRL+C is pressed.
      00001B                         58 rx1_head::  .blkb 1 ; rx1_queue head pointer
      00001C                         59 rx1_tail::   .blkb 1 ; rx1_queue tail pointer  
      00001D                         60 rx1_queue:: .ds RX_QUEUE_SIZE ; UART receive circular queue 
      00002D                         61 term_vars_end::
                           000016    62 TERMIOS_VARS_SIZE==term_vars_end-out 
                                     63 
                                     64 
                                     65 	.area CODE
                                     66 
                                     67 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     68 ;;; Uart1 intterrupt handler 
                                     69 ;;; on receive character 
                                     70 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     71 ;--------------------------
                                     72 ; UART receive character
                                     73 ; in a FIFO buffer 
                                     74 ; CTRL+C (ASCII 3)
                                     75 ; cancel program execution
                                     76 ; and fall back to command line
                                     77 ; CTRL+X reboot system 
                                     78 ; CTLR+Z erase EEPROM autorun 
                                     79 ;        information and reboot
                                     80 ;--------------------------
      0084DF                         81 UartRxHandler: ; console receive char 
      0084DF 72 0B 52 40 2B   [ 2]   82 	btjf UART_SR,#UART_SR_RXNE,5$ 
      0084E4 C6 52 41         [ 1]   83 	ld a,UART_DR 
      0084E7 A1 03            [ 1]   84 	cp a,#CTRL_C 
      0084E9 26 09            [ 1]   85 	jrne 2$
      0084EB CE 00 19         [ 2]   86 	ldw x,ctrl_c_vector 
      0084EE 27 1F            [ 1]   87 	jreq 5$ 
      0084F0 1F 08            [ 2]   88 	ldw (8,sp),x 
      0084F2 20 1B            [ 2]   89 	jra 5$ 
      0084F4                         90 2$:
      0084F4 A1 18            [ 1]   91 	cp a,#CAN ; CTRL_X 
      0084F6 26 04            [ 1]   92 	jrne 3$
      000478                         93 	_swreset 	
      0084F8 35 80 50 D1      [ 1]    1     mov WWDG_CR,#0X80
      0084FC                         94 3$:	
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 67.
Hexadecimal [24-Bits]



      0084FC 88               [ 1]   95 	push a 
      0084FD A6 1D            [ 1]   96 	ld a,#rx1_queue 
      0084FF CB 00 1C         [ 1]   97 	add a,rx1_tail 
      008502 5F               [ 1]   98 	clrw x 
      008503 97               [ 1]   99 	ld xl,a 
      008504 84               [ 1]  100 	pop a 
      008505 F7               [ 1]  101 	ld (x),a 
      008506 C6 00 1C         [ 1]  102 	ld a,rx1_tail 
      008509 4C               [ 1]  103 	inc a 
      00850A A4 0F            [ 1]  104 	and a,#RX_QUEUE_SIZE-1
      00850C C7 00 1C         [ 1]  105 	ld rx1_tail,a 
      00850F                        106 5$:	
      00850F 80               [11]  107 	iret 
                                    108 
                                    109 
                                    110 ;---------------------------------------------
                                    111 ; initialize UART, 115200 8N1
                                    112 ; called from cold_start in hardware_init.asm 
                                    113 ; input:
                                    114 ;	none
                                    115 ; output:
                                    116 ;   none
                                    117 ;---------------------------------------------
                           01C200   118 BAUD_RATE=115200
                           000001   119 	N1=1
                           000003   120 	N2=N1+INT_SIZE 
                           000005   121 	VSIZE=N2+2
      008510                        122 uart_init:
      000490                        123 	_vars VSIZE 
      008510 52 05            [ 2]    1     sub sp,#VSIZE 
                                    124 ; BRR value = Fmaster/115200 
      008512 5F               [ 1]  125 	clrw x 
      000493                        126 	_ldaz fmstr 
      008513 B6 0D                    1     .byte 0xb6,fmstr 
      008515 02               [ 1]  127 	rlwa x 
      008516 90 AE 27 10      [ 2]  128 	ldw y,#10000
      00851A CD 83 C4         [ 4]  129 	call umstar
      00049D                        130 	_i16_store N2   
      00851D 1F 03            [ 2]    1     ldw (N2,sp),x 
      00851F 93               [ 1]  131 	ldw x,y 
      0004A0                        132 	_i16_store N1 
      008520 1F 01            [ 2]    1     ldw (N1,sp),x 
      008522 AE 04 80         [ 2]  133 	ldw x,#BAUD_RATE/100
      008525 CD 84 2D         [ 4]  134 	call udiv32_16 ; X quotient, Y  remainder 
      008528 90 A3 02 40      [ 2]  135 	cpw y,#BAUD_RATE/200
      00852C 2B 01            [ 1]  136 	jrmi 1$ 
      00852E 5C               [ 1]  137 	incw x
      00852F                        138 1$:  
                                    139 ; // brr value in X
      00852F A6 10            [ 1]  140 	ld a,#16 
      008531 62               [ 2]  141 	div x,a 
      008532 88               [ 1]  142 	push a  ; least nibble of BRR1 
      008533 02               [ 1]  143 	rlwa x 
      008534 4E               [ 1]  144 	swap a  ; high nibble of BRR1 
      008535 1A 01            [ 1]  145 	or a,(1,sp)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 68.
Hexadecimal [24-Bits]



      0004B7                        146 	_drop 1 
      008537 5B 01            [ 2]    1     addw sp,#1 
      008539 C7 52 43         [ 1]  147 	ld UART_BRR2,a 
      00853C 9E               [ 1]  148 	ld a,xh 
      00853D C7 52 42         [ 1]  149 	ld UART_BRR1,a
      008540                        150 3$:
      008540 72 5F 52 41      [ 1]  151     clr UART_DR
      008544 35 2C 52 45      [ 1]  152 	mov UART_CR2,#((1<<UART_CR2_TEN)|(1<<UART_CR2_REN)|(1<<UART_CR2_RIEN));
      008548 72 10 52 45      [ 1]  153 	bset UART_CR2,#UART_CR2_SBK
      00854C 72 0D 52 40 FB   [ 2]  154     btjf UART_SR,#UART_SR_TC,.
      008551 72 5F 00 1B      [ 1]  155     clr rx1_head 
      008555 72 5F 00 1C      [ 1]  156 	clr rx1_tail
      008559 5F               [ 1]  157 	clrw x
      0004DA                        158 	_strxz ctrl_c_vector
      00855A BF 19                    1     .byte 0xbf,ctrl_c_vector 
      00855C AE 85 98         [ 2]  159 	ldw x,#uart_putc 
      0004DF                        160 	_strxz out 
      00855F BF 17                    1     .byte 0xbf,out 
      008561 72 10 00 02      [ 1]  161 	bset UART,#UART_CR1_PIEN
      0004E5                        162 	_drop VSIZE 
      008565 5B 05            [ 2]    1     addw sp,#VSIZE 
      008567 81               [ 4]  163 	ret
                                    164 
                                    165 ;---------------------------
                                    166 ;  clear rx1_queue 
                                    167 ;---------------------------
      008568                        168 clear_queue:
      0004E8                        169     _clrz rx1_head 
      008568 3F 1B                    1     .byte 0x3f, rx1_head 
      0004EA                        170 	_clrz rx1_tail 
      00856A 3F 1C                    1     .byte 0x3f, rx1_tail 
      00856C 81               [ 4]  171 	ret 
                                    172 
                                    173 ;---------------------------------
                                    174 ;  set output vector 
                                    175 ;  input:
                                    176 ;     A     STDOUT -> uart 
                                    177 ;           BUFOUT -> [ptr16]
                                    178 ;     X     buffer address 
                                    179 ;---------------------------------
      00856D                        180 set_output:
      00856D CF 00 0F         [ 2]  181 	ldw ptr16,x 
      008570 AE 85 98         [ 2]  182 	ldw x,#uart_putc 
      008573 A1 01            [ 1]  183 	cp a,#STDOUT 
      008575 27 07            [ 1]  184 	jreq 1$
      008577 A1 03            [ 1]  185 	cp a,#BUFOUT 
      008579 26 05            [ 1]  186 	jrne 9$  
      00857B AE 85 87         [ 2]  187 	ldw x,#buf_putc 
      0004FE                        188 1$: _strxz out  
      00857E BF 17                    1     .byte 0xbf,out 
      008580 81               [ 4]  189 9$:	ret 
                                    190 
                                    191 
                                    192 ;---------------------------------
                                    193 ;  vectorized character output 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 69.
Hexadecimal [24-Bits]



                                    194 ;  input:
                                    195 ;     A   character to send 
                                    196 ;---------------------------------
      008581                        197 putc::
      008581 89               [ 2]  198 	pushw x 
      000502                        199 	_ldxz out 
      008582 BE 17                    1     .byte 0xbe,out 
      008584 FD               [ 4]  200 	call (x)
      008585 85               [ 2]  201 	popw x 
      008586 81               [ 4]  202 	ret 
                                    203 
                                    204 ;---------------------------------
                                    205 ; output character to a buffer 
                                    206 ; pointed by ptr16
                                    207 ; input:
                                    208 ;    A     character to save 
                                    209 ;---------------------------------
      008587                        210 buf_putc:
      008587 89               [ 2]  211 	pushw x 
      000508                        212 	_ldxz ptr16 
      008588 BE 0F                    1     .byte 0xbe,ptr16 
      00858A A1 08            [ 1]  213 	cp a,#BS 
      00858C 26 03            [ 1]  214 	jrne 1$
      00858E 5A               [ 2]  215 	decw x 
      00858F 20 02            [ 2]  216 	jra 9$ 
      008591                        217 1$:
      008591 F7               [ 1]  218 	ld (x),a
      008592 5C               [ 1]  219 	incw x  
      008593 7F               [ 1]  220 9$:	clr (x)
      000514                        221 	_strxz ptr16 
      008594 BF 0F                    1     .byte 0xbf,ptr16 
      008596 85               [ 2]  222 	popw x
      008597 81               [ 4]  223 	ret 
                                    224 
                                    225 
                                    226 ;---------------------------------
                                    227 ; uart_putc
                                    228 ; send a character via UART
                                    229 ; input:
                                    230 ;    A  	character to send
                                    231 ;---------------------------------
      008598                        232 uart_putc:: 
      008598 72 00 50 10 FB   [ 2]  233 	btjt PD_IDR,#DTR,. ; wait for DTR==0
      00859D                        234 uart_putc_nfc:: ; no flow control 
      00859D 72 0F 52 40 FB   [ 2]  235 	btjf UART_SR,#UART_SR_TXE,.
      0085A2 C7 52 41         [ 1]  236 	ld UART_DR,a 
      0085A5 81               [ 4]  237 	ret 
                                    238 
                                    239 
                                    240 ;---------------------------------
                                    241 ; Query for character in rx1_queue
                                    242 ; input:
                                    243 ;   none 
                                    244 ; output:
                                    245 ;   A     0 no charcter available
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 70.
Hexadecimal [24-Bits]



                                    246 ;   Z     1 no character available
                                    247 ;---------------------------------
      0085A6                        248 qgetc::
      0085A6                        249 uart_qgetc::
      000526                        250 	_ldaz rx1_head 
      0085A6 B6 1B                    1     .byte 0xb6,rx1_head 
      0085A8 C0 00 1C         [ 1]  251 	sub a,rx1_tail 
      0085AB 81               [ 4]  252 	ret 
                                    253 
                                    254 ;---------------------------------
                                    255 ; wait character from UART 
                                    256 ; input:
                                    257 ;   none
                                    258 ; output:
                                    259 ;   A 			char  
                                    260 ;--------------------------------	
      0085AC                        261 getc:: ;console input
      0085AC                        262 uart_getc::
      0085AC CD 85 A6         [ 4]  263 	call uart_qgetc
      0085AF 27 FB            [ 1]  264 	jreq uart_getc 
      0085B1 89               [ 2]  265 	pushw x 
                                    266 ;; rx1_queue must be in page 0 	
      0085B2 A6 1D            [ 1]  267 	ld a,#rx1_queue
      0085B4 CB 00 1B         [ 1]  268 	add a,rx1_head 
      0085B7 5F               [ 1]  269 	clrw x  
      0085B8 97               [ 1]  270 	ld xl,a 
      0085B9 F6               [ 1]  271 	ld a,(x)
      0085BA 88               [ 1]  272 	push a
      00053B                        273 	_ldaz rx1_head 
      0085BB B6 1B                    1     .byte 0xb6,rx1_head 
      0085BD 4C               [ 1]  274 	inc a 
      0085BE A4 0F            [ 1]  275 	and a,#RX_QUEUE_SIZE-1
      000540                        276 	_straz rx1_head 
      0085C0 B7 1B                    1     .byte 0xb7,rx1_head 
      0085C2 84               [ 1]  277 	pop a 
      0085C3 72 05 00 07 03   [ 2]  278 	btjf sys_flags,#FSYS_UPPER,1$
      0085C8 CD 89 02         [ 4]  279 	call to_upper 
      0085CB                        280 1$: 
      0085CB 85               [ 2]  281 	popw x
      0085CC 81               [ 4]  282 	ret 
                                    283 
                           000000   284 .if ANSI 
                                    285 ;-----------------------------
                                    286 ;  constants replacing 
                                    287 ;  ANSI sequence received 
                                    288 ;  from terminal.
                                    289 ;  These are the ANSI sequences
                                    290 ;  accepted by readln function
                                    291 ;------------------------------
                                    292     ARROW_LEFT=128
                                    293     ARROW_RIGHT=129
                                    294     HOME=130
                                    295     KEY_END=131
                                    296     SUP=132 
                                    297 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 71.
Hexadecimal [24-Bits]



                                    298 convert_table: .byte 'C',ARROW_RIGHT,'D',ARROW_LEFT,'H',HOME,'F',KEY_END,'3',SUP,0,0
                                    299 
                                    300 ;--------------------------------
                                    301 ; receive ANSI ESC 
                                    302 ; sequence and convert it
                                    303 ; to a single character code 
                                    304 ; in range {128..255}
                                    305 ; This is called after receiving 
                                    306 ; ESC character. 
                                    307 ; ignored sequence return 0 
                                    308 ; output:
                                    309 ;   A    converted character 
                                    310 ;-------------------------------
                                    311 get_escape:
                                    312     call getc 
                                    313     cp a,#'[ ; this character is expected after ESC 
                                    314     jreq 1$
                                    315     clr a
                                    316     ret
                                    317 1$: call getc 
                                    318     ldw x,#convert_table
                                    319 2$:
                                    320     cp a,(x)
                                    321     jreq 4$
                                    322     addw x,#2
                                    323     tnz (x)
                                    324     jrne 2$
                                    325     clr a
                                    326     ret 
                                    327 4$: incw x 
                                    328     ld a,(x)
                                    329     cp a,#SUP
                                    330     jrne 5$
                                    331     push a 
                                    332     call getc
                                    333     pop a 
                                    334 5$:
                                    335     ret 
                                    336 .endif 
                                    337 
                                    338 ;-----------------------------
                                    339 ; send an ASCIZ string to UART 
                                    340 ; input: 
                                    341 ;   x 		char * 
                                    342 ; output:
                                    343 ;   none 
                                    344 ;-------------------------------
      0085CD                        345 puts::
      0085CD F6               [ 1]  346     ld a,(x)
      0085CE 27 06            [ 1]  347 	jreq 1$
      0085D0 CD 85 81         [ 4]  348 	call putc 
      0085D3 5C               [ 1]  349 	incw x 
      0085D4 20 F7            [ 2]  350 	jra puts 
      0085D6 5C               [ 1]  351 1$:	incw x 
      0085D7 81               [ 4]  352 	ret 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 72.
Hexadecimal [24-Bits]



                                    353 
                           000000   354 .if ANSI 
                                    355 ;---------------------------------------------------------------
                                    356 ; send ANSI Control Sequence Introducer (CSI) 
                                    357 ; ANSI: CSI 
                                    358 ; note: ESC is ASCII 27
                                    359 ;       [   is ASCII 91
                                    360 ; ref: https://en.wikipedia.org/wiki/ANSI_escape_code#CSIsection  
                                    361 ;----------------------------------------------------------------- 
                                    362 send_csi:
                                    363 	push a 
                                    364 	ld a,#ESC 
                                    365 	call putc 
                                    366 	ld a,#'[
                                    367 	call putc
                                    368 	pop a  
                                    369 	ret 
                                    370 
                                    371 .endif 
                                    372 
                                    373 ;---------------------------
                                    374 ; delete character at left 
                                    375 ; of cursor on terminal 
                                    376 ; input:
                                    377 ;   none 
                                    378 ; output:
                                    379 ;	none 
                                    380 ;---------------------------
      0085D8                        381 bksp::
      0085D8 88               [ 1]  382 	push a 
      0085D9 A6 08            [ 1]  383 	ld a,#BS 
      0085DB CD 85 81         [ 4]  384 	call putc 
                           000001   385 .if 1 
      0085DE A6 20            [ 1]  386 	ld a,#SPACE 
      0085E0 CD 85 81         [ 4]  387 	call putc 
      0085E3 A6 08            [ 1]  388 	ld a,#BS 
      0085E5 CD 85 81         [ 4]  389 	call putc 
                                    390 .endif 
      0085E8 84               [ 1]  391 	pop a 
      0085E9 81               [ 4]  392 	ret 
                                    393  
                                    394 
                                    395 ;---------------------------
                                    396 ; send LF character 
                                    397 ; terminal interpret it 
                                    398 ; as CRLF 
                                    399 ;---------------------------
      0085EA                        400 new_line:: 
      0085EA A6 0A            [ 1]  401 	ld a,#LF 
      0085EC CD 85 81         [ 4]  402 	call putc 
      0085EF 81               [ 4]  403 	ret 
                                    404 
                                    405 ;--------------------------
                                    406 ; erase terminal screen 
                                    407 ;--------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 73.
Hexadecimal [24-Bits]



      0085F0                        408 clr_screen::
      0085F0 A6 1B            [ 1]  409 	ld a,#ESC 
      0085F2 CD 85 81         [ 4]  410 	call putc 
      0085F5 A6 63            [ 1]  411 	ld a,#'c 
      0085F7 CD 85 81         [ 4]  412 	call putc 
      0085FA 81               [ 4]  413 	ret 
                                    414 
                                    415 ;--------------------------
                                    416 ; output a single space
                                    417 ;--------------------------
      0085FB                        418 space::
      0085FB A6 20            [ 1]  419 	ld a,#SPACE 
      0085FD CD 85 81         [ 4]  420 	call putc 
      008600 81               [ 4]  421 	ret 
                                    422 
                                    423 ;--------------------------
                                    424 ; print n spaces on terminal
                                    425 ; input:
                                    426 ;  X 		number of spaces 
                                    427 ; output:
                                    428 ;	none 
                                    429 ;---------------------------
      008601                        430 spaces::
      008601 A6 20            [ 1]  431 	ld a,#SPACE 
      008603 5D               [ 2]  432 1$:	tnzw x
      008604 27 06            [ 1]  433 	jreq 9$
      008606 CD 85 81         [ 4]  434 	call putc 
      008609 5A               [ 2]  435 	decw x
      00860A 20 F7            [ 2]  436 	jra 1$
      00860C                        437 9$: 
      00860C 81               [ 4]  438 	ret 
                                    439 
                           000000   440 .if ANSI
                                    441 ;-----------------------------
                                    442 ; send ANSI sequence to delete
                                    443 ; whole display line. 
                                    444 ; cursor set left screen.
                                    445 ; ANSI: CSI K
                                    446 ; input:
                                    447 ;   none
                                    448 ; output:
                                    449 ;   none 
                                    450 ;-----------------------------
                                    451 erase_line:
                                    452 ; move to screen left 
                                    453 	call restore_cursor_pos  
                                    454 ; delete from cursor to end of line 
                                    455     call send_csi
                                    456 	ld a,#'K 
                                    457 	call putc 
                                    458 	ret 
                                    459 
                                    460 ;---------------------------------
                                    461 ; move cursor to CPOS 
                                    462 ; input:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 74.
Hexadecimal [24-Bits]



                                    463 ;   A     CPOS 
                                    464 ;---------------------------------
                                    465 move_to_cpos:
                                    466 	call restore_cursor_pos
                                    467 	tnz a 
                                    468 	jreq 9$ 
                                    469 	call send_csi 
                                    470 	call send_parameter
                                    471 	ld a,#'C 
                                    472 	call putc 
                                    473 9$:	ret 
                                    474 
                                    475 ;----------------------------------
                                    476 ; change cursor shape according 
                                    477 ; to editing mode 
                                    478 ; input:
                                    479 ;   A      -1 block shape (overwrite) 
                                    480 ;           0 vertical line (insert)
                                    481 ; output:
                                    482 ;   none 
                                    483 ;-----------------------------------
                                    484 cursor_style:
                                    485 	tnz a 
                                    486 	jrne 1$ 
                                    487 	ld a,#'5 
                                    488 	jra 2$
                                    489 1$: ld a,#'1
                                    490 2$:	
                                    491 	call send_csi
                                    492 	call putc 
                                    493 	call space
                                    494 	ld a,#'q 
                                    495 	call putc 
                                    496 	ret 
                                    497 
                                    498 ;--------------------------
                                    499 ; insert character in text 
                                    500 ; line 
                                    501 ; input:
                                    502 ;   A       character to insert 
                                    503 ;   XL      insert position  
                                    504 ;   XH     line length    
                                    505 ; output:
                                    506 ;   tib     updated
                                    507 ;-------------------------
                                    508  ; local variables 
                                    509 	ICHAR=1 ; character to insert 
                                    510 	LLEN=2  ; line length
                                    511 	IPOS=3  ; insert position 
                                    512 	VSIZE=3  ; local variables size 
                                    513 insert_char: 
                                    514 	_vars VSIZE 
                                    515     ld (ICHAR,sp),a 
                                    516 	ldw (LLEN,sp),x 
                                    517 	clr a 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 75.
Hexadecimal [24-Bits]



                                    518 	rrwa x ; A=IPOS , XL=LLEN, XH=0 
                                    519 	ld a,xl  
                                    520 	sub a,(IPOS,sp) 
                                    521 	addw x,#tib 
                                    522 	call move_string_right 
                                    523 	ld a,(ICHAR,sp)
                                    524 	ld (x),a
                                    525 	_drop VSIZE  
                                    526 	ret 
                                    527 .endif 
                                    528 
                           000000   529 .if ANSI 
                                    530 ;------------------------------------
                                    531 ; read a line of text from terminal
                                    532 ;  control keys:
                                    533 ;    BS   efface caractère à gauche 
                                    534 ;    CTRL_R  edit previous line.
                                    535 ;    CTRL_D  delete line  
                                    536 ;    HOME  go to start of line  
                                    537 ;    KEY_END  go to end of line 
                                    538 ;    ARROW_LEFT  move cursor left 
                                    539 ;    ARROW_RIGHT  move cursor right 
                                    540 ;    CTRL_L accept lower case letter 
                                    541 ;    CTRL_U accept upper case only 
                                    542 ;    CTRL_O  toggle between insert/overwrite
                                    543 ; input:
                                    544 ;	A    length of string already in buffer 
                                    545 ; local variable on stack:
                                    546 ;	LL  line length
                                    547 ;   RXCHAR last received character
                                    548 ; use:
                                    549 ;   Y point end of line  
                                    550 ; output:
                                    551 ;   A  line length 
                                    552 ;   text in tib  buffer
                                    553 ;------------------------------------
                                    554 	; local variables
                                    555 	RXCHAR = 1 ; last char received
                                    556 	LL_HB=1  ; line length high byte 
                                    557 	LL = 2  ; actual line length
                                    558 	CPOS=3  ; cursor position 
                                    559 	OVRWR=4 ; overwrite flag 
                                    560 	VSIZE=4 
                                    561 	
                                    562 readln::
                                    563 	pushw y 
                                    564 	_vars VSIZE 
                                    565 	clrw x 
                                    566 	ldw (LL_HB,sp),x 
                                    567 	ldw (CPOS,sp),x 
                                    568 	ld (LL,sp),a
                                    569 	ld (CPOS,sp),a  
                                    570 	cpl (OVRWR,sp) ; default to overwrite mode
                                    571 	call save_cursor_pos
                                    572 	tnz (LL,sp)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 76.
Hexadecimal [24-Bits]



                                    573 	jreq skip_display
                                    574 	ldw x,#tib 
                                    575 	call puts 
                                    576 	jra skip_display 
                                    577 readln_loop:
                                    578 	call display_line
                                    579 update_cursor:
                                    580 	ld a,(CPOS,sp)
                                    581 	call move_to_cpos   
                                    582 skip_display: 
                                    583 	call getc
                                    584 	ld (RXCHAR,sp),a
                                    585     cp a,#ESC 
                                    586     jrne 0$
                                    587     call get_escape 
                                    588     ld (RXCHAR,sp),a 
                                    589 0$:	cp a,#CR
                                    590 	jrne 1$
                                    591 	jp readln_quit
                                    592 1$:	cp a,#LF 
                                    593 	jrne 2$ 
                                    594 	jp readln_quit
                                    595 2$:
                                    596 	cp a,#BS
                                    597 	jrne 3$
                                    598 	ld a,(CPOS,sp)
                                    599 	call delete_left
                                    600 	cp a,(CPOS,sp)
                                    601 	jreq 21$ 
                                    602 	ld (CPOS,SP),a 
                                    603 	dec (LL,sp)
                                    604 21$:
                                    605     jp readln_loop 
                                    606 3$:
                                    607 	cp a,#CTRL_D
                                    608 	jrne 4$
                                    609 ;delete line 
                                    610 	clr a 
                                    611 	ldw x,#tib 
                                    612 	clr(x)
                                    613 	clr (CPOS,sp)
                                    614 	clr (LL,sp)
                                    615 	jra readln_loop
                                    616 4$:
                                    617 	cp a,#CTRL_R 
                                    618 	jrne 5$
                                    619 ;repeat line 
                                    620 	tnz (LL,sp)
                                    621 	jrne readln_loop
                                    622 	ldw x,#tib 
                                    623 	call strlen
                                    624 	tnz a  
                                    625 	jreq readln_loop
                                    626 	ld (LL,sp),a 
                                    627     ld (CPOS,sp),a
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 77.
Hexadecimal [24-Bits]



                                    628 	jra readln_loop 
                                    629 5$:
                                    630 	cp a,#ARROW_RIGHT
                                    631    	jrne 7$ 
                                    632 ; right arrow
                                    633 	ld a,(CPOS,sp)
                                    634     cp a,(LL,sp)
                                    635     jrmi 61$
                                    636     jp skip_display 
                                    637 61$:
                                    638 	inc (CPOS,sp)
                                    639     jp update_cursor  
                                    640 7$: cp a,#ARROW_LEFT  
                                    641 	jrne 8$
                                    642 ; left arrow 
                                    643 	tnz (CPOS,sp)
                                    644 	jrne 71$
                                    645 	jp skip_display
                                    646 71$:
                                    647 	dec (CPOS,sp)
                                    648 	jp update_cursor 
                                    649 8$: cp a,#HOME  
                                    650 	jrne 9$
                                    651 ; HOME 
                                    652 	clr (CPOS,sp)
                                    653 	call restore_cursor_pos
                                    654 	jp skip_display  
                                    655 9$: cp a,#KEY_END  
                                    656 	jrne 10$
                                    657 ; KEY_END 
                                    658 	ld a,(LL,sp)
                                    659 	ld (CPOS,sp),a 
                                    660 	jp update_cursor
                                    661 10$:
                                    662 	cp a,#CTRL_O
                                    663 	jrne 13$ 
                                    664 ; toggle between insert/overwrite
                                    665 	cpl (OVRWR,sp)
                                    666  	ld a,(OVRWR,sp)
                                    667 	call cursor_style
                                    668 	call beep_1khz
                                    669 	jp skip_display
                                    670 13$: cp a,#SUP 
                                    671     jrne final_test 
                                    672 ; del character under cursor 
                                    673     ld a,(CPOS,sp)
                                    674 	cp a,(LL,sp)
                                    675 	jrne 14$ 
                                    676 	jp skip_display
                                    677 14$:
                                    678 	call delete_under
                                    679 	dec (LL,sp)
                                    680     jp readln_loop 
                                    681 final_test:
                                    682 	cp a,#SPACE
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 78.
Hexadecimal [24-Bits]



                                    683 	jrpl accept_char
                                    684 	jp skip_display
                                    685 accept_char:
                                    686 	ld a,#TIB_SIZE-1
                                    687 	cp a, (LL,sp)
                                    688 	jrpl 1$
                                    689 	jp skip_display ; max length reached 
                                    690 1$:	tnz (OVRWR,sp)
                                    691 	jrne overwrite
                                    692 ; insert mode 
                                    693     ld a,(CPOS,sp)
                                    694 	cp a,(LL,sp)
                                    695 	jreq overwrite
                                    696 	clrw x 
                                    697     ld xl,a ; xl=cpos 
                                    698 	ld a,(LL,sp)
                                    699 	ld xh,a  ; xh=ll 
                                    700     ld a,(RXCHAR,sp)
                                    701     call insert_char 
                                    702     inc (LL,sp)
                                    703     inc (CPOS,sp)	
                                    704     jp readln_loop 
                                    705 overwrite:
                                    706 	clrw x 
                                    707 	ld a,(CPOS,sp)
                                    708 	ld xl,a 
                                    709 	addw x,#tib 
                                    710 	ld a,(RXCHAR,sp)
                                    711 	ld (x),a
                                    712 	call putc 
                                    713 	ld a,(CPOS,sp)
                                    714 	cp a,(LL,sp)
                                    715 	jrmi 1$
                                    716 	inc (LL,sp)
                                    717 	clr (1,x) 
                                    718 1$:	
                                    719 	inc (CPOS,sp)
                                    720 	jp skip_display 
                                    721 readln_quit:
                                    722 	ldw x,#tib
                                    723     clr (LL_HB,sp) 
                                    724     addw x,(LL_HB,sp)
                                    725     clr (x)
                                    726 	ld a,#CR
                                    727 	call putc
                                    728  	ld a,#-1 
                                    729 	call cursor_style
                                    730 	ld a,(LL,sp)
                                    731 	_drop VSIZE 
                                    732 	popw y 
                                    733 	ret
                                    734 
                                    735 ;--------------------------
                                    736 ; delete character under cursor
                                    737 ; and update display 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 79.
Hexadecimal [24-Bits]



                                    738 ; input:
                                    739 ;   A      cursor position
                                    740 ;   Y      end of line pointer 
                                    741 ; output:
                                    742 ;   A      not change 
                                    743 ;   Y      updated 
                                    744 ;-------------------------
                                    745 	CPOS=1
                                    746 	VSIZE=1
                                    747 delete_under:
                                    748 	push A ; CPOS 
                                    749 	clrw x 
                                    750 	ld xl,a 
                                    751 	addw x,#tib 
                                    752 	ld a,(x)
                                    753 	jreq 2$ ; at end of line  
                                    754 	call move_string_left
                                    755 2$: pop a
                                    756 	ret 
                                    757 
                                    758 
                                    759 ;------------------------------
                                    760 ; delete character left of cursor
                                    761 ; and update display  
                                    762 ; input:
                                    763 ;    A    CPOS 
                                    764 ;    Y    end of line pointer 
                                    765 ; output:
                                    766 ;    A    updated CPOS 
                                    767 ;-------------------------------
                                    768 delete_left:
                                    769 	tnz a 
                                    770 	jreq 9$ 
                                    771 	push a 
                                    772 	clrw x 
                                    773 	ld xl,a  
                                    774 	addw x,#tib
                                    775 	decw x
                                    776 	call move_string_left   
                                    777 	pop a 
                                    778 	dec a  
                                    779 9$:	ret 
                                    780 
                                    781 ;-----------------------------
                                    782 ; move_string_left 
                                    783 ; move .asciz 1 character left 
                                    784 ; input: 
                                    785 ;    X    destination 
                                    786 ; output:
                                    787 ;    x    end of moved string 
                                    788 ;-----------------------------
                                    789 move_string_left: 
                                    790 1$:	ld a,(1,x)
                                    791 	ld (x),a
                                    792 	jreq 2$  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 80.
Hexadecimal [24-Bits]



                                    793 	incw x 
                                    794 	jra 1$ 
                                    795 2$: ret 
                                    796 
                                    797 ;-----------------------------
                                    798 ; move_string_right 
                                    799 ; move .asciz 1 character right 
                                    800 ; to give space for character 
                                    801 ; insertion 
                                    802 ; input:
                                    803 ;   A     string length 
                                    804 ;   X     *str_end 
                                    805 ; output:
                                    806 ;   X     *slot  
                                    807 ;------------------------------
                                    808 move_string_right: 
                                    809 	tnz a 
                                    810 	jreq 9$
                                    811 	inc a  
                                    812 	push a
                                    813 1$: ld a,(x)
                                    814 	ld (1,x),a
                                    815 	decw x  
                                    816 	dec (1,sp)
                                    817 	jrne 1$
                                    818 	_drop 1
                                    819 	incw x  
                                    820 9$: ret 
                                    821 
                                    822 ;------------------------------
                                    823 ; display '>' on terminal 
                                    824 ; followed by edited line
                                    825 ;------------------------------
                                    826 display_line:
                                    827 	call erase_line  
                                    828 ; write edited line 	
                                    829 	ldw x,#tib 
                                    830 	call puts 
                                    831 	ret 
                                    832 
                           000001   833 .else 
                                    834  
                                    835 ;--------------------------
                                    836 ; this version of readln 
                                    837 ; if to be used with 
                                    838 ; non ANSI terminal 
                                    839 ; like STM8_terminal 
                                    840 ; 
                                    841 ; CTRL+R  repeat last input line 
                                    842 ; BS      delete last character 
                                    843 ; input:
                                    844 ;   A     initial line length
                                    845 ;   X     initial string  
                                    846 ; output:
                                    847 ;   A     line length 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 81.
Hexadecimal [24-Bits]



                                    848 ;   X     tib address 
                                    849 ;--------------------------
                           00003C   850 MAX_LEN=60
                           000001   851 	LN_LEN=1
                           000002   852 	CPOS=2
                           000003   853 	CHAR=3 
                           000003   854 	VSIZE=CHAR  
      00860D                        855 readln::
      00058D                        856 	_vars VSIZE 
      00860D 52 03            [ 2]    1     sub sp,#VSIZE 
      00860F 6B 01            [ 1]  857 	ld (LN_LEN,sp),a 
      008611 6B 02            [ 1]  858 	ld (CPOS,sp),a  
      008613 AE 16 80         [ 2]  859 	ldw x,#tib 
      008616 4D               [ 1]  860 	tnz a  
      008617 27 04            [ 1]  861 	jreq 1$ 
      008619 CD 85 CD         [ 4]  862 	call puts 
      00861C 5A               [ 2]  863 	decw x  
      00861D                        864 1$:
      00861D CD 85 AC         [ 4]  865 	call uart_getc
      008620 6B 03            [ 1]  866 	ld (CHAR,sp),a 
      008622 A1 20            [ 1]  867 	cp a,#SPACE 
      008624 24 55            [ 1]  868 	jruge 8$
      008626 A1 0D            [ 1]  869 	cp a,#CR 
      008628 26 03            [ 1]  870 	jrne 12$
      00862A CC 86 CD         [ 2]  871 	jp 9$ 
      00862D                        872 12$:
      00862D A1 08            [ 1]  873 	cp a,#BS 
      00862F 26 15            [ 1]  874 	jrne 2$ 
      008631 0D 01            [ 1]  875 	tnz (LN_LEN,sp)
      008633 27 E8            [ 1]  876 	jreq 1$ 
      008635 7B 02            [ 1]  877 	ld a,(CPOS,sp)
      008637 11 01            [ 1]  878 	cp a,(LN_LEN,sp)
      008639 2B E2            [ 1]  879 	jrmi 1$ 
      00863B CD 85 D8         [ 4]  880 	call bksp 
                                    881 ;	ld a,#BS 
                                    882 ;	call uart_putc 
      00863E 5A               [ 2]  883 	decw x 
      00863F 7F               [ 1]  884 	clr (x)
      008640 0A 01            [ 1]  885 	dec (LN_LEN,sp)
      008642 0A 02            [ 1]  886 	dec (CPOS,sp)
      008644 20 D7            [ 2]  887 	jra 1$ 
      008646                        888 2$: 
      008646 A1 12            [ 1]  889 	cp a,#CTRL_R 
      008648 26 14            [ 1]  890 	jrne 3$
      00864A 0D 01            [ 1]  891 	tnz (LN_LEN,sp)
      00864C 26 CF            [ 1]  892 	jrne 1$  
      00864E AE 16 80         [ 2]  893 	ldw x,#tib 
      008651 CD 88 94         [ 4]  894 	call strlen 
      008654 6B 01            [ 1]  895 	ld (LN_LEN,sp),a
      008656 6B 02            [ 1]  896 	ld (CPOS,sp),a 
      008658 CD 85 CD         [ 4]  897 	call puts  
      00865B 5A               [ 2]  898 	decw x
      00865C 20 BF            [ 2]  899 	jra 1$ 
      00865E                        900 3$:
      00865E A1 04            [ 1]  901 	cp a,#CTRL_D 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 82.
Hexadecimal [24-Bits]



      008660 26 0E            [ 1]  902 	jrne 4$
      008662 72 1D 00 43      [ 1]  903 	bres flags,#FAUTO 
      008666 A6 0D            [ 1]  904 	ld a,#CR 
      008668 72 5F 16 80      [ 1]  905 	clr tib 
      00866C 0F 01            [ 1]  906 	clr (LN_LEN,sp)
      00866E 20 5D            [ 2]  907 	jra 9$
      008670                        908 4$:	
      008670 A1 1B            [ 1]  909 	cp a,#ESC 
      008672 26 A9            [ 1]  910 	jrne 1$ 
      008674 CD 86 D8         [ 4]  911 	call process_esc 
      008677 0F 01            [ 1]  912 	clr (LN_LEN,sp)
      008679 20 55            [ 2]  913 	jra 10$ 
      00867B                        914 8$: 
      00867B A1 80            [ 1]  915 	cp a,#128 
      00867D 2B 24            [ 1]  916 	jrmi 88$  
                                    917 ; virtual keys 
      00867F A1 8F            [ 1]  918 	cp a,#VK_LEFT ; left arrow 
      008681 26 0A            [ 1]  919 	jrne 82$ 
      008683 0D 02            [ 1]  920 	tnz (CPOS,sp)
      008685 27 03            [ 1]  921 	jreq 81$ 
      008687 CD 87 07         [ 4]  922 	call cursor_left 
      00868A                        923 81$: 
      00868A CC 86 1D         [ 2]  924 	jp 1$ 
      00868D                        925 82$: 
      00868D A1 90            [ 1]  926 	cp a,#VK_RIGHT ; right arrow  
      00868F 27 03            [ 1]  927 	jreq 84$
      008691 CC 86 1D         [ 2]  928 	jp 1$ 
      008694                        929 84$:
      008694 7B 02            [ 1]  930 	ld a,(CPOS,sp)
      008696 11 01            [ 1]  931 	cp a,(LN_LEN,sp)
      008698 2B 03            [ 1]  932 	jrmi 86$
      00869A CC 86 1D         [ 2]  933 	jp 1$ 
      00869D                        934 86$:
      00869D CD 87 13         [ 4]  935 	call cursor_right
      0086A0 CC 86 1D         [ 2]  936 	jp 1$ 
      0086A3                        937 88$: 
      0086A3 7B 02            [ 1]  938 	ld a,(CPOS,sp)
      0086A5 11 01            [ 1]  939 	cp a,(LN_LEN,sp)
      0086A7 27 0C            [ 1]  940 	jreq 89$ 
                                    941 ; replace charater in middle of line 
      0086A9 7B 03            [ 1]  942 	ld a,(CHAR,sp)
      0086AB F7               [ 1]  943 	ld (x),a 
      0086AC CD 85 98         [ 4]  944 	call uart_putc 
      0086AF 0C 02            [ 1]  945 	inc (CPOS,sp) 
      0086B1 5C               [ 1]  946 	incw x 
      0086B2 CC 86 1D         [ 2]  947 	jp 1$
      0086B5                        948 89$: ; append character to end of line 
      0086B5 7B 01            [ 1]  949 	ld a,(LN_LEN,sp)
      0086B7 A1 3C            [ 1]  950 	cp a,#MAX_LEN 
      0086B9 2B 03            [ 1]  951 	jrmi 892$
      0086BB CC 86 1D         [ 2]  952     jp 1$ 
      0086BE                        953 892$:
      0086BE 7B 03            [ 1]  954 	ld a,(CHAR,sp)
      0086C0 CD 85 98         [ 4]  955 	call uart_putc 
      0086C3 F7               [ 1]  956 	ld (x),a 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 83.
Hexadecimal [24-Bits]



      0086C4 5C               [ 1]  957 	incw x 
      0086C5 7F               [ 1]  958 	clr (x)
      0086C6 0C 01            [ 1]  959 	inc (LN_LEN,sp)
      0086C8 0C 02            [ 1]  960 	inc (CPOS,sp)
      0086CA CC 86 1D         [ 2]  961 	jp 1$ 
      0086CD CD 85 98         [ 4]  962 9$:	call uart_putc  
      0086D0                        963 10$: 
      0086D0 AE 16 80         [ 2]  964 	ldw x,#tib 
      0086D3 7B 01            [ 1]  965 	ld a,(LN_LEN,sp)
      000655                        966 	_drop VSIZE 
      0086D5 5B 03            [ 2]    1     addw sp,#VSIZE 
      0086D7 81               [ 4]  967 	ret 
                                    968 
                                    969 ;----------------------
                                    970 ; received an ESC 
                                    971 ; process ANSI command 
                                    972 ;----------------------
                           000001   973 	P1=1 
                           000002   974 	P2=P1+1 
                           000003   975 	VSIZE=P2+1 
      0086D8                        976 process_esc:
      000658                        977 	_vars VSIZE 
      0086D8 52 03            [ 2]    1     sub sp,#VSIZE 
      0086DA 72 11 00 07      [ 1]  978 	bres sys_flags,#FSYS_TIMER 
      0086DE AE 00 0A         [ 2]  979 	ldw x,#10 
      000661                        980 	_strxz timer 
      0086E1 BF 03                    1     .byte 0xbf,timer 
      0086E3 CD 87 DE         [ 4]  981 	call get_parameter 
      0086E6 A1 63            [ 1]  982 	cp a,#'c  
      0086E8 26 05            [ 1]  983 	jrne 1$ 
      0086EA CD 85 F0         [ 4]  984 	call clr_screen
      0086ED 20 15            [ 2]  985 	jra 9$
      0086EF                        986 1$:
      0086EF A1 3B            [ 1]  987 	cp a,#'; 
      0086F1 26 11            [ 1]  988 	jrne 9$ 
      0086F3 1F 01            [ 2]  989 	ldw (P1,sp),x 
      0086F5 CD 87 DE         [ 4]  990 	call get_parameter 
      0086F8 A1 52            [ 1]  991 	cp a,#'R 
      0086FA 26 08            [ 1]  992 	jrne 9$ 
      0086FC 1F 02            [ 2]  993 	ldw (P2,sp),x 
      0086FE 7B 02            [ 1]  994 	ld a,(P1+1,sp)
      008700 95               [ 1]  995 	ld xh,a 
      008701 7B 03            [ 1]  996 	ld a,(P2+1,sp)
      008703 97               [ 1]  997 	ld xl,a 
      008704                        998 9$:
      000684                        999 	_drop VSIZE 
      008704 5B 03            [ 2]    1     addw sp,#VSIZE 
      008706 81               [ 4] 1000 	ret 
                                   1001 
                                   1002 
                                   1003 ;----------------------
                                   1004 ; move cursor 1 space 
                                   1005 ; left 
                                   1006 ;----------------------
      008707                       1007 cursor_left:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 84.
Hexadecimal [24-Bits]



      008707 5A               [ 2] 1008 	decw x 
      008708 0A 04            [ 1] 1009 	dec (CPOS+2,sp)
      00870A CD 87 D1         [ 4] 1010 	call send_csi 
      00870D A6 44            [ 1] 1011 	ld a,#'D 
      00870F CD 85 98         [ 4] 1012 	call uart_putc 
      008712 81               [ 4] 1013 	ret 
                                   1014 
                                   1015 ;-------------------------
                                   1016 ; move cursor 1 space 
                                   1017 ; right 
                                   1018 ;-------------------------
      008713                       1019 cursor_right:
      008713 5C               [ 1] 1020 	incw x 
      008714 0C 04            [ 1] 1021 	inc (CPOS+2,sp)
      008716 CD 87 D1         [ 4] 1022 	call send_csi 
      008719 A6 43            [ 1] 1023 	ld a,#'C 
      00871B CD 85 98         [ 4] 1024 	call uart_putc 
      00871E 81               [ 4] 1025 	ret 
                                   1026 
                                   1027 ;-------------------------------
                                   1028 ; save current cursor postion 
                                   1029 ; this value persist to next 
                                   1030 ; call to this procedure.
                                   1031 ; ANSI: CSI s
                                   1032 ;--------------------------------
      00871F                       1033 save_cursor_pos:: 
      00871F 88               [ 1] 1034 	push a 
      008720 CD 87 D1         [ 4] 1035 	call send_csi 
      008723 A6 73            [ 1] 1036 	ld a,#'s 
      008725 CD 85 81         [ 4] 1037 	call putc 
      008728 84               [ 1] 1038 	pop a 
      008729 81               [ 4] 1039 	ret 
                                   1040 
                                   1041 ;--------------------------------
                                   1042 ; restore cursor position from 
                                   1043 ; saved value 
                                   1044 ; ANSI: CSI u	
                                   1045 ;---------------------------------
      00872A                       1046 restore_cursor_pos::
      00872A 88               [ 1] 1047 	push a 
      00872B CD 87 D1         [ 4] 1048 	call send_csi 
      00872E A6 75            [ 1] 1049 	ld a,#'u 
      008730 CD 85 81         [ 4] 1050 	call putc 
      008733 84               [ 1] 1051 	pop a 
      008734 81               [ 4] 1052 	ret 
                                   1053 
                                   1054 ;----------------------------
                                   1055 ; set cursor at line,column 
                                   1056 ; input:
                                   1057 ;    XH    line 
                                   1058 ;    XL    column 
                                   1059 ;-----------------------------
      008735                       1060 set_cursor_pos::
      008735 89               [ 2] 1061 	pushw x 
      008736 CD 87 D1         [ 4] 1062 	call send_csi 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 85.
Hexadecimal [24-Bits]



      008739 7B 01            [ 1] 1063 	ld a,(1,sp); line 
      00873B CD 88 01         [ 4] 1064 	call send_parameter
      00873E A6 3B            [ 1] 1065     ld a,#';
      008740 CD 85 98         [ 4] 1066 	call uart_putc 
      008743 7B 02            [ 1] 1067 	ld a,(2,sp) ; column 
      008745 CD 88 01         [ 4] 1068 	call send_parameter
      008748 A6 48            [ 1] 1069 3$: ld a,#'H 
      00874A CD 85 98         [ 4] 1070 	call uart_putc
      0006CD                       1071 	_drop 2 
      00874D 5B 02            [ 2]    1     addw sp,#2 
      00874F 81               [ 4] 1072 	ret 
                                   1073 
                                   1074 ;---------------------------
                                   1075 ; move cursor at column  
                                   1076 ; input:
                                   1077 ;    A    column  
                                   1078 ;---------------------------
      008750                       1079 cursor_column::
      008750 CD 87 D1         [ 4] 1080 	call send_csi 
      008753 CD 88 01         [ 4] 1081 	call send_parameter 
      008756 A6 47            [ 1] 1082 	ld a,#'G 
      008758 CD 85 98         [ 4] 1083 	call uart_putc 
      00875B 81               [ 4] 1084 	ret 
                                   1085 
                                   1086 ;--------------------
                                   1087 ; ask terminal to 
                                   1088 ; send charater at 
                                   1089 ; current cursor 
                                   1090 ; position 
                                   1091 ; output:
                                   1092 ;    A    character 
                                   1093 ;------------------
      00875C                       1094 get_char_at::
      00875C A6 1B            [ 1] 1095 	ld a,#ESC 
      00875E CD 85 98         [ 4] 1096 	call uart_putc 
      008761 A6 5F            [ 1] 1097 	ld a,#'_ 
      008763 CD 85 98         [ 4] 1098 	call uart_putc 
      008766 A6 43            [ 1] 1099 	ld a,#'C 
      008768 CD 85 98         [ 4] 1100 	call uart_putc 
      00876B 3B 00 07         [ 1] 1101     push  sys_flags  
      00876E 72 15 00 07      [ 1] 1102 	bres sys_flags,#FSYS_UPPER 
      008772 CD 85 AC         [ 4] 1103 	call uart_getc
      008775 32 00 07         [ 1] 1104 	pop sys_flags  
      008778 81               [ 4] 1105 	ret 
                                   1106 
                                   1107 ;--------------------------
                                   1108 ; ask terminal for 
                                   1109 ; cursor position  
                                   1110 ;  ESC[6n
                                   1111 ;  terminal return:
                                   1112 ;     ESC[line;columnR 
                                   1113 ;  output:
                                   1114 ;      XH   line 
                                   1115 ;      XL   column 
                                   1116 ;      X=0  if no report 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 86.
Hexadecimal [24-Bits]



                                   1117 ;--------------------------
                           000001  1118 	LINE=1 
                           000003  1119 	COL=LINE+2 
                           000004  1120 	VSIZE=COL+1
      008779                       1121 cursor_pos::
      0006F9                       1122 	_vars VSIZE
      008779 52 04            [ 2]    1     sub sp,#VSIZE 
      00877B 5F               [ 1] 1123 	clrw x 
      00877C 1F 01            [ 2] 1124 	ldw (LINE,sp),x 
      00877E 1F 03            [ 2] 1125 	ldw (COL,sp),x  
      008780 CD 85 68         [ 4] 1126 	call clear_queue 
      008783 72 11 00 07      [ 1] 1127 	bres sys_flags,#FSYS_TIMER 
      008787 AE 00 14         [ 2] 1128 	ldw x,#20 
      00070A                       1129 	_strxz timer  
      00878A BF 03                    1     .byte 0xbf,timer 
      00878C CD 87 D1         [ 4] 1130 	call send_csi 
      00878F A6 36            [ 1] 1131 	ld a,#'6 
      008791 CD 85 98         [ 4] 1132 	call uart_putc 
      008794 A6 6E            [ 1] 1133 	ld a,#'n 
      008796 CD 85 98         [ 4] 1134 	call uart_putc 
      008799                       1135 0$:
      008799 72 00 00 07 2A   [ 2] 1136 	btjt sys_flags,#FSYS_TIMER,9$ 
      00879E CD 85 A6         [ 4] 1137 	call uart_qgetc 
      0087A1 27 F6            [ 1] 1138 	jreq 0$ 
      0087A3 CD 85 AC         [ 4] 1139 	call uart_getc 
      0087A6 A1 1B            [ 1] 1140 	cp a,#ESC 
      0087A8 26 EF            [ 1] 1141 	jrne 0$ 
      0087AA CD 85 AC         [ 4] 1142 	call uart_getc 
      0087AD A1 5B            [ 1] 1143 	cp a,#'[ 
      0087AF 26 17            [ 1] 1144     jrne 9$ 
      0087B1                       1145 1$:
      0087B1 CD 87 DE         [ 4] 1146 	call get_parameter 
      0087B4 A1 3B            [ 1] 1147 	cp a,#'; 
      0087B6 26 10            [ 1] 1148 	jrne 9$ 
      0087B8 1F 01            [ 2] 1149 	ldw (LINE,sp),x 
      0087BA CD 87 DE         [ 4] 1150 	call get_parameter 
      0087BD A1 52            [ 1] 1151 	cp a,#'R 
      0087BF 27 05            [ 1] 1152 	jreq 8$ 
      0087C1 5F               [ 1] 1153 	clrw x 
      0087C2 1F 01            [ 2] 1154 	ldw (LINE,sp),x 
      0087C4 20 02            [ 2] 1155 	jra 9$ 
      0087C6                       1156 8$:	
      0087C6 1F 03            [ 2] 1157 	ldw (COL,sp),x 
      0087C8 7B 02            [ 1] 1158 9$: ld a,(LINE+1,sp)
      0087CA 95               [ 1] 1159 	ld xh,a 
      0087CB 7B 04            [ 1] 1160 	ld a,(COL+1,sp)
      0087CD 97               [ 1] 1161 	ld xl,a 	
      00074E                       1162 	_drop VSIZE 
      0087CE 5B 04            [ 2]    1     addw sp,#VSIZE 
      0087D0 81               [ 4] 1163 	ret 
                                   1164 
                                   1165 ;--------------------
                                   1166 ; send ESC[
                                   1167 ;--------------------
      0087D1                       1168 send_csi:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 87.
Hexadecimal [24-Bits]



      0087D1 88               [ 1] 1169 	push a 
      0087D2 A6 1B            [ 1] 1170 	ld a,#27 
      0087D4 CD 85 98         [ 4] 1171 	call uart_putc 
      0087D7 A6 5B            [ 1] 1172 	ld a,#'[
      0087D9 CD 85 98         [ 4] 1173 	call uart_putc 	
      0087DC 84               [ 1] 1174 	pop a 
      0087DD 81               [ 4] 1175 	ret 
                                   1176 
                                   1177 ;------------------------
                                   1178 ; receive parameter from 
                                   1179 ; terminal 
                                   1180 ; output:
                                   1181 ;     X     value 
                                   1182 ;------------------------
                           000001  1183 	DIGIT=1
                           000002  1184 	VSIZE=DIGIT+1
      0087DE                       1185 get_parameter:
      0087DE 5F               [ 1] 1186 	clrw x
      0087DF 89               [ 2] 1187 	pushw x  
      0087E0 72 00 00 07 19   [ 2] 1188 1$:	btjt sys_flags,#FSYS_TIMER,2$  
      0087E5 CD 85 A6         [ 4] 1189 	call uart_qgetc 
      0087E8 27 F6            [ 1] 1190 	jreq 1$ 
      0087EA CD 85 AC         [ 4] 1191 	call uart_getc
      0087ED CD 89 1E         [ 4] 1192 	call is_digit 
      0087F0 24 0C            [ 1] 1193 	jrnc 2$  
      0087F2 A0 30            [ 1] 1194 	sub a,#'0 
      0087F4 6B 02            [ 1] 1195 	ld (DIGIT+1,sp),a  
      0087F6 A6 0A            [ 1] 1196 	ld a,#10 
      0087F8 42               [ 4] 1197 	mul x,a 
      0087F9 72 FB 01         [ 2] 1198 	addw x,(DIGIT,sp)
      0087FC 20 E2            [ 2] 1199 	jra 1$ 
      0087FE                       1200 2$: 
      00077E                       1201 	_drop  VSIZE 
      0087FE 5B 02            [ 2]    1     addw sp,#VSIZE 
      008800 81               [ 4] 1202 	ret
                                   1203 
                                   1204 ;---------------------
                                   1205 ;send ANSI parameter value
                                   1206 ; ANSI parameter values are 
                                   1207 ; sent as ASCII charater 
                                   1208 ; not as binary number.
                                   1209 ; this routine 
                                   1210 ; convert binary number to 
                                   1211 ; ASCII string and send it.
                                   1212 ; expected range {0..99}
                                   1213 ; input: 
                                   1214 ; 	A {0..99} 
                                   1215 ; output:
                                   1216 ;   none 
                                   1217 ;---------------------
      008801                       1218 send_parameter:
      008801 89               [ 2] 1219 	pushw x 
      008802 5F               [ 1] 1220 	clrw x 
      008803 97               [ 1] 1221 	ld xl,a 
      008804 A6 0A            [ 1] 1222 	ld a,#10 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 88.
Hexadecimal [24-Bits]



      008806 62               [ 2] 1223 	div x,a 
      008807 AB 30            [ 1] 1224 	add a,#'0 
      008809 95               [ 1] 1225 	ld xh,a ; least digit 
      00880A 9F               [ 1] 1226 	ld a,xl ; most digit 
      00880B 4D               [ 1] 1227     tnz a 
      00880C 27 0B            [ 1] 1228     jreq 2$
      00880E A1 0A            [ 1] 1229 	cp a,#10 
      008810 2B 02            [ 1] 1230 	jrmi 1$
      008812 A6 09            [ 1] 1231 	ld a,#9
      008814                       1232 1$:
      008814 AB 30            [ 1] 1233 	add a,#'0 
      008816 CD 85 98         [ 4] 1234 	call uart_putc
      008819 9E               [ 1] 1235 2$:	ld a,xh 
      00881A CD 85 98         [ 4] 1236 	call uart_putc 
      00881D 85               [ 2] 1237 	popw x 
      00881E 81               [ 4] 1238 	ret 
                                   1239 
                                   1240 .endif 
                                   1241 
                                   1242 
                                   1243 ;----------------------------------
                                   1244 ; convert to hexadecimal digit 
                                   1245 ; input:
                                   1246 ;   A       digit to convert 
                                   1247 ; output:
                                   1248 ;   A       hexdecimal character 
                                   1249 ;----------------------------------
      00881F                       1250 to_hex_char::
      00881F A4 0F            [ 1] 1251 	and a,#15 
      008821 A1 0A            [ 1] 1252 	cp a,#10 
      008823 2B 02            [ 1] 1253 	jrmi 1$ 
      008825 AB 07            [ 1] 1254 	add a,#7
      008827 AB 30            [ 1] 1255 1$: add a,#'0 
      008829 81               [ 4] 1256 	ret 
                                   1257 
                                   1258 ;------------------------------
                                   1259 ; print byte  in hexadecimal 
                                   1260 ; on console
                                   1261 ; no space separator 
                                   1262 ; input:
                                   1263 ;    A		byte to print
                                   1264 ;------------------------------
      00882A                       1265 print_hex::
      00882A 88               [ 1] 1266 	push a 
      00882B 4E               [ 1] 1267 	swap a 
      00882C CD 88 1F         [ 4] 1268 	call to_hex_char 
      00882F CD 85 81         [ 4] 1269 	call putc 
      008832 84               [ 1] 1270     pop a  
      008833 CD 88 1F         [ 4] 1271 	call to_hex_char
      008836 CD 85 81         [ 4] 1272 	call putc   
      008839 81               [ 4] 1273 	ret 
                                   1274 
                                   1275 ;------------------------
                                   1276 ; print int8 
                                   1277 ; input:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 89.
Hexadecimal [24-Bits]



                                   1278 ;    A    int8 
                                   1279 ; output:
                                   1280 ;    none 
                                   1281 ;-----------------------
      00883A                       1282 prt_i8:
      00883A 5F               [ 1] 1283 	clrw x 
      00883B 97               [ 1] 1284 	ld xl,a  
                                   1285 
                                   1286 
                                   1287 ;------------------------------------
                                   1288 ; print integer  
                                   1289 ; input:
                                   1290 ;	X  		    integer to print 
                                   1291 ;	'base' 		numerical base for conversion 
                                   1292 ;    A 			signed||unsigned conversion
                                   1293 ;  output:
                                   1294 ;    A          string length
                                   1295 ;------------------------------------
      00883C                       1296 print_int::
      00883C A6 FF            [ 1] 1297 	ld a,#255  ; signed conversion  
      00883E CD 88 47         [ 4] 1298     call itoa  ; conversion entier en  .asciz
      008841 88               [ 1] 1299 	push a 
      008842 CD 85 CD         [ 4] 1300 	call puts
      008845 84               [ 1] 1301 	pop a 
      008846 81               [ 4] 1302     ret	
                                   1303 
                                   1304 ;------------------------------------
                                   1305 ; convert integer in x to string
                                   1306 ; input:
                                   1307 ;   'base'	conversion base 
                                   1308 ;	X   	integer to convert
                                   1309 ;   A       0=unsigned, else signed 
                                   1310 ; output:
                                   1311 ;   X  		pointer to first char of string
                                   1312 ;   A       string length
                                   1313 ; use:
                                   1314 ;   pad     to build string 
                                   1315 ;------------------------------------
                           000001  1316 	SIGN=1  ; 1 byte, integer sign 
                           000002  1317 	LEN=SIGN+1   ; 1 byte, string length 
                           000002  1318 	VSIZE=2 ;locals size
      008847                       1319 itoa::
      008847 90 89            [ 2] 1320 	pushw y 
      0007C9                       1321 	_vars VSIZE
      008849 52 02            [ 2]    1     sub sp,#VSIZE 
      00884B 0F 02            [ 1] 1322 	clr (LEN,sp) ; string length  
      00884D 0F 01            [ 1] 1323 	clr (SIGN,sp)    ; sign
      00884F 4D               [ 1] 1324 	tnz a
      008850 27 06            [ 1] 1325 	jreq 1$ ; unsigned conversion  
      008852 5D               [ 2] 1326 	tnzw x 
      008853 2A 03            [ 1] 1327 	jrpl 1$ 
      008855 03 01            [ 1] 1328 	cpl (SIGN,sp)
      008857 50               [ 2] 1329 	negw x 
      008858                       1330 1$:
                                   1331 ; initialize string pointer 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 90.
Hexadecimal [24-Bits]



                                   1332 ; build string at end of pad  
      008858 90 AE 17 00      [ 2] 1333 	ldw y,#pad 
      00885C 72 A9 00 80      [ 2] 1334 	addw y,#PAD_SIZE 
      008860 90 5A            [ 2] 1335 	decw y 
      008862 90 7F            [ 1] 1336 	clr (y)
      008864 A6 20            [ 1] 1337 	ld a,#SPACE
      008866 90 5A            [ 2] 1338 	decw y
      008868 90 F7            [ 1] 1339 	ld (y),a 
      00886A 0C 02            [ 1] 1340 	inc (LEN,sp)
      00886C                       1341 itoa_loop:
      00886C A6 0A            [ 1] 1342     ld a,#10 
      00886E 62               [ 2] 1343     div x,a 
      00886F AB 30            [ 1] 1344     add a,#'0  ; remainder of division
      008871 A1 3A            [ 1] 1345     cp a,#'9+1
      008873 2B 02            [ 1] 1346     jrmi 2$
      008875 AB 07            [ 1] 1347     add a,#7 
      008877                       1348 2$:	
      008877 90 5A            [ 2] 1349 	decw y
      008879 90 F7            [ 1] 1350     ld (y),a
      00887B 0C 02            [ 1] 1351 	inc (LEN,sp)
                                   1352 ; if x==0 conversion done
      00887D 5D               [ 2] 1353 	tnzw x 
      00887E 26 EC            [ 1] 1354     jrne itoa_loop
      008880 7B 01            [ 1] 1355 	ld a,(SIGN,sp)
      008882 27 08            [ 1] 1356     jreq 10$
      008884 A6 2D            [ 1] 1357     ld a,#'-
      008886 90 5A            [ 2] 1358     decw y
      008888 90 F7            [ 1] 1359     ld (y),a
      00888A 0C 02            [ 1] 1360 	inc (LEN,sp)
      00888C                       1361 10$:
      00888C 7B 02            [ 1] 1362 	ld a,(LEN,sp)
      00888E 93               [ 1] 1363 	ldw x,y 
      00080F                       1364 	_drop VSIZE
      00888F 5B 02            [ 2]    1     addw sp,#VSIZE 
      008891 90 85            [ 2] 1365 	popw y 
      008893 81               [ 4] 1366 	ret
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 91.
Hexadecimal [24-Bits]



                                      1 ;;
                                      2 ; Copyright Jacques Deschênes 2019,2022,2023  
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
                                     19 ;--------------------------
                                     20 ; standards functions
                                     21 ;--------------------------
                                     22 
                                     23 ;	.include "config.inc"
                                     24 
                                     25 ;--------------------------
                                     26 	.area CODE
                                     27 ;--------------------------
                                     28 
                                     29 ;--------------------------------------
                                     30 ; retrun string length
                                     31 ; input:
                                     32 ;   X         .asciz  pointer 
                                     33 ; output:
                                     34 ;   X         not affected 
                                     35 ;   A         length 
                                     36 ;-------------------------------------
      008894                         37 strlen::
      008894 89               [ 2]   38 	pushw x 
      008895 4F               [ 1]   39 	clr a
      008896 7D               [ 1]   40 1$:	tnz (x) 
      008897 27 04            [ 1]   41 	jreq 9$ 
      008899 4C               [ 1]   42 	inc a 
      00889A 5C               [ 1]   43 	incw x 
      00889B 20 F9            [ 2]   44 	jra 1$ 
      00889D 85               [ 2]   45 9$:	popw x 
      00889E 81               [ 4]   46 	ret 
                                     47 
                                     48 ;------------------------------------
                                     49 ; compare 2 strings
                                     50 ; input:
                                     51 ;   X 		char* first string 
                                     52 ;   Y       char* second string 
                                     53 ; output:
                                     54 ;   Z flag 	0 != | 1 ==  
                                     55 ;-------------------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 92.
Hexadecimal [24-Bits]



      00889F                         56 strcmp::
      00889F F6               [ 1]   57 	ld a,(x)
      0088A0 27 09            [ 1]   58 	jreq 5$ 
      0088A2 90 F1            [ 1]   59 	cp a,(y) 
      0088A4 26 07            [ 1]   60 	jrne 9$ 
      0088A6 5C               [ 1]   61 	incw x 
      0088A7 90 5C            [ 1]   62 	incw y 
      0088A9 20 F4            [ 2]   63 	jra strcmp 
      0088AB                         64 5$: ; end of first string 
      0088AB 90 F1            [ 1]   65 	cp a,(y)
      0088AD 81               [ 4]   66 9$:	ret 
                                     67 
                                     68 ;---------------------------------------
                                     69 ;  copy src string to dest 
                                     70 ; input:
                                     71 ;   X 		dest 
                                     72 ;   Y 		src 
                                     73 ; output: 
                                     74 ;   X 		dest 
                                     75 ;----------------------------------
      0088AE                         76 strcpy::
      0088AE 88               [ 1]   77 	push a 
      0088AF 89               [ 2]   78 	pushw x 
      0088B0 90 F6            [ 1]   79 1$: ld a,(y)
      0088B2 27 06            [ 1]   80 	jreq 9$ 
      0088B4 F7               [ 1]   81 	ld (x),a 
      0088B5 5C               [ 1]   82 	incw x 
      0088B6 90 5C            [ 1]   83 	incw y 
      0088B8 20 F6            [ 2]   84 	jra 1$ 
      0088BA 7F               [ 1]   85 9$:	clr (x)
      0088BB 85               [ 2]   86 	popw x 
      0088BC 84               [ 1]   87 	pop a 
      0088BD 81               [ 4]   88 	ret 
                                     89 
                                     90 ;---------------------------------------
                                     91 ; move memory block 
                                     92 ; input:
                                     93 ;   X 		destination 
                                     94 ;   Y 	    source 
                                     95 ;   acc16	bytes count 
                                     96 ; output:
                                     97 ;   X       destination 
                                     98 ;--------------------------------------
                           000001    99 	INCR=1 ; incrament high byte 
                           000002   100 	LB=2 ; increment low byte 
                           000002   101 	VSIZE=2
      0088BE                        102 move::
      0088BE 88               [ 1]  103 	push a 
      0088BF 89               [ 2]  104 	pushw x 
      000840                        105 	_vars VSIZE 
      0088C0 52 02            [ 2]    1     sub sp,#VSIZE 
      0088C2 0F 01            [ 1]  106 	clr (INCR,sp)
      0088C4 0F 02            [ 1]  107 	clr (LB,sp)
      0088C6 90 89            [ 2]  108 	pushw y 
      0088C8 13 01            [ 2]  109 	cpw x,(1,sp) ; compare DEST to SRC 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 93.
Hexadecimal [24-Bits]



      0088CA 90 85            [ 2]  110 	popw y 
      0088CC 27 2F            [ 1]  111 	jreq move_exit ; x==y 
      0088CE 2B 0E            [ 1]  112 	jrmi move_down
      0088D0                        113 move_up: ; start from top address with incr=-1
      0088D0 72 BB 00 15      [ 2]  114 	addw x,acc16
      0088D4 72 B9 00 15      [ 2]  115 	addw y,acc16
      0088D8 03 01            [ 1]  116 	cpl (INCR,sp)
      0088DA 03 02            [ 1]  117 	cpl (LB,sp)   ; increment = -1 
      0088DC 20 05            [ 2]  118 	jra move_loop  
      0088DE                        119 move_down: ; start from bottom address with incr=1 
      0088DE 5A               [ 2]  120     decw x 
      0088DF 90 5A            [ 2]  121 	decw y
      0088E1 0C 02            [ 1]  122 	inc (LB,sp) ; incr=1 
      0088E3                        123 move_loop:	
      000863                        124     _ldaz acc16 
      0088E3 B6 15                    1     .byte 0xb6,acc16 
      0088E5 CA 00 16         [ 1]  125 	or a, acc8
      0088E8 27 13            [ 1]  126 	jreq move_exit 
      0088EA 72 FB 01         [ 2]  127 	addw x,(INCR,sp)
      0088ED 72 F9 01         [ 2]  128 	addw y,(INCR,sp) 
      0088F0 90 F6            [ 1]  129 	ld a,(y)
      0088F2 F7               [ 1]  130 	ld (x),a 
      0088F3 89               [ 2]  131 	pushw x 
      000874                        132 	_ldxz acc16 
      0088F4 BE 15                    1     .byte 0xbe,acc16 
      0088F6 5A               [ 2]  133 	decw x 
      0088F7 CF 00 15         [ 2]  134 	ldw acc16,x 
      0088FA 85               [ 2]  135 	popw x 
      0088FB 20 E6            [ 2]  136 	jra move_loop
      0088FD                        137 move_exit:
      00087D                        138 	_drop VSIZE
      0088FD 5B 02            [ 2]    1     addw sp,#VSIZE 
      0088FF 85               [ 2]  139 	popw x 
      008900 84               [ 1]  140 	pop a 
      008901 81               [ 4]  141 	ret 	
                                    142 
                                    143 ;-------------------------
                                    144 ;  upper case letter 
                                    145 ; input:
                                    146 ;   A    letter 
                                    147 ; output:
                                    148 ;   A    
                                    149 ;--------------------------
      008902                        150 to_upper::
      008902 A1 61            [ 1]  151     cp a,#'a 
      008904 2B 06            [ 1]  152     jrmi 9$ 
      008906 A1 7B            [ 1]  153     cp a,#'z+1 
      008908 2A 02            [ 1]  154     jrpl 9$ 
      00890A A4 DF            [ 1]  155     and a,#0xDF 
      00890C 81               [ 4]  156 9$: ret 
                                    157 
                                    158 ;-------------------------------------
                                    159 ; check if A is a letter 
                                    160 ; input:
                                    161 ;   A 			character to test 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 94.
Hexadecimal [24-Bits]



                                    162 ; output:
                                    163 ;   C flag      1 true, 0 false 
                                    164 ;-------------------------------------
      00890D                        165 is_alpha::
      00890D A1 41            [ 1]  166 	cp a,#'A 
      00890F 8C               [ 1]  167 	ccf 
      008910 24 0B            [ 1]  168 	jrnc 9$ 
      008912 A1 5B            [ 1]  169 	cp a,#'Z+1 
      008914 25 07            [ 1]  170 	jrc 9$ 
      008916 A1 61            [ 1]  171 	cp a,#'a 
      008918 8C               [ 1]  172 	ccf 
      008919 24 02            [ 1]  173 	jrnc 9$
      00891B A1 7B            [ 1]  174 	cp a,#'z+1
      00891D 81               [ 4]  175 9$: ret 	
                                    176 
                                    177 ;------------------------------------
                                    178 ; check if character in {'0'..'9'}
                                    179 ; input:
                                    180 ;    A  character to test
                                    181 ; output:
                                    182 ;    Carry  0 not digit | 1 digit
                                    183 ;------------------------------------
      00891E                        184 is_digit::
      00891E A1 30            [ 1]  185 	cp a,#'0
      008920 25 03            [ 1]  186 	jrc 1$
      008922 A1 3A            [ 1]  187     cp a,#'9+1
      008924 8C               [ 1]  188 	ccf 
      008925 8C               [ 1]  189 1$:	ccf 
      008926 81               [ 4]  190     ret
                                    191 
                                    192 ;------------------------------------
                                    193 ; check if character in {'0'..'9','A'..'F'}
                                    194 ; input:
                                    195 ;    A  character to test
                                    196 ; output:
                                    197 ;    Carry  0 not hex_digit | 1 hex_digit
                                    198 ;------------------------------------
      008927                        199 is_hex_digit::
      008927 CD 89 1E         [ 4]  200 	call is_digit 
      00892A 25 08            [ 1]  201 	jrc 9$
      00892C A1 41            [ 1]  202 	cp a,#'A 
      00892E 25 03            [ 1]  203 	jrc 1$
      008930 A1 47            [ 1]  204 	cp a,#'G 
      008932 8C               [ 1]  205 	ccf 
      008933 8C               [ 1]  206 1$: ccf 
      008934 81               [ 4]  207 9$: ret 
                                    208 
                                    209 
                                    210 ;-------------------------------------
                                    211 ; return true if character in  A 
                                    212 ; is letter or digit.
                                    213 ; input:
                                    214 ;   A     ASCII character 
                                    215 ; output:
                                    216 ;   A     no change 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 95.
Hexadecimal [24-Bits]



                                    217 ;   Carry    0 false| 1 true 
                                    218 ;--------------------------------------
      008935                        219 is_alnum::
      008935 CD 89 1E         [ 4]  220 	call is_digit
      008938 25 03            [ 1]  221 	jrc 1$ 
      00893A CD 89 0D         [ 4]  222 	call is_alpha
      00893D 81               [ 4]  223 1$:	ret 
                                    224 
                                    225 ;-------------------------------
                                    226 ; print application information
                                    227 ; input:
                                    228 ;    X        app name string 
                                    229 ;    Y        copyright string 
                                    230 ;  on stack 
                                    231 ;    MAJOR     major version 
                                    232 ;    MINOR     minor version 
                                    233 ;    REVISION  revision 
                                    234 ;-------------------------------
      00893E 76 65 72 73 69 6F 6E   235 version_str: .asciz "version " 
             20 00
      008947                        236 	_argofs 0 
                           000002     1     ARG_OFS=2+0 
      0008C7                        237 	_arg MAJOR  1
                           000003     1     MAJOR=ARG_OFS+1 
      0008C7                        238 	_arg MINOR  2 
                           000004     1     MINOR=ARG_OFS+2 
      0008C7                        239 	_arg REVISION 3  
                           000005     1     REVISION=ARG_OFS+3 
      0008C7                        240 app_info::
      008947 CD 85 CD         [ 4]  241 	call puts 
      00894A 93               [ 1]  242 	ldw x,y
      00894B CD 85 CD         [ 4]  243 	call puts 
      00894E AE 89 3E         [ 2]  244 	ldw x,#version_str
      008951 CD 85 CD         [ 4]  245 	call puts 
      008954 7B 03            [ 1]  246 	ld a,(MAJOR,sp)
      008956 CD 88 3A         [ 4]  247 	call prt_i8 
      008959 CD 85 D8         [ 4]  248 	call bksp 
      00895C A6 2E            [ 1]  249 	ld a,#'. 
      00895E CD 85 81         [ 4]  250 	call putc 
      008961 7B 04            [ 1]  251 	ld a,(MINOR,sp)
      008963 CD 88 3A         [ 4]  252 	call prt_i8 
      008966 CD 85 D8         [ 4]  253 	call bksp 
      008969 A6 52            [ 1]  254 	ld a,#'R  
      00896B CD 85 81         [ 4]  255 	call putc 
      00896E 7B 05            [ 1]  256 	ld a,(REVISION,sp)
      008970 CD 88 3A         [ 4]  257 	call prt_i8
      008973 CD 85 EA         [ 4]  258 	call new_line  
      008976 81               [ 4]  259 	ret 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 96.
Hexadecimal [24-Bits]



                                      1 ;;
                                      2 ; Copyright Jacques Deschênes 2023  
                                      3 ; This file is part of pomme-1 
                                      4 ;
                                      5 ;     pomme-1 is free software: you can redistribute it and/or modify
                                      6 ;     it under the terms of the GNU General Public License as published by
                                      7 ;     the Free Software Foundation, either version 3 of the License, or
                                      8 ;     (at your option) any later version.
                                      9 ;
                                     10 ;     pomme-1 is distributed in the hope that it will be useful,
                                     11 ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                     12 ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                     13 ;     GNU General Public License for more details.
                                     14 ;
                                     15 ;     You should have received a copy of the GNU General Public License
                                     16 ;     along with pomme-1.  If not, see <http://www.gnu.org/licenses/>.
                                     17 ;;
                                     18 
                                     19 ;-------------------------------
                                     20 ;  SPI peripheral support
                                     21 ;  low level driver 
                                     22 ;--------------------------------
                                     23 
                                     24 	.module SPI 
                                     25 
                                     26 
                                     27     .module SPI    
                                     28 ;    .include "config.inc"
                                     29 
                                     30     .area CODE 
                                     31 
                                     32 ; SPI channel select pins 
                           000000    33 SPI_CS_RAM==0     ; PB0 
                           000001    34 SPI_CS_EEPROM==1   ; PB1 
                                     35 
                                     36 
                                     37 ; SPI RAM commands 
                                     38 ;----------------------------
                                     39 ; 23LC1024 
                                     40 ; mode set 
                                     41 ;  bit7:6 | mode 
                                     42 ;  -------|------
                                     43 ;    00   |  byte 
                                     44 ;    01   |  sequential 
                                     45 ;    10   |  page 
                                     46 ;    11   | reserved 
                                     47 ;-------------------------------
                           000020    48 RAM_PG_SIZE=32 ; bytes 
                           000002    49 SPI_RAM_WRITE=2 
                           000003    50 SPI_RAM_READ=3
                           000001    51 SPI_RAM_WRMOD=1 ; write mode register
                           000005    52 SPI_RAM_RDMOD=5 ; read mode register   
                           000000    53 RW_MODE_BYTE=0 
                           000040    54 RW_MODE_SEQ=(1<<6) 
                           000080    55 RW_MODE_PAG=(2<<6) 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 97.
Hexadecimal [24-Bits]



                                     56 
                                     57 ;-----------------------------------------------
                                     58 ; 25LC1024 programming
                                     59 ; 1) set /CS TO 0  
                                     60 ; 2) enable FLASH WRITE with WR_EN cmd 
                                     61 ; 3) set /CS TO 1 
                                     62 ; 4) set /CS to 0 
                                     63 ; 5) send SPI_EEPROM_WRITE followed by 24 bits address
                                     64 ; 6) send up to 256 data bytes 
                                     65 ; 7) rise /CS to 1  
                                     66 ;-----------------------------------------------
                           001000    67 SECTOR_SIZE=4096 ; bytes 
                           000003    68 SPI_EEPROM_READ=3 
                           000002    69 SPI_EEPROM_WRITE=2 ; 256 bytes page 
                           000001    70 WR_STATUS=1  ; write status register 
                           000005    71 RD_STATUS=5  ; read status register 
                           000006    72 WR_EN=6      ; set WEL bit 
                           0000D8    73 SECT_ERASE=0xD8   ; 32KB 
                           000042    74 PAGE_ERASE=0x42 ; 256 bytes  
                           0000C7    75 CHIP_ERASE=0xC7   ; whole memory  
                                     76 ; SR 1 status bits 
                           000000    77 SR_WIP_BIT=0
                           000001    78 SR_WEL_BIT=1 
                                     79 
                                     80 
                                     81 ;---------------------------------
                                     82 ; enable SPI peripheral to maximum 
                                     83 ; frequency = Fspi=Fmstr/2 
                                     84 ; input:
                                     85 ;    none  
                                     86 ; output:
                                     87 ;    none 
                                     88 ;--------------------------------- 
      008977                         89 spi_enable::
      008977 72 12 50 C7      [ 1]   90 	bset CLK_PCKENR1,#CLK_PCKENR1_SPI ; enable clock signal 
                                     91 ; configure ~CS on PB1 and BP0 (CN4:11 and CN4:12) as output. 
      00897B 72 11 50 08      [ 1]   92 	bres PB_CR1,#SPI_CS_RAM ; 10K external pull up  
      00897F 72 10 50 07      [ 1]   93 	bset PB_DDR,#SPI_CS_RAM 
      008983 72 10 50 05      [ 1]   94 	bset PB_ODR,#SPI_CS_RAM   ; deselet channel 
      008987 72 13 50 08      [ 1]   95 	bres PB_CR1,#SPI_CS_EEPROM ; 10K external pull up  
      00898B 72 12 50 07      [ 1]   96 	bset PB_DDR,#SPI_CS_EEPROM  
      00898F 72 12 50 05      [ 1]   97 	bset PB_ODR,#SPI_CS_EEPROM  ; deselect channel 
                                     98 ; ~CS line controlled by sofware 	
      008993 72 12 52 01      [ 1]   99 	bset SPI_CR2,#SPI_CR2_SSM 
      008997 72 10 52 01      [ 1]  100     bset SPI_CR2,#SPI_CR2_SSI 
                                    101 ; configure SPI as master mode 0.	
      00899B 72 14 52 00      [ 1]  102 	bset SPI_CR1,#SPI_CR1_MSTR
                                    103 ; enable SPI
      00899F 72 5F 52 02      [ 1]  104 	clr SPI_ICR 
      0089A3 72 1C 52 00      [ 1]  105 	bset SPI_CR1,#SPI_CR1_SPE 	
      0089A7 72 01 52 03 03   [ 2]  106 	btjf SPI_SR,#SPI_SR_RXNE,9$ 
      0089AC C6 52 04         [ 1]  107 	ld a,SPI_DR 
      0089AF A6 40            [ 1]  108 9$: ld a,#RW_MODE_SEQ
      0089B1 CD 8A 60         [ 4]  109 	call spi_ram_set_mode 
      0089B4 CD 8A 75         [ 4]  110 	call spi_ram_read_mode 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 98.
Hexadecimal [24-Bits]



      0089B7 A1 40            [ 1]  111 	cp a,#RW_MODE_SEQ
      0089B9 27 08            [ 1]  112 	jreq 10$  
      0089BB AE 89 C4         [ 2]  113 	ldw x,#spi_mode_failed 
      0089BE CD 85 CD         [ 4]  114 	call puts 
      0089C1 20 FE            [ 2]  115 	jra . 
      0089C3                        116 10$:
      0089C3 81               [ 4]  117 	ret 
      0089C4 66 61 69 6C 65 73 20   118 spi_mode_failed: .asciz "failes to set SPI RAM mode\n"
             74 6F 20 73 65 74 20
             53 50 49 20 52 41 4D
             20 6D 6F 64 65 0A 00
                                    119 
                                    120 ;----------------------------
                                    121 ; disable SPI peripheral 
                                    122 ;----------------------------
      0089E0                        123 spi_disable:
                                    124 ; wait spi idle 
      0089E0 72 03 52 03 FB   [ 2]  125 	btjf SPI_SR,#SPI_SR_TXE,. 
      0089E5 72 01 52 03 FB   [ 2]  126 	btjf SPI_SR,#SPI_SR_RXNE,. 
      0089EA 72 0E 52 03 FB   [ 2]  127 	btjt SPI_SR,#SPI_SR_BSY,.
      0089EF 72 1D 52 00      [ 1]  128 	bres SPI_CR1,#SPI_CR1_SPE
      0089F3 72 13 50 C7      [ 1]  129 	bres CLK_PCKENR1,#CLK_PCKENR1_SPI 
      0089F7 72 11 50 07      [ 1]  130 	bres PB_DDR,#SPI_CS_RAM 
      0089FB 72 13 50 07      [ 1]  131 	bres PB_DDR,#SPI_CS_EEPROM  
      0089FF 81               [ 4]  132 	ret 
                                    133 
                                    134 ;------------------------
                                    135 ; clear SPI error 
                                    136 ;-----------------------
      008A00                        137 spi_clear_error:
      008A00 A6 78            [ 1]  138 	ld a,#0x78 
      008A02 C5 52 03         [ 1]  139 	bcp a,SPI_SR 
      008A05 27 04            [ 1]  140 	jreq 1$
      008A07 72 5F 52 03      [ 1]  141 	clr SPI_SR 
      008A0B 81               [ 4]  142 1$: ret 
                                    143 
                                    144 ;----------------------
                                    145 ; send byte 
                                    146 ; input:
                                    147 ;   A     byte to send 
                                    148 ; output:
                                    149 ;   A     byte received 
                                    150 ;----------------------
      008A0C                        151 spi_send_byte:
      008A0C 88               [ 1]  152 	push a 
      008A0D CD 8A 00         [ 4]  153 	call spi_clear_error
      008A10 84               [ 1]  154 	pop a 
      008A11 72 03 52 03 FB   [ 2]  155 	btjf SPI_SR,#SPI_SR_TXE,.
      008A16 C7 52 04         [ 1]  156 	ld SPI_DR,a
      008A19 72 01 52 03 FB   [ 2]  157 	btjf SPI_SR,#SPI_SR_RXNE,.  
      008A1E C6 52 04         [ 1]  158 	ld a,SPI_DR 
      008A21 81               [ 4]  159 	ret 
                                    160 
                                    161 ;------------------------------
                                    162 ;  receive SPI byte 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 99.
Hexadecimal [24-Bits]



                                    163 ; output:
                                    164 ;    A 
                                    165 ;------------------------------
      008A22                        166 spi_rcv_byte:
      008A22 A6 FF            [ 1]  167 	ld a,#255
      008A24 72 01 52 03 E3   [ 2]  168 	btjf SPI_SR,#SPI_SR_RXNE,spi_send_byte 
      008A29 C6 52 04         [ 1]  169 	ld a,SPI_DR 
      008A2C 81               [ 4]  170 	ret
                                    171 
                                    172 ;----------------------------
                                    173 ;  create bit mask
                                    174 ;  input:
                                    175 ;     A     bit 
                                    176 ;  output:
                                    177 ;     A     2^bit 
                                    178 ;-----------------------------
      008A2D                        179 create_bit_mask:
      008A2D 88               [ 1]  180 	push a 
      008A2E A6 01            [ 1]  181 	ld a,#1 
      008A30 0D 01            [ 1]  182 	tnz (1,sp)
      008A32 27 05            [ 1]  183 	jreq 9$
      008A34                        184 1$:
      008A34 48               [ 1]  185 	sll a 
      008A35 0A 01            [ 1]  186 	dec (1,sp)
      008A37 26 FB            [ 1]  187 	jrne 1$
      0009B9                        188 9$: _drop 1
      008A39 5B 01            [ 2]    1     addw sp,#1 
      008A3B 81               [ 4]  189 	ret 
                                    190 
                                    191 ;-------------------------------
                                    192 ; SPI select channel 
                                    193 ; input:
                                    194 ;   A    channel SPI_CS_RAM || 
                                    195 ;                SPI_CS_EEPROM 
                                    196 ;--------------------------------
      008A3C                        197 spi_select_channel:
      008A3C CD 8A 2D         [ 4]  198 	call create_bit_mask 
      008A3F 43               [ 1]  199 	cpl a  
      008A40 88               [ 1]  200 	push a 
      008A41 C6 50 05         [ 1]  201 	ld a,PB_ODR 
      008A44 14 01            [ 1]  202 	and a,(1,sp)
      008A46 C7 50 05         [ 1]  203 	ld PB_ODR,a 
      0009C9                        204 	_drop 1 
      008A49 5B 01            [ 2]    1     addw sp,#1 
      008A4B 81               [ 4]  205 	ret 
                                    206 
                                    207 ;------------------------------
                                    208 ; SPI deselect channel 
                                    209 ; input:
                                    210 ;   A    channel SPI_CS_RAM ||
                                    211 ; 				 SPI_CS_EEPROM 
                                    212 ;-------------------------------
      008A4C                        213 spi_deselect_channel:
      008A4C 72 0E 52 03 FB   [ 2]  214 	btjt SPI_SR,#SPI_SR_BSY,.
      008A51 CD 8A 2D         [ 4]  215 	call create_bit_mask 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 100.
Hexadecimal [24-Bits]



      008A54 88               [ 1]  216 	push a 
      008A55 C6 50 05         [ 1]  217 	ld a,PB_ODR 
      008A58 1A 01            [ 1]  218 	or a,(1,sp)
      008A5A C7 50 05         [ 1]  219 	ld PB_ODR,a 
      0009DD                        220 	_drop 1 
      008A5D 5B 01            [ 2]    1     addw sp,#1 
      008A5F 81               [ 4]  221 	ret 
                                    222 
                                    223 ;----------------------------
                                    224 ; set spi RAM operating mode 
                                    225 ; input:
                                    226 ;   A     mode byte 
                                    227 ;----------------------------
      008A60                        228 spi_ram_set_mode: 
      008A60 88               [ 1]  229 	push a 
      008A61 A6 00            [ 1]  230 	ld a,#SPI_CS_RAM 
      008A63 CD 8A 3C         [ 4]  231 	call spi_select_channel
      008A66 A6 01            [ 1]  232 	ld a,#SPI_RAM_WRMOD
      008A68 CD 8A 0C         [ 4]  233 	call spi_send_byte 
      008A6B 84               [ 1]  234 	pop a 
      008A6C CD 8A 0C         [ 4]  235 	call spi_send_byte 
      008A6F A6 00            [ 1]  236 	ld a,#SPI_CS_RAM 
      008A71 CD 8A 4C         [ 4]  237 	call spi_deselect_channel
      008A74 81               [ 4]  238 	ret 
                                    239 
                                    240 ;----------------------------
                                    241 ; read spi RAM mode register 
                                    242 ; output:
                                    243 ;   A       mode byte 
                                    244 ;----------------------------
      008A75                        245 spi_ram_read_mode:
      008A75 A6 00            [ 1]  246 	ld a,#SPI_CS_RAM 
      008A77 CD 8A 3C         [ 4]  247 	call spi_select_channel
      008A7A A6 05            [ 1]  248 	ld a,#SPI_RAM_RDMOD 
      008A7C CD 8A 0C         [ 4]  249 	call spi_send_byte 
      008A7F CD 8A 22         [ 4]  250 	call spi_rcv_byte
      008A82 88               [ 1]  251 	push a 
      008A83 A6 00            [ 1]  252 	ld a,#SPI_CS_RAM 
      008A85 CD 8A 4C         [ 4]  253 	call spi_deselect_channel
      008A88 84               [ 1]  254 	pop a 
      008A89 81               [ 4]  255 	ret 
                                    256 
                                    257 
                                    258 ;-----------------------------
                                    259 ; send 24 bits address to 
                                    260 ; SPI device, RAM || FLASH 
                                    261 ; input:
                                    262 ;   farptr   address 
                                    263 ;------------------------------
      008A8A                        264 spi_send_addr:
      000A0A                        265 	_ldaz farptr 
      008A8A B6 0E                    1     .byte 0xb6,farptr 
      008A8C CD 8A 0C         [ 4]  266 	call spi_send_byte 
      000A0F                        267 	_ldaz ptr16 
      008A8F B6 0F                    1     .byte 0xb6,ptr16 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 101.
Hexadecimal [24-Bits]



      008A91 CD 8A 0C         [ 4]  268 	call spi_send_byte 
      000A14                        269 	_ldaz ptr8 
      008A94 B6 10                    1     .byte 0xb6,ptr8 
      008A96 CD 8A 0C         [ 4]  270 	call spi_send_byte 
      008A99 81               [ 4]  271 	ret 
                                    272 
                                    273 ;--------------------------
                                    274 ; write data to spi RAM 
                                    275 ; input:
                                    276 ;   farptr  address 
                                    277 ;   x       count 0=65536
                                    278 ;   y       buffer 
                                    279 ;----------------------------
      008A9A                        280 spi_ram_write:
      008A9A 88               [ 1]  281 	push a 
      008A9B A6 00            [ 1]  282 	ld a,#SPI_CS_RAM 
      008A9D CD 8A 3C         [ 4]  283 	call spi_select_channel
      008AA0 A6 02            [ 1]  284 	ld a,#SPI_RAM_WRITE
      008AA2 CD 8A 0C         [ 4]  285 	call spi_send_byte
      008AA5 CD 8A 8A         [ 4]  286 	call spi_send_addr 
      008AA8 90 F6            [ 1]  287 1$:	ld a,(y)
      008AAA 90 5C            [ 1]  288 	incw y 
      008AAC CD 8A 0C         [ 4]  289 	call spi_send_byte
      008AAF 5A               [ 2]  290 	decw x 
      008AB0 26 F6            [ 1]  291 	jrne 1$ 
      008AB2 A6 00            [ 1]  292 	ld a,#SPI_CS_RAM 
      008AB4 CD 8A 4C         [ 4]  293 	call spi_deselect_channel
      008AB7 84               [ 1]  294 	pop a 
      008AB8 81               [ 4]  295 	ret 
                                    296 
                                    297 ;-------------------------------
                                    298 ; read bytes from SPI RAM 
                                    299 ; input:
                                    300 ;   farptr   address 
                                    301 ;   X        count 
                                    302 ;   Y        buffer 
                                    303 ;-------------------------------
      008AB9                        304 spi_ram_read:
      008AB9 88               [ 1]  305 	push a 
      008ABA A6 00            [ 1]  306 	ld a,#SPI_CS_RAM 
      008ABC CD 8A 3C         [ 4]  307 	call spi_select_channel
      008ABF A6 03            [ 1]  308 	ld a,#SPI_RAM_READ
      008AC1 CD 8A 0C         [ 4]  309 	call spi_send_byte
      008AC4 CD 8A 8A         [ 4]  310 	call spi_send_addr 
      008AC7 CD 8A 22         [ 4]  311 1$:	call spi_rcv_byte 
      008ACA 90 F7            [ 1]  312 	ld (y),a 
      008ACC 90 5C            [ 1]  313 	incw y 
      008ACE 5A               [ 2]  314 	decw x 
      008ACF 26 F6            [ 1]  315 	jrne 1$ 
      008AD1 A6 00            [ 1]  316 	ld a,#SPI_CS_RAM 
      008AD3 CD 8A 4C         [ 4]  317 	call spi_deselect_channel
      008AD6 84               [ 1]  318 	pop a 
      008AD7 81               [ 4]  319 	ret 
                                    320 
                                    321 ;---------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 102.
Hexadecimal [24-Bits]



                                    322 ; enable write to eeprom 
                                    323 ;----------------------
      008AD8                        324 eeprom_enable_write:
      008AD8 A6 01            [ 1]  325 	ld a,#SPI_CS_EEPROM 
      008ADA CD 8A 3C         [ 4]  326 	call spi_select_channel 
      008ADD A6 06            [ 1]  327 	ld a,#WR_EN 
      008ADF CD 8A 0C         [ 4]  328 	call spi_send_byte 
      008AE2 A6 01            [ 1]  329 	ld a,#SPI_CS_EEPROM 
      008AE4 CD 8A 4C         [ 4]  330 	call spi_deselect_channel 
      008AE7 81               [ 4]  331 	ret 
                                    332 
                                    333 ;----------------------------
                                    334 ;  read eeprom status register 
                                    335 ;----------------------------
      008AE8                        336 eeprom_read_status:
      008AE8 A6 01            [ 1]  337 	ld a,#SPI_CS_EEPROM 	
      008AEA CD 8A 3C         [ 4]  338 	call spi_select_channel 
      008AED A6 05            [ 1]  339 	ld a,#RD_STATUS 
      008AEF CD 8A 0C         [ 4]  340 	call spi_send_byte
      008AF2 CD 8A 22         [ 4]  341 	call spi_rcv_byte 
      008AF5 88               [ 1]  342 	push a  
      008AF6 A6 01            [ 1]  343 	ld a,#SPI_CS_EEPROM 
      008AF8 CD 8A 4C         [ 4]  344 	call spi_deselect_channel
      008AFB 84               [ 1]  345 	pop a		
      008AFC 81               [ 4]  346 	ret
                                    347 
                                    348 ;----------------------------
                                    349 ; write data to 25LC1024
                                    350 ; page 
                                    351 ; input:
                                    352 ;   farptr  address 
                                    353 ;   A       byte count, 0 -> 256 
                                    354 ;   X       buffer address 
                                    355 ; output:
                                    356 ;   none 
                                    357 ;----------------------------
                           000001   358 	BUF_ADR=1 
                           000003   359 	COUNT=BUF_ADR+2
                           000003   360 	VSIZE=COUNT 
      008AFD                        361 eeprom_write::
      008AFD 88               [ 1]  362 	push a 
      008AFE 89               [ 2]  363 	pushw x 
      008AFF CD 8A D8         [ 4]  364 	call eeprom_enable_write
      008B02 A6 01            [ 1]  365 	ld a,#SPI_CS_EEPROM 
      008B04 CD 8A 3C         [ 4]  366 	call spi_select_channel 
      008B07 A6 02            [ 1]  367 	ld a,#SPI_EEPROM_WRITE 
      008B09 CD 8A 0C         [ 4]  368 	call spi_send_byte 
      008B0C CD 8A 8A         [ 4]  369 	call spi_send_addr 
      008B0F 1E 01            [ 2]  370 	ldw x,(BUF_ADR,sp)
      008B11                        371 1$:
      008B11 F6               [ 1]  372 	ld a,(x)
      008B12 CD 8A 0C         [ 4]  373 	call spi_send_byte
      008B15 5C               [ 1]  374 	incw x
      008B16 0A 03            [ 1]  375 	dec (COUNT,sp) 
      008B18 26 F7            [ 1]  376 	jrne 1$ 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 103.
Hexadecimal [24-Bits]



      008B1A A6 01            [ 1]  377 6$: ld a,#SPI_CS_EEPROM 
      008B1C CD 8A 4C         [ 4]  378 	call spi_deselect_channel
      008B1F CD 8A E8         [ 4]  379 7$:	call eeprom_read_status 
      008B22 A5 01            [ 1]  380 	bcp a,#(1<<SR_WIP_BIT)
      008B24 26 F9            [ 1]  381 	jrne 7$
      000AA6                        382 	_drop VSIZE
      008B26 5B 03            [ 2]    1     addw sp,#VSIZE 
      008B28 81               [ 4]  383 	ret 
                                    384 
                                    385 
                                    386 ;-------------------------- 
                                    387 ; read bytes from flash 
                                    388 ; memory in buffer 
                                    389 ; input:
                                    390 ;   farptr addr in flash 
                                    391 ;   x     count, 0=65536
                                    392 ;   y     buffer addr 
                                    393 ;---------------------------
      008B29                        394 eeprom_read::
      008B29 89               [ 2]  395 	pushw x 
      008B2A A6 01            [ 1]  396 	ld a,#SPI_CS_EEPROM
      008B2C CD 8A 3C         [ 4]  397 	call spi_select_channel
      008B2F A6 03            [ 1]  398 	ld a,#SPI_EEPROM_READ
      008B31 CD 8A 0C         [ 4]  399 	call spi_send_byte
      008B34 CD 8A 8A         [ 4]  400 	call spi_send_addr  
      008B37 CD 8A 22         [ 4]  401 1$: call spi_rcv_byte 
      008B3A 90 F7            [ 1]  402 	ld (y),a 
      008B3C 90 5C            [ 1]  403 	incw y 
      008B3E 1E 01            [ 2]  404 	ldw x,(1,sp)
      008B40 5A               [ 2]  405 	decw x
      008B41 1F 01            [ 2]  406 	ldw (1,sp),x 
      008B43 26 F2            [ 1]  407 	jrne 1$ 
      008B45 A6 01            [ 1]  408 9$:	ld a,#SPI_CS_EEPROM 
      008B47 CD 8A 4C         [ 4]  409 	call spi_deselect_channel
      000ACA                        410 	_drop 2 
      008B4A 5B 02            [ 2]    1     addw sp,#2 
      008B4C 81               [ 4]  411 	ret 
                                    412 
                                    413 ;--------------------
                                    414 ; return true if 
                                    415 ; page empty 
                                    416 ; input:
                                    417 ;    X   page# 
                                    418 ; output:
                                    419 ;    A   -1 true||0 false 
                                    420 ;    X   not changed 
                                    421 ;-------------------------
      008B4D                        422 eeprom_page_empty:
      008B4D 89               [ 2]  423 	pushw x 
      008B4E CD 8B BB         [ 4]  424 	call page_addr 
      000AD1                        425 	_straz farptr 
      008B51 B7 0E                    1     .byte 0xb7,farptr 
      000AD3                        426 	_strxz ptr16 
      008B53 BF 0F                    1     .byte 0xbf,ptr16 
      008B55 A6 01            [ 1]  427 	ld a,#SPI_CS_EEPROM 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 104.
Hexadecimal [24-Bits]



      008B57 CD 8A 3C         [ 4]  428 	call spi_select_channel
      008B5A A6 03            [ 1]  429 	ld a,#SPI_EEPROM_READ 
      008B5C CD 8A 0C         [ 4]  430 	call spi_send_byte 
      008B5F CD 8A 8A         [ 4]  431 	call spi_send_addr
      008B62 4B 00            [ 1]  432 	push #0 
      008B64 CD 8A 22         [ 4]  433 1$:	call spi_rcv_byte 
      008B67 A1 FF            [ 1]  434 	cp a,#0xff 
      008B69 26 08            [ 1]  435 	jrne 8$ 
      008B6B 0A 01            [ 1]  436 	dec (1,sp)
      008B6D 26 F5            [ 1]  437 	jrne 1$ 
      008B6F 03 01            [ 1]  438 	cpl (1,sp) 
      008B71 20 02            [ 2]  439 	jra 9$
      008B73 0F 01            [ 1]  440 8$: clr (1,sp) 
      008B75 A6 01            [ 1]  441 9$: ld a,#SPI_CS_EEPROM 
      008B77 CD 8A 4C         [ 4]  442 	call spi_deselect_channel
      008B7A 84               [ 1]  443 	pop a 
      008B7B 85               [ 2]  444 	popw x 
      008B7C 81               [ 4]  445 	ret 
                                    446 
                                    447 ;----------------------
                                    448 ; erase 32KB sector 
                                    449 ; input:
                                    450 ;   A    sector number {0..3} 
                                    451 ; output:
                                    452 ;   none 
                                    453 ;----------------------
      008B7D                        454 eeprom_erase_sector:
      008B7D CD 8B BB         [ 4]  455 	call page_addr 
      000B00                        456 	_straz farptr 
      008B80 B7 0E                    1     .byte 0xb7,farptr 
      000B02                        457 	_strxz ptr16 
      008B82 BF 0F                    1     .byte 0xbf,ptr16 
      008B84 CD 8A D8         [ 4]  458 	call eeprom_enable_write
      008B87 A6 01            [ 1]  459 	ld a,#SPI_CS_EEPROM 
      008B89 CD 8A 3C         [ 4]  460 	call spi_select_channel
      008B8C A6 D8            [ 1]  461 	ld a,#SECT_ERASE
      008B8E CD 8A 0C         [ 4]  462 	call spi_send_byte 
      008B91 CD 8A 8A         [ 4]  463 	call spi_send_addr 
      008B94 A6 01            [ 1]  464 	ld a,#SPI_CS_EEPROM 
      008B96 CD 8A 4C         [ 4]  465 	call spi_deselect_channel
      008B99 CD 8A E8         [ 4]  466 1$:	call eeprom_read_status
      008B9C A5 01            [ 1]  467 	bcp a,#(1<<SR_WIP_BIT)
      008B9E 26 F9            [ 1]  468 	jrne 1$
      008BA0 81               [ 4]  469 	ret 
                                    470 
                                    471 ;-----------------------------
                                    472 ; erase whole eeprom 
                                    473 ;-----------------------------
      008BA1                        474 eeprom_erase_chip::
      008BA1 CD 8A D8         [ 4]  475 	call eeprom_enable_write 
      008BA4 A6 01            [ 1]  476 	ld a,#SPI_CS_EEPROM 
      008BA6 CD 8A 3C         [ 4]  477 	call spi_select_channel
      008BA9 A6 C7            [ 1]  478 	ld a,#CHIP_ERASE
      008BAB CD 8A 0C         [ 4]  479 	call spi_send_byte 
      008BAE A6 01            [ 1]  480 	ld a,#SPI_CS_EEPROM 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 105.
Hexadecimal [24-Bits]



      008BB0 CD 8A 4C         [ 4]  481 	call spi_deselect_channel
      008BB3 CD 8A E8         [ 4]  482 1$:	call eeprom_read_status
      008BB6 A5 01            [ 1]  483 	bcp a,#(1<<SR_WIP_BIT)
      008BB8 26 F9            [ 1]  484 	jrne 1$
      008BBA 81               [ 4]  485 	ret 
                                    486 
                                    487 ;---------------------------
                                    488 ; convert page number 
                                    489 ; to address addr=256*page#
                                    490 ; input:
                                    491 ;   X     page {0..511}
                                    492 ; ouput:
                                    493 ;   A:X    address 
                                    494 ;---------------------------
      008BBB                        495 page_addr:
      008BBB 4F               [ 1]  496 	clr a 
      008BBC 02               [ 1]  497 	rlwa x 
      008BBD 81               [ 4]  498 	ret 
                                    499 
                                    500 ;----------------------------
                                    501 ; convert address to sector#
                                    502 ; input:
                                    503 ;   farptr   address 
                                    504 ; output:
                                    505 ;   X       page  {0..511}
                                    506 ;----------------------------
      008BBE                        507 addr_to_page::
      000B3E                        508 	_ldaz farptr 
      008BBE B6 0E                    1     .byte 0xb6,farptr 
      000B40                        509 	_ldxz ptr16 
      008BC0 BE 0F                    1     .byte 0xbe,ptr16 
      008BC2 01               [ 1]  510 	rrwa x  
      008BC3 81               [ 4]  511 	ret 
                                    512 
                                    513 ;---- test code -----
                                    514 
                                    515 ; ----- spi FLASH test ---------
                           000000   516 .if 0
                                    517 eeprom_test_msg: .byte 27,'c 
                                    518 .asciz "spi EEPROM test\n"
                                    519 no_empty_msg: .asciz " no empty page "
                                    520 writing_msg: .asciz "\nwriting 128 bytes in page " 
                                    521 reading_msg: .asciz "\nreading back\n" 
                                    522 repeat_msg: .asciz "\nkey to repeat"
                                    523 eeprom_test:
                                    524 	call spi_enable
                                    525 3$:
                                    526 	ldw x,#eeprom_test_msg 
                                    527 	call puts 
                                    528 	ldw x,#writing_msg   
                                    529 	call puts 
                                    530 ; search empty page 
                                    531 	clrw x
                                    532 7$:	call save_cursor_pos
                                    533 	pushw x 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 106.
Hexadecimal [24-Bits]



                                    534 	call print_int 
                                    535 	call restore_cursor_pos 
                                    536 	popw x 
                                    537 	call eeprom_page_empty
                                    538 	tnz a 
                                    539 	jrmi 5$
                                    540 	incw x 
                                    541 	cpw x,#512
                                    542 	jrmi 7$
                                    543 	clr a 
                                    544 	call eeprom_erase_sector
                                    545 	ldw x,#no_empty_msg 
                                    546 	call puts 
                                    547 	call prng
                                    548 	rlwa x 
                                    549 	and a,#1 
                                    550 	rrwa x 
                                    551 5$: pushw x  
                                    552 	call print_int 
                                    553 	call new_line 
                                    554 	popw x 
                                    555 	call page_addr 
                                    556 	_straz farptr 
                                    557 	_strxz ptr16 
                                    558 ; fill tib with 128 random byte 
                                    559 0$:
                                    560 	push #64
                                    561 	ldw y,#tib 
                                    562 1$:
                                    563 	call prng 
                                    564 	ldw (y),x
                                    565 	ld a,xh 
                                    566 	call print_hex
                                    567 	call space  
                                    568 	ld a,xl 
                                    569 	call print_hex 
                                    570 	call space 
                                    571 	addw y,#2 
                                    572 	pop a 
                                    573 	dec a 
                                    574 	jreq 4$
                                    575 	push a 
                                    576 	and a,#7 
                                    577 	jrne 1$ 
                                    578 	call new_line 
                                    579 	jra 1$ 
                                    580 4$:
                                    581 	ld a,#128 
                                    582 	ldw x,#tib 
                                    583 	call eeprom_write
                                    584 ; clear tib
                                    585 	ldw x,#tib 
                                    586 	ld a,#128 
                                    587 6$:	clr (x)
                                    588 	incw x 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 107.
Hexadecimal [24-Bits]



                                    589 	dec a 
                                    590 	jrne 6$
                                    591 ;read back written data 
                                    592 	ldw x,#reading_msg 
                                    593 	call puts 
                                    594 	ldw y,#tib 
                                    595 	ldw x,#128 
                                    596 	call eeprom_read 
                                    597 	push #128 
                                    598 	ldw y,#tib 
                                    599 2$: ld a,(y)
                                    600 	call print_hex 
                                    601 	call space 
                                    602 	incw y
                                    603 	pop a 
                                    604 	dec a
                                    605 	jreq 9$  
                                    606 	push a  
                                    607 	and a,#15 
                                    608 	jrne 2$
                                    609 	call new_line
                                    610 	jra 2$  
                                    611 9$:	
                                    612 	ldw x,#repeat_msg
                                    613 	call puts 
                                    614 	call getc
                                    615 	jp 3$
                                    616 .endif 
                                    617 
                                    618 
                                    619 
                                    620 ;----- spi RAM test 
                           000000   621 .if 0
                                    622 spi_ram_msg: .byte 27,'c  
                                    623  .asciz "SPI RAM test\n"
                                    624 spi_ram_write_msg: .asciz "Writing 128 bytes at "
                                    625 spi_ram_read_msg: .asciz "\nreading data back\n"
                                    626 spi_ram_test:
                                    627 	call spi_enable 
                                    628 	ldw x,#spi_ram_msg 
                                    629 	call puts
                                    630 	ldw x,#spi_ram_write_msg 
                                    631 	call puts  
                                    632 	call prng 
                                    633 	_clrz farptr 
                                    634 	_strxz ptr16 
                                    635 	call print_int
                                    636 	call new_line
                                    637 ; fill tib with random bytes 
                                    638 	push #64
                                    639 	ldw y,#tib 
                                    640 1$:	call prng 
                                    641 	ldw (y),x 
                                    642 	addw y,#2
                                    643 	pushw x 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 108.
Hexadecimal [24-Bits]



                                    644 	pop a 
                                    645 	call print_hex 
                                    646 	call space 
                                    647 	pop a 
                                    648 	call print_hex 
                                    649 	call space  
                                    650 	pop a 
                                    651 	dec a 
                                    652 	jreq 4$
                                    653 	push a 
                                    654 	and a,#7 
                                    655 	jrne 1$ 
                                    656 	call new_line 
                                    657 	jra 1$ 
                                    658 4$:
                                    659 	ldw x,#128 
                                    660 	ldw y,#tib 
                                    661 	call spi_ram_write 
                                    662 	ldw x,#spi_ram_read_msg 
                                    663 	call puts
                                    664 ; clear tib 
                                    665 	ldw x,#128
                                    666 	ldw y,#tib 
                                    667 2$: clr (y)
                                    668 	incw y 
                                    669 	decw x 
                                    670 	jrne 2$
                                    671 	ldw y,#tib 
                                    672 	ldw x,#128 
                                    673 	call spi_ram_read 
                                    674 	push #128 
                                    675 	ldw y,#tib
                                    676 ; print read values 
                                    677 3$:	ld a,(y)
                                    678 	incw y 
                                    679 	call print_hex 
                                    680 	call space 
                                    681 	pop a 
                                    682 	dec a 
                                    683 	jreq 5$
                                    684 	push a 
                                    685 	and a,#15
                                    686 	jrne 3$ 
                                    687 	call new_line
                                    688 	jra 3$ 
                                    689 5$:
                                    690 	ldw x,#repeat_msg
                                    691 	call puts 
                                    692 	call getc 
                                    693 	jp spi_ram_test
                                    694 .endif 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 109.
Hexadecimal [24-Bits]

Symbol Table

    .__.$$$.=  002710 L   |     .__.ABS.=  000000 G   |     .__.CPU.=  000000 L
    .__.H$L.=  000001 L   |     ACK     =  000006     |     ADC_CR1 =  005401 
    ADC_CR1_=  000000     |     ADC_CR1_=  000001     |     ADC_CR1_=  000004 
    ADC_CR1_=  000005     |     ADC_CR1_=  000006     |     ADC_CR2 =  005402 
    ADC_CR2_=  000003     |     ADC_CR2_=  000004     |     ADC_CR2_=  000005 
    ADC_CR2_=  000006     |     ADC_CR2_=  000001     |     ADC_CR3 =  005403 
    ADC_CR3_=  000007     |     ADC_CR3_=  000006     |     ADC_CSR =  005400 
    ADC_CSR_=  000006     |     ADC_CSR_=  000004     |     ADC_CSR_=  000000 
    ADC_CSR_=  000001     |     ADC_CSR_=  000002     |     ADC_CSR_=  000003 
    ADC_CSR_=  000007     |     ADC_CSR_=  000005     |     ADC_DRH =  005404 
    ADC_DRL =  005405     |     ADC_TDRH=  005406     |     ADC_TDRL=  005407 
    ADR_SIZE=  000002     |     AFR     =  004803     |     AFR0_ADC=  000000 
    AFR1_TIM=  000001     |     AFR2_CCO=  000002     |     AFR3_TIM=  000003 
    AFR4_TIM=  000004     |     AFR5_TIM=  000005     |     AFR6_I2C=  000006 
    AFR7_BEE=  000007     |     ANSI    =  000000     |     APP_DATA=  000030 
    ARG_OFS =  000002     |     ARITHM_V=  000004     |     AWU_APR =  0050F1 
    AWU_CSR =  0050F0     |     AWU_CSR_=  000004     |     AWU_TBR =  0050F2 
    B0_MASK =  000001     |     B115200 =  000006     |     B19200  =  000003 
    B1_MASK =  000002     |     B230400 =  000007     |     B2400   =  000000 
    B2_MASK =  000004     |     B38400  =  000004     |     B3_MASK =  000008 
    B460800 =  000008     |     B4800   =  000001     |     B4_MASK =  000010 
    B57600  =  000005     |     B5_MASK =  000020     |     B6_MASK =  000040 
    B7_MASK =  000080     |     B921600 =  000009     |     B9600   =  000002 
    BAT_OK  =  0000AA     |     BAUD_RAT=  01C200     |     BEEP_BIT=  000004 
    BEEP_CSR=  0050F3     |     BEEP_MAS=  000010     |     BEEP_POR=  00000F 
    BELL    =  000007     |     BIT0    =  000000     |     BIT1    =  000001 
    BIT2    =  000002     |     BIT3    =  000003     |     BIT4    =  000004 
    BIT5    =  000005     |     BIT6    =  000006     |     BIT7    =  000007 
    BLOCK_SI=  000080     |     BOOT_ROM=  006000     |     BOOT_ROM=  007FFF 
    BS      =  000008     |     BUFOUT  =  000003     |     BUF_ADR =  000001 
    CAN     =  000018     |     CAN_DGR =  005426     |     CAN_FPSR=  005427 
    CAN_IER =  005425     |     CAN_MCR =  005420     |     CAN_MSR =  005421 
    CAN_P0  =  005428     |     CAN_P1  =  005429     |     CAN_P2  =  00542A 
    CAN_P3  =  00542B     |     CAN_P4  =  00542C     |     CAN_P5  =  00542D 
    CAN_P6  =  00542E     |     CAN_P7  =  00542F     |     CAN_P8  =  005430 
    CAN_P9  =  005431     |     CAN_PA  =  005432     |     CAN_PB  =  005433 
    CAN_PC  =  005434     |     CAN_PD  =  005435     |     CAN_PE  =  005436 
    CAN_PF  =  005437     |     CAN_RFR =  005424     |     CAN_TPR =  005423 
    CAN_TSR =  005422     |     CC_C    =  000000     |     CC_H    =  000004 
    CC_I0   =  000003     |     CC_I1   =  000005     |     CC_N    =  000002 
    CC_V    =  000007     |     CC_Z    =  000001     |     CELL_SIZ=  000002 G
    CFG_GCR =  007F60     |     CFG_GCR_=  000001     |     CFG_GCR_=  000000 
    CHAR    =  000003     |     CHIP_ERA=  0000C7     |     CHK_TIMO=  00000B G
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 110.
Hexadecimal [24-Bits]

Symbol Table

    CLK_PCKE=  000002     |     CLK_PCKE=  000007     |     CLK_SWCR=  0050C5 
    CLK_SWCR=  000000     |     CLK_SWCR=  000001     |     CLK_SWCR=  000002 
    CLK_SWCR=  000003     |     CLK_SWIM=  0050CD     |     CLK_SWR =  0050C4 
    CLK_SWR_=  0000B4     |     CLK_SWR_=  0000E1     |     CLK_SWR_=  0000D2 
    CLS     =  000005 G   |     COL     =  000003     |     COLON   =  00003A 
    COMMA   =  00002C     |     COUNT   =  000003     |     CPOS    =  000002 
    CPU_A   =  007F00     |     CPU_CCR =  007F0A     |     CPU_PCE =  007F01 
    CPU_PCH =  007F02     |     CPU_PCL =  007F03     |     CPU_SPH =  007F08 
    CPU_SPL =  007F09     |     CPU_XH  =  007F04     |     CPU_XL  =  007F05 
    CPU_YH  =  007F06     |     CPU_YL  =  007F07     |     CR      =  00000D 
    CTRL_A  =  000001     |     CTRL_B  =  000002     |     CTRL_C  =  000003 
    CTRL_D  =  000004     |     CTRL_E  =  000005     |     CTRL_F  =  000006 
    CTRL_G  =  000007     |     CTRL_H  =  000008     |     CTRL_I  =  000009 
    CTRL_J  =  00000A     |     CTRL_K  =  00000B     |     CTRL_L  =  00000C 
    CTRL_M  =  00000D     |     CTRL_N  =  00000E     |     CTRL_O  =  00000F 
    CTRL_P  =  000010     |     CTRL_Q  =  000011     |     CTRL_R  =  000012 
    CTRL_S  =  000013     |     CTRL_T  =  000014     |     CTRL_U  =  000015 
    CTRL_V  =  000016     |     CTRL_W  =  000017     |     CTRL_X  =  000018 
    CTRL_Y  =  000019     |     CTRL_Z  =  00001A     |     DBLDIVDN=  000005 
    DBLHI   =  000001     |     DBLLO   =  000003     |     DC1     =  000011 
    DC2     =  000012     |     DC3     =  000013     |     DC4     =  000014 
    DEBUG   =  000000     |     DEBUG_BA=  007F00     |     DEBUG_EN=  007FFF 
    DELBK   =  000006 G   |     DEVID_BA=  0048CD     |     DEVID_EN=  0048D8 
    DEVID_LO=  0048D2     |     DEVID_LO=  0048D3     |     DEVID_LO=  0048D4 
    DEVID_LO=  0048D5     |     DEVID_LO=  0048D6     |     DEVID_LO=  0048D7 
    DEVID_LO=  0048D8     |     DEVID_WA=  0048D1     |     DEVID_XH=  0048CE 
    DEVID_XL=  0048CD     |     DEVID_YH=  0048D0     |     DEVID_YL=  0048CF 
    DIGIT   =  000001     |     DIVDHI  =  000001     |     DIVDLO  =  000003 
    DIVDNDHI=  00000B     |     DIVDNDLO=  00000D     |     DIVISOR =  000001 
    DIVISR  =  000005     |     DIVR    =  000005     |     DLE     =  000010 
    DM_BK1RE=  007F90     |     DM_BK1RH=  007F91     |     DM_BK1RL=  007F92 
    DM_BK2RE=  007F93     |     DM_BK2RH=  007F94     |     DM_BK2RL=  007F95 
    DM_CR1  =  007F96     |     DM_CR2  =  007F97     |     DM_CSR1 =  007F98 
    DM_CSR2 =  007F99     |     DM_ENFCT=  007F9A     |     DPROD   =  000003 
    DTR     =  000000     |     EEPROM_B=  004000     |     EEPROM_E=  0043FF 
    EEPROM_S=  000400     |     EM      =  000019     |     ENQ     =  000005 
    EOF     =  0000FF     |     EOT     =  000004     |     ERR_DIV0   ****** GX
    ERR_GT32   ****** GX  |     ESC     =  00001B     |     ETB     =  000017 
    ETX     =  000003     |     EXTI_CR1=  0050A0     |     EXTI_CR2=  0050A1 
    FAUTO   =  000006     |     FCOMP   =  000005     |     FF      =  00000C 
    FHSE    =  7A1200     |     FHSI    =  F42400     |     FIRST_DA=  000004 
    FLASH_BA=  008000     |     FLASH_CR=  00505A     |     FLASH_CR=  000002 
    FLASH_CR=  000000     |     FLASH_CR=  000003     |     FLASH_CR=  000001 
    FLASH_CR=  00505B     |     FLASH_CR=  000005     |     FLASH_CR=  000004 
    FLASH_CR=  000007     |     FLASH_CR=  000000     |     FLASH_CR=  000006 
    FLASH_DU=  005064     |     FLASH_DU=  0000AE     |     FLASH_DU=  000056 
    FLASH_EN=  017FFF     |     FLASH_FP=  00505D     |     FLASH_FP=  000000 
    FLASH_FP=  000001     |     FLASH_FP=  000002     |     FLASH_FP=  000003 
    FLASH_FP=  000004     |     FLASH_FP=  000005     |     FLASH_IA=  00505F 
    FLASH_IA=  000003     |     FLASH_IA=  000002     |     FLASH_IA=  000006 
    FLASH_IA=  000001     |     FLASH_IA=  000000     |     FLASH_NC=  00505C 
    FLASH_NF=  00505E     |     FLASH_NF=  000000     |     FLASH_NF=  000001 
    FLASH_NF=  000002     |     FLASH_NF=  000003     |     FLASH_NF=  000004 
    FLASH_NF=  000005     |     FLASH_PU=  005062     |     FLASH_PU=  000056 
    FLASH_PU=  0000AE     |     FLASH_SI=  010000     |     FLASH_WS=  00480D 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 111.
Hexadecimal [24-Bits]

Symbol Table

    FLSI    =  01F400     |     FMSTR   =  000010     |     FOPT    =  000001 
    FREE_RAM=  001580 G   |     FRUN    =  000000     |     FS      =  00001C 
    FSLEEP  =  000003     |     FSTOP   =  000004     |     FSYS_TIM=  000000 G
    FSYS_TON=  000001 G   |     FSYS_UPP=  000002 G   |     FS_BASE =  00C000 G
    FS_SIZE =  00C000 G   |     FTRACE  =  000007     |     GETC    =  000003 G
    GETLN   =  000007 G   |     GET_RND =  00000D G   |     GPIO_BAS=  005000 
    GPIO_CR1=  000003     |     GPIO_CR2=  000004     |     GPIO_DDR=  000002 
    GPIO_IDR=  000001     |     GPIO_ODR=  000000     |     GPIO_SIZ=  000005 
    GS      =  00001D     |     HSE     =  000000     |     HSECNT  =  004809 
    HSI     =  000001     |     I2C_BASE=  005210     |     I2C_CCRH=  00521C 
    I2C_CCRH=  000080     |     I2C_CCRH=  0000C0     |     I2C_CCRH=  000080 
    I2C_CCRH=  000000     |     I2C_CCRH=  000001     |     I2C_CCRH=  000000 
    I2C_CCRH=  000006     |     I2C_CCRH=  000007     |     I2C_CCRL=  00521B 
    I2C_CCRL=  00001A     |     I2C_CCRL=  000002     |     I2C_CCRL=  00000D 
    I2C_CCRL=  000050     |     I2C_CCRL=  000090     |     I2C_CCRL=  0000A0 
    I2C_CR1 =  005210     |     I2C_CR1_=  000006     |     I2C_CR1_=  000007 
    I2C_CR1_=  000000     |     I2C_CR2 =  005211     |     I2C_CR2_=  000002 
    I2C_CR2_=  000003     |     I2C_CR2_=  000000     |     I2C_CR2_=  000001 
    I2C_CR2_=  000007     |     I2C_DR  =  005216     |     I2C_FREQ=  005212 
    I2C_ITR =  00521A     |     I2C_ITR_=  000002     |     I2C_ITR_=  000000 
    I2C_ITR_=  000001     |     I2C_OARH=  005214     |     I2C_OARH=  000001 
    I2C_OARH=  000002     |     I2C_OARH=  000006     |     I2C_OARH=  000007 
    I2C_OARL=  005213     |     I2C_OARL=  000000     |     I2C_OAR_=  000813 
    I2C_OAR_=  000009     |     I2C_PECR=  00521E     |     I2C_READ=  000001 
    I2C_SR1 =  005217     |     I2C_SR1_=  000003     |     I2C_SR1_=  000001 
    I2C_SR1_=  000002     |     I2C_SR1_=  000006     |     I2C_SR1_=  000000 
    I2C_SR1_=  000004     |     I2C_SR1_=  000007     |     I2C_SR2 =  005218 
    I2C_SR2_=  000002     |     I2C_SR2_=  000001     |     I2C_SR2_=  000000 
    I2C_SR2_=  000003     |     I2C_SR2_=  000005     |     I2C_SR3 =  005219 
    I2C_SR3_=  000001     |     I2C_SR3_=  000007     |     I2C_SR3_=  000004 
    I2C_SR3_=  000000     |     I2C_SR3_=  000002     |     I2C_TRIS=  00521D 
    I2C_TRIS=  000005     |     I2C_TRIS=  000005     |     I2C_TRIS=  000005 
    I2C_TRIS=  000011     |     I2C_TRIS=  000011     |     I2C_TRIS=  000011 
    I2C_WRIT=  000000     |     INCR    =  000001     |     INPUT_DI=  000000 
    INPUT_EI=  000001     |     INPUT_FL=  000000     |     INPUT_PU=  000001 
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
    INT_VECT=  00805C     |     INT_VECT=  008058     |     ITC_SPR1=  007F70 
    ITC_SPR2=  007F71     |     ITC_SPR3=  007F72     |     ITC_SPR4=  007F73 
    ITC_SPR5=  007F74     |     ITC_SPR6=  007F75     |     ITC_SPR7=  007F76 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 112.
Hexadecimal [24-Bits]

Symbol Table

    ITC_SPR8=  007F77     |     ITC_SPR_=  000001     |     ITC_SPR_=  000000 
    ITC_SPR_=  000003     |     IWDG_KEY=  000055     |     IWDG_KEY=  0000CC 
    IWDG_KEY=  0000AA     |     IWDG_KR =  0050E0     |     IWDG_PR =  0050E1 
    IWDG_RLR=  0050E2     |     KBD_ACK =  0000FA     |     KBD_LED =  0000ED 
    KBD_RESE=  0000FE     |     KBD_RESE=  0000FF     |     KERNEL_M=  000001 
    KERNEL_M=  000000     |     KERNEL_R=  000002     |     KEY_REL =  0000F0 
    LB      =  000002     |     LED_BIT =  000005     |     LED_MASK=  000020 
    LED_PORT=  00500A     |     LEN     =  000002     |     LF      =  00000A 
    LINE    =  000001     |     LINE_HEA=  000003     |     LN_LEN  =  000001 
    MAJOR   =  000003     |     MASKED  =  000005     |     MAX_LEN =  00003C 
    MAX_LINE=  007FFF     |     MINOR   =  000004     |     N1      =  000001 
    N2      =  000003     |     NAFR    =  004804     |     NAK     =  000015 
    NAME_SIZ=  000002     |     NCLKOPT =  004808     |     NFLASH_W=  00480E 
    NHSECNT =  00480A     |     NLEN_MAS=  00000F     |     NONE_IDX=  0000FF 
    NOPT1   =  004802     |     NOPT2   =  004804     |     NOPT3   =  004806 
    NOPT4   =  004808     |     NOPT5   =  00480A     |     NOPT6   =  00480C 
    NOPT7   =  00480E     |     NOPTBL  =  00487F     |     NUBC    =  004802 
    NUCLEO_8=  000001     |     NUCLEO_8=  000000     |     NWDGOPT =  004806 
    NWDGOPT_=  FFFFFFFD     |     NWDGOPT_=  FFFFFFFC     |     NWDGOPT_=  FFFFFFFF 
    NWDGOPT_=  FFFFFFFE     |   5 NonHandl   000000 GR  |     OFS_UART=  000002 
    OFS_UART=  000003     |     OFS_UART=  000004     |     OFS_UART=  000005 
    OFS_UART=  000006     |     OFS_UART=  000007     |     OFS_UART=  000008 
    OFS_UART=  000009     |     OFS_UART=  000001     |     OFS_UART=  000009 
    OFS_UART=  00000A     |     OFS_UART=  000000     |     OPT0    =  004800 
    OPT1    =  004801     |     OPT2    =  004803     |     OPT3    =  004805 
    OPT4    =  004807     |     OPT5    =  004809     |     OPT6    =  00480B 
    OPT7    =  00480D     |     OPTBL   =  00487E     |     OPTION_B=  004800 
    OPTION_E=  00487F     |     OPTION_S=  000080     |     OUTPUT_F=  000001 
    OUTPUT_O=  000000     |     OUTPUT_P=  000001     |     OUTPUT_S=  000000 
    P1      =  000001     |     P2      =  000002     |     PA      =  000000 
    PAD_SIZE=  000080 G   |     PAGE0_SI=  000100 G   |     PAGE_ERA=  000042 
    PA_BASE =  005000     |     PA_CR1  =  005003     |     PA_CR2  =  005004 
    PA_DDR  =  005002     |     PA_IDR  =  005001     |     PA_ODR  =  005000 
    PB      =  000005     |     PB_BASE =  005005     |     PB_CR1  =  005008 
    PB_CR2  =  005009     |     PB_DDR  =  005007     |     PB_IDR  =  005006 
    PB_ODR  =  005005     |     PC      =  00000A     |     PC_BASE =  00500A 
    PC_CR1  =  00500D     |     PC_CR2  =  00500E     |     PC_DDR  =  00500C 
    PC_IDR  =  00500B     |     PC_ODR  =  00500A     |     PD      =  00000F 
    PD_BASE =  00500F     |     PD_CR1  =  005012     |     PD_CR2  =  005013 
    PD_DDR  =  005011     |     PD_IDR  =  005010     |     PD_ODR  =  00500F 
    PE      =  000014     |     PE_BASE =  005014     |     PE_CR1  =  005017 
    PE_CR2  =  005018     |     PE_DDR  =  005016     |     PE_IDR  =  005015 
    PE_ODR  =  005014     |     PF      =  000019     |     PF_BASE =  005019 
    PF_CR1  =  00501C     |     PF_CR2  =  00501D     |     PF_DDR  =  00501B 
    PF_IDR  =  00501A     |     PF_ODR  =  005019     |     PG      =  00001E 
    PG_BASE =  00501E     |     PG_CR1  =  005021     |     PG_CR2  =  005022 
    PG_DDR  =  005020     |     PG_IDR  =  00501F     |     PG_ODR  =  00501E 
    PH      =  000023     |     PH_BASE =  005023     |     PH_CR1  =  005026 
    PH_CR2  =  005027     |     PH_DDR  =  005025     |     PH_IDR  =  005024 
    PH_ODR  =  005023     |     PI      =  000028     |     PI_BASE =  005028 
    PI_CR1  =  00502B     |     PI_CR2  =  00502C     |     PI_DDR  =  00502A 
    PI_IDR  =  005029     |     PI_ODR  =  005028     |     PRIORITY=  000003 
    PRT_INT =  000009 G   |     PRT_STR =  000008 G   |     PUTC    =  000002 G
    QCHAR   =  000004 G   |     RAM_BASE=  000000     |     RAM_END =  0017FF 
    RAM_PG_S=  000020     |     RAM_SIZE=  001800     |     RD_STATU=  000005 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 113.
Hexadecimal [24-Bits]

Symbol Table

    REVISION=  000005     |     ROP     =  004800     |     RS      =  00001E 
    RST_SR  =  0050B3     |     RW_MODE_=  000000     |     RW_MODE_=  000080 
    RW_MODE_=  000040     |     RX_QUEUE=  000010 G   |     SC_APPS =  00002F 
    SC_BKSP =  000066     |     SC_CAPS =  000058     |     SC_DEL  =  000071 
    SC_DOWN =  000072     |     SC_END  =  000069     |     SC_ENTER=  00005A 
    SC_ESC  =  000076     |     SC_F1   =  000005     |     SC_F10  =  000009 
    SC_F11  =  000078     |     SC_F12  =  000007     |     SC_F2   =  000006 
    SC_F3   =  000004     |     SC_F4   =  00000C     |     SC_F5   =  000003 
    SC_F6   =  00000B     |     SC_F7   =  000083     |     SC_F8   =  00000A 
    SC_F9   =  000001     |     SC_HOME =  00006C     |     SC_INSER=  000070 
    SC_KP0  =  000070     |     SC_KP1  =  000069     |     SC_KP2  =  000072 
    SC_KP3  =  00007A     |     SC_KP4  =  00006B     |     SC_KP5  =  000073 
    SC_KP6  =  000074     |     SC_KP7  =  00006C     |     SC_KP8  =  000075 
    SC_KP9  =  00007D     |     SC_KPDIV=  00004A     |     SC_KPDOT=  000071 
    SC_KPENT=  00005A     |     SC_KPMIN=  00007B     |     SC_KPMUL=  00007C 
    SC_KPPLU=  000079     |     SC_LALT =  000011     |     SC_LCTRL=  000014 
    SC_LEFT =  00006B     |     SC_LGUI =  00001F     |     SC_LSHIF=  000012 
    SC_LWIND=  00001F     |     SC_MENU =  00005D     |     SC_NUM  =  000077 
  5 SC_PAUSE   000457 R   |     SC_PGDN =  00007A     |     SC_PGUP =  00007D 
  5 SC_PRN     00044D R   |   5 SC_PRN_R   000451 R   |     SC_RALT =  000011 
    SC_RCTRL=  000014     |     SC_RGUI =  000027     |     SC_RIGHT=  000074 
    SC_RSHIF=  000059     |     SC_RWIND=  000027     |     SC_SCROL=  00007E 
    SC_TAB  =  00000D     |     SC_UP   =  000075     |     SECTOR_S=  001000 
    SECT_ERA=  0000D8     |     SEED_PRN=  00000E G   |     SEMIC   =  00003B 
    SET_TIME=  00000A G   |     SFR_BASE=  005000     |     SFR_END =  0057FF 
    SHARP   =  000023     |     SI      =  00000F     |     SIGN    =  000001 
    SLOT    =  000004     |     SO      =  00000E     |     SOH     =  000001 
    SPACE   =  000020     |     SPI_CR1 =  005200     |     SPI_CR1_=  000003 
    SPI_CR1_=  000000     |     SPI_CR1_=  000001     |     SPI_CR1_=  000007 
    SPI_CR1_=  000002     |     SPI_CR1_=  000006     |     SPI_CR2 =  005201 
    SPI_CR2_=  000007     |     SPI_CR2_=  000006     |     SPI_CR2_=  000005 
    SPI_CR2_=  000004     |     SPI_CR2_=  000002     |     SPI_CR2_=  000000 
    SPI_CR2_=  000001     |     SPI_CRCP=  005205     |     SPI_CS_E=  000001 G
    SPI_CS_R=  000000 G   |     SPI_DR  =  005204     |     SPI_EEPR=  000003 
    SPI_EEPR=  000002     |     SPI_ICR =  005202     |     SPI_RAM_=  000005 
    SPI_RAM_=  000003     |     SPI_RAM_=  000002     |     SPI_RAM_=  000001 
    SPI_RXCR=  005206     |     SPI_SR  =  005203     |     SPI_SR_B=  000007 
    SPI_SR_C=  000004     |     SPI_SR_M=  000005     |     SPI_SR_O=  000006 
    SPI_SR_R=  000000     |     SPI_SR_T=  000001     |     SPI_SR_W=  000003 
    SPI_TXCR=  005207     |     SPR_ADDR=  000001     |     SQUOT   =  000006 
    SREMDR  =  000005     |     SR_WEL_B=  000001     |     SR_WIP_B=  000000 
    STACK_EM=  0017FF     |     STACK_SI=  000080 G   |     START_TO=  00000C G
    STDOUT  =  000001     |     STX     =  000002     |     SUB     =  00001A 
    SWIM_CSR=  007F80     |     SYN     =  000016     |     SYS_RST =  000000 G
    SYS_SIZE=  004000     |     SYS_TICK=  000001     |     SYS_VARS=  000004 
    SYS_VARS=  000012 G   |     TAB     =  000009     |     TAB_WIDT=  000004 
    TERMIOS_=  000016 G   |     TIB_SIZE=  000080 G   |     TICK    =  000027 
    TIM1_ARR=  005262     |     TIM1_ARR=  005263     |     TIM1_BKR=  00526D 
    TIM1_CCE=  00525C     |     TIM1_CCE=  00525D     |     TIM1_CCM=  005258 
    TIM1_CCM=  000000     |     TIM1_CCM=  000001     |     TIM1_CCM=  000004 
    TIM1_CCM=  000005     |     TIM1_CCM=  000006     |     TIM1_CCM=  000007 
    TIM1_CCM=  000002     |     TIM1_CCM=  000003     |     TIM1_CCM=  000007 
    TIM1_CCM=  000002     |     TIM1_CCM=  000004     |     TIM1_CCM=  000005 
    TIM1_CCM=  000006     |     TIM1_CCM=  000003     |     TIM1_CCM=  005259 
    TIM1_CCM=  000000     |     TIM1_CCM=  000001     |     TIM1_CCM=  000004 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 114.
Hexadecimal [24-Bits]

Symbol Table

    TIM1_CCM=  000005     |     TIM1_CCM=  000006     |     TIM1_CCM=  000007 
    TIM1_CCM=  000002     |     TIM1_CCM=  000003     |     TIM1_CCM=  000007 
    TIM1_CCM=  000002     |     TIM1_CCM=  000004     |     TIM1_CCM=  000005 
    TIM1_CCM=  000006     |     TIM1_CCM=  000003     |     TIM1_CCM=  00525A 
    TIM1_CCM=  000000     |     TIM1_CCM=  000001     |     TIM1_CCM=  000004 
    TIM1_CCM=  000005     |     TIM1_CCM=  000006     |     TIM1_CCM=  000007 
    TIM1_CCM=  000002     |     TIM1_CCM=  000003     |     TIM1_CCM=  000007 
    TIM1_CCM=  000002     |     TIM1_CCM=  000004     |     TIM1_CCM=  000005 
    TIM1_CCM=  000006     |     TIM1_CCM=  000003     |     TIM1_CCM=  00525B 
    TIM1_CCM=  000000     |     TIM1_CCM=  000001     |     TIM1_CCM=  000004 
    TIM1_CCM=  000005     |     TIM1_CCM=  000006     |     TIM1_CCM=  000007 
    TIM1_CCM=  000002     |     TIM1_CCM=  000003     |     TIM1_CCM=  000007 
    TIM1_CCM=  000002     |     TIM1_CCM=  000004     |     TIM1_CCM=  000005 
    TIM1_CCM=  000006     |     TIM1_CCM=  000003     |     TIM1_CCR=  005265 
    TIM1_CCR=  005266     |     TIM1_CCR=  005267     |     TIM1_CCR=  005268 
    TIM1_CCR=  005269     |     TIM1_CCR=  00526A     |     TIM1_CCR=  00526B 
    TIM1_CCR=  00526C     |     TIM1_CNT=  00525E     |     TIM1_CNT=  00525F 
    TIM1_CR1=  005250     |     TIM1_CR2=  005251     |     TIM1_CR2=  000000 
    TIM1_CR2=  000002     |     TIM1_CR2=  000004     |     TIM1_CR2=  000005 
    TIM1_CR2=  000006     |     TIM1_DTR=  00526E     |     TIM1_EGR=  005257 
    TIM1_EGR=  000007     |     TIM1_EGR=  000001     |     TIM1_EGR=  000002 
    TIM1_EGR=  000003     |     TIM1_EGR=  000004     |     TIM1_EGR=  000005 
    TIM1_EGR=  000006     |     TIM1_EGR=  000000     |     TIM1_ETR=  005253 
    TIM1_ETR=  000006     |     TIM1_ETR=  000000     |     TIM1_ETR=  000001 
    TIM1_ETR=  000002     |     TIM1_ETR=  000003     |     TIM1_ETR=  000007 
    TIM1_ETR=  000004     |     TIM1_ETR=  000005     |     TIM1_IER=  005254 
    TIM1_IER=  000007     |     TIM1_IER=  000001     |     TIM1_IER=  000002 
    TIM1_IER=  000003     |     TIM1_IER=  000004     |     TIM1_IER=  000005 
    TIM1_IER=  000006     |     TIM1_IER=  000000     |     TIM1_OIS=  00526F 
    TIM1_PSC=  005260     |     TIM1_PSC=  005261     |     TIM1_RCR=  005264 
    TIM1_SMC=  005252     |     TIM1_SMC=  000007     |     TIM1_SMC=  000000 
    TIM1_SMC=  000001     |     TIM1_SMC=  000002     |     TIM1_SMC=  000004 
    TIM1_SMC=  000005     |     TIM1_SMC=  000006     |     TIM1_SR1=  005255 
    TIM1_SR1=  000007     |     TIM1_SR1=  000001     |     TIM1_SR1=  000002 
    TIM1_SR1=  000003     |     TIM1_SR1=  000004     |     TIM1_SR1=  000005 
    TIM1_SR1=  000006     |     TIM1_SR1=  000000     |     TIM1_SR2=  005256 
    TIM1_SR2=  000001     |     TIM1_SR2=  000002     |     TIM1_SR2=  000003 
    TIM1_SR2=  000004     |     TIM2_ARR=  00530D     |     TIM2_ARR=  00530E 
    TIM2_CCE=  005308     |     TIM2_CCE=  000000     |     TIM2_CCE=  000001 
    TIM2_CCE=  000004     |     TIM2_CCE=  000005     |     TIM2_CCE=  005309 
    TIM2_CCM=  005305     |     TIM2_CCM=  005306     |     TIM2_CCM=  005307 
    TIM2_CCM=  000000     |     TIM2_CCM=  000004     |     TIM2_CCM=  000003 
    TIM2_CCR=  00530F     |     TIM2_CCR=  005310     |     TIM2_CCR=  005311 
    TIM2_CCR=  005312     |     TIM2_CCR=  005313     |     TIM2_CCR=  005314 
    TIM2_CLK=  00F424     |     TIM2_CNT=  00530A     |     TIM2_CNT=  00530B 
    TIM2_CR1=  005300     |     TIM2_CR1=  000007     |     TIM2_CR1=  000000 
    TIM2_CR1=  000003     |     TIM2_CR1=  000001     |     TIM2_CR1=  000002 
    TIM2_EGR=  005304     |     TIM2_EGR=  000001     |     TIM2_EGR=  000002 
    TIM2_EGR=  000003     |     TIM2_EGR=  000006     |     TIM2_EGR=  000000 
    TIM2_IER=  005301     |     TIM2_PSC=  00530C     |     TIM2_SR1=  005302 
    TIM2_SR2=  005303     |     TIM3_ARR=  00532B     |     TIM3_ARR=  00532C 
    TIM3_CCE=  005327     |     TIM3_CCE=  000000     |     TIM3_CCE=  000001 
    TIM3_CCE=  000004     |     TIM3_CCE=  000005     |     TIM3_CCE=  000000 
    TIM3_CCE=  000001     |     TIM3_CCM=  005325     |     TIM3_CCM=  005326 
    TIM3_CCM=  000000     |     TIM3_CCM=  000004     |     TIM3_CCM=  000003 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 115.
Hexadecimal [24-Bits]

Symbol Table

    TIM3_CCR=  00532D     |     TIM3_CCR=  00532E     |     TIM3_CCR=  00532F 
    TIM3_CCR=  005330     |     TIM3_CNT=  005328     |     TIM3_CNT=  005329 
    TIM3_CR1=  005320     |     TIM3_CR1=  000007     |     TIM3_CR1=  000000 
    TIM3_CR1=  000003     |     TIM3_CR1=  000001     |     TIM3_CR1=  000002 
    TIM3_EGR=  005324     |     TIM3_IER=  005321     |     TIM3_PSC=  00532A 
    TIM3_SR1=  005322     |     TIM3_SR2=  005323     |     TIM4_ARR=  005346 
    TIM4_CNT=  005344     |     TIM4_CR1=  005340     |     TIM4_CR1=  000007 
    TIM4_CR1=  000000     |     TIM4_CR1=  000003     |     TIM4_CR1=  000001 
    TIM4_CR1=  000002     |     TIM4_EGR=  005343     |     TIM4_EGR=  000000 
    TIM4_IER=  005341     |     TIM4_IER=  000000     |     TIM4_PSC=  005345 
    TIM4_PSC=  000000     |     TIM4_PSC=  000007     |     TIM4_PSC=  000004 
    TIM4_PSC=  000001     |     TIM4_PSC=  000005     |     TIM4_PSC=  000002 
    TIM4_PSC=  000006     |     TIM4_PSC=  000003     |     TIM4_PSC=  000000 
    TIM4_PSC=  000001     |     TIM4_PSC=  000002     |     TIM4_SR =  005342 
    TIM4_SR_=  000000     |     TIM_CR1_=  000007     |     TIM_CR1_=  000000 
    TIM_CR1_=  000006     |     TIM_CR1_=  000005     |     TIM_CR1_=  000004 
    TIM_CR1_=  000003     |     TIM_CR1_=  000001     |     TIM_CR1_=  000002 
    TOS     =  000001     |     TYPE_CON=  000020     |     TYPE_DVA=  000010 
    TYPE_MAS=  0000F0     |   5 Timer4Up   000246 R   |   5 TrapHand   0001AD GR
    U1      =  000001     |     UART    =  000002     |     UART1   =  000000 
    UART1_BA=  005230     |     UART1_BR=  005232     |     UART1_BR=  005233 
    UART1_CR=  005234     |     UART1_CR=  005235     |     UART1_CR=  005236 
    UART1_CR=  005237     |     UART1_CR=  005238     |     UART1_DR=  005231 
    UART1_GT=  005239     |     UART1_PO=  000000     |     UART1_PS=  00523A 
    UART1_RX=  000004     |     UART1_SR=  005230     |     UART1_TX=  000005 
    UART2   =  000001     |     UART3   =  000002     |     UART3_BA=  005240 
    UART3_BR=  005242     |     UART3_BR=  005243     |     UART3_CR=  005244 
    UART3_CR=  005245     |     UART3_CR=  005246     |     UART3_CR=  005247 
    UART3_CR=  005249     |     UART3_DR=  005241     |     UART3_PO=  00000F 
    UART3_RX=  000006     |     UART3_SR=  005240     |     UART3_TX=  000005 
    UART_BRR=  005242     |     UART_BRR=  005243     |     UART_CR1=  005244 
    UART_CR1=  000004     |     UART_CR1=  000002     |     UART_CR1=  000000 
    UART_CR1=  000001     |     UART_CR1=  000007     |     UART_CR1=  000006 
    UART_CR1=  000005     |     UART_CR1=  000003     |     UART_CR2=  005245 
    UART_CR2=  000004     |     UART_CR2=  000002     |     UART_CR2=  000005 
    UART_CR2=  000001     |     UART_CR2=  000000     |     UART_CR2=  000006 
    UART_CR2=  000003     |     UART_CR2=  000007     |     UART_CR3=  000003 
    UART_CR3=  000001     |     UART_CR3=  000002     |     UART_CR3=  000000 
    UART_CR3=  000006     |     UART_CR3=  000004     |     UART_CR3=  000005 
    UART_CR4=  000000     |     UART_CR4=  000001     |     UART_CR4=  000002 
    UART_CR4=  000003     |     UART_CR4=  000004     |     UART_CR4=  000006 
    UART_CR4=  000005     |     UART_CR5=  000003     |     UART_CR5=  000001 
    UART_CR5=  000002     |     UART_CR5=  000004     |     UART_CR5=  000005 
    UART_CR6=  000004     |     UART_CR6=  000007     |     UART_CR6=  000001 
    UART_CR6=  000002     |     UART_CR6=  000000     |     UART_CR6=  000005 
    UART_DR =  005241     |     UART_PCK=  000003     |     UART_POR=  00500D 
    UART_POR=  00500E     |     UART_POR=  00500C     |     UART_POR=  00500B 
    UART_POR=  00500A     |     UART_RX_=  000006     |     UART_SR =  005240 
    UART_SR_=  000001     |     UART_SR_=  000004     |     UART_SR_=  000002 
    UART_SR_=  000003     |     UART_SR_=  000000     |     UART_SR_=  000005 
    UART_SR_=  000006     |     UART_SR_=  000007     |     UART_TX_=  000005 
    UBC     =  004801     |     US      =  00001F     |   5 UartRxHa   00045F R
    VK_APPS =  000097     |     VK_BACK =  000008     |     VK_CAPS =  0000A8 
    VK_CBACK=  0000BA     |     VK_CDEL =  0000B9     |     VK_CDOWN=  0000B2 
    VK_CEND =  0000B6     |     VK_CHOME=  0000B5     |     VK_CLEFT=  0000B3 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 116.
Hexadecimal [24-Bits]

Symbol Table

    VK_CLOCK=  00009B     |     VK_CPGDN=  0000B8     |     VK_CPGUP=  0000B7 
    VK_CRIGH=  0000B4     |     VK_CUP  =  0000B1     |     VK_DELET=  00007F 
    VK_DOWN =  00008E     |     VK_END  =  000092     |     VK_ENTER=  00000D 
    VK_ESC  =  00001B     |     VK_F1   =  000080     |     VK_F10  =  00008A 
    VK_F11  =  00008B     |     VK_F12  =  00008C     |     VK_F2   =  000081 
    VK_F3   =  000082     |     VK_F4   =  000083     |     VK_F5   =  000084 
    VK_F6   =  000085     |     VK_F7   =  000086     |     VK_F8   =  000087 
    VK_F9   =  000088     |     VK_HOME =  000091     |     VK_INSER=  000095 
    VK_LALT =  00009E     |     VK_LCTRL=  00009D     |     VK_LEFT =  00008F 
    VK_LGUI =  0000A0     |     VK_LSHIF=  00009C     |     VK_LWIND=  0000BB 
    VK_MENU =  0000BD     |     VK_NLOCK=  00009A     |     VK_NUM  =  0000A5 
    VK_PAUSE=  000099     |     VK_PGDN =  000094     |     VK_PGUP =  000093 
    VK_PRN  =  000098     |     VK_RALT =  0000A3     |     VK_RCTRL=  0000A1 
    VK_RGUI =  0000A2     |     VK_RIGHT=  000090     |     VK_RSHIF=  00009F 
    VK_RWIND=  0000BC     |     VK_SCROL=  0000A4     |     VK_SDEL =  0000BF 
    VK_SDOWN=  0000AA     |     VK_SEND =  0000AE     |     VK_SHOME=  0000AD 
    VK_SLEEP=  0000BE     |     VK_SLEFT=  0000AB     |     VK_SPACE=  000020 
    VK_SPGDN=  0000B0     |     VK_SPGUP=  0000AF     |     VK_SRIGH=  0000AC 
    VK_SUP  =  0000A9     |     VK_TAB  =  000009     |     VK_UP   =  00008D 
    VSIZE   =  000003     |     VT      =  00000B     |     WDGOPT  =  004805 
    WDGOPT_I=  000002     |     WDGOPT_L=  000003     |     WDGOPT_W=  000000 
    WDGOPT_W=  000001     |     WOZMON     ****** GX  |     WR_EN   =  000006 
    WR_STATU=  000001     |     WWDG_CR =  0050D1     |     WWDG_WR =  0050D2 
    XOFF    =  000013     |     XON     =  000011     |     XT2_KEY =  0000E1 
    XT_KEY  =  0000E0     |   3 acc16      000014 GR  |   3 acc24      000013 R
  3 acc32      000012 R   |   3 acc8       000015 GR  |   5 addr_to_   000B3E GR
  5 app_info   0008C7 GR  |   3 arithm_v   000016 R   |   3 base       00000B GR
  5 beep_1kh   00026B GR  |   5 bksp       000558 GR  |   2 block_bu   001700 GR
  5 buf_putc   000507 R   |   5 clear_qu   0004E8 R   |   5 clock_in   000001 R
  5 clr_scre   000570 GR  |   5 cold_sta   0000A2 R   |     compile    ****** GX
  5 create_b   0009AD R   |   3 ctrl_c_v   000018 GR  |   5 cursor_c   0006D0 GR
  5 cursor_l   000687 R   |   5 cursor_p   0006F9 GR  |   5 cursor_r   000693 R
  5 dbl_sign   0003E6 R   |   5 div32_16   0003F0 GR  |   5 divide     00042C GR
  5 dneg       0003DD R   |   5 dump_cod   000116 R   |   5 eeprom_e   000A58 R
  5 eeprom_e   000B21 GR  |   5 eeprom_e   000AFD R   |   5 eeprom_p   000ACD R
  5 eeprom_r   000AA9 GR  |   5 eeprom_r   000A68 R   |   5 eeprom_w   000A7D GR
  3 farptr     00000D GR  |     flags      ****** GX  |   3 fmstr      00000C GR
  5 get_char   0006DC GR  |   5 get_para   00075E R   |   5 getc       00052C GR
  5 is_alnum   0008B5 GR  |   5 is_alpha   00088D GR  |   5 is_digit   00089E GR
  5 is_hex_d   0008A7 GR  |   5 itoa       0007C7 GR  |   5 itoa_loo   0007EC R
  5 kernel_c   000171 R   |   5 kernel_n   000167 R   |   5 kernel_s   000197 R
  3 kvars_en   000012 GR  |   5 long_div   0003BF R   |   5 modulo     000448 R
  5 move       00083E GR  |   5 move_dow   00085E R   |   5 move_exi   00087D R
  5 move_loo   000863 R   |   5 move_up    000850 R   |   5 multiply   000384 GR
  5 neg_acc1   000326 R   |   5 new_line   00056A GR  |   3 out        000016 GR
  2 pad        001700 GR  |   5 page_add   000B3B R   |   5 print_he   0007AA GR
  5 print_in   0007BC GR  |   5 prng       0002EF GR  |   5 process_   000658 R
    prt_basi   ****** GX  |   5 prt_i8     0007BA R   |   3 ptr16      00000E GR
  3 ptr8       00000F GR  |   5 putc       000501 GR  |   5 puts       00054D GR
  5 qgetc      000526 GR  |   5 readln     00058D GR  |   5 restore_   0006AA GR
  3 rx1_head   00001A GR  |   3 rx1_queu   00001C GR  |   3 rx1_tail   00001B GR
  5 save_cur   00069F GR  |   3 seedx      000007 GR  |   3 seedy      000009 GR
  5 send_csi   000751 R   |   5 send_par   000781 R   |   5 set_curs   0006B5 GR
  5 set_int_   00006B GR  |   5 set_outp   0004ED R   |   5 set_seed   000311 GR
  5 sll_xy_3   0002E1 R   |   5 space      00057B GR  |   5 spaces     000581 GR
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 117.
Hexadecimal [24-Bits]

Symbol Table

  5 spi_clea   000980 R   |   5 spi_dese   0009CC R   |   5 spi_disa   000960 R
  5 spi_enab   0008F7 GR  |   5 spi_mode   000944 R   |   5 spi_ram_   000A39 R
  5 spi_ram_   0009F5 R   |   5 spi_ram_   0009E0 R   |   5 spi_ram_   000A1A R
  5 spi_rcv_   0009A2 R   |   5 spi_sele   0009BC R   |   5 spi_send   000A0A R
  5 spi_send   00098C R   |   5 srl_xy_3   0002E8 R   |   2 stack_fu   001780 GR
  2 stack_un   001800 GR  |   5 strcmp     00081F GR  |   5 strcpy     00082E GR
  5 strlen     000814 GR  |   3 sys_flag   000006 GR  |   5 syscall_   000245 R
  5 syscall_   0001B5 R   |     tb_error   ****** GX  |   3 term_var   00002C GR
  5 test       000106 R   |   2 tib        001680 GR  |   3 ticks      000000 GR
  3 timer      000002 GR  |   5 timer2_i   000022 R   |   5 timer4_i   00002F R
  5 to_hex_c   00079F GR  |   5 to_upper   000882 GR  |   5 tone       00027A GR
  3 tone_ms    000004 GR  |   5 tone_off   0002BA R   |   3 trap_ret   000010 GR
  5 uart_get   00052C GR  |   5 uart_ini   000490 R   |   5 uart_put   000518 GR
  5 uart_put   00051D GR  |   5 uart_qge   000526 GR  |   5 udiv32_1   0003AD R
  5 umstar     000344 R   |   5 umul16_8   000335 GR  |   5 version_   0008BE R
  5 xor_seed   0002C5 R

ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 118.
Hexadecimal [24-Bits]

Area Table

   0 _CODE      size      0   flags    0
   1 SSEG       size      0   flags    8
   2 SSEG0      size    180   flags    8
   3 DATA       size     2C   flags    0
   4 HOME       size     80   flags    0
   5 CODE       size    B44   flags    0

