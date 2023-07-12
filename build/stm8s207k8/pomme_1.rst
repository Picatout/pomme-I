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
                           000080     5 STACK_SIZE==128 ; at end of RAM 
                           000080     6 PAD_SIZE==BLOCK_SIZE ; 128 bytes below stack 
                           000080     7 TIB_SIZE==128 ; below pad 
                           000100     8 PAGE0_SIZE==256 ; reserved for system variables 
                           001580     9 FREE_RAM==RAM_SIZE-STACK_SIZE-PAD_SIZE-TIB_SIZE-PAGE0_SIZE ; 5504
                           004000    10 SYS_SIZE=0x4000 ; flash reserved for system 16KB 
                                     11 ; file system in flash memory to save BASIC programs 
                           00C000    12 FS_BASE==0xC000 ; file system base address 49152 
                           00C000    13 FS_SIZE==0xC000 ; file system size 49152 bytes  48KB 
                                     14 
                           000001    15 HSI=1 ; set this to 1 if using internal high speed oscillator  
                           000001    16 .if HSI 
                           000000    17 HSE=0
                           000000    18 .else
                                     19 HSE=1  
                                     20 .endif 
                                     21 
                           000010    22 FMSTR=16 ; master clock frequency in Mhz 
                                     23 
                                     24 ; boards list
                                     25 ; set selected board to 1  
                           000000    26 NUCLEO_8S208RB=0
                                     27 ; use this to ensure 
                                     28 ; only one is selected 
                           000000    29 .if NUCLEO_8S208RB 
                                     30 NUCLEO_8S207K8=0
                           000001    31 .else 
                           000001    32 NUCLEO_8S207K8=1
                                     33 .endif 
                                     34 
                                     35 ; NUCLEO-8S208RB config.
                           000000    36 .if NUCLEO_8S208RB 
                                     37     .include "inc/stm8s208.inc" 
                                     38     .include "inc/nucleo_8s208.inc"
                                     39 .endif  
                                     40 
                                     41 ; NUCLEO-8S207K8 config. 
                           000001    42 .if NUCLEO_8S207K8 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 3.
Hexadecimal [24-Bits]



                                     43     .include "inc/stm8s207.inc" 
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



                                     44     .include "inc/nucleo_8s207.inc"
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



                                     45 .endif 
                                     46 
                                     47 ; all boards includes 
                                     48 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 27.
Hexadecimal [24-Bits]



                                     49 	.include "inc/ascii.inc"
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



                                     50 	.include "inc/gen_macros.inc" 
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



                                     51 	.include "app_macros.inc" 
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 36.
Hexadecimal [24-Bits]



                                     52     .include "arithm16_macros.inc" 
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



                                     53 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 38.
Hexadecimal [24-Bits]



                                     31 
                           000004    32 SYS_VARS_ORG=4 
                                     33 
                                     34 ; application vars start at this address 
                           000028    35 APP_VARS_START_ADR==SYS_VARS_ORG+SYS_VARS_SIZE+ARITHM_VARS_SIZE+TERMIOS_VARS_SIZE
                                     36 
                                     37 ;--------------------------------
                                     38 	.area DATA (ABS)
      000004                         39 	.org SYS_VARS_ORG  
                                     40 ;---------------------------------
                                     41 
      000004                         42 ticks: .blkw 1 ; millisecond system ticks 
      000006                         43 timer: .blkw 1 ; msec count down timer 
      000008                         44 tone_ms: .blkw 1 ; tone duration msec 
      00000A                         45 sys_flags: .blkb 1; system boolean flags 
      00000B                         46 seedx: .blkw 1  ; bits 31...15 used by 'prng' function
      00000D                         47 seedy: .blkw 1  ; bits 15...0 used by 'prng' function 
      00000F                         48 base: .blkb 1 ;  numeric base used by 'print_int' 
      000010                         49 fmstr: .blkb 1 ; Fmaster frequency in Mhz
      000011                         50 farptr: .blkb 1 ; 24 bits pointer used by file system, upper-byte
      000012                         51 ptr16::  .blkb 1 ; 16 bits pointer , farptr high-byte 
      000013                         52 ptr8:   .blkb 1 ; 8 bits pointer, farptr low-byte  
      000014                         53 trap_ret: .blkw 1 ; trap return address 
      000016                         54 kvars_end: 
                           000012    55 SYS_VARS_SIZE==kvars_end-ticks   
                                     56 
                                     57 ; system boolean flags 
                           000000    58 FSYS_TIMER==0 
                           000001    59 FSYS_TONE==1 
                           000002    60 FSYS_UPPER==2 ; getc uppercase all letters 
                                     61   
                                     62 ;;--------------------------------------
                                     63     .area HOME
                                     64 ;; interrupt vector table at 0x8000
                                     65 ;;--------------------------------------
                                     66 
      008000 82 00 81 25             67     int cold_start			; RESET vector 
      008004 82 00 81 E7             68 	int TrapHandler         ; trap instruction 
      008008 82 00 80 80             69 	int NonHandledInterrupt ;int0 TLI   external top level interrupt
      00800C 82 00 80 80             70 	int NonHandledInterrupt ;int1 AWU   auto wake up from halt
      008010 82 00 80 80             71 	int NonHandledInterrupt ;int2 CLK   clock controller
      008014 82 00 80 80             72 	int NonHandledInterrupt ;int3 EXTI0 gpio A external interrupts
      008018 82 00 80 80             73 	int NonHandledInterrupt ;int4 EXTI1 gpio B external interrupts
      00801C 82 00 80 80             74 	int NonHandledInterrupt ;int5 EXTI2 gpio C external interrupts
      008020 82 00 80 80             75 	int NonHandledInterrupt ;int6 EXTI3 gpio D external interrupts
      008024 82 00 80 80             76 	int NonHandledInterrupt ;int7 EXTI4 gpio E external interrupt 
      008028 82 00 80 80             77 	int NonHandledInterrupt ;int8 beCAN RX interrupt
      00802C 82 00 80 80             78 	int NonHandledInterrupt ;int9 beCAN TX/ER/SC interrupt
      008030 82 00 80 80             79 	int NonHandledInterrupt ;int10 SPI End of transfer
      008034 82 00 80 80             80 	int NonHandledInterrupt ;int11 TIM1 update/overflow/underflow/trigger/break
      008038 82 00 80 80             81 	int NonHandledInterrupt ;int12 TIM1 ; TIM1 capture/compare
      00803C 82 00 80 80             82 	int NonHandledInterrupt ;int13 TIM2 update /overflow
      008040 82 00 80 80             83 	int NonHandledInterrupt ;int14 TIM2 capture/compare
      008044 82 00 80 80             84 	int NonHandledInterrupt ;int15 TIM3 Update/overflow
      008048 82 00 80 80             85 	int NonHandledInterrupt ;int16 TIM3 Capture/compare
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 39.
Hexadecimal [24-Bits]



      00804C 82 00 80 80             86 	int NonHandledInterrupt ;int17 UART1 TX completed
                           000000    87 .if NUCLEO_8S208RB  
                                     88 	int UartRxHandler		;int18 UART1 RX full 
                           000001    89 .else 
      008050 82 00 80 80             90 	int NonHandledInterrupt ;int18 UART1 RX full 
                                     91 .endif 
      008054 82 00 80 80             92 	int NonHandledInterrupt ; int19 i2c
      008058 82 00 80 80             93 	int NonHandledInterrupt ;int20 UART3 TX completed
                           000001    94 .if NUCLEO_8S207K8  
      00805C 82 00 84 8F             95 	int UartRxHandler 		;int21 UART3 RX full
                           000000    96 .else 
                                     97 	int NonHandledInterrupt ;int21 UART3 RX full
                                     98 .endif 
      008060 82 00 80 80             99 	int NonHandledInterrupt ;int22 ADC2 end of conversion
      008064 82 00 82 85            100 	int Timer4UpdateHandler	;int23 TIM4 update/overflow ; used as msec ticks counter
      008068 82 00 80 80            101 	int NonHandledInterrupt ;int24 flash writing EOP/WR_PG_DIS
      00806C 82 00 80 80            102 	int NonHandledInterrupt ;int25  not used
      008070 82 00 80 80            103 	int NonHandledInterrupt ;int26  not used
      008074 82 00 80 80            104 	int NonHandledInterrupt ;int27  not used
      008078 82 00 80 80            105 	int NonHandledInterrupt ;int28  not used
      00807C 82 00 80 80            106 	int NonHandledInterrupt ;int29  not used
                                    107 
                                    108 
                                    109 	.area CODE 
                                    110 ;	.org 0x8080 
                                    111 
                                    112 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    113 ; non handled interrupt 
                                    114 ; reset MCU
                                    115 ;;;;;;;;;;;;;;;;;;;;;;;;;;;
      008080                        116 NonHandledInterrupt:
      000000                        117 	_swreset ; see "inc/gen_macros.inc"
      008080 35 80 50 D1      [ 1]    1     mov WWDG_CR,#0X80
                                    118 
                           000000   119 .if 0
                                    120 user_interrupted:
                                    121 ; BASIC program can be 
                                    122 ; interrupted by CTRL+C 
                                    123 ; in case locked in infinite loop. 
                                    124     btjt flags,#FRUN,4$
                                    125 	ret 
                                    126 4$:	; program interrupted by user 
                                    127 	bres flags,#FRUN 
                                    128 ;	ldw x,#USER_ABORT
                                    129 ;	call puts 
                                    130 5$:	jp warm_start
                                    131 
                                    132 
                                    133 ;USER_ABORT: .asciz "\nProgram aborted by user.\n"
                                    134 .endif 
                                    135 
                                    136 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    137 ;    peripherals initialization
                                    138 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    139 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 40.
Hexadecimal [24-Bits]



                                    140 ;----------------------------------------
                                    141 ; inialize MCU clock 
                                    142 ; input:
                                    143 ;   A       fmstr Mhz 
                                    144 ;   XL      CLK_CKDIVR , clock divisor
                                    145 ;   XH     HSI|HSE   
                                    146 ; output:
                                    147 ;   none 
                                    148 ;----------------------------------------
      008084                        149 clock_init:	
      000004                        150 	_straz fmstr
      008084 B7 10                    1     .byte 0xb7,fmstr 
      008086 9E               [ 1]  151 	ld a,xh ; clock source HSI|HSE 
      008087 72 17 50 C5      [ 1]  152 	bres CLK_SWCR,#CLK_SWCR_SWIF 
      00808B C1 50 C3         [ 1]  153 	cp a,CLK_CMSR 
      00808E 27 0C            [ 1]  154 	jreq 2$ ; no switching required 
                                    155 ; select clock source 
      008090 C7 50 C4         [ 1]  156 	ld CLK_SWR,a
      008093 72 07 50 C5 FB   [ 2]  157 	btjf CLK_SWCR,#CLK_SWCR_SWIF,. 
      008098 72 12 50 C5      [ 1]  158 	bset CLK_SWCR,#CLK_SWCR_SWEN
      00809C                        159 2$: 	
                                    160 ; cpu clock divisor 
      00809C 9F               [ 1]  161 	ld a,xl 
      00809D C7 50 C6         [ 1]  162 	ld CLK_CKDIVR,a  
      0080A0 72 5F 50 C6      [ 1]  163 	clr CLK_CKDIVR 
      0080A4 81               [ 4]  164 	ret
                                    165 
                                    166 ;----------------------------------
                                    167 ; TIMER2 used as audio tone output 
                                    168 ; on port D:5. CN9-6
                                    169 ; channel 1 configured as PWM mode 1 
                                    170 ;-----------------------------------  
      0080A5                        171 timer2_init:
      0080A5 72 1A 50 C7      [ 1]  172 	bset CLK_PCKENR1,#CLK_PCKENR1_TIM2 ; enable TIMER2 clock 
      0080A9 35 60 53 05      [ 1]  173  	mov TIM2_CCMR1,#(6<<TIM2_CCMR_OCM) ; PWM mode 1 
      0080AD 35 06 53 0C      [ 1]  174 	mov TIM2_PSCR,#6 ; fmstr/64
      0080B1 81               [ 4]  175 	ret 
                                    176 
                                    177 ;---------------------------------
                                    178 ; TIM4 is configured to generate an 
                                    179 ; interrupt every millisecond 
                                    180 ;----------------------------------
      0080B2                        181 timer4_init:
      0080B2 72 18 50 C7      [ 1]  182 	bset CLK_PCKENR1,#CLK_PCKENR1_TIM4
      0080B6 72 11 53 40      [ 1]  183 	bres TIM4_CR1,#TIM4_CR1_CEN 
      0080BA C6 00 10         [ 1]  184 	ld a,fmstr 
      0080BD AE 00 E8         [ 2]  185 	ldw x,#0xe8 
      0080C0 42               [ 4]  186 	mul x,a
      0080C1 89               [ 2]  187 	pushw x 
      0080C2 AE 00 03         [ 2]  188 	ldw x,#3 
      0080C5 42               [ 4]  189 	mul x,a 
      0080C6 5E               [ 1]  190 	swapw x 
      0080C7 72 FB 01         [ 2]  191 	addw x,(1,sp) 
      00004A                        192 	_drop 2  
      0080CA 5B 02            [ 2]    1     addw sp,#2 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 41.
Hexadecimal [24-Bits]



      0080CC 4F               [ 1]  193 	clr a 
      0080CD                        194 0$:	 
      0080CD A3 01 00         [ 2]  195 	cpw x,#256 
      0080D0 2B 04            [ 1]  196 	jrmi 1$ 
      0080D2 4C               [ 1]  197 	inc a 
      0080D3 54               [ 2]  198 	srlw x 
      0080D4 20 F7            [ 2]  199 	jra 0$ 
      0080D6                        200 1$:
      0080D6 C7 53 45         [ 1]  201 	ld TIM4_PSCR,a 
      0080D9 9F               [ 1]  202 	ld a,xl 
      0080DA C7 53 46         [ 1]  203 	ld TIM4_ARR,a
      0080DD 35 05 53 40      [ 1]  204 	mov TIM4_CR1,#((1<<TIM4_CR1_CEN)|(1<<TIM4_CR1_URS))
      0080E1 72 10 53 41      [ 1]  205 	bset TIM4_IER,#TIM4_IER_UIE
                                    206 ; set int level to 1 
      0080E5 A6 01            [ 1]  207 	ld a,#ITC_SPR_LEVEL1 
      0080E7 AE 00 17         [ 2]  208 	ldw x,#INT_TIM4_OVF 
      0080EA CD 80 EE         [ 4]  209 	call set_int_priority
      0080ED 81               [ 4]  210 	ret
                                    211 
                                    212 
                                    213 ;--------------------------
                                    214 ; set software interrupt 
                                    215 ; priority 
                                    216 ; input:
                                    217 ;   A    priority 1,2,3 
                                    218 ;   X    vector 
                                    219 ;---------------------------
                           000001   220 	SPR_ADDR=1 
                           000003   221 	PRIORITY=3
                           000004   222 	SLOT=4
                           000005   223 	MASKED=5  
                           000005   224 	VSIZE=5
      0080EE                        225 set_int_priority::
      00006E                        226 	_vars VSIZE
      0080EE 52 05            [ 2]    1     sub sp,#VSIZE 
      0080F0 A4 03            [ 1]  227 	and a,#3  
      0080F2 6B 03            [ 1]  228 	ld (PRIORITY,sp),a 
      0080F4 A6 04            [ 1]  229 	ld a,#4 
      0080F6 62               [ 2]  230 	div x,a 
      0080F7 48               [ 1]  231 	sll a  ; slot*2 
      0080F8 6B 04            [ 1]  232 	ld (SLOT,sp),a
      0080FA 1C 7F 70         [ 2]  233 	addw x,#ITC_SPR1 
      0080FD 1F 01            [ 2]  234 	ldw (SPR_ADDR,sp),x 
                                    235 ; build mask
      0080FF AE FF FC         [ 2]  236 	ldw x,#0xfffc 	
      008102 7B 04            [ 1]  237 	ld a,(SLOT,sp)
      008104 27 05            [ 1]  238 	jreq 2$ 
      008106 99               [ 1]  239 	scf 
      008107 59               [ 2]  240 1$:	rlcw x 
      008108 4A               [ 1]  241 	dec a 
      008109 26 FC            [ 1]  242 	jrne 1$
      00810B 9F               [ 1]  243 2$:	ld a,xl 
                                    244 ; apply mask to slot 
      00810C 1E 01            [ 2]  245 	ldw x,(SPR_ADDR,sp)
      00810E F4               [ 1]  246 	and a,(x)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 42.
Hexadecimal [24-Bits]



      00810F 6B 05            [ 1]  247 	ld (MASKED,sp),a 
                                    248 ; shift priority to slot 
      008111 7B 03            [ 1]  249 	ld a,(PRIORITY,sp)
      008113 97               [ 1]  250 	ld xl,a 
      008114 7B 04            [ 1]  251 	ld a,(SLOT,sp)
      008116 27 04            [ 1]  252 	jreq 4$
      008118 58               [ 2]  253 3$:	sllw x 
      008119 4A               [ 1]  254 	dec a 
      00811A 26 FC            [ 1]  255 	jrne 3$
      00811C 9F               [ 1]  256 4$:	ld a,xl 
      00811D 1A 05            [ 1]  257 	or a,(MASKED,sp)
      00811F 1E 01            [ 2]  258 	ldw x,(SPR_ADDR,sp)
      008121 F7               [ 1]  259 	ld (x),a 
      0000A2                        260 	_drop VSIZE 
      008122 5B 05            [ 2]    1     addw sp,#VSIZE 
      008124 81               [ 4]  261 	ret 
                                    262 
                                    263 ;-------------------------------------
                                    264 ;  initialization entry point 
                                    265 ;-------------------------------------
      008125                        266 cold_start:
                                    267 ;at reset stack pointer is at RAM_END  
                                    268 ; clear all ram
      008125 96               [ 1]  269 	ldw x,sp 
                           000000   270 .if 0	
                                    271 0$: clr (x)
                                    272 	decw x 
                                    273 	jrne 0$
                                    274 .endif 	
                                    275 ; activate pull up on all inputs 
      008126 A6 FF            [ 1]  276 	ld a,#255 
      008128 C7 50 03         [ 1]  277 	ld PA_CR1,a 
      00812B C7 50 08         [ 1]  278 	ld PB_CR1,a 
      00812E C7 50 0D         [ 1]  279 	ld PC_CR1,a 
      008131 C7 50 12         [ 1]  280 	ld PD_CR1,a 
      008134 C7 50 17         [ 1]  281 	ld PE_CR1,a 
      008137 C7 50 1C         [ 1]  282 	ld PF_CR1,a 
      00813A C7 50 21         [ 1]  283 	ld PG_CR1,a 
      00813D C7 50 2B         [ 1]  284 	ld PI_CR1,a
                                    285 ; set user LED pin as output 
      008140 72 1A 50 0D      [ 1]  286     bset LED_PORT+GPIO_CR1,#LED_BIT
      008144 72 1A 50 0E      [ 1]  287     bset LED_PORT+GPIO_CR2,#LED_BIT
      008148 72 1A 50 0C      [ 1]  288     bset LED_PORT+ GPIO_DDR,#LED_BIT
      00814C 72 1B 50 0A      [ 1]  289 	bres LED_PORT+GPIO_ODR,#LED_BIT ; turn on user LED  
                                    290 ; disable schmitt triggers on Arduino CN4 analog inputs
      008150 55 00 3F 54 07   [ 1]  291 	mov ADC_TDRL,0x3f
                                    292 ; select internal clock no divisor: 16 Mhz 	
      008155 A6 10            [ 1]  293 	ld a,#16 ; Mhz 
      008157 AE E1 00         [ 2]  294 	ldw x,#CLK_SWR_HSI<<8   ; high speed internal oscillator 
      00815A CD 80 84         [ 4]  295     call clock_init 
                                    296 ; UART at 115200 BAUD
                                    297 ; used for user interface 
      00815D AE 85 41         [ 2]  298 	ldw x,#uart_putc 
      008160 CF 00 1A         [ 2]  299 	ldw out,x 
      008163 CD 84 C0         [ 4]  300 	call uart_init
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 43.
Hexadecimal [24-Bits]



      008166 CD 80 B2         [ 4]  301 	call timer4_init ; msec ticks timer 
      008169 CD 80 A5         [ 4]  302 	call timer2_init ; tone generator 	
      00816C 9A               [ 1]  303 	rim ; enable interrupts 
      00816D 35 0A 00 0F      [ 1]  304 	mov base,#10
      0000F1                        305 	_clrz sys_flags 
      008171 3F 0A                    1     .byte 0x3f, sys_flags 
      008173 CD 82 AA         [ 4]  306 	call beep_1khz  ;
      008176 AE FF FF         [ 2]  307 	ldw x,#-1
      008179 CD 83 50         [ 4]  308 	call set_seed 
                                    309 
                                    310 ;jp spi_ram_test 
                                    311 ;jp eeprom_test 
                                    312 
                                    313 ; jp kernel_test 	
      00817C CC 8B 90         [ 2]  314 	jp WOZMON
                                    315 
                           000001   316 .if 1
      00817F 72 14 00 0A      [ 1]  317 	bset sys_flags,#FSYS_UPPER 
      008183 CD 85 E9         [ 4]  318 call new_line 	
      008186                        319 test: ; test compiler 
      008186 A6 3E            [ 1]  320 	ld a,#'> 
      008188 CD 85 2C         [ 4]  321 	call putc 
      00818B CD 86 79         [ 4]  322 	call readln 
      00818E CD 91 0C         [ 4]  323 	call compile 
      008191 CD 81 96         [ 4]  324 	call dump_code 
      008194 20 F0            [ 2]  325 	jra test 
                                    326 
      008196                        327 dump_code: 
      008196 90 AE 17 00      [ 2]  328 	ldw y,#pad 
      00819A 4B 10            [ 1]  329 	push #16  
      00819C 90 E6 02         [ 1]  330 	ld a,(2,y)
      00819F 88               [ 1]  331 	push a
      0081A0 90 9E            [ 1]  332 	ld a,yh 
      0081A2 CD 88 1C         [ 4]  333 	call print_hex 
      0081A5 90 9F            [ 1]  334 	ld a,yl  
      0081A7 CD 88 1C         [ 4]  335 	call print_hex
      0081AA AE 00 02         [ 2]  336 	ldw x,#2 
      0081AD CD 86 0C         [ 4]  337 	call spaces 
      0081B0                        338 1$: 
      0081B0 90 F6            [ 1]  339 	ld a,(y)
      0081B2 CD 88 1C         [ 4]  340 	call print_hex 
      0081B5 CD 86 06         [ 4]  341 	call space 
      0081B8 90 5C            [ 1]  342 	incw y
      0081BA 0A 02            [ 1]  343 	dec (2,sp)
      0081BC 26 17            [ 1]  344 	jrne 2$ 
      0081BE CD 85 E9         [ 4]  345 	call new_line 
      0081C1 90 9E            [ 1]  346 	ld a,yh 
      0081C3 CD 88 1C         [ 4]  347 	call print_hex 
      0081C6 90 9F            [ 1]  348 	ld a,yl  
      0081C8 CD 88 1C         [ 4]  349 	call print_hex
      0081CB AE 00 02         [ 2]  350 	ldw x,#2 
      0081CE CD 86 0C         [ 4]  351 	call spaces 
      0081D1 A6 10            [ 1]  352 	ld a,#16
      0081D3 6B 02            [ 1]  353 	ld (2,sp),a 
      0081D5                        354 2$:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 44.
Hexadecimal [24-Bits]



      0081D5 0A 01            [ 1]  355 	dec (1,sp) 
      0081D7 26 D7            [ 1]  356 	jrne 1$ 
      000159                        357 9$: _drop 2 
      0081D9 5B 02            [ 2]    1     addw sp,#2 
      0081DB CD 85 E9         [ 4]  358 	call new_line 
      0081DE AE 17 00         [ 2]  359 	ldw x,#pad   
      0081E1 E6 02            [ 1]  360 	ld a,(2,x)
      0081E3 CD 9E 55         [ 4]  361 	call prt_basic_line 
      0081E6 81               [ 4]  362 	ret 	
                                    363 .endif 
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
                                     21 ;-----------------------
                                     22 ; a little kernel 
                                     23 ; to access TERMIOS 
                                     24 ; functions using 
                                     25 ; STM8 TRAP instruction
                                     26 ;------------------------
                                     27 ;;-----------------------------------
                                     28     .area SSEG (ABS)
                                     29 ;; working buffers and stack at end of RAM. 	
                                     30 ;;-----------------------------------
      001680                         31     .org RAM_SIZE-STACK_SIZE-TIB_SIZE-PAD_SIZE 
      001680                         32 tib:: .ds TIB_SIZE             ; terminal input buffer
      001700                         33 block_buffer::                 ; use to write FLASH block (alias for pad )
      001700                         34 pad:: .ds PAD_SIZE             ; working buffer
      001780                         35 stack_full:: .ds STACK_SIZE   ; control stack 
      001800                         36 stack_unf:: ; stack underflow ; control_stack underflow 
                                     37 
                                     38 
                                     39 ;---------------------------------------------
                                     40 ;  kernel functions table 
                                     41 ;  functions code is passed in A 
                                     42 ;  parameters are passed in X,Y
                                     43 ;  output returned in A,X,Y,CC  
                                     44 ;
                                     45 ;  code |  function      | input    |  output
                                     46 ;  -----|----------------|----------|---------
                                     47 ;    0  | reset system   | none     | none 
                                     48 ;    1  | ticks          | none     | X=msec ticker 
                                     49 ;    2  | putchar        | X=char   | none 
                                     50 ;    3  | getchar        | none     | A=char
                                     51 ;    4  | querychar      | none     | A=0,-1
                                     52 ;    5  | clr_screen     | none     | none 
                                     53 ;    6  | delback        | none     | none 
                                     54 ;    7  | getline        | xl=buflen | A= line length
                                     55 ;       |                | xh=lnlen  |  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 46.
Hexadecimal [24-Bits]



                                     56 ;       |                | y=bufadr | 
                                     57 ;    8  | puts           | X=*str   | none 
                                     58 ;    9  | print_int      | X=int16  | none 
                                     59 ;       |                | A=unsigned| A=string length 
                                     60 ;    10 | set timer      | X=value  | none 
                                     61 ;   11  | check time out | none     | A=0|-1 
                                     62 ;   12  | génère une     | X=msec   | 
                                     63 ;       | tonalité audio | Y=Freq   | none
                                     64 ;   13  | stop tone      |  none    | none
                                     65 ;   14  | get random #   | none     | X = random value 
                                     66 ;   15  | seed prgn      | X=param  | none  
                                     67 ;----------------------------------------------
                                     68 ; syscall codes  
                                     69 ; global constants 
                           000000    70     SYS_RST==0
                           000001    71     SYS_TICKS=1 
                           000002    72     PUTC==2
                           000003    73     GETC==3 
                           000004    74     QCHAR==4
                           000005    75     CLS==5
                           000006    76     DELBK==6
                           000007    77     GETLN==7 
                           000008    78     PRT_STR==8
                           000009    79     PRT_INT==9 
                           00000A    80     SET_TIMER==10
                           00000B    81     CHK_TIMOUT==11 
                           00000C    82     START_TONE==12 
                           00000D    83     GET_RND==13
                           00000E    84     SEED_PRNG==14 
                                     85 
                                     86 ;;-------------------------------
                                     87     .area CODE
                                     88 
                                     89 ;;--------------------------------
                                     90 
                                     91 
                                     92 ;-------------------------
                                     93 ;  software interrupt handler 
                                     94 ;-------------------------
      0081E7                         95 TrapHandler::
      0081E7 1E 08            [ 2]   96     ldw x,(8,sp) ; get trap return address 
      000169                         97     _strxz trap_ret 
      0081E9 BF 14                    1     .byte 0xbf,trap_ret 
      0081EB AE 81 F1         [ 2]   98     ldw x,#syscall_handler 
      0081EE 1F 08            [ 2]   99     ldw (8,sp),x 
      0081F0 80               [11]  100     iret 
                                    101 
                                    102 
                                    103 
                                    104     .macro _syscode n, t 
                                    105     cp a,#n 
                                    106     jrne t   
                                    107     .endm 
                                    108 
                                    109 ;---------------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 47.
Hexadecimal [24-Bits]



                                    110 ;  must be handled outside 
                                    111 ;  of TrapHandler to enable 
                                    112 ;  interrupts 
                                    113 ;---------------------------------
      0081F1                        114 syscall_handler:      
      000171                        115     _syscode SYS_RST, 0$ 
      0081F1 A1 00            [ 1]    1     cp a,#SYS_RST 
      0081F3 26 04            [ 1]    2     jrne 0$   
      000175                        116     _swreset
      0081F5 35 80 50 D1      [ 1]    1     mov WWDG_CR,#0X80
      0081F9                        117 0$:
      000179                        118     _syscode SYS_TICKS,1$
      0081F9 A1 01            [ 1]    1     cp a,#SYS_TICKS 
      0081FB 26 05            [ 1]    2     jrne 1$   
      00017D                        119     _ldxz ticks 
      0081FD BE 04                    1     .byte 0xbe,ticks 
      0081FF CC 82 81         [ 2]  120     jp syscall_exit      
      008202                        121 1$:
      000182                        122     _syscode PUTC, 2$  
      008202 A1 02            [ 1]    1     cp a,#PUTC 
      008204 26 07            [ 1]    2     jrne 2$   
      008206 9F               [ 1]  123     ld a,xl 
      008207 CD 85 41         [ 4]  124     call uart_putc
      00820A CC 82 81         [ 2]  125     jp syscall_exit 
      00820D                        126 2$:
      00018D                        127     _syscode GETC,3$ 
      00820D A1 03            [ 1]    1     cp a,#GETC 
      00820F 26 06            [ 1]    2     jrne 3$   
      008211 CD 85 50         [ 4]  128     call uart_getc 
      008214 CC 82 81         [ 2]  129     jp syscall_exit
      008217                        130 3$:
      000197                        131     _syscode QCHAR,4$ 
      008217 A1 04            [ 1]    1     cp a,#QCHAR 
      008219 26 05            [ 1]    2     jrne 4$   
      00821B CD 85 4A         [ 4]  132     call qgetc  
      00821E 20 61            [ 2]  133     jra syscall_exit
      008220                        134 4$:
      0001A0                        135     _syscode CLS,5$ 
      008220 A1 05            [ 1]    1     cp a,#CLS 
      008222 26 05            [ 1]    2     jrne 5$   
      008224 CD 85 EF         [ 4]  136     call clr_screen
      008227 20 58            [ 2]  137     jra syscall_exit 
      008229                        138 5$: 
      0001A9                        139     _syscode DELBK,6$ 
      008229 A1 06            [ 1]    1     cp a,#DELBK 
      00822B 26 05            [ 1]    2     jrne 6$   
      00822D CD 85 D9         [ 4]  140     call bksp  
      008230 20 4F            [ 2]  141     jra syscall_exit 
      008232                        142 6$: 
      0001B2                        143     _syscode GETLN , 7$
      008232 A1 07            [ 1]    1     cp a,#GETLN 
      008234 26 05            [ 1]    2     jrne 7$   
      008236 CD 86 79         [ 4]  144     call readln  
      008239 20 46            [ 2]  145     jra syscall_exit 
      00823B                        146 7$: 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 48.
Hexadecimal [24-Bits]



      0001BB                        147     _syscode PRT_STR , 8$
      00823B A1 08            [ 1]    1     cp a,#PRT_STR 
      00823D 26 05            [ 1]    2     jrne 8$   
      00823F CD 85 A3         [ 4]  148     call puts 
      008242 20 3D            [ 2]  149     jra syscall_exit
      008244                        150 8$: 
      0001C4                        151     _syscode PRT_INT , 9$
      008244 A1 09            [ 1]    1     cp a,#PRT_INT 
      008246 26 05            [ 1]    2     jrne 9$   
      008248 CD 88 2E         [ 4]  152     call print_int
      00824B 20 34            [ 2]  153     jra syscall_exit      
      00824D                        154 9$: 
      0001CD                        155     _syscode SET_TIMER , 10$
      00824D A1 0A            [ 1]    1     cp a,#SET_TIMER 
      00824F 26 08            [ 1]    2     jrne 10$   
      008251 72 11 00 0A      [ 1]  156     bres sys_flags,#FSYS_TIMER 
      0001D5                        157     _strxz timer 
      008255 BF 06                    1     .byte 0xbf,timer 
      008257 20 28            [ 2]  158     jra syscall_exit 
      008259                        159 10$:
      0001D9                        160     _syscode CHK_TIMOUT, 11$
      008259 A1 0B            [ 1]    1     cp a,#CHK_TIMOUT 
      00825B 26 09            [ 1]    2     jrne 11$   
      00825D 4F               [ 1]  161     clr a 
      00825E 72 01 00 0A 1E   [ 2]  162     btjf sys_flags,#FSYS_TIMER,syscall_exit  
      008263 43               [ 1]  163     cpl a 
      008264 20 1B            [ 2]  164     jra syscall_exit
      008266                        165 11$: 
      0001E6                        166     _syscode START_TONE , 12$    
      008266 A1 0C            [ 1]    1     cp a,#START_TONE 
      008268 26 05            [ 1]    2     jrne 12$   
      00826A CD 82 B9         [ 4]  167     call tone 
      00826D 20 12            [ 2]  168     jra syscall_exit 
      00826F                        169 12$: 
      0001EF                        170     _syscode GET_RND , 13$
      00826F A1 0D            [ 1]    1     cp a,#GET_RND 
      008271 26 05            [ 1]    2     jrne 13$   
      008273 CD 83 2E         [ 4]  171     call prng 
      008276 20 09            [ 2]  172     jra syscall_exit 
      008278                        173 13$: 
      0001F8                        174     _syscode SEED_PRNG , 14$
      008278 A1 0E            [ 1]    1     cp a,#SEED_PRNG 
      00827A 26 05            [ 1]    2     jrne 14$   
      00827C CD 83 50         [ 4]  175     call set_seed 
      00827F 20 00            [ 2]  176     jra syscall_exit 
      008281                        177 14$: 
                                    178 
                                    179 ; bad codes ignored 
      008281                        180 syscall_exit:
      008281 72 CC 00 14      [ 5]  181     jp [trap_ret] 
                                    182 
                                    183 
                                    184 ;------------------------------
                                    185 ; TIMER 4 is used to maintain 
                                    186 ; a milliseconds 'ticks' counter
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 49.
Hexadecimal [24-Bits]



                                    187 ; and decrement 'timer' varaiable
                                    188 ; and 'tone_ms' variable .
                                    189 ; these 3 variables are unsigned  
                                    190 ; ticks range {0..65535}
                                    191 ; timer range {0..65535}
                                    192 ; tone_ms range {0..65535}
                                    193 ;--------------------------------
      008285                        194 Timer4UpdateHandler:
      008285 72 5F 53 42      [ 1]  195 	clr TIM4_SR 
      000209                        196 	_incz ticks+1 
      008289 3C 05                    1     .byte 0x3c, ticks+1 
      00828B 26 02            [ 1]  197 	jrne 0$ 
      00020D                        198 	_incz ticks
      00828D 3C 04                    1     .byte 0x3c, ticks 
      00828F                        199 0$:
      00020F                        200 	_ldxz timer
      00828F BE 06                    1     .byte 0xbe,timer 
      008291 27 09            [ 1]  201 	jreq 1$
      008293 5A               [ 2]  202 	decw x 
      000214                        203 	_strxz timer 
      008294 BF 06                    1     .byte 0xbf,timer 
      008296 26 04            [ 1]  204 	jrne 1$ 
      008298 72 10 00 0A      [ 1]  205 	bset sys_flags,#FSYS_TIMER  
      00829C                        206 1$:
      00021C                        207     _ldxz tone_ms 
      00829C BE 08                    1     .byte 0xbe,tone_ms 
      00829E 27 09            [ 1]  208     jreq 2$ 
      0082A0 5A               [ 2]  209     decw x 
      000221                        210     _strxz tone_ms 
      0082A1 BF 08                    1     .byte 0xbf,tone_ms 
      0082A3 26 04            [ 1]  211     jrne 2$ 
      0082A5 72 13 00 0A      [ 1]  212     bres sys_flags,#FSYS_TONE   
      0082A9                        213 2$: 
      0082A9 80               [11]  214 	iret 
                                    215 
                                    216 
                                    217 ;-----------------
                                    218 ; 1 Khz beep 
                                    219 ;-----------------
      0082AA                        220 beep_1khz::
      0082AA 90 89            [ 2]  221 	pushw y 
      0082AC AE 00 64         [ 2]  222 	ldw x,#100
      0082AF 90 AE 03 E8      [ 2]  223 	ldw y,#1000
      0082B3 CD 82 B9         [ 4]  224 	call tone
      0082B6 90 85            [ 2]  225 	popw y
      0082B8 81               [ 4]  226 	ret 
                                    227 
                                    228 ;---------------------
                                    229 ; input:
                                    230 ;   Y   frequency 
                                    231 ;   x   duration 
                                    232 ;---------------------
                           000001   233 	DIVDHI=1   ; dividend 31..16 
                           000003   234 	DIVDLO=DIVDHI+INT_SIZE ; dividend 15..0 
                           000005   235 	DIVR=DIVDLO+INT_SIZE  ; divisor 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 50.
Hexadecimal [24-Bits]



                           000006   236 	VSIZE=3*INT_SIZE  
      0082B9                        237 tone:: 
      000239                        238 	_vars VSIZE 
      0082B9 52 06            [ 2]    1     sub sp,#VSIZE 
      00023B                        239 	_strxz tone_ms 
      0082BB BF 08                    1     .byte 0xbf,tone_ms 
      0082BD 72 12 00 0A      [ 1]  240 	bset sys_flags,#FSYS_TONE    
      0082C1 17 05            [ 2]  241 	ldw (DIVR,sp),y  ; divisor  
      0082C3 90 AE 00 10      [ 2]  242 	ldw y,#fmstr 
      0082C7 AE 3D 09         [ 2]  243 	ldw x,#15625 ; ftimer=fmstr*1e6/64
      0082CA CD 83 87         [ 4]  244 	call umstar    ; x product 15..0 , y=product 31..16 
      00024D                        245 	_i16_store DIVDLO  
      0082CD 1F 03            [ 2]    1     ldw (DIVDLO,sp),x 
      0082CF 17 01            [ 2]  246 	ldw (DIVDHI,sp),y 
      000251                        247 	_i16_fetch DIVR ; DIVR=freq audio   
      0082D1 1E 05            [ 2]    1     ldw x,(DIVR,sp)
      0082D3 CD 83 F2         [ 4]  248 	call udiv32_16 
      0082D6 9E               [ 1]  249 	ld a,xh 
      0082D7 C7 53 0D         [ 1]  250 	ld TIM2_ARRH,a 
      0082DA 9F               [ 1]  251 	ld a,xl 
      0082DB C7 53 0E         [ 1]  252 	ld TIM2_ARRL,a 
                                    253 ; 50% duty cycle 
      0082DE 54               [ 2]  254 	srlw x  
      0082DF 9E               [ 1]  255 	ld a,xh 
      0082E0 C7 53 0F         [ 1]  256 	ld TIM2_CCR1H,a 
      0082E3 9F               [ 1]  257 	ld a,xl
      0082E4 C7 53 10         [ 1]  258 	ld TIM2_CCR1L,a
      0082E7 72 10 53 08      [ 1]  259 	bset TIM2_CCER1,#TIM2_CCER1_CC1E
      0082EB 72 10 53 00      [ 1]  260 	bset TIM2_CR1,#TIM2_CR1_CEN
      0082EF 72 10 53 04      [ 1]  261 	bset TIM2_EGR,#TIM2_EGR_UG 	
      0082F3                        262 0$: ; wait end of tone 
      0082F3 8F               [10]  263     wfi 
      0082F4 72 02 00 0A FA   [ 2]  264     btjt sys_flags,#FSYS_TONE ,0$    
      0082F9                        265 tone_off: 
      0082F9 72 11 53 08      [ 1]  266 	bres TIM2_CCER1,#TIM2_CCER1_CC1E
      0082FD 72 11 53 00      [ 1]  267 	bres TIM2_CR1,#TIM2_CR1_CEN 
      000281                        268      _drop VSIZE 
      008301 5B 06            [ 2]    1     addw sp,#VSIZE 
      008303 81               [ 4]  269 	ret 
                                    270 
                                    271 
                                    272 ;---------------------------------
                                    273 ; Pseudo Random Number Generator 
                                    274 ; XORShift algorithm.
                                    275 ;---------------------------------
                                    276 
                                    277 ;---------------------------------
                                    278 ;  seedx:seedy= x:y ^ seedx:seedy
                                    279 ; output:
                                    280 ;  X:Y   seedx:seedy new value   
                                    281 ;---------------------------------
      008304                        282 xor_seed32:
      008304 9E               [ 1]  283     ld a,xh 
      000285                        284     _xorz seedx 
      008305 B8 0B                    1     .byte 0xb8,seedx 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 51.
Hexadecimal [24-Bits]



      000287                        285     _straz seedx
      008307 B7 0B                    1     .byte 0xb7,seedx 
      008309 9F               [ 1]  286     ld a,xl 
      00028A                        287     _xorz seedx+1 
      00830A B8 0C                    1     .byte 0xb8,seedx+1 
      00028C                        288     _straz seedx+1 
      00830C B7 0C                    1     .byte 0xb7,seedx+1 
      00830E 90 9E            [ 1]  289     ld a,yh 
      000290                        290     _xorz seedy
      008310 B8 0D                    1     .byte 0xb8,seedy 
      000292                        291     _straz seedy 
      008312 B7 0D                    1     .byte 0xb7,seedy 
      008314 90 9F            [ 1]  292     ld a,yl 
      000296                        293     _xorz seedy+1 
      008316 B8 0E                    1     .byte 0xb8,seedy+1 
      000298                        294     _straz seedy+1 
      008318 B7 0E                    1     .byte 0xb7,seedy+1 
      00029A                        295     _ldxz seedx  
      00831A BE 0B                    1     .byte 0xbe,seedx 
      00029C                        296     _ldyz seedy 
      00831C 90 BE 0D                 1     .byte 0x90,0xbe,seedy 
      00831F 81               [ 4]  297     ret 
                                    298 
                                    299 ;-----------------------------------
                                    300 ;   x:y= x:y << a 
                                    301 ;  input:
                                    302 ;    A     shift count 
                                    303 ;    X:Y   uint32 value 
                                    304 ;  output:
                                    305 ;    X:Y   uint32 shifted value   
                                    306 ;-----------------------------------
      008320                        307 sll_xy_32: 
      008320 90 58            [ 2]  308     sllw y 
      008322 59               [ 2]  309     rlcw x
      008323 4A               [ 1]  310     dec a 
      008324 26 FA            [ 1]  311     jrne sll_xy_32 
      008326 81               [ 4]  312     ret 
                                    313 
                                    314 ;-----------------------------------
                                    315 ;   x:y= x:y >> a 
                                    316 ;  input:
                                    317 ;    A     shift count 
                                    318 ;    X:Y   uint32 value 
                                    319 ;  output:
                                    320 ;    X:Y   uint32 shifted value   
                                    321 ;-----------------------------------
      008327                        322 srl_xy_32: 
      008327 54               [ 2]  323     srlw x 
      008328 90 56            [ 2]  324     rrcw y 
      00832A 4A               [ 1]  325     dec a 
      00832B 26 FA            [ 1]  326     jrne srl_xy_32 
      00832D 81               [ 4]  327     ret 
                                    328 
                                    329 ;-------------------------------------
                                    330 ;  PRNG generator proper 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 52.
Hexadecimal [24-Bits]



                                    331 ; input:
                                    332 ;   none 
                                    333 ; ouput:
                                    334 ;   X     bits 31...16  PRNG seed  
                                    335 ;  use: 
                                    336 ;   seedx:seedy   system variables   
                                    337 ;--------------------------------------
      00832E                        338 prng::
      00832E 90 89            [ 2]  339 	pushw y   
      0002B0                        340     _ldxz seedx
      008330 BE 0B                    1     .byte 0xbe,seedx 
      0002B2                        341 	_ldyz seedy  
      008332 90 BE 0D                 1     .byte 0x90,0xbe,seedy 
      008335 A6 0D            [ 1]  342 	ld a,#13
      008337 CD 83 20         [ 4]  343     call sll_xy_32 
      00833A CD 83 04         [ 4]  344     call xor_seed32
      00833D A6 11            [ 1]  345     ld a,#17 
      00833F CD 83 27         [ 4]  346     call srl_xy_32
      008342 CD 83 04         [ 4]  347     call xor_seed32 
      008345 A6 05            [ 1]  348     ld a,#5 
      008347 CD 83 20         [ 4]  349     call sll_xy_32
      00834A CD 83 04         [ 4]  350     call xor_seed32
      00834D 90 85            [ 2]  351     popw y 
      00834F 81               [ 4]  352     ret 
                                    353 
                                    354 
                                    355 ;---------------------------------
                                    356 ; initialize seedx:seedy 
                                    357 ; input:
                                    358 ;    X    0 -> seedx=ticks, seedy=tib[0..1] 
                                    359 ;    X    !0 -> seedx=X, seedy=[0x6000]
                                    360 ;-------------------------------------------
      008350                        361 set_seed:
      008350 5D               [ 2]  362     tnzw x 
      008351 26 0B            [ 1]  363     jrne 1$ 
      008353 CE 00 04         [ 2]  364     ldw x,ticks 
      0002D6                        365     _strxz seedx
      008356 BF 0B                    1     .byte 0xbf,seedx 
      008358 CE 16 80         [ 2]  366     ldw x,tib 
      0002DB                        367     _strxz seedy  
      00835B BF 0D                    1     .byte 0xbf,seedy 
      00835D 81               [ 4]  368     ret 
      00835E CE 00 04         [ 2]  369 1$: ldw x,ticks 
      0002E1                        370     _strxz seedx
      008361 BF 0B                    1     .byte 0xbf,seedx 
      008363 CE 60 00         [ 2]  371     ldw x,0x6000
      0002E6                        372     _strxz seedy  
      008366 BF 0D                    1     .byte 0xbf,seedy 
      008368 81               [ 4]  373     ret 
                                    374 
                                    375  
                                    376      
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 53.
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
                                     27 ;-------------------------------------
                                     28 	.area DATA
      000016                         29 	.org SYS_VARS_ORG+SYS_VARS_SIZE 
                                     30 ;---------------------------------------
                                     31 
      000016                         32 acc32: .blkb 1 ; 32 bit accumalator upper-byte 
      000017                         33 acc24: .blkb 1 ; 24 bits accumulator upper-byte 
      000018                         34 acc16: .blkb 1 ; 16 bits accumulator, acc24 high-byte
      000019                         35 acc8:  .blkb 1 ;  8 bits accumulator, acc24 low-byte  
      00001A                         36 arithm_vars_end:
                           000004    37 ARITHM_VARS_SIZE=arithm_vars_end-acc32 
                                     38 
                                     39 ;----------------------------------
                                     40 	.area CODE
                                     41 ;----------------------------------
                                     42 
                                     43 ;-------------------------------
                                     44 ; acc16 2's complement 
                                     45 ;-------------------------------
      008369                         46 neg_acc16:
      008369 72 53 00 18      [ 1]   47 	cpl acc16 
      00836D 72 53 00 19      [ 1]   48 	cpl acc8 
      0002F1                         49 	_incz acc8
      008371 3C 19                    1     .byte 0x3c, acc8 
      008373 26 02            [ 1]   50 	jrne 1$ 
      0002F5                         51 	_incz acc16 
      008375 3C 18                    1     .byte 0x3c, acc16 
      008377 81               [ 4]   52 1$: ret 
                                     53 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 54.
Hexadecimal [24-Bits]



                                     54 ;----------------------------------------
                                     55 ;  unsigned multiply uint16*uint8 
                                     56 ;  input:
                                     57 ;     X     uint16 
                                     58 ;     A     uint8
                                     59 ;  output:
                                     60 ;     X     product 
                                     61 ;-----------------------------------------
      008378                         62 umul16_8:
      008378 89               [ 2]   63 	pushw x 
      008379 42               [ 4]   64 	mul x,a
      00837A 89               [ 2]   65 	pushw x 
      00837B 1E 03            [ 2]   66 	ldw x,(3,SP)
      00837D 5E               [ 1]   67 	swapw x 
      00837E 42               [ 4]   68 	mul x,a
      00837F 4F               [ 1]   69 	clr a 
      008380 02               [ 1]   70 	rlwa x ; if a<>0 then overlflow  
      008381 72 FB 01         [ 2]   71 	addw x,(1,sp)
      000304                         72 	_drop 4 
      008384 5B 04            [ 2]    1     addw sp,#4 
      008386 81               [ 4]   73 	ret 
                                     74 
                                     75 ;--------------------------------------
                                     76 ;  multiply 2 uint16_t return uint32_t
                                     77 ;  input:
                                     78 ;     x       uint16_t 
                                     79 ;     y       uint16_t 
                                     80 ;  output:
                                     81 ;     x       product bits 15..0
                                     82 ;     y       product bits 31..16 
                                     83 ;---------------------------------------
                           000001    84 		U1=1  ; uint16_t 
                           000003    85 		DPROD=U1+INT_SIZE ; uint32_t
                           000006    86 		VSIZE=3*INT_SIZE 
      008387                         87 umstar:
      000307                         88 	_vars VSIZE 
      008387 52 06            [ 2]    1     sub sp,#VSIZE 
      008389 1F 01            [ 2]   89 	ldw (U1,sp),x
      00838B 0F 05            [ 1]   90 	clr (DPROD+2,sp)
      00838D 0F 06            [ 1]   91 	clr (DPROD+3,sp) 
                                     92 ; DPROD=u1hi*u2hi
      00838F 90 9E            [ 1]   93 	ld a,yh 
      008391 5E               [ 1]   94 	swapw x 
      008392 42               [ 4]   95 	mul x,a 
      008393 1F 03            [ 2]   96 	ldw (DPROD,sp),x
                                     97 ; DPROD+1 +=u1hi*u2lo 
      008395 7B 01            [ 1]   98 	ld a,(U1,sp)
      008397 97               [ 1]   99 	ld xl,a 
      008398 90 9F            [ 1]  100 	ld a,yl 
      00839A 42               [ 4]  101 	mul x,a 
      00839B 72 FB 04         [ 2]  102 	addw x,(DPROD+1,sp)
      00839E 24 02            [ 1]  103 	jrnc 1$ 
      0083A0 0C 03            [ 1]  104 	inc (DPROD,sp)
      0083A2 1F 04            [ 2]  105 1$: ldw (DPROD+1,sp),x 
                                    106 ; DPROD+1 += u1lo*u2hi 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 55.
Hexadecimal [24-Bits]



      0083A4 7B 02            [ 1]  107 	ld a,(U1+1,sp)
      0083A6 97               [ 1]  108 	ld xl,a 
      0083A7 90 9E            [ 1]  109 	ld a,yh 
      0083A9 42               [ 4]  110 	mul x,a 
      0083AA 72 FB 04         [ 2]  111 	addw x,(DPROD+1,sp)
      0083AD 24 02            [ 1]  112 	jrnc 2$ 
      0083AF 0C 03            [ 1]  113 	inc (DPROD,sp)
      0083B1 1F 04            [ 2]  114 2$: ldw (DPROD+1,sp),x 
                                    115 ; DPROD+2=u1lo*u2lo 
      0083B3 93               [ 1]  116 	ldw x,y  
      0083B4 7B 02            [ 1]  117 	ld a,(U1+1,sp)
      0083B6 42               [ 4]  118 	mul x,a 
      0083B7 72 FB 05         [ 2]  119 	addw x,(DPROD+2,sp)
      0083BA 24 06            [ 1]  120 	jrnc 3$
      0083BC 0C 04            [ 1]  121 	inc (DPROD+1,sp)
      0083BE 26 02            [ 1]  122 	jrne 3$
      0083C0 0C 03            [ 1]  123 	inc (DPROD,sp)
      0083C2                        124 3$:
      0083C2 16 03            [ 2]  125 	ldw y,(DPROD,sp)
      000344                        126 	_drop VSIZE 
      0083C4 5B 06            [ 2]    1     addw sp,#VSIZE 
      0083C6 81               [ 4]  127 	ret
                                    128 
                                    129 
                                    130 ;-------------------------------------
                                    131 ; multiply 2 integers
                                    132 ; input:
                                    133 ;  	x       n1 
                                    134 ;   y 		n2 
                                    135 ; output:
                                    136 ;	X        product 
                                    137 ;-------------------------------------
                           000001   138 	SIGN=1
                           000001   139 	VSIZE=1
      0083C7                        140 multiply:
      000347                        141 	_vars VSIZE 
      0083C7 52 01            [ 2]    1     sub sp,#VSIZE 
      0083C9 0F 01            [ 1]  142 	clr (SIGN,sp)
      0083CB 5D               [ 2]  143 	tnzw x 
      0083CC 2A 03            [ 1]  144 	jrpl 1$
      0083CE 03 01            [ 1]  145 	cpl (SIGN,sp)
      0083D0 50               [ 2]  146 	negw x 
      0083D1                        147 1$:	
      0083D1 90 5D            [ 2]  148 	tnzw y   
      0083D3 2A 04            [ 1]  149 	jrpl 2$ 
      0083D5 03 01            [ 1]  150 	cpl (SIGN,sp)
      0083D7 90 50            [ 2]  151 	negw y 
      0083D9                        152 2$:	
      0083D9 CD 83 87         [ 4]  153 	call umstar
      0083DC 90 5D            [ 2]  154 	tnzw y 
      0083DE 26 03            [ 1]  155 	jrne 3$
      0083E0 5D               [ 2]  156 	tnzw x 
      0083E1 2A 05            [ 1]  157 	jrpl 4$
      0083E3                        158 3$:
      0083E3 A6 02            [ 1]  159 	ld a,#ERR_GT32767
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 56.
Hexadecimal [24-Bits]



      0083E5 CC 95 D5         [ 2]  160 	jp tb_error 
      0083E8                        161 4$:
      0083E8 7B 01            [ 1]  162 	ld a,(SIGN,sp)
      0083EA 27 03            [ 1]  163 	jreq 5$
      0083EC CD 84 19         [ 4]  164 	call dneg 
      0083EF                        165 5$:	
      00036F                        166 	_drop VSIZE 
      0083EF 5B 01            [ 2]    1     addw sp,#VSIZE 
      0083F1 81               [ 4]  167 	ret
                                    168 
                                    169 
                                    170 ;--------------------------------------
                                    171 ; divide uint32_t/uint16_t
                                    172 ; return:  quotient and remainder 
                                    173 ; quotient expected to be uint16_t 
                                    174 ; input:
                                    175 ;   DBLDIVDND    on stack 
                                    176 ;   X            divisor 
                                    177 ; output:
                                    178 ;   X            quotient 
                                    179 ;   Y            remainder 
                                    180 ;---------------------------------------
                           000002   181 	VSIZE=2
      0083F2                        182 	_argofs VSIZE 
                           000004     1     ARG_OFS=2+VSIZE 
      000372                        183 	_arg DBLDIVDND 1
                           000005     1     DBLDIVDND=ARG_OFS+1 
                                    184 	; local variables 
                           000001   185 	DIVISOR=1 
      000372                        186 udiv32_16:
      000372                        187 	_vars VSIZE 
      0083F2 52 02            [ 2]    1     sub sp,#VSIZE 
      0083F4 1F 01            [ 2]  188 	ldw (DIVISOR,sp),x	; save divisor 
      0083F6 1E 07            [ 2]  189 	ldw x,(DBLDIVDND+2,sp)  ; bits 15..0
      0083F8 16 05            [ 2]  190 	ldw y,(DBLDIVDND,sp) ; bits 31..16
      0083FA 90 5D            [ 2]  191 	tnzw y
      0083FC 26 06            [ 1]  192 	jrne long_division 
      0083FE 16 01            [ 2]  193 	ldw y,(DIVISOR,sp)
      008400 65               [ 2]  194 	divw x,y
      000381                        195 	_drop VSIZE 
      008401 5B 02            [ 2]    1     addw sp,#VSIZE 
      008403 81               [ 4]  196 	ret
      008404                        197 long_division:
      008404 51               [ 1]  198 	exgw x,y ; hi in x, lo in y 
      008405 A6 11            [ 1]  199 	ld a,#17 
      008407                        200 1$:
      008407 13 01            [ 2]  201 	cpw x,(DIVISOR,sp)
      008409 25 03            [ 1]  202 	jrc 2$
      00840B 72 F0 01         [ 2]  203 	subw x,(DIVISOR,sp)
      00840E 8C               [ 1]  204 2$:	ccf 
      00840F 90 59            [ 2]  205 	rlcw y 
      008411 59               [ 2]  206 	rlcw x 
      008412 4A               [ 1]  207 	dec a
      008413 26 F2            [ 1]  208 	jrne 1$
      008415 51               [ 1]  209 	exgw x,y 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 57.
Hexadecimal [24-Bits]



      000396                        210 	_drop VSIZE 
      008416 5B 02            [ 2]    1     addw sp,#VSIZE 
      008418 81               [ 4]  211 	ret
                                    212 
                                    213 ;-----------------------------
                                    214 ; negate double int.
                                    215 ; input:
                                    216 ;   x     bits 15..0
                                    217 ;   y     bits 31..16
                                    218 ; output: 
                                    219 ;   x     bits 15..0
                                    220 ;   y     bits 31..16
                                    221 ;-----------------------------
      008419                        222 dneg:
      008419 53               [ 2]  223 	cplw x 
      00841A 90 53            [ 2]  224 	cplw y 
      00841C 5C               [ 1]  225 	incw x 
      00841D 26 02            [ 1]  226 	jrne 1$  
      00841F 90 5C            [ 1]  227 	incw y 
      008421 81               [ 4]  228 1$: ret 
                                    229 
                                    230 
                                    231 ;--------------------------------
                                    232 ; sign extend single to double
                                    233 ; input:
                                    234 ;   x    int16_t
                                    235 ; output:
                                    236 ;   x    int32_t bits 15..0
                                    237 ;   y    int32_t bits 31..16
                                    238 ;--------------------------------
      008422                        239 dbl_sign_extend:
      008422 90 5F            [ 1]  240 	clrw y
      008424 9E               [ 1]  241 	ld a,xh 
      008425 A4 80            [ 1]  242 	and a,#0x80 
      008427 27 02            [ 1]  243 	jreq 1$
      008429 90 53            [ 2]  244 	cplw y
      00842B 81               [ 4]  245 1$: ret 	
                                    246 
                                    247 
                                    248 ;----------------------------------
                                    249 ;  euclidian divide dbl/n1 
                                    250 ;  ref: https://en.wikipedia.org/wiki/Euclidean_division
                                    251 ; input:
                                    252 ;    dbl    int32_t on stack 
                                    253 ;    x 		n1   int16_t  divisor  
                                    254 ; output:
                                    255 ;    X      dbl/x  int16_t 
                                    256 ;    Y      remainder int16_t 
                                    257 ;----------------------------------
                           000008   258 	VSIZE=8
      00842C                        259 	_argofs VSIZE 
                           00000A     1     ARG_OFS=2+VSIZE 
      0003AC                        260 	_arg DIVDNDHI 1 
                           00000B     1     DIVDNDHI=ARG_OFS+1 
      0003AC                        261 	_arg DIVDNDLO 3
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 58.
Hexadecimal [24-Bits]



                           00000D     1     DIVDNDLO=ARG_OFS+3 
                                    262 	; local variables
                           000001   263 	DBLHI=1
                           000003   264 	DBLLO=3 
                           000005   265 	SREMDR=5 ; sign remainder 
                           000006   266 	SQUOT=6 ; sign quotient 
                           000007   267 	DIVISR=7 ; divisor 
      0003AC                        268 div32_16:
      0003AC                        269 	_vars VSIZE 
      00842C 52 08            [ 2]    1     sub sp,#VSIZE 
      00842E 0F 05            [ 1]  270 	clr (SREMDR,sp)
      008430 0F 06            [ 1]  271 	clr (SQUOT,sp)
                                    272 ; copy arguments 
      008432 16 0B            [ 2]  273 	ldw y,(DIVDNDHI,sp)
      008434 17 01            [ 2]  274 	ldw (DBLHI,sp),y
      008436 16 0D            [ 2]  275 	ldw y,(DIVDNDLO,sp)
      008438 17 03            [ 2]  276 	ldw (DBLLO,sp),y 
                                    277 ; check for 0 divisor
                           000000   278 .if 0 
                                    279 	tnzw x 
                                    280     jrne 0$
                                    281 	ld a,#ERR_DIV0 
                                    282 	jp tb_error
                                    283 .endif  
                                    284 ; check divisor sign 	
      00843A 5D               [ 2]  285 0$:	tnzw x 
      00843B 2A 03            [ 1]  286 	jrpl 1$
      00843D 03 06            [ 1]  287 	cpl (SQUOT,sp)
      00843F 50               [ 2]  288 	negw x
      008440 1F 07            [ 2]  289 1$:	ldw (DIVISR,sp),x
                                    290 ; check dividend sign 	 
      008442 7B 01            [ 1]  291  	ld a,(DBLHI,sp) 
      008444 A4 80            [ 1]  292 	and a,#0x80 
      008446 27 0F            [ 1]  293 	jreq 2$ 
      008448 03 06            [ 1]  294 	cpl (SQUOT,sp)
      00844A 03 05            [ 1]  295 	cpl (SREMDR,sp)
      00844C 1E 03            [ 2]  296 	ldw x,(DBLLO,sp)
      00844E 16 01            [ 2]  297 	ldw y,(DBLHI,sp)
      008450 CD 84 19         [ 4]  298 	call dneg 
      008453 1F 03            [ 2]  299 	ldw (DBLLO,sp),x 
      008455 17 01            [ 2]  300 	ldw (DBLHI,sp),y 
      008457 1E 07            [ 2]  301 2$:	ldw x,(DIVISR,sp)
      008459 CD 83 F2         [ 4]  302 	call udiv32_16
      00845C 90 5D            [ 2]  303 	tnzw y 
      00845E 27 05            [ 1]  304 	jreq 3$ 
                                    305 ; x=quotient 
                                    306 ; y=remainder 
                                    307 ; sign quotient
      008460 0D 06            [ 1]  308 	tnz (SQUOT,sp)
      008462 2A 01            [ 1]  309 	jrpl 3$ 
      008464 50               [ 2]  310 	negw x 
      008465                        311 3$: ; sign remainder 
      008465 0D 05            [ 1]  312 	tnz (SREMDR,sp) 
      008467 2A 02            [ 1]  313 	jrpl 4$
      008469 90 50            [ 2]  314 	negw y 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 59.
Hexadecimal [24-Bits]



      00846B                        315 4$:	
      0003EB                        316 	_drop VSIZE 
      00846B 5B 08            [ 2]    1     addw sp,#VSIZE 
      00846D 81               [ 4]  317 	ret 
                                    318 
                                    319 
                                    320 
                                    321 ;----------------------------------
                                    322 ; division x/y 
                                    323 ; input:
                                    324 ;    X       dividend
                                    325 ;    Y       divisor 
                                    326 ; output:
                                    327 ;    X       quotient
                                    328 ;    Y       remainder 
                                    329 ;-----------------------------------
                                    330 	; local variables 
                           000001   331 	DBLHI=1
                           000003   332 	DBLLO=3
                           000005   333 	DIVISR=5
                           000006   334 	VSIZE=6 
      00846E                        335 divide: 
      0003EE                        336 	_vars VSIZE
      00846E 52 06            [ 2]    1     sub sp,#VSIZE 
      008470 90 5D            [ 2]  337 	tnzw y 
      008472 26 05            [ 1]  338 	jrne 1$
      008474 A6 12            [ 1]  339 	ld a,#ERR_DIV0 
      008476 CC 95 D5         [ 2]  340 	jp tb_error
      008479                        341 1$: 
      008479 17 05            [ 2]  342 	ldw (DIVISR,sp),y
      00847B CD 84 22         [ 4]  343 	call dbl_sign_extend
      00847E 1F 03            [ 2]  344 	ldw (DBLLO,sp),x 
      008480 17 01            [ 2]  345 	ldw (DBLHI,sp),y 
      008482 1E 05            [ 2]  346 	ldw x,(DIVISR,sp)
      008484 CD 84 2C         [ 4]  347 	call div32_16 
      000407                        348 	_drop VSIZE 
      008487 5B 06            [ 2]    1     addw sp,#VSIZE 
      008489 81               [ 4]  349 	ret
                                    350 
                                    351 
                                    352 ;----------------------------------
                                    353 ;  remainder resulting from euclidian 
                                    354 ;  division of x/y 
                                    355 ; input:
                                    356 ;   x   	dividend int16_t 
                                    357 ;   y 		divisor int16_t
                                    358 ; output:
                                    359 ;   X       n1%n2 
                                    360 ;----------------------------------
      00848A                        361 modulo:
      00848A CD 84 6E         [ 4]  362 	call divide
      00848D 93               [ 1]  363 	ldw x,y 
      00848E 81               [ 4]  364 	ret 
                                    365 
                                    366 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 60.
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
                           000000    32 SEPARATE=0 
                                     33 
                           000000    34 .if SEPARATE 
                                     35     .module TERMINAL  
                                     36     .include "config.inc"
                                     37 
                                     38     .area CODE 
                                     39 .endif 
                                     40 
                                     41 
                                     42 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     43 ;;   UART subroutines
                                     44 ;;   used for user interface 
                                     45 ;;   communication channel.
                                     46 ;;   settings: 
                                     47 ;;		115200 8N1 no flow control
                                     48 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     49 
                           000008    50 RX_QUEUE_SIZE==8 ; UART receive queue size 
                                     51 
                                     52 ;--------------------------------------
                                     53 	.area DATA
      00001A                         54 	.org SYS_VARS_ORG+SYS_VARS_SIZE+ARITHM_VARS_SIZE 
                                     55 ;--------------------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 61.
Hexadecimal [24-Bits]



                                     56 
      00001A                         57 out: .blkw 1 ; output char routine address 
      00001C                         58 ctrl_c_vector: .blkw 1 ; application can set a routine address here to be executed when CTTRL+C is pressed.
      00001E                         59 rx1_head:  .blkb 1 ; rx1_queue head pointer
      00001F                         60 rx1_tail:   .blkb 1 ; rx1_queue tail pointer  
      000020                         61 rx1_queue: .ds RX_QUEUE_SIZE ; UART receive circular queue 
      000028                         62 term_vars_end: 
                           00000E    63 TERMIOS_VARS_SIZE==term_vars_end-out 
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
      00848F                         81 UartRxHandler: ; console receive char 
      00848F 72 0B 52 40 2B   [ 2]   82 	btjf UART_SR,#UART_SR_RXNE,5$ 
      008494 C6 52 41         [ 1]   83 	ld a,UART_DR 
      008497 A1 03            [ 1]   84 	cp a,#CTRL_C 
      008499 26 09            [ 1]   85 	jrne 2$
      00849B CE 00 1C         [ 2]   86 	ldw x,ctrl_c_vector 
      00849E 27 1F            [ 1]   87 	jreq 5$ 
      0084A0 1F 08            [ 2]   88 	ldw (8,sp),x 
      0084A2 20 1B            [ 2]   89 	jra 5$ 
      0084A4                         90 2$:
      0084A4 A1 18            [ 1]   91 	cp a,#CAN ; CTRL_X 
      0084A6 26 04            [ 1]   92 	jrne 3$
      000428                         93 	_swreset 	
      0084A8 35 80 50 D1      [ 1]    1     mov WWDG_CR,#0X80
      0084AC                         94 3$:	
      0084AC 88               [ 1]   95 	push a 
      0084AD A6 20            [ 1]   96 	ld a,#rx1_queue 
      0084AF CB 00 1F         [ 1]   97 	add a,rx1_tail 
      0084B2 5F               [ 1]   98 	clrw x 
      0084B3 97               [ 1]   99 	ld xl,a 
      0084B4 84               [ 1]  100 	pop a 
      0084B5 F7               [ 1]  101 	ld (x),a 
      0084B6 C6 00 1F         [ 1]  102 	ld a,rx1_tail 
      0084B9 4C               [ 1]  103 	inc a 
      0084BA A4 07            [ 1]  104 	and a,#RX_QUEUE_SIZE-1
      0084BC C7 00 1F         [ 1]  105 	ld rx1_tail,a 
      0084BF                        106 5$:	
      0084BF 80               [11]  107 	iret 
                                    108 
                                    109 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 62.
Hexadecimal [24-Bits]



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
      0084C0                        122 uart_init:
      000440                        123 	_vars VSIZE 
      0084C0 52 05            [ 2]    1     sub sp,#VSIZE 
                                    124 ; BRR value = Fmaster/115200 
      0084C2 5F               [ 1]  125 	clrw x 
      000443                        126 	_ldaz fmstr 
      0084C3 B6 10                    1     .byte 0xb6,fmstr 
      0084C5 02               [ 1]  127 	rlwa x 
      0084C6 90 AE 27 10      [ 2]  128 	ldw y,#10000
      0084CA CD 83 87         [ 4]  129 	call umstar
      00044D                        130 	_i16_store N2   
      0084CD 1F 03            [ 2]    1     ldw (N2,sp),x 
      0084CF 93               [ 1]  131 	ldw x,y 
      000450                        132 	_i16_store N1 
      0084D0 1F 01            [ 2]    1     ldw (N1,sp),x 
      0084D2 AE 04 80         [ 2]  133 	ldw x,#BAUD_RATE/100
      0084D5 CD 83 F2         [ 4]  134 	call udiv32_16 ; X quotient, Y  remainder 
      0084D8 90 A3 02 40      [ 2]  135 	cpw y,#BAUD_RATE/200
      0084DC 2B 01            [ 1]  136 	jrmi 1$ 
      0084DE 5C               [ 1]  137 	incw x
      0084DF                        138 1$:  
                                    139 ; // brr value in X
      0084DF A6 10            [ 1]  140 	ld a,#16 
      0084E1 62               [ 2]  141 	div x,a 
      0084E2 88               [ 1]  142 	push a  ; least nibble of BRR1 
      0084E3 02               [ 1]  143 	rlwa x 
      0084E4 4E               [ 1]  144 	swap a  ; high nibble of BRR1 
      0084E5 1A 01            [ 1]  145 	or a,(1,sp)
      000467                        146 	_drop 1 
      0084E7 5B 01            [ 2]    1     addw sp,#1 
      0084E9 C7 52 43         [ 1]  147 	ld UART_BRR2,a 
      0084EC 9E               [ 1]  148 	ld a,xh 
      0084ED C7 52 42         [ 1]  149 	ld UART_BRR1,a
      0084F0                        150 3$:
      0084F0 72 5F 52 41      [ 1]  151     clr UART_DR
      0084F4 35 2C 52 45      [ 1]  152 	mov UART_CR2,#((1<<UART_CR2_TEN)|(1<<UART_CR2_REN)|(1<<UART_CR2_RIEN));
      0084F8 72 10 52 45      [ 1]  153 	bset UART_CR2,#UART_CR2_SBK
      0084FC 72 0D 52 40 FB   [ 2]  154     btjf UART_SR,#UART_SR_TC,.
      008501 72 5F 00 1E      [ 1]  155     clr rx1_head 
      008505 72 5F 00 1F      [ 1]  156 	clr rx1_tail
      008509 5F               [ 1]  157 	clrw x
      00048A                        158 	_strxz ctrl_c_vector
      00850A BF 1C                    1     .byte 0xbf,ctrl_c_vector 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 63.
Hexadecimal [24-Bits]



      00850C AE 85 41         [ 2]  159 	ldw x,#uart_putc 
      00048F                        160 	_strxz out 
      00850F BF 1A                    1     .byte 0xbf,out 
      008511 72 10 00 02      [ 1]  161 	bset UART,#UART_CR1_PIEN
      000495                        162 	_drop VSIZE 
      008515 5B 05            [ 2]    1     addw sp,#VSIZE 
      008517 81               [ 4]  163 	ret
                                    164 
                                    165 
                                    166 ;---------------------------------
                                    167 ;  set output vector 
                                    168 ;  input:
                                    169 ;     A     STDOUT -> uart 
                                    170 ;           BUFOUT -> [ptr16]
                                    171 ;     X     buffer address 
                                    172 ;---------------------------------
      008518                        173 set_output:
      008518 CF 00 12         [ 2]  174 	ldw ptr16,x 
      00851B AE 85 41         [ 2]  175 	ldw x,#uart_putc 
      00851E A1 01            [ 1]  176 	cp a,#STDOUT 
      008520 27 07            [ 1]  177 	jreq 1$
      008522 A1 03            [ 1]  178 	cp a,#BUFOUT 
      008524 26 05            [ 1]  179 	jrne 9$  
      008526 AE 85 32         [ 2]  180 	ldw x,#buf_putc 
      0004A9                        181 1$: _strxz out  
      008529 BF 1A                    1     .byte 0xbf,out 
      00852B 81               [ 4]  182 9$:	ret 
                                    183 
                                    184 
                                    185 ;---------------------------------
                                    186 ;  vectorized character output 
                                    187 ;  input:
                                    188 ;     A   character to send 
                                    189 ;---------------------------------
      00852C                        190 putc:
      00852C 89               [ 2]  191 	pushw x 
      0004AD                        192 	_ldxz out 
      00852D BE 1A                    1     .byte 0xbe,out 
      00852F FD               [ 4]  193 	call (x)
      008530 85               [ 2]  194 	popw x 
      008531 81               [ 4]  195 	ret 
                                    196 
                                    197 ;---------------------------------
                                    198 ; output character to a buffer 
                                    199 ; pointed by ptr16
                                    200 ; input:
                                    201 ;    A     character to save 
                                    202 ;---------------------------------
      008532                        203 buf_putc:
      008532 72 C7 00 12      [ 4]  204 	ld [ptr16],a
      0004B6                        205 	_incz ptr8 
      008536 3C 13                    1     .byte 0x3c, ptr8 
      008538 26 02            [ 1]  206 	jrne 9$
      0004BA                        207 	_incz ptr16 
      00853A 3C 12                    1     .byte 0x3c, ptr16 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 64.
Hexadecimal [24-Bits]



      00853C 72 3F 00 12      [ 4]  208 9$:	clr [ptr16] 
      008540 81               [ 4]  209 	ret 
                                    210 
                                    211 
                                    212 ;---------------------------------
                                    213 ; uart_putc
                                    214 ; send a character via UART
                                    215 ; input:
                                    216 ;    A  	character to send
                                    217 ;---------------------------------
      008541                        218 uart_putc:: 
      008541 72 0F 52 40 FB   [ 2]  219 	btjf UART_SR,#UART_SR_TXE,.
      008546 C7 52 41         [ 1]  220 	ld UART_DR,a 
      008549 81               [ 4]  221 	ret 
                                    222 
                                    223 
                                    224 ;---------------------------------
                                    225 ; Query for character in rx1_queue
                                    226 ; input:
                                    227 ;   none 
                                    228 ; output:
                                    229 ;   A     0 no charcter available
                                    230 ;   Z     1 no character available
                                    231 ;---------------------------------
      00854A                        232 qgetc::
      00854A                        233 uart_qgetc::
      0004CA                        234 	_ldaz rx1_head 
      00854A B6 1E                    1     .byte 0xb6,rx1_head 
      00854C C0 00 1F         [ 1]  235 	sub a,rx1_tail 
      00854F 81               [ 4]  236 	ret 
                                    237 
                                    238 ;---------------------------------
                                    239 ; wait character from UART 
                                    240 ; input:
                                    241 ;   none
                                    242 ; output:
                                    243 ;   A 			char  
                                    244 ;--------------------------------	
      008550                        245 getc:: ;console input
      008550                        246 uart_getc::
      008550 CD 85 4A         [ 4]  247 	call uart_qgetc
      008553 27 FB            [ 1]  248 	jreq uart_getc 
      008555 89               [ 2]  249 	pushw x 
                                    250 ;; rx1_queue must be in page 0 	
      008556 A6 20            [ 1]  251 	ld a,#rx1_queue
      008558 CB 00 1E         [ 1]  252 	add a,rx1_head 
      00855B 5F               [ 1]  253 	clrw x  
      00855C 97               [ 1]  254 	ld xl,a 
      00855D F6               [ 1]  255 	ld a,(x)
      00855E 88               [ 1]  256 	push a
      0004DF                        257 	_ldaz rx1_head 
      00855F B6 1E                    1     .byte 0xb6,rx1_head 
      008561 4C               [ 1]  258 	inc a 
      008562 A4 07            [ 1]  259 	and a,#RX_QUEUE_SIZE-1
      0004E4                        260 	_straz rx1_head 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 65.
Hexadecimal [24-Bits]



      008564 B7 1E                    1     .byte 0xb7,rx1_head 
      008566 84               [ 1]  261 	pop a 
      008567 72 05 00 0A 03   [ 2]  262 	btjf sys_flags,#FSYS_UPPER,1$
      00856C CD 88 F4         [ 4]  263 	call to_upper 
      00856F                        264 1$: 
      00856F 85               [ 2]  265 	popw x
      008570 81               [ 4]  266 	ret 
                                    267 
                                    268 ;-----------------------------
                                    269 ;  constants replacing 
                                    270 ;  ANSI sequence received 
                                    271 ;  from terminal.
                                    272 ;  These are the ANSI sequences
                                    273 ;  accepted by readln function
                                    274 ;------------------------------
                           000080   275     ARROW_LEFT=128
                           000081   276     ARROW_RIGHT=129
                           000082   277     HOME=130
                           000083   278     KEY_END=131
                           000084   279     SUP=132 
                                    280 
      008571 43 81 44 80 48 82 46   281 convert_table: .byte 'C',ARROW_RIGHT,'D',ARROW_LEFT,'H',HOME,'F',KEY_END,'3',SUP,0,0
             83 33 84 00 00
                                    282 
                                    283 ;--------------------------------
                                    284 ; receive ANSI ESC 
                                    285 ; sequence and convert it
                                    286 ; to a single character code 
                                    287 ; in range {128..255}
                                    288 ; This is called after receiving 
                                    289 ; ESC character. 
                                    290 ; ignored sequence return 0 
                                    291 ; output:
                                    292 ;   A    converted character 
                                    293 ;-------------------------------
      00857D                        294 get_escape:
      00857D CD 85 50         [ 4]  295     call getc 
      008580 A1 5B            [ 1]  296     cp a,#'[ ; this character is expected after ESC 
      008582 27 02            [ 1]  297     jreq 1$
      008584 4F               [ 1]  298     clr a
      008585 81               [ 4]  299     ret
      008586 CD 85 50         [ 4]  300 1$: call getc 
      008589 AE 85 71         [ 2]  301     ldw x,#convert_table
      00858C                        302 2$:
      00858C F1               [ 1]  303     cp a,(x)
      00858D 27 08            [ 1]  304     jreq 4$
      00858F 1C 00 02         [ 2]  305     addw x,#2
      008592 7D               [ 1]  306     tnz (x)
      008593 26 F7            [ 1]  307     jrne 2$
      008595 4F               [ 1]  308     clr a
      008596 81               [ 4]  309     ret 
      008597 5C               [ 1]  310 4$: incw x 
      008598 F6               [ 1]  311     ld a,(x)
      008599 A1 84            [ 1]  312     cp a,#SUP
      00859B 26 05            [ 1]  313     jrne 5$
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 66.
Hexadecimal [24-Bits]



      00859D 88               [ 1]  314     push a 
      00859E CD 85 50         [ 4]  315     call getc
      0085A1 84               [ 1]  316     pop a 
      0085A2                        317 5$:
      0085A2 81               [ 4]  318     ret 
                                    319 
                                    320 
                                    321 ;-----------------------------
                                    322 ; send an ASCIZ string to UART 
                                    323 ; input: 
                                    324 ;   x 		char * 
                                    325 ; output:
                                    326 ;   none 
                                    327 ;-------------------------------
      0085A3                        328 puts::
      0085A3 F6               [ 1]  329     ld a,(x)
      0085A4 27 06            [ 1]  330 	jreq 1$
      0085A6 CD 85 2C         [ 4]  331 	call putc 
      0085A9 5C               [ 1]  332 	incw x 
      0085AA 20 F7            [ 2]  333 	jra puts 
      0085AC 5C               [ 1]  334 1$:	incw x 
      0085AD 81               [ 4]  335 	ret 
                                    336 
                                    337 ;---------------------------------------------------------------
                                    338 ; send ANSI Control Sequence Introducer (CSI) 
                                    339 ; ANSI: CSI 
                                    340 ; note: ESC is ASCII 27
                                    341 ;       [   is ASCII 91
                                    342 ; ref: https://en.wikipedia.org/wiki/ANSI_escape_code#CSIsection  
                                    343 ;----------------------------------------------------------------- 
      0085AE                        344 send_csi:
      0085AE 88               [ 1]  345 	push a 
      0085AF A6 1B            [ 1]  346 	ld a,#ESC 
      0085B1 CD 85 2C         [ 4]  347 	call putc 
      0085B4 A6 5B            [ 1]  348 	ld a,#'[
      0085B6 CD 85 2C         [ 4]  349 	call putc
      0085B9 84               [ 1]  350 	pop a  
      0085BA 81               [ 4]  351 	ret 
                                    352 
                                    353 ;---------------------
                                    354 ;send ANSI parameter value
                                    355 ; ANSI parameter values are 
                                    356 ; sent as ASCII charater 
                                    357 ; not as binary number.
                                    358 ; this routine 
                                    359 ; convert binary number to 
                                    360 ; ASCII string and send it.
                                    361 ; expected range {0..99}
                                    362 ; input: 
                                    363 ; 	A {0..99} 
                                    364 ; output:
                                    365 ;   none 
                                    366 ;---------------------
      0085BB                        367 send_parameter:
      0085BB 89               [ 2]  368 	pushw x 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 67.
Hexadecimal [24-Bits]



      0085BC 5F               [ 1]  369 	clrw x 
      0085BD 97               [ 1]  370 	ld xl,a 
      0085BE A6 0A            [ 1]  371 	ld a,#10 
      0085C0 62               [ 2]  372 	div x,a 
      0085C1 95               [ 1]  373 	ld xh,a 
      0085C2 9F               [ 1]  374 	ld a,xl
      0085C3 4D               [ 1]  375     tnz a 
      0085C4 27 0B            [ 1]  376     jreq 2$
      0085C6 A1 09            [ 1]  377 	cp a,#9 
      0085C8 23 02            [ 2]  378 	jrule 1$
      0085CA A6 09            [ 1]  379 	ld a,#9
      0085CC                        380 1$:
      0085CC AB 30            [ 1]  381 	add a,#'0 
      0085CE CD 85 2C         [ 4]  382 	call putc
      0085D1 9E               [ 1]  383 2$:	ld a,xh 
      0085D2 AB 30            [ 1]  384 	add a,#'0
      0085D4 CD 85 2C         [ 4]  385 	call putc 
      0085D7 85               [ 2]  386 	popw x 
      0085D8 81               [ 4]  387 	ret 
                                    388 
                                    389 ;---------------------------
                                    390 ; delete character at left 
                                    391 ; of cursor on terminal 
                                    392 ; input:
                                    393 ;   none 
                                    394 ; output:
                                    395 ;	none 
                                    396 ;---------------------------
      0085D9                        397 bksp:
      0085D9 A6 08            [ 1]  398 	ld a,#BS 
      0085DB CD 85 2C         [ 4]  399 	call putc 
      0085DE A6 20            [ 1]  400 	ld a,#SPACE 
      0085E0 CD 85 2C         [ 4]  401 	call putc 
      0085E3 A6 08            [ 1]  402 	ld a,#BS 
      0085E5 CD 85 2C         [ 4]  403 	call putc 
      0085E8 81               [ 4]  404 	ret 
                                    405 
                                    406 ;---------------------------
                                    407 ; send LF character 
                                    408 ; terminal interpret it 
                                    409 ; as CRLF 
                                    410 ;---------------------------
      0085E9                        411 new_line: 
      0085E9 A6 0A            [ 1]  412 	ld a,#LF 
      0085EB CD 85 2C         [ 4]  413 	call putc 
      0085EE 81               [ 4]  414 	ret 
                                    415 
                                    416 ;--------------------------
                                    417 ; erase terminal screen 
                                    418 ;--------------------------
      0085EF                        419 clr_screen:
      0085EF A6 1B            [ 1]  420 	ld a,#ESC 
      0085F1 CD 85 2C         [ 4]  421 	call putc 
      0085F4 A6 63            [ 1]  422 	ld a,#'c 
      0085F6 CD 85 2C         [ 4]  423 	call putc 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 68.
Hexadecimal [24-Bits]



      0085F9 81               [ 4]  424 	ret 
                                    425 
                                    426 ;---------------------------
                                    427 ; move cursor at column  
                                    428 ; input:
                                    429 ;    n    colon 
                                    430 ;---------------------------
      0085FA                        431 cursor_column:
      0085FA CD 85 AE         [ 4]  432 	call send_csi 
      0085FD CD 85 BB         [ 4]  433 	call send_parameter 
      008600 A6 47            [ 1]  434 	ld a,#'G 
      008602 CD 85 2C         [ 4]  435 	call putc 
      008605 81               [ 4]  436 	ret 
                                    437 
                                    438 
                                    439 ;--------------------------
                                    440 ; output a single space
                                    441 ;--------------------------
      008606                        442 space:
      008606 A6 20            [ 1]  443 	ld a,#SPACE 
      008608 CD 85 2C         [ 4]  444 	call putc 
      00860B 81               [ 4]  445 	ret 
                                    446 
                                    447 ;--------------------------
                                    448 ; print n spaces on terminal
                                    449 ; input:
                                    450 ;  X 		number of spaces 
                                    451 ; output:
                                    452 ;	none 
                                    453 ;---------------------------
      00860C                        454 spaces::
      00860C A6 20            [ 1]  455 	ld a,#SPACE 
      00860E 5D               [ 2]  456 1$:	tnzw x
      00860F 27 06            [ 1]  457 	jreq 9$
      008611 CD 85 2C         [ 4]  458 	call putc 
      008614 5A               [ 2]  459 	decw x
      008615 20 F7            [ 2]  460 	jra 1$
      008617                        461 9$: 
      008617 81               [ 4]  462 	ret 
                                    463 
                                    464 
                                    465 ;-----------------------------
                                    466 ; send ANSI sequence to delete
                                    467 ; whole display line. 
                                    468 ; cursor set left screen.
                                    469 ; ANSI: CSI K
                                    470 ; input:
                                    471 ;   none
                                    472 ; output:
                                    473 ;   none 
                                    474 ;-----------------------------
      008618                        475 erase_line:
                                    476 ; move to screen left 
      008618 CD 86 2D         [ 4]  477 	call restore_cursor_pos  
                                    478 ; delete from cursor to end of line 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 69.
Hexadecimal [24-Bits]



      00861B CD 85 AE         [ 4]  479     call send_csi
      00861E A6 4B            [ 1]  480 	ld a,#'K 
      008620 CD 85 2C         [ 4]  481 	call putc 
      008623 81               [ 4]  482 	ret 
                                    483 
                                    484 ;-------------------------------
                                    485 ; save current cursor postion 
                                    486 ; this value persist to next 
                                    487 ; call to this procedure.
                                    488 ; ANSI: CSI s
                                    489 ;--------------------------------
      008624                        490 save_cursor_pos: 
      008624 CD 85 AE         [ 4]  491 	call send_csi 
      008627 A6 73            [ 1]  492 	ld a,#'s 
      008629 CD 85 2C         [ 4]  493 	call putc 
      00862C 81               [ 4]  494 	ret 
                                    495 
                                    496 ;--------------------------------
                                    497 ; restore cursor position from 
                                    498 ; saved value 
                                    499 ; ANSI: CSI u	
                                    500 ;---------------------------------
      00862D                        501 restore_cursor_pos:
      00862D 88               [ 1]  502 	push a 
      00862E CD 85 AE         [ 4]  503 	call send_csi 
      008631 A6 75            [ 1]  504 	ld a,#'u 
      008633 CD 85 2C         [ 4]  505 	call putc 
      008636 84               [ 1]  506 	pop a 
      008637 81               [ 4]  507 	ret 
                                    508 
                                    509 ;---------------------------------
                                    510 ; move cursor to CPOS 
                                    511 ; input:
                                    512 ;   A     CPOS 
                                    513 ;---------------------------------
      008638                        514 move_to_cpos:
      008638 CD 86 2D         [ 4]  515 	call restore_cursor_pos
      00863B 4D               [ 1]  516 	tnz a 
      00863C 27 0B            [ 1]  517 	jreq 9$ 
      00863E CD 85 AE         [ 4]  518 	call send_csi 
      008641 CD 85 BB         [ 4]  519 	call send_parameter
      008644 A6 43            [ 1]  520 	ld a,#'C 
      008646 CD 85 2C         [ 4]  521 	call putc 
      008649 81               [ 4]  522 9$:	ret 
                                    523 
                                    524 ;----------------------------------
                                    525 ; change cursor shape according 
                                    526 ; to editing mode 
                                    527 ; input:
                                    528 ;   A      -1 block shape (overwrite) 
                                    529 ;           0 vertical line (insert)
                                    530 ; output:
                                    531 ;   none 
                                    532 ;-----------------------------------
      00864A                        533 cursor_style:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 70.
Hexadecimal [24-Bits]



      00864A 4D               [ 1]  534 	tnz a 
      00864B 26 04            [ 1]  535 	jrne 1$ 
      00864D A6 35            [ 1]  536 	ld a,#'5 
      00864F 20 02            [ 2]  537 	jra 2$
      008651 A6 31            [ 1]  538 1$: ld a,#'1
      008653                        539 2$:	
      008653 CD 85 AE         [ 4]  540 	call send_csi
      008656 CD 85 2C         [ 4]  541 	call putc 
      008659 CD 86 06         [ 4]  542 	call space
      00865C A6 71            [ 1]  543 	ld a,#'q 
      00865E CD 85 2C         [ 4]  544 	call putc 
      008661 81               [ 4]  545 	ret 
                                    546 
                                    547 ;--------------------------
                                    548 ; insert character in text 
                                    549 ; line 
                                    550 ; input:
                                    551 ;   A       character to insert 
                                    552 ;   XL      insert position  
                                    553 ;   XH     line length    
                                    554 ; output:
                                    555 ;   tib     updated
                                    556 ;-------------------------
                                    557  ; local variables 
                           000001   558 	ICHAR=1 ; character to insert 
                           000002   559 	LLEN=2  ; line length
                           000003   560 	IPOS=3  ; insert position 
                           000003   561 	VSIZE=3  ; local variables size 
      008662                        562 insert_char: 
      0005E2                        563 	_vars VSIZE 
      008662 52 03            [ 2]    1     sub sp,#VSIZE 
      008664 6B 01            [ 1]  564     ld (ICHAR,sp),a 
      008666 1F 02            [ 2]  565 	ldw (LLEN,sp),x 
      008668 4F               [ 1]  566 	clr a 
      008669 01               [ 1]  567 	rrwa x ; A=IPOS , XL=LLEN, XH=0 
      00866A 9F               [ 1]  568 	ld a,xl  
      00866B 10 03            [ 1]  569 	sub a,(IPOS,sp) 
      00866D 1C 16 80         [ 2]  570 	addw x,#tib 
      008670 CD 87 F6         [ 4]  571 	call move_string_right 
      008673 7B 01            [ 1]  572 	ld a,(ICHAR,sp)
      008675 F7               [ 1]  573 	ld (x),a
      0005F6                        574 	_drop VSIZE  
      008676 5B 03            [ 2]    1     addw sp,#VSIZE 
      008678 81               [ 4]  575 	ret 
                                    576 
                                    577 ;------------------------------------
                                    578 ; read a line of text from terminal
                                    579 ;  control keys: 
                                    580 ;    BS   efface caractère à gauche 
                                    581 ;    CTRL_R  edit previous line.
                                    582 ;    CTRL_D  delete line  
                                    583 ;    HOME  go to start of line  
                                    584 ;    KEY_END  go to end of line 
                                    585 ;    ARROW_LEFT  move cursor left 
                                    586 ;    ARROW_RIGHT  move cursor right 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 71.
Hexadecimal [24-Bits]



                                    587 ;    CTRL_L accept lower case letter 
                                    588 ;    CTRL_U accept upper case only 
                                    589 ;    CTRL_O  toggle between insert/overwrite
                                    590 ; input:
                                    591 ;	A    length of string already in buffer 
                                    592 ; local variable on stack:
                                    593 ;	LL  line length
                                    594 ;   RXCHAR last received character
                                    595 ; use:
                                    596 ;   Y point end of line  
                                    597 ; output:
                                    598 ;   A  line length 
                                    599 ;   text in tib  buffer
                                    600 ;------------------------------------
                                    601 	; local variables
                           000001   602 	RXCHAR = 1 ; last char received
                           000001   603 	LL_HB=1  ; line length high byte 
                           000002   604 	LL = 2  ; actual line length
                           000003   605 	CPOS=3  ; cursor position 
                           000004   606 	OVRWR=4 ; overwrite flag 
                           000004   607 	VSIZE=4 
      008679                        608 readln::
      008679 90 89            [ 2]  609 	pushw y 
      0005FB                        610 	_vars VSIZE 
      00867B 52 04            [ 2]    1     sub sp,#VSIZE 
      00867D 5F               [ 1]  611 	clrw x 
      00867E 1F 01            [ 2]  612 	ldw (LL_HB,sp),x 
      008680 1F 03            [ 2]  613 	ldw (CPOS,sp),x 
      008682 6B 02            [ 1]  614 	ld (LL,sp),a
      008684 6B 03            [ 1]  615 	ld (CPOS,sp),a  
      008686 03 04            [ 1]  616 	cpl (OVRWR,sp) ; default to overwrite mode
      008688 CD 86 24         [ 4]  617 	call save_cursor_pos
      00868B 0D 02            [ 1]  618 	tnz (LL,sp)
      00868D 27 10            [ 1]  619 	jreq skip_display
      00868F AE 16 80         [ 2]  620 	ldw x,#tib 
      008692 CD 85 A3         [ 4]  621 	call puts 
      008695 20 08            [ 2]  622 	jra skip_display 
      008697                        623 readln_loop:
      008697 CD 88 07         [ 4]  624 	call display_line
      00869A                        625 update_cursor:
      00869A 7B 03            [ 1]  626 	ld a,(CPOS,sp)
      00869C CD 86 38         [ 4]  627 	call move_to_cpos   
      00869F                        628 skip_display: 
      00869F CD 85 50         [ 4]  629 	call getc
      0086A2 6B 01            [ 1]  630 	ld (RXCHAR,sp),a
      0086A4 A1 1B            [ 1]  631     cp a,#ESC 
      0086A6 26 05            [ 1]  632     jrne 0$
      0086A8 CD 85 7D         [ 4]  633     call get_escape 
      0086AB 6B 01            [ 1]  634     ld (RXCHAR,sp),a 
      0086AD A1 0D            [ 1]  635 0$:	cp a,#CR
      0086AF 26 03            [ 1]  636 	jrne 1$
      0086B1 CC 87 B1         [ 2]  637 	jp readln_quit
      0086B4 A1 0A            [ 1]  638 1$:	cp a,#LF 
      0086B6 26 03            [ 1]  639 	jrne 2$ 
      0086B8 CC 87 B1         [ 2]  640 	jp readln_quit
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 72.
Hexadecimal [24-Bits]



      0086BB                        641 2$:
      0086BB A1 08            [ 1]  642 	cp a,#BS
      0086BD 26 10            [ 1]  643 	jrne 3$
      0086BF 7B 03            [ 1]  644 	ld a,(CPOS,sp)
      0086C1 CD 87 DD         [ 4]  645 	call delete_left
      0086C4 11 03            [ 1]  646 	cp a,(CPOS,sp)
      0086C6 27 04            [ 1]  647 	jreq 21$ 
      0086C8 6B 03            [ 1]  648 	ld (CPOS,SP),a 
      0086CA 0A 02            [ 1]  649 	dec (LL,sp)
      0086CC                        650 21$:
      0086CC CC 86 97         [ 2]  651     jp readln_loop 
      0086CF                        652 3$:
      0086CF A1 04            [ 1]  653 	cp a,#CTRL_D
      0086D1 26 0B            [ 1]  654 	jrne 4$
                                    655 ;delete line 
      0086D3 4F               [ 1]  656 	clr a 
      0086D4 AE 16 80         [ 2]  657 	ldw x,#tib 
      0086D7 7F               [ 1]  658 	clr(x)
      0086D8 0F 03            [ 1]  659 	clr (CPOS,sp)
      0086DA 0F 02            [ 1]  660 	clr (LL,sp)
      0086DC 20 B9            [ 2]  661 	jra readln_loop
      0086DE                        662 4$:
      0086DE A1 12            [ 1]  663 	cp a,#CTRL_R 
      0086E0 26 13            [ 1]  664 	jrne 5$
                                    665 ;repeat line 
      0086E2 0D 02            [ 1]  666 	tnz (LL,sp)
      0086E4 26 B1            [ 1]  667 	jrne readln_loop
      0086E6 AE 16 80         [ 2]  668 	ldw x,#tib 
      0086E9 CD 88 86         [ 4]  669 	call strlen
      0086EC 4D               [ 1]  670 	tnz a  
      0086ED 27 A8            [ 1]  671 	jreq readln_loop
      0086EF 6B 02            [ 1]  672 	ld (LL,sp),a 
      0086F1 6B 03            [ 1]  673     ld (CPOS,sp),a
      0086F3 20 A2            [ 2]  674 	jra readln_loop 
      0086F5                        675 5$:
      0086F5 A1 81            [ 1]  676 	cp a,#ARROW_RIGHT
      0086F7 26 0E            [ 1]  677    	jrne 7$ 
                                    678 ; right arrow
      0086F9 7B 03            [ 1]  679 	ld a,(CPOS,sp)
      0086FB 11 02            [ 1]  680     cp a,(LL,sp)
      0086FD 2B 03            [ 1]  681     jrmi 61$
      0086FF CC 86 9F         [ 2]  682     jp skip_display 
      008702                        683 61$:
      008702 0C 03            [ 1]  684 	inc (CPOS,sp)
      008704 CC 86 9A         [ 2]  685     jp update_cursor  
      008707 A1 80            [ 1]  686 7$: cp a,#ARROW_LEFT  
      008709 26 0C            [ 1]  687 	jrne 8$
                                    688 ; left arrow 
      00870B 0D 03            [ 1]  689 	tnz (CPOS,sp)
      00870D 26 03            [ 1]  690 	jrne 71$
      00870F CC 86 9F         [ 2]  691 	jp skip_display
      008712                        692 71$:
      008712 0A 03            [ 1]  693 	dec (CPOS,sp)
      008714 CC 86 9A         [ 2]  694 	jp update_cursor 
      008717 A1 82            [ 1]  695 8$: cp a,#HOME  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 73.
Hexadecimal [24-Bits]



      008719 26 08            [ 1]  696 	jrne 9$
                                    697 ; HOME 
      00871B 0F 03            [ 1]  698 	clr (CPOS,sp)
      00871D CD 86 2D         [ 4]  699 	call restore_cursor_pos
      008720 CC 86 9F         [ 2]  700 	jp skip_display  
      008723 A1 83            [ 1]  701 9$: cp a,#KEY_END  
      008725 26 07            [ 1]  702 	jrne 10$
                                    703 ; KEY_END 
      008727 7B 02            [ 1]  704 	ld a,(LL,sp)
      008729 6B 03            [ 1]  705 	ld (CPOS,sp),a 
      00872B CC 86 9A         [ 2]  706 	jp update_cursor
      00872E                        707 10$:
      00872E A1 0C            [ 1]  708 	cp a,#CTRL_L 
      008730 26 07            [ 1]  709 	jrne 11$ 
      008732 72 15 00 0A      [ 1]  710 	bres sys_flags,#FSYS_UPPER 
      008736 CC 86 9F         [ 2]  711 	jp skip_display 
      008739                        712 11$: 
      008739 A1 15            [ 1]  713 	cp a,#CTRL_U 
      00873B 26 07            [ 1]  714 	jrne 12$
      00873D 72 14 00 0A      [ 1]  715 	bset sys_flags,#FSYS_UPPER
      008741 CC 86 9F         [ 2]  716 	jp skip_display 
      008744                        717 12$: 
      008744 A1 0F            [ 1]  718 	cp a,#CTRL_O
      008746 26 0D            [ 1]  719 	jrne 13$ 
                                    720 ; toggle between insert/overwrite
      008748 03 04            [ 1]  721 	cpl (OVRWR,sp)
      00874A 7B 04            [ 1]  722  	ld a,(OVRWR,sp)
      00874C CD 86 4A         [ 4]  723 	call cursor_style
      00874F CD 82 AA         [ 4]  724 	call beep_1khz
      008752 CC 86 9F         [ 2]  725 	jp skip_display
      008755 A1 84            [ 1]  726 13$: cp a,#SUP 
      008757 26 11            [ 1]  727     jrne final_test 
                                    728 ; del character under cursor 
      008759 7B 03            [ 1]  729     ld a,(CPOS,sp)
      00875B 11 02            [ 1]  730 	cp a,(LL,sp)
      00875D 26 03            [ 1]  731 	jrne 14$ 
      00875F CC 86 9F         [ 2]  732 	jp skip_display
      008762                        733 14$:
      008762 CD 87 CF         [ 4]  734 	call delete_under
      008765 0A 02            [ 1]  735 	dec (LL,sp)
      008767 CC 86 97         [ 2]  736     jp readln_loop 
      00876A                        737 final_test:
      00876A A1 20            [ 1]  738 	cp a,#SPACE
      00876C 2A 03            [ 1]  739 	jrpl accept_char
      00876E CC 86 9F         [ 2]  740 	jp skip_display
      008771                        741 accept_char:
      008771 A6 7F            [ 1]  742 	ld a,#TIB_SIZE-1
      008773 11 02            [ 1]  743 	cp a, (LL,sp)
      008775 2A 03            [ 1]  744 	jrpl 1$
      008777 CC 86 9F         [ 2]  745 	jp skip_display ; max length reached 
      00877A 0D 04            [ 1]  746 1$:	tnz (OVRWR,sp)
      00877C 26 17            [ 1]  747 	jrne overwrite
                                    748 ; insert mode 
      00877E 7B 03            [ 1]  749     ld a,(CPOS,sp)
      008780 11 02            [ 1]  750 	cp a,(LL,sp)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 74.
Hexadecimal [24-Bits]



      008782 27 11            [ 1]  751 	jreq overwrite
      008784 5F               [ 1]  752 	clrw x 
      008785 97               [ 1]  753     ld xl,a ; xl=cpos 
      008786 7B 02            [ 1]  754 	ld a,(LL,sp)
      008788 95               [ 1]  755 	ld xh,a  ; xh=ll 
      008789 7B 01            [ 1]  756     ld a,(RXCHAR,sp)
      00878B CD 86 62         [ 4]  757     call insert_char 
      00878E 0C 02            [ 1]  758     inc (LL,sp)
      008790 0C 03            [ 1]  759     inc (CPOS,sp)	
      008792 CC 86 97         [ 2]  760     jp readln_loop 
      008795                        761 overwrite:
      008795 5F               [ 1]  762 	clrw x 
      008796 7B 03            [ 1]  763 	ld a,(CPOS,sp)
      008798 97               [ 1]  764 	ld xl,a 
      008799 1C 16 80         [ 2]  765 	addw x,#tib 
      00879C 7B 01            [ 1]  766 	ld a,(RXCHAR,sp)
      00879E F7               [ 1]  767 	ld (x),a
      00879F CD 85 2C         [ 4]  768 	call putc 
      0087A2 7B 03            [ 1]  769 	ld a,(CPOS,sp)
      0087A4 11 02            [ 1]  770 	cp a,(LL,sp)
      0087A6 2B 04            [ 1]  771 	jrmi 1$
      0087A8 0C 02            [ 1]  772 	inc (LL,sp)
      0087AA 6F 01            [ 1]  773 	clr (1,x) 
      0087AC                        774 1$:	
      0087AC 0C 03            [ 1]  775 	inc (CPOS,sp)
      0087AE CC 86 9F         [ 2]  776 	jp skip_display 
      0087B1                        777 readln_quit:
      0087B1 AE 16 80         [ 2]  778 	ldw x,#tib
      0087B4 0F 01            [ 1]  779     clr (LL_HB,sp) 
      0087B6 72 FB 01         [ 2]  780     addw x,(LL_HB,sp)
      0087B9 7F               [ 1]  781     clr (x)
      0087BA A6 0D            [ 1]  782 	ld a,#CR
      0087BC CD 85 2C         [ 4]  783 	call putc
      0087BF A6 FF            [ 1]  784  	ld a,#-1 
      0087C1 CD 86 4A         [ 4]  785 	call cursor_style
      0087C4 7B 02            [ 1]  786 	ld a,(LL,sp)
      000746                        787 	_drop VSIZE 
      0087C6 5B 04            [ 2]    1     addw sp,#VSIZE 
      0087C8 90 85            [ 2]  788 	popw y 
      0087CA 72 14 00 0A      [ 1]  789 	bset sys_flags,#FSYS_UPPER 
      0087CE 81               [ 4]  790 	ret
                                    791 
                                    792 ;--------------------------
                                    793 ; delete character under cursor
                                    794 ; and update display 
                                    795 ; input:
                                    796 ;   A      cursor position
                                    797 ;   Y      end of line pointer 
                                    798 ; output:
                                    799 ;   A      not change 
                                    800 ;   Y      updated 
                                    801 ;-------------------------
                           000001   802 	CPOS=1
                           000001   803 	VSIZE=1
      0087CF                        804 delete_under:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 75.
Hexadecimal [24-Bits]



      0087CF 88               [ 1]  805 	push A ; CPOS 
      0087D0 5F               [ 1]  806 	clrw x 
      0087D1 97               [ 1]  807 	ld xl,a 
      0087D2 1C 16 80         [ 2]  808 	addw x,#tib 
      0087D5 F6               [ 1]  809 	ld a,(x)
      0087D6 27 03            [ 1]  810 	jreq 2$ ; at end of line  
      0087D8 CD 87 ED         [ 4]  811 	call move_string_left
      0087DB 84               [ 1]  812 2$: pop a
      0087DC 81               [ 4]  813 	ret 
                                    814 
                                    815 
                                    816 ;------------------------------
                                    817 ; delete character left of cursor
                                    818 ; and update display  
                                    819 ; input:
                                    820 ;    A    CPOS 
                                    821 ;    Y    end of line pointer 
                                    822 ; output:
                                    823 ;    A    updated CPOS 
                                    824 ;-------------------------------
      0087DD                        825 delete_left:
      0087DD 4D               [ 1]  826 	tnz a 
      0087DE 27 0C            [ 1]  827 	jreq 9$ 
      0087E0 88               [ 1]  828 	push a 
      0087E1 5F               [ 1]  829 	clrw x 
      0087E2 97               [ 1]  830 	ld xl,a  
      0087E3 1C 16 80         [ 2]  831 	addw x,#tib
      0087E6 5A               [ 2]  832 	decw x
      0087E7 CD 87 ED         [ 4]  833 	call move_string_left   
      0087EA 84               [ 1]  834 	pop a 
      0087EB 4A               [ 1]  835 	dec a  
      0087EC 81               [ 4]  836 9$:	ret 
                                    837 
                                    838 ;-----------------------------
                                    839 ; move_string_left 
                                    840 ; move .asciz 1 character left 
                                    841 ; input: 
                                    842 ;    X    destination 
                                    843 ; output:
                                    844 ;    x    end of moved string 
                                    845 ;-----------------------------
      0087ED                        846 move_string_left: 
      0087ED E6 01            [ 1]  847 1$:	ld a,(1,x)
      0087EF F7               [ 1]  848 	ld (x),a
      0087F0 27 03            [ 1]  849 	jreq 2$  
      0087F2 5C               [ 1]  850 	incw x 
      0087F3 20 F8            [ 2]  851 	jra 1$ 
      0087F5 81               [ 4]  852 2$: ret 
                                    853 
                                    854 ;-----------------------------
                                    855 ; move_string_right 
                                    856 ; move .asciz 1 character right 
                                    857 ; to give space for character 
                                    858 ; insertion 
                                    859 ; input:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 76.
Hexadecimal [24-Bits]



                                    860 ;   A     string length 
                                    861 ;   X     *str_end 
                                    862 ; output:
                                    863 ;   X     *slot  
                                    864 ;------------------------------
      0087F6                        865 move_string_right: 
      0087F6 4D               [ 1]  866 	tnz a 
      0087F7 27 0D            [ 1]  867 	jreq 9$
      0087F9 4C               [ 1]  868 	inc a  
      0087FA 88               [ 1]  869 	push a
      0087FB F6               [ 1]  870 1$: ld a,(x)
      0087FC E7 01            [ 1]  871 	ld (1,x),a
      0087FE 5A               [ 2]  872 	decw x  
      0087FF 0A 01            [ 1]  873 	dec (1,sp)
      008801 26 F8            [ 1]  874 	jrne 1$
      000783                        875 	_drop 1
      008803 5B 01            [ 2]    1     addw sp,#1 
      008805 5C               [ 1]  876 	incw x  
      008806 81               [ 4]  877 9$: ret 
                                    878 
                                    879 ;------------------------------
                                    880 ; display '>' on terminal 
                                    881 ; followed by edited line
                                    882 ;------------------------------
      008807                        883 display_line:
      008807 CD 86 18         [ 4]  884 	call erase_line  
                                    885 ; write edited line 	
      00880A AE 16 80         [ 2]  886 	ldw x,#tib 
      00880D CD 85 A3         [ 4]  887 	call puts 
      008810 81               [ 4]  888 	ret 
                                    889 
                                    890 ;----------------------------------
                                    891 ; convert to hexadecimal digit 
                                    892 ; input:
                                    893 ;   A       digit to convert 
                                    894 ; output:
                                    895 ;   A       hexdecimal character 
                                    896 ;----------------------------------
      008811                        897 to_hex_char::
      008811 A4 0F            [ 1]  898 	and a,#15 
      008813 A1 0A            [ 1]  899 	cp a,#10 
      008815 2B 02            [ 1]  900 	jrmi 1$ 
      008817 AB 07            [ 1]  901 	add a,#7
      008819 AB 30            [ 1]  902 1$: add a,#'0 
      00881B 81               [ 4]  903 	ret 
                                    904 
                                    905 ;------------------------------
                                    906 ; print byte  in hexadecimal 
                                    907 ; on console
                                    908 ; no space separator 
                                    909 ; input:
                                    910 ;    A		byte to print
                                    911 ;------------------------------
      00881C                        912 print_hex::
      00881C 88               [ 1]  913 	push a 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 77.
Hexadecimal [24-Bits]



      00881D 4E               [ 1]  914 	swap a 
      00881E CD 88 11         [ 4]  915 	call to_hex_char 
      008821 CD 85 2C         [ 4]  916 	call putc 
      008824 84               [ 1]  917     pop a  
      008825 CD 88 11         [ 4]  918 	call to_hex_char
      008828 CD 85 2C         [ 4]  919 	call putc   
      00882B 81               [ 4]  920 	ret 
                                    921 
                                    922 ;------------------------
                                    923 ; print int8 
                                    924 ; input:
                                    925 ;    A    int8 
                                    926 ; output:
                                    927 ;    none 
                                    928 ;-----------------------
      00882C                        929 prt_i8:
      00882C 5F               [ 1]  930 	clrw x 
      00882D 97               [ 1]  931 	ld xl,a  
                                    932 
                                    933 
                                    934 ;------------------------------------
                                    935 ; print integer  
                                    936 ; input:
                                    937 ;	X  		    integer to print 
                                    938 ;	'base' 		numerical base for conversion 
                                    939 ;    A 			signed||unsigned conversion
                                    940 ;  output:
                                    941 ;    A          string length
                                    942 ;------------------------------------
      00882E                        943 print_int:
      00882E A6 FF            [ 1]  944 	ld a,#255  ; signed conversion  
      008830 CD 88 39         [ 4]  945     call itoa  ; conversion entier en  .asciz
      008833 88               [ 1]  946 	push a 
      008834 CD 85 A3         [ 4]  947 	call puts
      008837 84               [ 1]  948 	pop a 
      008838 81               [ 4]  949     ret	
                                    950 
                                    951 ;------------------------------------
                                    952 ; convert integer in x to string
                                    953 ; input:
                                    954 ;   'base'	conversion base 
                                    955 ;	X   	integer to convert
                                    956 ;   A       0=unsigned, else signed 
                                    957 ; output:
                                    958 ;   X  		pointer to first char of string
                                    959 ;   A       string length
                                    960 ; use:
                                    961 ;   pad     to build string 
                                    962 ;------------------------------------
                           000001   963 	SIGN=1  ; 1 byte, integer sign 
                           000002   964 	LEN=SIGN+1   ; 1 byte, string length 
                           000002   965 	VSIZE=2 ;locals size
      008839                        966 itoa::
      008839 90 89            [ 2]  967 	pushw y 
      0007BB                        968 	_vars VSIZE
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 78.
Hexadecimal [24-Bits]



      00883B 52 02            [ 2]    1     sub sp,#VSIZE 
      00883D 0F 02            [ 1]  969 	clr (LEN,sp) ; string length  
      00883F 0F 01            [ 1]  970 	clr (SIGN,sp)    ; sign
      008841 4D               [ 1]  971 	tnz a
      008842 27 06            [ 1]  972 	jreq 1$ ; unsigned conversion  
      008844 5D               [ 2]  973 	tnzw x 
      008845 2A 03            [ 1]  974 	jrpl 1$ 
      008847 03 01            [ 1]  975 	cpl (SIGN,sp)
      008849 50               [ 2]  976 	negw x 
      00884A                        977 1$:
                                    978 ; initialize string pointer 
                                    979 ; build string at end of pad  
      00884A 90 AE 17 00      [ 2]  980 	ldw y,#pad 
      00884E 72 A9 00 80      [ 2]  981 	addw y,#PAD_SIZE 
      008852 90 5A            [ 2]  982 	decw y 
      008854 90 7F            [ 1]  983 	clr (y)
      008856 A6 20            [ 1]  984 	ld a,#SPACE
      008858 90 5A            [ 2]  985 	decw y
      00885A 90 F7            [ 1]  986 	ld (y),a 
      00885C 0C 02            [ 1]  987 	inc (LEN,sp)
      00885E                        988 itoa_loop:
      00885E A6 0A            [ 1]  989     ld a,#10 
      008860 62               [ 2]  990     div x,a 
      008861 AB 30            [ 1]  991     add a,#'0  ; remainder of division
      008863 A1 3A            [ 1]  992     cp a,#'9+1
      008865 2B 02            [ 1]  993     jrmi 2$
      008867 AB 07            [ 1]  994     add a,#7 
      008869                        995 2$:	
      008869 90 5A            [ 2]  996 	decw y
      00886B 90 F7            [ 1]  997     ld (y),a
      00886D 0C 02            [ 1]  998 	inc (LEN,sp)
                                    999 ; if x==0 conversion done
      00886F 5D               [ 2] 1000 	tnzw x 
      008870 26 EC            [ 1] 1001     jrne itoa_loop
      008872 7B 01            [ 1] 1002 	ld a,(SIGN,sp)
      008874 27 08            [ 1] 1003     jreq 10$
      008876 A6 2D            [ 1] 1004     ld a,#'-
      008878 90 5A            [ 2] 1005     decw y
      00887A 90 F7            [ 1] 1006     ld (y),a
      00887C 0C 02            [ 1] 1007 	inc (LEN,sp)
      00887E                       1008 10$:
      00887E 7B 02            [ 1] 1009 	ld a,(LEN,sp)
      008880 93               [ 1] 1010 	ldw x,y 
      000801                       1011 	_drop VSIZE
      008881 5B 02            [ 2]    1     addw sp,#VSIZE 
      008883 90 85            [ 2] 1012 	popw y 
      008885 81               [ 4] 1013 	ret
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 79.
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
                                     23 
                                     24 ;--------------------------
                                     25 	.area CODE
                                     26 ;--------------------------
                                     27 
                                     28 ;--------------------------------------
                                     29 ; retrun string length
                                     30 ; input:
                                     31 ;   X         .asciz  pointer 
                                     32 ; output:
                                     33 ;   X         not affected 
                                     34 ;   A         length 
                                     35 ;-------------------------------------
      008886                         36 strlen::
      008886 89               [ 2]   37 	pushw x 
      008887 4F               [ 1]   38 	clr a
      008888 7D               [ 1]   39 1$:	tnz (x) 
      008889 27 04            [ 1]   40 	jreq 9$ 
      00888B 4C               [ 1]   41 	inc a 
      00888C 5C               [ 1]   42 	incw x 
      00888D 20 F9            [ 2]   43 	jra 1$ 
      00888F 85               [ 2]   44 9$:	popw x 
      008890 81               [ 4]   45 	ret 
                                     46 
                                     47 ;------------------------------------
                                     48 ; compare 2 strings
                                     49 ; input:
                                     50 ;   X 		char* first string 
                                     51 ;   Y       char* second string 
                                     52 ; output:
                                     53 ;   Z flag 	0 != | 1 ==  
                                     54 ;-------------------------------------
      008891                         55 strcmp::
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 80.
Hexadecimal [24-Bits]



      008891 F6               [ 1]   56 	ld a,(x)
      008892 27 09            [ 1]   57 	jreq 5$ 
      008894 90 F1            [ 1]   58 	cp a,(y) 
      008896 26 07            [ 1]   59 	jrne 9$ 
      008898 5C               [ 1]   60 	incw x 
      008899 90 5C            [ 1]   61 	incw y 
      00889B 20 F4            [ 2]   62 	jra strcmp 
      00889D                         63 5$: ; end of first string 
      00889D 90 F1            [ 1]   64 	cp a,(y)
      00889F 81               [ 4]   65 9$:	ret 
                                     66 
                                     67 ;---------------------------------------
                                     68 ;  copy src string to dest 
                                     69 ; input:
                                     70 ;   X 		dest 
                                     71 ;   Y 		src 
                                     72 ; output: 
                                     73 ;   X 		dest 
                                     74 ;----------------------------------
      0088A0                         75 strcpy::
      0088A0 88               [ 1]   76 	push a 
      0088A1 89               [ 2]   77 	pushw x 
      0088A2 90 F6            [ 1]   78 1$: ld a,(y)
      0088A4 27 06            [ 1]   79 	jreq 9$ 
      0088A6 F7               [ 1]   80 	ld (x),a 
      0088A7 5C               [ 1]   81 	incw x 
      0088A8 90 5C            [ 1]   82 	incw y 
      0088AA 20 F6            [ 2]   83 	jra 1$ 
      0088AC 7F               [ 1]   84 9$:	clr (x)
      0088AD 85               [ 2]   85 	popw x 
      0088AE 84               [ 1]   86 	pop a 
      0088AF 81               [ 4]   87 	ret 
                                     88 
                                     89 ;---------------------------------------
                                     90 ; move memory block 
                                     91 ; input:
                                     92 ;   X 		destination 
                                     93 ;   Y 	    source 
                                     94 ;   acc16	bytes count 
                                     95 ; output:
                                     96 ;   X       destination 
                                     97 ;--------------------------------------
                           000001    98 	INCR=1 ; incrament high byte 
                           000002    99 	LB=2 ; increment low byte 
                           000002   100 	VSIZE=2
      0088B0                        101 move::
      0088B0 88               [ 1]  102 	push a 
      0088B1 89               [ 2]  103 	pushw x 
      000832                        104 	_vars VSIZE 
      0088B2 52 02            [ 2]    1     sub sp,#VSIZE 
      0088B4 0F 01            [ 1]  105 	clr (INCR,sp)
      0088B6 0F 02            [ 1]  106 	clr (LB,sp)
      0088B8 90 89            [ 2]  107 	pushw y 
      0088BA 13 01            [ 2]  108 	cpw x,(1,sp) ; compare DEST to SRC 
      0088BC 90 85            [ 2]  109 	popw y 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 81.
Hexadecimal [24-Bits]



      0088BE 27 2F            [ 1]  110 	jreq move_exit ; x==y 
      0088C0 2B 0E            [ 1]  111 	jrmi move_down
      0088C2                        112 move_up: ; start from top address with incr=-1
      0088C2 72 BB 00 18      [ 2]  113 	addw x,acc16
      0088C6 72 B9 00 18      [ 2]  114 	addw y,acc16
      0088CA 03 01            [ 1]  115 	cpl (INCR,sp)
      0088CC 03 02            [ 1]  116 	cpl (LB,sp)   ; increment = -1 
      0088CE 20 05            [ 2]  117 	jra move_loop  
      0088D0                        118 move_down: ; start from bottom address with incr=1 
      0088D0 5A               [ 2]  119     decw x 
      0088D1 90 5A            [ 2]  120 	decw y
      0088D3 0C 02            [ 1]  121 	inc (LB,sp) ; incr=1 
      0088D5                        122 move_loop:	
      000855                        123     _ldaz acc16 
      0088D5 B6 18                    1     .byte 0xb6,acc16 
      0088D7 CA 00 19         [ 1]  124 	or a, acc8
      0088DA 27 13            [ 1]  125 	jreq move_exit 
      0088DC 72 FB 01         [ 2]  126 	addw x,(INCR,sp)
      0088DF 72 F9 01         [ 2]  127 	addw y,(INCR,sp) 
      0088E2 90 F6            [ 1]  128 	ld a,(y)
      0088E4 F7               [ 1]  129 	ld (x),a 
      0088E5 89               [ 2]  130 	pushw x 
      000866                        131 	_ldxz acc16 
      0088E6 BE 18                    1     .byte 0xbe,acc16 
      0088E8 5A               [ 2]  132 	decw x 
      0088E9 CF 00 18         [ 2]  133 	ldw acc16,x 
      0088EC 85               [ 2]  134 	popw x 
      0088ED 20 E6            [ 2]  135 	jra move_loop
      0088EF                        136 move_exit:
      00086F                        137 	_drop VSIZE
      0088EF 5B 02            [ 2]    1     addw sp,#VSIZE 
      0088F1 85               [ 2]  138 	popw x 
      0088F2 84               [ 1]  139 	pop a 
      0088F3 81               [ 4]  140 	ret 	
                                    141 
                                    142 ;-------------------------
                                    143 ;  upper case letter 
                                    144 ; input:
                                    145 ;   A    letter 
                                    146 ; output:
                                    147 ;   A    
                                    148 ;--------------------------
      0088F4                        149 to_upper:
      0088F4 A1 61            [ 1]  150     cp a,#'a 
      0088F6 2B 06            [ 1]  151     jrmi 9$ 
      0088F8 A1 7B            [ 1]  152     cp a,#'z+1 
      0088FA 2A 02            [ 1]  153     jrpl 9$ 
      0088FC A4 DF            [ 1]  154     and a,#0xDF 
      0088FE 81               [ 4]  155 9$: ret 
                                    156 
                                    157 ;-------------------------------------
                                    158 ; check if A is a letter 
                                    159 ; input:
                                    160 ;   A 			character to test 
                                    161 ; output:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 82.
Hexadecimal [24-Bits]



                                    162 ;   C flag      1 true, 0 false 
                                    163 ;-------------------------------------
      0088FF                        164 is_alpha::
      0088FF A1 41            [ 1]  165 	cp a,#'A 
      008901 8C               [ 1]  166 	ccf 
      008902 24 0B            [ 1]  167 	jrnc 9$ 
      008904 A1 5B            [ 1]  168 	cp a,#'Z+1 
      008906 25 07            [ 1]  169 	jrc 9$ 
      008908 A1 61            [ 1]  170 	cp a,#'a 
      00890A 8C               [ 1]  171 	ccf 
      00890B 24 02            [ 1]  172 	jrnc 9$
      00890D A1 7B            [ 1]  173 	cp a,#'z+1
      00890F 81               [ 4]  174 9$: ret 	
                                    175 
                                    176 ;------------------------------------
                                    177 ; check if character in {'0'..'9'}
                                    178 ; input:
                                    179 ;    A  character to test
                                    180 ; output:
                                    181 ;    Carry  0 not digit | 1 digit
                                    182 ;------------------------------------
      008910                        183 is_digit::
      008910 A1 30            [ 1]  184 	cp a,#'0
      008912 25 03            [ 1]  185 	jrc 1$
      008914 A1 3A            [ 1]  186     cp a,#'9+1
      008916 8C               [ 1]  187 	ccf 
      008917 8C               [ 1]  188 1$:	ccf 
      008918 81               [ 4]  189     ret
                                    190 
                                    191 ;------------------------------------
                                    192 ; check if character in {'0'..'9','A'..'F'}
                                    193 ; input:
                                    194 ;    A  character to test
                                    195 ; output:
                                    196 ;    Carry  0 not hex_digit | 1 hex_digit
                                    197 ;------------------------------------
      008919                        198 is_hex_digit::
      008919 CD 89 10         [ 4]  199 	call is_digit 
      00891C 25 08            [ 1]  200 	jrc 9$
      00891E A1 41            [ 1]  201 	cp a,#'A 
      008920 25 03            [ 1]  202 	jrc 1$
      008922 A1 47            [ 1]  203 	cp a,#'G 
      008924 8C               [ 1]  204 	ccf 
      008925 8C               [ 1]  205 1$: ccf 
      008926 81               [ 4]  206 9$: ret 
                                    207 
                                    208 
                                    209 ;-------------------------------------
                                    210 ; return true if character in  A 
                                    211 ; is letter or digit.
                                    212 ; input:
                                    213 ;   A     ASCII character 
                                    214 ; output:
                                    215 ;   A     no change 
                                    216 ;   Carry    0 false| 1 true 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 83.
Hexadecimal [24-Bits]



                                    217 ;--------------------------------------
      008927                        218 is_alnum::
      008927 CD 89 10         [ 4]  219 	call is_digit
      00892A 25 03            [ 1]  220 	jrc 1$ 
      00892C CD 88 FF         [ 4]  221 	call is_alpha
      00892F 81               [ 4]  222 1$:	ret 
                                    223 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 84.
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
                           000000    26 SEPARATE=0 
                                     27 
                           000000    28 .if SEPARATE 
                                     29     .module I2C   
                                     30     .include "config.inc"
                                     31 
                                     32     .area CODE 
                                     33 .endif 
                                     34 
                                     35 ; SPI channel select pins 
                           000000    36 SPI_CS_RAM==0     ; PB0 
                           000001    37 SPI_CS_EEPROM==1   ; PB1 
                                     38 
                                     39 
                                     40 ; SPI RAM commands 
                                     41 ;----------------------------
                                     42 ; 23LC1024 
                                     43 ; mode set 
                                     44 ;  bit7:6 | mode 
                                     45 ;  -------|------
                                     46 ;    00   |  byte 
                                     47 ;    01   |  sequential 
                                     48 ;    10   |  page 
                                     49 ;    11   | reserved 
                                     50 ;-------------------------------
                           000020    51 RAM_PG_SIZE=32 ; bytes 
                           000002    52 SPI_RAM_WRITE=2 
                           000003    53 SPI_RAM_READ=3
                           000001    54 SPI_RAM_WRMOD=1 ; write mode register
                           000005    55 SPI_RAM_RDMOD=5 ; read mode register   
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 85.
Hexadecimal [24-Bits]



                           000000    56 RW_MODE_BYTE=0 
                           000040    57 RW_MODE_SEQ=(1<<6) 
                           000080    58 RW_MODE_PAG=(2<<6) 
                                     59 
                                     60 ;-----------------------------------------------
                                     61 ; 25LC1024 programming
                                     62 ; 1) set /CS TO 0  
                                     63 ; 2) enable FLASH WRITE with WR_EN cmd 
                                     64 ; 3) set /CS TO 1 
                                     65 ; 4) set /CS to 0 
                                     66 ; 5) send SPI_EEPROM_WRITE followed by 24 bits address
                                     67 ; 6) send up to 256 data bytes 
                                     68 ; 7) rise /CS to 1  
                                     69 ;-----------------------------------------------
                           001000    70 SECTOR_SIZE=4096 ; bytes 
                           000003    71 SPI_EEPROM_READ=3 
                           000002    72 SPI_EEPROM_WRITE=2 ; 256 bytes page 
                           000001    73 WR_STATUS=1  ; write status register 
                           000005    74 RD_STATUS=5  ; read status register 
                           000006    75 WR_EN=6      ; set WEL bit 
                           0000D8    76 SECT_ERASE=0xD8   ; 32KB 
                           000042    77 PAGE_ERASE=0x42 ; 256 bytes  
                           0000C7    78 CHIP_ERASE=0xC7   ; whole memory  
                                     79 ; SR 1 status bits 
                           000000    80 SR_WIP_BIT=0
                           000001    81 SR_WEL_BIT=1 
                                     82 
                                     83 
                                     84 ;---------------------------------
                                     85 ; enable SPI peripheral to maximum 
                                     86 ; frequency = Fspi=Fmstr/2 
                                     87 ; input:
                                     88 ;    none  
                                     89 ; output:
                                     90 ;    none 
                                     91 ;--------------------------------- 
      008930                         92 spi_enable:
      008930 72 12 50 C7      [ 1]   93 	bset CLK_PCKENR1,#CLK_PCKENR1_SPI ; enable clock signal 
                                     94 ; configure ~CS on PB1 and BP0 (CN4:11 and CN4:12) as output. 
      008934 72 11 50 08      [ 1]   95 	bres PB_CR1,#SPI_CS_RAM ; 10K external pull up  
      008938 72 10 50 07      [ 1]   96 	bset PB_DDR,#SPI_CS_RAM 
      00893C 72 10 50 05      [ 1]   97 	bset PB_ODR,#SPI_CS_RAM   ; deselet channel 
      008940 72 13 50 08      [ 1]   98 	bres PB_CR1,#SPI_CS_EEPROM ; 10K external pull up  
      008944 72 12 50 07      [ 1]   99 	bset PB_DDR,#SPI_CS_EEPROM  
      008948 72 12 50 05      [ 1]  100 	bset PB_ODR,#SPI_CS_EEPROM  ; deselect channel 
                                    101 ; ~CS line controlled by sofware 	
      00894C 72 12 52 01      [ 1]  102 	bset SPI_CR2,#SPI_CR2_SSM 
      008950 72 10 52 01      [ 1]  103     bset SPI_CR2,#SPI_CR2_SSI 
                                    104 ; configure SPI as master mode 0.	
      008954 72 14 52 00      [ 1]  105 	bset SPI_CR1,#SPI_CR1_MSTR
                                    106 ; enable SPI
      008958 72 5F 52 02      [ 1]  107 	clr SPI_ICR 
      00895C 72 1C 52 00      [ 1]  108 	bset SPI_CR1,#SPI_CR1_SPE 	
      008960 72 01 52 03 03   [ 2]  109 	btjf SPI_SR,#SPI_SR_RXNE,9$ 
      008965 C6 52 04         [ 1]  110 	ld a,SPI_DR 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 86.
Hexadecimal [24-Bits]



      008968 A6 40            [ 1]  111 9$: ld a,#RW_MODE_SEQ
      00896A CD 8A 19         [ 4]  112 	call spi_ram_set_mode 
      00896D CD 8A 2E         [ 4]  113 	call spi_ram_read_mode 
      008970 A1 40            [ 1]  114 	cp a,#RW_MODE_SEQ
      008972 27 08            [ 1]  115 	jreq 10$  
      008974 AE 89 7D         [ 2]  116 	ldw x,#spi_mode_failed 
      008977 CD 85 A3         [ 4]  117 	call puts 
      00897A 20 FE            [ 2]  118 	jra . 
      00897C                        119 10$:
      00897C 81               [ 4]  120 	ret 
      00897D 66 61 69 6C 65 73 20   121 spi_mode_failed: .asciz "failes to set SPI RAM mode\n"
             74 6F 20 73 65 74 20
             53 50 49 20 52 41 4D
             20 6D 6F 64 65 0A 00
                                    122 
                                    123 ;----------------------------
                                    124 ; disable SPI peripheral 
                                    125 ;----------------------------
      008999                        126 spi_disable:
                                    127 ; wait spi idle 
      008999 72 03 52 03 FB   [ 2]  128 	btjf SPI_SR,#SPI_SR_TXE,. 
      00899E 72 01 52 03 FB   [ 2]  129 	btjf SPI_SR,#SPI_SR_RXNE,. 
      0089A3 72 0E 52 03 FB   [ 2]  130 	btjt SPI_SR,#SPI_SR_BSY,.
      0089A8 72 1D 52 00      [ 1]  131 	bres SPI_CR1,#SPI_CR1_SPE
      0089AC 72 13 50 C7      [ 1]  132 	bres CLK_PCKENR1,#CLK_PCKENR1_SPI 
      0089B0 72 11 50 07      [ 1]  133 	bres PB_DDR,#SPI_CS_RAM 
      0089B4 72 13 50 07      [ 1]  134 	bres PB_DDR,#SPI_CS_EEPROM  
      0089B8 81               [ 4]  135 	ret 
                                    136 
                                    137 ;------------------------
                                    138 ; clear SPI error 
                                    139 ;-----------------------
      0089B9                        140 spi_clear_error:
      0089B9 A6 78            [ 1]  141 	ld a,#0x78 
      0089BB C5 52 03         [ 1]  142 	bcp a,SPI_SR 
      0089BE 27 04            [ 1]  143 	jreq 1$
      0089C0 72 5F 52 03      [ 1]  144 	clr SPI_SR 
      0089C4 81               [ 4]  145 1$: ret 
                                    146 
                                    147 ;----------------------
                                    148 ; send byte 
                                    149 ; input:
                                    150 ;   A     byte to send 
                                    151 ; output:
                                    152 ;   A     byte received 
                                    153 ;----------------------
      0089C5                        154 spi_send_byte:
      0089C5 88               [ 1]  155 	push a 
      0089C6 CD 89 B9         [ 4]  156 	call spi_clear_error
      0089C9 84               [ 1]  157 	pop a 
      0089CA 72 03 52 03 FB   [ 2]  158 	btjf SPI_SR,#SPI_SR_TXE,.
      0089CF C7 52 04         [ 1]  159 	ld SPI_DR,a
      0089D2 72 01 52 03 FB   [ 2]  160 	btjf SPI_SR,#SPI_SR_RXNE,.  
      0089D7 C6 52 04         [ 1]  161 	ld a,SPI_DR 
      0089DA 81               [ 4]  162 	ret 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 87.
Hexadecimal [24-Bits]



                                    163 
                                    164 ;------------------------------
                                    165 ;  receive SPI byte 
                                    166 ; output:
                                    167 ;    A 
                                    168 ;------------------------------
      0089DB                        169 spi_rcv_byte:
      0089DB A6 FF            [ 1]  170 	ld a,#255
      0089DD 72 01 52 03 E3   [ 2]  171 	btjf SPI_SR,#SPI_SR_RXNE,spi_send_byte 
      0089E2 C6 52 04         [ 1]  172 	ld a,SPI_DR 
      0089E5 81               [ 4]  173 	ret
                                    174 
                                    175 ;----------------------------
                                    176 ;  create bit mask
                                    177 ;  input:
                                    178 ;     A     bit 
                                    179 ;  output:
                                    180 ;     A     2^bit 
                                    181 ;-----------------------------
      0089E6                        182 create_bit_mask:
      0089E6 88               [ 1]  183 	push a 
      0089E7 A6 01            [ 1]  184 	ld a,#1 
      0089E9 0D 01            [ 1]  185 	tnz (1,sp)
      0089EB 27 05            [ 1]  186 	jreq 9$
      0089ED                        187 1$:
      0089ED 48               [ 1]  188 	sll a 
      0089EE 0A 01            [ 1]  189 	dec (1,sp)
      0089F0 26 FB            [ 1]  190 	jrne 1$
      000972                        191 9$: _drop 1
      0089F2 5B 01            [ 2]    1     addw sp,#1 
      0089F4 81               [ 4]  192 	ret 
                                    193 
                                    194 ;-------------------------------
                                    195 ; SPI select channel 
                                    196 ; input:
                                    197 ;   A    channel SPI_CS_RAM || 
                                    198 ;                SPI_CS_EEPROM 
                                    199 ;--------------------------------
      0089F5                        200 spi_select_channel:
      0089F5 CD 89 E6         [ 4]  201 	call create_bit_mask 
      0089F8 43               [ 1]  202 	cpl a  
      0089F9 88               [ 1]  203 	push a 
      0089FA C6 50 05         [ 1]  204 	ld a,PB_ODR 
      0089FD 14 01            [ 1]  205 	and a,(1,sp)
      0089FF C7 50 05         [ 1]  206 	ld PB_ODR,a 
      000982                        207 	_drop 1 
      008A02 5B 01            [ 2]    1     addw sp,#1 
      008A04 81               [ 4]  208 	ret 
                                    209 
                                    210 ;------------------------------
                                    211 ; SPI deselect channel 
                                    212 ; input:
                                    213 ;   A    channel SPI_CS_RAM ||
                                    214 ; 				 SPI_CS_EEPROM 
                                    215 ;-------------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 88.
Hexadecimal [24-Bits]



      008A05                        216 spi_deselect_channel:
      008A05 72 0E 52 03 FB   [ 2]  217 	btjt SPI_SR,#SPI_SR_BSY,.
      008A0A CD 89 E6         [ 4]  218 	call create_bit_mask 
      008A0D 88               [ 1]  219 	push a 
      008A0E C6 50 05         [ 1]  220 	ld a,PB_ODR 
      008A11 1A 01            [ 1]  221 	or a,(1,sp)
      008A13 C7 50 05         [ 1]  222 	ld PB_ODR,a 
      000996                        223 	_drop 1 
      008A16 5B 01            [ 2]    1     addw sp,#1 
      008A18 81               [ 4]  224 	ret 
                                    225 
                                    226 ;----------------------------
                                    227 ; set spi RAM operating mode 
                                    228 ; input:
                                    229 ;   A     mode byte 
                                    230 ;----------------------------
      008A19                        231 spi_ram_set_mode: 
      008A19 88               [ 1]  232 	push a 
      008A1A A6 00            [ 1]  233 	ld a,#SPI_CS_RAM 
      008A1C CD 89 F5         [ 4]  234 	call spi_select_channel
      008A1F A6 01            [ 1]  235 	ld a,#SPI_RAM_WRMOD
      008A21 CD 89 C5         [ 4]  236 	call spi_send_byte 
      008A24 84               [ 1]  237 	pop a 
      008A25 CD 89 C5         [ 4]  238 	call spi_send_byte 
      008A28 A6 00            [ 1]  239 	ld a,#SPI_CS_RAM 
      008A2A CD 8A 05         [ 4]  240 	call spi_deselect_channel
      008A2D 81               [ 4]  241 	ret 
                                    242 
                                    243 ;----------------------------
                                    244 ; read spi RAM mode register 
                                    245 ; output:
                                    246 ;   A       mode byte 
                                    247 ;----------------------------
      008A2E                        248 spi_ram_read_mode:
      008A2E A6 00            [ 1]  249 	ld a,#SPI_CS_RAM 
      008A30 CD 89 F5         [ 4]  250 	call spi_select_channel
      008A33 A6 05            [ 1]  251 	ld a,#SPI_RAM_RDMOD 
      008A35 CD 89 C5         [ 4]  252 	call spi_send_byte 
      008A38 CD 89 DB         [ 4]  253 	call spi_rcv_byte
      008A3B 88               [ 1]  254 	push a 
      008A3C A6 00            [ 1]  255 	ld a,#SPI_CS_RAM 
      008A3E CD 8A 05         [ 4]  256 	call spi_deselect_channel
      008A41 84               [ 1]  257 	pop a 
      008A42 81               [ 4]  258 	ret 
                                    259 
                                    260 
                                    261 ;-----------------------------
                                    262 ; send 24 bits address to 
                                    263 ; SPI device, RAM || FLASH 
                                    264 ; input:
                                    265 ;   farptr   address 
                                    266 ;------------------------------
      008A43                        267 spi_send_addr:
      0009C3                        268 	_ldaz farptr 
      008A43 B6 11                    1     .byte 0xb6,farptr 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 89.
Hexadecimal [24-Bits]



      008A45 CD 89 C5         [ 4]  269 	call spi_send_byte 
      0009C8                        270 	_ldaz ptr16 
      008A48 B6 12                    1     .byte 0xb6,ptr16 
      008A4A CD 89 C5         [ 4]  271 	call spi_send_byte 
      0009CD                        272 	_ldaz ptr8 
      008A4D B6 13                    1     .byte 0xb6,ptr8 
      008A4F CD 89 C5         [ 4]  273 	call spi_send_byte 
      008A52 81               [ 4]  274 	ret 
                                    275 
                                    276 ;--------------------------
                                    277 ; write data to spi RAM 
                                    278 ; input:
                                    279 ;   farptr  address 
                                    280 ;   x       count 0=65536
                                    281 ;   y       buffer 
                                    282 ;----------------------------
      008A53                        283 spi_ram_write:
      008A53 88               [ 1]  284 	push a 
      008A54 A6 00            [ 1]  285 	ld a,#SPI_CS_RAM 
      008A56 CD 89 F5         [ 4]  286 	call spi_select_channel
      008A59 A6 02            [ 1]  287 	ld a,#SPI_RAM_WRITE
      008A5B CD 89 C5         [ 4]  288 	call spi_send_byte
      008A5E CD 8A 43         [ 4]  289 	call spi_send_addr 
      008A61 90 F6            [ 1]  290 1$:	ld a,(y)
      008A63 90 5C            [ 1]  291 	incw y 
      008A65 CD 89 C5         [ 4]  292 	call spi_send_byte
      008A68 5A               [ 2]  293 	decw x 
      008A69 26 F6            [ 1]  294 	jrne 1$ 
      008A6B A6 00            [ 1]  295 	ld a,#SPI_CS_RAM 
      008A6D CD 8A 05         [ 4]  296 	call spi_deselect_channel
      008A70 84               [ 1]  297 	pop a 
      008A71 81               [ 4]  298 	ret 
                                    299 
                                    300 ;-------------------------------
                                    301 ; read bytes from SPI RAM 
                                    302 ; input:
                                    303 ;   farptr   address 
                                    304 ;   X        count 
                                    305 ;   Y        buffer 
                                    306 ;-------------------------------
      008A72                        307 spi_ram_read:
      008A72 88               [ 1]  308 	push a 
      008A73 A6 00            [ 1]  309 	ld a,#SPI_CS_RAM 
      008A75 CD 89 F5         [ 4]  310 	call spi_select_channel
      008A78 A6 03            [ 1]  311 	ld a,#SPI_RAM_READ
      008A7A CD 89 C5         [ 4]  312 	call spi_send_byte
      008A7D CD 8A 43         [ 4]  313 	call spi_send_addr 
      008A80 CD 89 DB         [ 4]  314 1$:	call spi_rcv_byte 
      008A83 90 F7            [ 1]  315 	ld (y),a 
      008A85 90 5C            [ 1]  316 	incw y 
      008A87 5A               [ 2]  317 	decw x 
      008A88 26 F6            [ 1]  318 	jrne 1$ 
      008A8A A6 00            [ 1]  319 	ld a,#SPI_CS_RAM 
      008A8C CD 8A 05         [ 4]  320 	call spi_deselect_channel
      008A8F 84               [ 1]  321 	pop a 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 90.
Hexadecimal [24-Bits]



      008A90 81               [ 4]  322 	ret 
                                    323 
                                    324 ;---------------------
                                    325 ; enable write to eeprom 
                                    326 ;----------------------
      008A91                        327 eeprom_enable_write:
      008A91 A6 01            [ 1]  328 	ld a,#SPI_CS_EEPROM 
      008A93 CD 89 F5         [ 4]  329 	call spi_select_channel 
      008A96 A6 06            [ 1]  330 	ld a,#WR_EN 
      008A98 CD 89 C5         [ 4]  331 	call spi_send_byte 
      008A9B A6 01            [ 1]  332 	ld a,#SPI_CS_EEPROM 
      008A9D CD 8A 05         [ 4]  333 	call spi_deselect_channel 
      008AA0 81               [ 4]  334 	ret 
                                    335 
                                    336 ;----------------------------
                                    337 ;  read eeprom status register 
                                    338 ;----------------------------
      008AA1                        339 eeprom_read_status:
      008AA1 A6 01            [ 1]  340 	ld a,#SPI_CS_EEPROM 	
      008AA3 CD 89 F5         [ 4]  341 	call spi_select_channel 
      008AA6 A6 05            [ 1]  342 	ld a,#RD_STATUS 
      008AA8 CD 89 C5         [ 4]  343 	call spi_send_byte
      008AAB CD 89 DB         [ 4]  344 	call spi_rcv_byte 
      008AAE 88               [ 1]  345 	push a  
      008AAF A6 01            [ 1]  346 	ld a,#SPI_CS_EEPROM 
      008AB1 CD 8A 05         [ 4]  347 	call spi_deselect_channel
      008AB4 84               [ 1]  348 	pop a		
      008AB5 81               [ 4]  349 	ret
                                    350 
                                    351 ;----------------------------
                                    352 ; write data to 25LC1024
                                    353 ; page 
                                    354 ; input:
                                    355 ;   farptr  address 
                                    356 ;   A       byte count, 0 -> 256 
                                    357 ;   X       buffer address 
                                    358 ; output:
                                    359 ;   none 
                                    360 ;----------------------------
                           000001   361 	BUF_ADR=1 
                           000003   362 	COUNT=BUF_ADR+2
                           000003   363 	VSIZE=COUNT 
      008AB6                        364 eeprom_write:
      008AB6 88               [ 1]  365 	push a 
      008AB7 89               [ 2]  366 	pushw x 
      008AB8 CD 8A 91         [ 4]  367 	call eeprom_enable_write
      008ABB A6 01            [ 1]  368 	ld a,#SPI_CS_EEPROM 
      008ABD CD 89 F5         [ 4]  369 	call spi_select_channel 
      008AC0 A6 02            [ 1]  370 	ld a,#SPI_EEPROM_WRITE 
      008AC2 CD 89 C5         [ 4]  371 	call spi_send_byte 
      008AC5 CD 8A 43         [ 4]  372 	call spi_send_addr 
      008AC8 1E 01            [ 2]  373 	ldw x,(BUF_ADR,sp)
      008ACA                        374 1$:
      008ACA F6               [ 1]  375 	ld a,(x)
      008ACB CD 89 C5         [ 4]  376 	call spi_send_byte
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 91.
Hexadecimal [24-Bits]



      008ACE 5C               [ 1]  377 	incw x
      008ACF 0A 03            [ 1]  378 	dec (COUNT,sp) 
      008AD1 26 F7            [ 1]  379 	jrne 1$ 
      008AD3 A6 01            [ 1]  380 6$: ld a,#SPI_CS_EEPROM 
      008AD5 CD 8A 05         [ 4]  381 	call spi_deselect_channel
      008AD8 CD 8A A1         [ 4]  382 7$:	call eeprom_read_status 
      008ADB A5 01            [ 1]  383 	bcp a,#(1<<SR_WIP_BIT)
      008ADD 26 F9            [ 1]  384 	jrne 7$
      000A5F                        385 	_drop VSIZE
      008ADF 5B 03            [ 2]    1     addw sp,#VSIZE 
      008AE1 81               [ 4]  386 	ret 
                                    387 
                                    388 
                                    389 ;-------------------------- 
                                    390 ; read bytes from flash 
                                    391 ; memory in buffer 
                                    392 ; input:
                                    393 ;   farptr addr in flash 
                                    394 ;   x     count, 0=65536
                                    395 ;   y     buffer addr 
                                    396 ;---------------------------
      008AE2                        397 eeprom_read:
      008AE2 89               [ 2]  398 	pushw x 
      008AE3 A6 01            [ 1]  399 	ld a,#SPI_CS_EEPROM
      008AE5 CD 89 F5         [ 4]  400 	call spi_select_channel
      008AE8 A6 03            [ 1]  401 	ld a,#SPI_EEPROM_READ
      008AEA CD 89 C5         [ 4]  402 	call spi_send_byte
      008AED CD 8A 43         [ 4]  403 	call spi_send_addr  
      008AF0 CD 89 DB         [ 4]  404 1$: call spi_rcv_byte 
      008AF3 90 F7            [ 1]  405 	ld (y),a 
      008AF5 90 5C            [ 1]  406 	incw y 
      008AF7 1E 01            [ 2]  407 	ldw x,(1,sp)
      008AF9 5A               [ 2]  408 	decw x
      008AFA 1F 01            [ 2]  409 	ldw (1,sp),x 
      008AFC 26 F2            [ 1]  410 	jrne 1$ 
      008AFE A6 01            [ 1]  411 9$:	ld a,#SPI_CS_EEPROM 
      008B00 CD 8A 05         [ 4]  412 	call spi_deselect_channel
      000A83                        413 	_drop 2 
      008B03 5B 02            [ 2]    1     addw sp,#2 
      008B05 81               [ 4]  414 	ret 
                                    415 
                                    416 ;--------------------
                                    417 ; return true if 
                                    418 ; page empty 
                                    419 ; input:
                                    420 ;    X   page# 
                                    421 ; output:
                                    422 ;    A   -1 true||0 false 
                                    423 ;    X   not changed 
                                    424 ;-------------------------
      008B06                        425 eeprom_page_empty:
      008B06 89               [ 2]  426 	pushw x 
      008B07 CD 8B 74         [ 4]  427 	call page_addr 
      000A8A                        428 	_straz farptr 
      008B0A B7 11                    1     .byte 0xb7,farptr 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 92.
Hexadecimal [24-Bits]



      000A8C                        429 	_strxz ptr16 
      008B0C BF 12                    1     .byte 0xbf,ptr16 
      008B0E A6 01            [ 1]  430 	ld a,#SPI_CS_EEPROM 
      008B10 CD 89 F5         [ 4]  431 	call spi_select_channel
      008B13 A6 03            [ 1]  432 	ld a,#SPI_EEPROM_READ 
      008B15 CD 89 C5         [ 4]  433 	call spi_send_byte 
      008B18 CD 8A 43         [ 4]  434 	call spi_send_addr
      008B1B 4B 00            [ 1]  435 	push #0 
      008B1D CD 89 DB         [ 4]  436 1$:	call spi_rcv_byte 
      008B20 A1 FF            [ 1]  437 	cp a,#0xff 
      008B22 26 08            [ 1]  438 	jrne 8$ 
      008B24 0A 01            [ 1]  439 	dec (1,sp)
      008B26 26 F5            [ 1]  440 	jrne 1$ 
      008B28 03 01            [ 1]  441 	cpl (1,sp) 
      008B2A 20 02            [ 2]  442 	jra 9$
      008B2C 0F 01            [ 1]  443 8$: clr (1,sp) 
      008B2E A6 01            [ 1]  444 9$: ld a,#SPI_CS_EEPROM 
      008B30 CD 8A 05         [ 4]  445 	call spi_deselect_channel
      008B33 84               [ 1]  446 	pop a 
      008B34 85               [ 2]  447 	popw x 
      008B35 81               [ 4]  448 	ret 
                                    449 
                                    450 ;----------------------
                                    451 ; erase 32KB sector 
                                    452 ; input:
                                    453 ;   A    sector number {0..3} 
                                    454 ; output:
                                    455 ;   none 
                                    456 ;----------------------
      008B36                        457 eeprom_erase_sector:
      008B36 CD 8B 74         [ 4]  458 	call page_addr 
      000AB9                        459 	_straz farptr 
      008B39 B7 11                    1     .byte 0xb7,farptr 
      000ABB                        460 	_strxz ptr16 
      008B3B BF 12                    1     .byte 0xbf,ptr16 
      008B3D CD 8A 91         [ 4]  461 	call eeprom_enable_write
      008B40 A6 01            [ 1]  462 	ld a,#SPI_CS_EEPROM 
      008B42 CD 89 F5         [ 4]  463 	call spi_select_channel
      008B45 A6 D8            [ 1]  464 	ld a,#SECT_ERASE
      008B47 CD 89 C5         [ 4]  465 	call spi_send_byte 
      008B4A CD 8A 43         [ 4]  466 	call spi_send_addr 
      008B4D A6 01            [ 1]  467 	ld a,#SPI_CS_EEPROM 
      008B4F CD 8A 05         [ 4]  468 	call spi_deselect_channel
      008B52 CD 8A A1         [ 4]  469 1$:	call eeprom_read_status
      008B55 A5 01            [ 1]  470 	bcp a,#(1<<SR_WIP_BIT)
      008B57 26 F9            [ 1]  471 	jrne 1$
      008B59 81               [ 4]  472 	ret 
                                    473 
                                    474 ;-----------------------------
                                    475 ; erase whole eeprom 
                                    476 ;-----------------------------
      008B5A                        477 eeprom_erase_chip:
      008B5A CD 8A 91         [ 4]  478 	call eeprom_enable_write 
      008B5D A6 01            [ 1]  479 	ld a,#SPI_CS_EEPROM 
      008B5F CD 89 F5         [ 4]  480 	call spi_select_channel
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 93.
Hexadecimal [24-Bits]



      008B62 A6 C7            [ 1]  481 	ld a,#CHIP_ERASE
      008B64 CD 89 C5         [ 4]  482 	call spi_send_byte 
      008B67 A6 01            [ 1]  483 	ld a,#SPI_CS_EEPROM 
      008B69 CD 8A 05         [ 4]  484 	call spi_deselect_channel
      008B6C CD 8A A1         [ 4]  485 1$:	call eeprom_read_status
      008B6F A5 01            [ 1]  486 	bcp a,#(1<<SR_WIP_BIT)
      008B71 26 F9            [ 1]  487 	jrne 1$
      008B73 81               [ 4]  488 	ret 
                                    489 
                                    490 ;---------------------------
                                    491 ; convert page number 
                                    492 ; to address addr=256*page#
                                    493 ; input:
                                    494 ;   X     page {0..511}
                                    495 ; ouput:
                                    496 ;   A:X    address 
                                    497 ;---------------------------
      008B74                        498 page_addr:
      008B74 4F               [ 1]  499 	clr a 
      008B75 02               [ 1]  500 	rlwa x 
      008B76 81               [ 4]  501 	ret 
                                    502 
                                    503 ;----------------------------
                                    504 ; convert address to sector#
                                    505 ; input:
                                    506 ;   farptr   address 
                                    507 ; output:
                                    508 ;   X       page  {0..511}
                                    509 ;----------------------------
      008B77                        510 addr_to_page:
      000AF7                        511 	_ldaz farptr 
      008B77 B6 11                    1     .byte 0xb6,farptr 
      000AF9                        512 	_ldxz ptr16 
      008B79 BE 12                    1     .byte 0xbe,ptr16 
      008B7B 01               [ 1]  513 	rrwa x  
      008B7C 81               [ 4]  514 	ret 
                                    515 
                                    516 ;---- test code -----
                                    517 
                                    518 ; ----- spi FLASH test ---------
                           000000   519 .if 0
                                    520 eeprom_test_msg: .byte 27,'c 
                                    521 .asciz "spi EEPROM test\n"
                                    522 no_empty_msg: .asciz " no empty page "
                                    523 writing_msg: .asciz "\nwriting 128 bytes in page " 
                                    524 reading_msg: .asciz "\nreading back\n" 
                                    525 repeat_msg: .asciz "\nkey to repeat"
                                    526 eeprom_test:
                                    527 	call spi_enable
                                    528 3$:
                                    529 	ldw x,#eeprom_test_msg 
                                    530 	call puts 
                                    531 	ldw x,#writing_msg   
                                    532 	call puts 
                                    533 ; search empty page 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 94.
Hexadecimal [24-Bits]



                                    534 	clrw x
                                    535 7$:	call save_cursor_pos
                                    536 	pushw x 
                                    537 	call print_int 
                                    538 	call restore_cursor_pos 
                                    539 	popw x 
                                    540 	call eeprom_page_empty
                                    541 	tnz a 
                                    542 	jrmi 5$
                                    543 	incw x 
                                    544 	cpw x,#512
                                    545 	jrmi 7$
                                    546 	clr a 
                                    547 	call eeprom_erase_sector
                                    548 	ldw x,#no_empty_msg 
                                    549 	call puts 
                                    550 	call prng
                                    551 	rlwa x 
                                    552 	and a,#1 
                                    553 	rrwa x 
                                    554 5$: pushw x  
                                    555 	call print_int 
                                    556 	call new_line 
                                    557 	popw x 
                                    558 	call page_addr 
                                    559 	_straz farptr 
                                    560 	_strxz ptr16 
                                    561 ; fill tib with 128 random byte 
                                    562 0$:
                                    563 	push #64
                                    564 	ldw y,#tib 
                                    565 1$:
                                    566 	call prng 
                                    567 	ldw (y),x
                                    568 	ld a,xh 
                                    569 	call print_hex
                                    570 	call space  
                                    571 	ld a,xl 
                                    572 	call print_hex 
                                    573 	call space 
                                    574 	addw y,#2 
                                    575 	pop a 
                                    576 	dec a 
                                    577 	jreq 4$
                                    578 	push a 
                                    579 	and a,#7 
                                    580 	jrne 1$ 
                                    581 	call new_line 
                                    582 	jra 1$ 
                                    583 4$:
                                    584 	ld a,#128 
                                    585 	ldw x,#tib 
                                    586 	call eeprom_write
                                    587 ; clear tib
                                    588 	ldw x,#tib 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 95.
Hexadecimal [24-Bits]



                                    589 	ld a,#128 
                                    590 6$:	clr (x)
                                    591 	incw x 
                                    592 	dec a 
                                    593 	jrne 6$
                                    594 ;read back written data 
                                    595 	ldw x,#reading_msg 
                                    596 	call puts 
                                    597 	ldw y,#tib 
                                    598 	ldw x,#128 
                                    599 	call eeprom_read 
                                    600 	push #128 
                                    601 	ldw y,#tib 
                                    602 2$: ld a,(y)
                                    603 	call print_hex 
                                    604 	call space 
                                    605 	incw y
                                    606 	pop a 
                                    607 	dec a
                                    608 	jreq 9$  
                                    609 	push a  
                                    610 	and a,#15 
                                    611 	jrne 2$
                                    612 	call new_line
                                    613 	jra 2$  
                                    614 9$:	
                                    615 	ldw x,#repeat_msg
                                    616 	call puts 
                                    617 	call getc
                                    618 	jp 3$
                                    619 .endif 
                                    620 
                                    621 
                                    622 
                                    623 ;----- spi RAM test 
                           000000   624 .if 0
                                    625 spi_ram_msg: .byte 27,'c  
                                    626  .asciz "SPI RAM test\n"
                                    627 spi_ram_write_msg: .asciz "Writing 128 bytes at "
                                    628 spi_ram_read_msg: .asciz "\nreading data back\n"
                                    629 spi_ram_test:
                                    630 	call spi_enable 
                                    631 	ldw x,#spi_ram_msg 
                                    632 	call puts
                                    633 	ldw x,#spi_ram_write_msg 
                                    634 	call puts  
                                    635 	call prng 
                                    636 	_clrz farptr 
                                    637 	_strxz ptr16 
                                    638 	call print_int
                                    639 	call new_line
                                    640 ; fill tib with random bytes 
                                    641 	push #64
                                    642 	ldw y,#tib 
                                    643 1$:	call prng 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 96.
Hexadecimal [24-Bits]



                                    644 	ldw (y),x 
                                    645 	addw y,#2
                                    646 	pushw x 
                                    647 	pop a 
                                    648 	call print_hex 
                                    649 	call space 
                                    650 	pop a 
                                    651 	call print_hex 
                                    652 	call space  
                                    653 	pop a 
                                    654 	dec a 
                                    655 	jreq 4$
                                    656 	push a 
                                    657 	and a,#7 
                                    658 	jrne 1$ 
                                    659 	call new_line 
                                    660 	jra 1$ 
                                    661 4$:
                                    662 	ldw x,#128 
                                    663 	ldw y,#tib 
                                    664 	call spi_ram_write 
                                    665 	ldw x,#spi_ram_read_msg 
                                    666 	call puts
                                    667 ; clear tib 
                                    668 	ldw x,#128
                                    669 	ldw y,#tib 
                                    670 2$: clr (y)
                                    671 	incw y 
                                    672 	decw x 
                                    673 	jrne 2$
                                    674 	ldw y,#tib 
                                    675 	ldw x,#128 
                                    676 	call spi_ram_read 
                                    677 	push #128 
                                    678 	ldw y,#tib
                                    679 ; print read values 
                                    680 3$:	ld a,(y)
                                    681 	incw y 
                                    682 	call print_hex 
                                    683 	call space 
                                    684 	pop a 
                                    685 	dec a 
                                    686 	jreq 5$
                                    687 	push a 
                                    688 	and a,#15
                                    689 	jrne 3$ 
                                    690 	call new_line
                                    691 	jra 3$ 
                                    692 5$:
                                    693 	ldw x,#repeat_msg
                                    694 	call puts 
                                    695 	call getc 
                                    696 	jp spi_ram_test
                                    697 .endif 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 97.
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
                                     19 ;--------------------------------
                                     20 ;  with this version of wozmon 
                                     21 ;  for stm8 I follow exact model 
                                     22 ;  used by Steve Wozniak only 
                                     23 ;  exception is taking advantage 
                                     24 ;  of extension that STM8 bring 
                                     25 ;  over 6502 cpu. 
                                     26 ;--------------------------------
                                     27 
                                     28 
                                     29     .module MONITOR
                                     30 
                                     31     .area CODE
                                     32 
                                     33 ;--------------------------------------------------
                                     34 ; command line interface
                                     35 ; input formats:
                                     36 ;       hex_number  -> display byte at that address 
                                     37 ;       hex_number.hex_number -> display bytes in that range 
                                     38 ;       hex_number: hex_byte [hex_byte]*  -> modify content of RAM or peripheral registers 
                                     39 ;       hex_numberR  -> run machine code a hex_number  address  
                                     40 ;       CTRL_B -> launch pomme BASIC
                                     41 ;----------------------------------------------------
                                     42 ; monitor variables 
                           000028    43 YSAV = APP_VARS_START_ADR 
                           00002A    44 XAMADR = YSAV+2
                           00002C    45 STORADR= XAMADR+2
                           00002E    46 LAST=STORADR+2
                           000030    47 MODE=LAST+2 
                                     48 
                                     49 
                                     50 ; operating modes
                           000000    51 XAM=0
                           00002E    52 XAM_BLOK='.
                           00003A    53 STOR=': 
                                     54 
                                     55 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 98.
Hexadecimal [24-Bits]



                                     56 ; Modeled on Apple I monitor Written by Steve Wozniak 
                                     57 
      008B7D 70 6F 6D 6D 65 20 49    58 mon_str: .asciz "pomme I monitor" 
             20 6D 6F 6E 69 74 6F
             72 00
                                     59 
      008B8D                         60 GO_BASIC: 
      008B8D CC 96 D3         [ 2]   61     jp P1BASIC 
      008B90                         62 WOZMON:: 
      008B90 CD 85 EF         [ 4]   63     call clr_screen
      008B93 AE 8B 7D         [ 2]   64     ldw x,#mon_str
      008B96 CD 85 A3         [ 4]   65     call puts 
      008B99                         66 GETLINE: 
      008B99 A6 0D            [ 1]   67     ld a,#CR 
      008B9B CD 85 2C         [ 4]   68     call putc 
      008B9E A6 23            [ 1]   69     ld a,#'# 
      008BA0 CD 85 2C         [ 4]   70     call putc
      008BA3 90 5F            [ 1]   71     clrw y 
      008BA5 20 09            [ 2]   72     jra NEXTCHAR 
      008BA7                         73 BACKSPACE:
      008BA7 90 5D            [ 2]   74     tnzw y 
      008BA9 27 05            [ 1]   75     jreq NEXTCHAR 
      008BAB CD 85 D9         [ 4]   76     call bksp 
      008BAE 90 5A            [ 2]   77     decw y 
      008BB0                         78 NEXTCHAR:
      008BB0 CD 85 50         [ 4]   79     call getc
      008BB3 A1 08            [ 1]   80     cp a,#BS  
      008BB5 27 F0            [ 1]   81     jreq BACKSPACE 
      008BB7 A1 1B            [ 1]   82     cp a,#ESC 
      008BB9 27 DE            [ 1]   83     jreq GETLINE ; rejected characters cancel input, start over  
      008BBB A1 02            [ 1]   84     cp a,#CTRL_B 
      008BBD 27 CE            [ 1]   85     jreq GO_BASIC 
      008BBF A1 60            [ 1]   86     cp a,#'`
      008BC1 2B 02            [ 1]   87     jrmi UPPER ; already uppercase 
                                     88 ; uppercase character
                                     89 ; all characters from 0x60..0x7f 
                                     90 ; are folded to 0x40..0x5f     
      008BC3 A4 DF            [ 1]   91     and a,#0XDF  
      008BC5                         92 UPPER: ; there is no lower case letter in buffer 
      008BC5 90 D7 16 80      [ 1]   93     ld (tib,y),a 
      008BC9 CD 85 2C         [ 4]   94     call putc
      008BCC A1 0D            [ 1]   95     cp a,#CR 
      008BCE 27 04            [ 1]   96     jreq EOL
      008BD0 90 5C            [ 1]   97     incw y 
      008BD2 20 DC            [ 2]   98     jra NEXTCHAR  
      008BD4                         99 EOL: ; end of line, now analyse input 
      008BD4 90 AE FF FF      [ 2]  100     ldw y,#-1
      008BD8 4F               [ 1]  101     clr a  
      008BD9                        102 SETMODE: 
      000B59                        103     _straz MODE  
      008BD9 B7 30                    1     .byte 0xb7,MODE 
      008BDB                        104 BLSKIP: ; skip blank  
      008BDB 90 5C            [ 1]  105     incw y 
      008BDD                        106 NEXTITEM:
      008BDD 90 D6 16 80      [ 1]  107     ld a,(tib,y)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 99.
Hexadecimal [24-Bits]



      008BE1 A1 0D            [ 1]  108     cp a,#CR ; 
      008BE3 27 B4            [ 1]  109     jreq GETLINE ; end of input line  
      008BE5 A1 2E            [ 1]  110     cp a,#XAM_BLOK
      008BE7 2B F2            [ 1]  111     jrmi BLSKIP 
      008BE9 27 EE            [ 1]  112     jreq SETMODE 
      008BEB A1 3A            [ 1]  113     cp a,#STOR 
      008BED 27 EA            [ 1]  114     jreq SETMODE 
      008BEF A1 52            [ 1]  115     cp a,#'R 
      008BF1 27 44            [ 1]  116     jreq RUN
      000B73                        117     _stryz YSAV ; save for comparison
      008BF3 90 BF 28                 1     .byte 0x90,0xbf,YSAV 
      008BF6 5F               [ 1]  118     clrw x 
      008BF7                        119 NEXTHEX:
      008BF7 90 D6 16 80      [ 1]  120     ld a,(tib,y)
      008BFB A8 30            [ 1]  121     xor a,#0x30 
      008BFD A1 0A            [ 1]  122     cp a,#10 
      008BFF 2B 06            [ 1]  123     jrmi DIG 
      008C01 A1 71            [ 1]  124     cp a,#0x71 
      008C03 2B 10            [ 1]  125     jrmi NOTHEX 
      008C05 A0 67            [ 1]  126     sub a,#0x67
      008C07                        127 DIG: 
      008C07 4B 04            [ 1]  128     push #4
      008C09 4E               [ 1]  129     swap a 
      008C0A                        130 HEXSHIFT:
      008C0A 48               [ 1]  131     sll a 
      008C0B 59               [ 2]  132     rlcw x  
      008C0C 0A 01            [ 1]  133     dec (1,sp)
      008C0E 26 FA            [ 1]  134     jrne HEXSHIFT
      008C10 84               [ 1]  135     pop a 
      008C11 90 5C            [ 1]  136     incw y
      008C13 20 E2            [ 2]  137     jra NEXTHEX
      008C15                        138 NOTHEX:
      008C15 90 B3 28         [ 2]  139     cpw y,YSAV 
      008C18 26 03            [ 1]  140     jrne GOTNUMBER
      008C1A CC 8B 99         [ 2]  141     jp GETLINE ; no hex number  
      008C1D                        142 GOTNUMBER: 
      000B9D                        143     _ldaz MODE 
      008C1D B6 30                    1     .byte 0xb6,MODE 
      008C1F 26 09            [ 1]  144     jrne NOTREAD ; not READ mode  
                                    145 ; set XAM and STOR address 
      000BA1                        146     _strxz XAMADR 
      008C21 BF 2A                    1     .byte 0xbf,XAMADR 
      000BA3                        147     _strxz STORADR 
      008C23 BF 2C                    1     .byte 0xbf,STORADR 
      000BA5                        148     _strxz LAST 
      008C25 BF 2E                    1     .byte 0xbf,LAST 
      008C27 4F               [ 1]  149     clr a 
      008C28 20 16            [ 2]  150     jra NXTPRNT 
      008C2A                        151 NOTREAD:  
                                    152 ; which mode then?        
      008C2A A1 3A            [ 1]  153     cp a,#': 
      008C2C 26 0C            [ 1]  154     jrne XAM_BLOCK
      008C2E 9F               [ 1]  155     ld a,xl 
      000BAF                        156     _ldxz STORADR 
      008C2F BE 2C                    1     .byte 0xbe,STORADR 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 100.
Hexadecimal [24-Bits]



      008C31 F7               [ 1]  157     ld (x),a 
      008C32 5C               [ 1]  158     incw x 
      000BB3                        159     _strxz STORADR 
      008C33 BF 2C                    1     .byte 0xbf,STORADR 
      008C35                        160 TONEXTITEM:
      008C35 20 A6            [ 2]  161     jra NEXTITEM 
      008C37                        162 RUN:
      000BB7                        163     _ldxz XAMADR 
      008C37 BE 2A                    1     .byte 0xbe,XAMADR 
      008C39 FC               [ 2]  164     jp (x)
      008C3A                        165 XAM_BLOCK:
      000BBA                        166     _strxz LAST 
      008C3A BF 2E                    1     .byte 0xbf,LAST 
      000BBC                        167     _ldxz XAMADR
      008C3C BE 2A                    1     .byte 0xbe,XAMADR 
      008C3E 5C               [ 1]  168     incw x 
      008C3F 9F               [ 1]  169     ld a,xl
      008C40                        170 NXTPRNT:
      008C40 26 12            [ 1]  171     jrne PRDATA 
      008C42 A6 0D            [ 1]  172     ld a,#CR 
      008C44 CD 85 2C         [ 4]  173     call putc 
      008C47 9E               [ 1]  174     ld a,xh 
      008C48 CD 8C 69         [ 4]  175     call PRBYTE 
      008C4B 9F               [ 1]  176     ld a,xl 
      008C4C CD 8C 69         [ 4]  177     call PRBYTE 
      008C4F A6 3A            [ 1]  178     ld a,#': 
      008C51 CD 85 2C         [ 4]  179     call putc 
      008C54                        180 PRDATA:
      008C54 A6 20            [ 1]  181     ld a,#SPACE 
      008C56 CD 85 2C         [ 4]  182     call putc
      008C59 F6               [ 1]  183     ld a,(x)
      008C5A CD 8C 69         [ 4]  184     call PRBYTE
      008C5D 5C               [ 1]  185     incw x
      008C5E 27 D5            [ 1]  186     jreq TONEXTITEM ; rollover 
      008C60                        187 XAMNEXT:
      008C60 B3 2E            [ 2]  188     cpw x,LAST 
      008C62 22 D1            [ 1]  189     jrugt TONEXTITEM
      008C64                        190 MOD8CHK:
      008C64 9F               [ 1]  191     ld a,xl 
      008C65 A4 07            [ 1]  192     and a,#7 
      008C67 20 D7            [ 2]  193     jra NXTPRNT
      008C69                        194 PRBYTE:
      008C69 CD 88 1C         [ 4]  195     call print_hex
      008C6C 81               [ 4]  196     ret 
      008C6D                        197 ECHO:
      008C6D CD 85 2C         [ 4]  198     call putc 
      008C70 81               [ 4]  199     RET 
                                    200 
                                    201 ;----------------------------
                                    202 ; code to test 'R' command 
                                    203 ; blink LED on NUCLEO board 
                                    204 ;----------------------------
                           000000   205 .if 0
                                    206 r_test:
                                    207     bset PC_DDR,#5
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 101.
Hexadecimal [24-Bits]



                                    208     bset PC_CR1,#5
                                    209 1$: bcpl PC_ODR,#5 
                                    210 ; delay 
                                    211     ld a,#4
                                    212     clrw x
                                    213 2$:
                                    214     decw x 
                                    215     jrne 2$
                                    216     dec a 
                                    217     jrne 2$ 
                                    218 ; if key exit 
                                    219     btjf UART_SR,#UART_SR_RXNE,1$
                                    220     ld a,UART_DR 
                                    221 ; reset MCU to ensure monitor
                                    222 ; with peripherals in known state
                                    223     _swreset
                                    224 
                                    225 ;------------------------------------
                                    226 ; another program to test 'R' command
                                    227 ; print ASCII characters to terminal
                                    228 ; in loop 
                                    229 ;-------------------------------------
                                    230 ascii:
                                    231     ld a,#SPACE
                                    232 1$:
                                    233     call putc 
                                    234     inc a 
                                    235     cp a,#127 
                                    236     jrmi 1$
                                    237     ld a,#CR 
                                    238     call putc 
                                    239 ; if key exit 
                                    240     btjf UART_SR,#UART_SR_RXNE,ascii
                                    241     ld a,UART_DR 
                                    242 ; reset MCU to ensure monitor
                                    243 ; with peripherals in known state
                                    244     _swreset
                                    245 
                                    246 .endif 
                                    247 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 102.
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
                           000000    19 .if SEPARATE 
                                     20     .module PROC_TABLE 
                                     21     .include "config.inc"
                                     22 
                                     23     .area CODE 
                                     24 .endif 
                                     25 
                                     26 
                                     27 
                                     28 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     29 ;;  table of code routines 
                                     30 ;; used by virtual machine 
                                     31 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     32 
                                     33 	.macro _code_entry proc_address,token_name    
                                     34 	.word proc_address
                                     35 	token_name =TOK_IDX 
                                     36 	TOK_IDX=TOK_IDX+1 
                                     37 	.endm 
                                     38 
                           000000    39 	TOK_IDX=0
      008C71                         40 code_addr:
                                     41 ; command end marker  
      000BF1                         42 	_code_entry next_line, EOL_IDX  ; $0 
      008C71 97 78                    1 	.word next_line
                           000000     2 	EOL_IDX =TOK_IDX 
                           000001     3 	TOK_IDX=TOK_IDX+1 
      000BF3                         43 	_code_entry do_nothing, COLON_IDX   ; $1 ':'
      008C73 97 60                    1 	.word do_nothing
                           000001     2 	COLON_IDX =TOK_IDX 
                           000002     3 	TOK_IDX=TOK_IDX+1 
                           000001    44     CMD_END = TOK_IDX-1 
                                     45 ; caractères délimiteurs 
      000BF5                         46     _code_entry syntax_error, COMMA_IDX ; $2  ',' 
      008C75 95 D3                    1 	.word syntax_error
                           000002     2 	COMMA_IDX =TOK_IDX 
                           000003     3 	TOK_IDX=TOK_IDX+1 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 103.
Hexadecimal [24-Bits]



      000BF7                         47 	_code_entry syntax_error,SCOL_IDX  ; $3 ';' 
      008C77 95 D3                    1 	.word syntax_error
                           000003     2 	SCOL_IDX =TOK_IDX 
                           000004     3 	TOK_IDX=TOK_IDX+1 
      000BF9                         48 	_code_entry syntax_error, LPAREN_IDX ; $4 '(' 
      008C79 95 D3                    1 	.word syntax_error
                           000004     2 	LPAREN_IDX =TOK_IDX 
                           000005     3 	TOK_IDX=TOK_IDX+1 
      000BFB                         49 	_code_entry syntax_error, RPAREN_IDX ; $5 ')' 
      008C7B 95 D3                    1 	.word syntax_error
                           000005     2 	RPAREN_IDX =TOK_IDX 
                           000006     3 	TOK_IDX=TOK_IDX+1 
      000BFD                         50 	_code_entry syntax_error, QUOTE_IDX  ; $6 '"' 
      008C7D 95 D3                    1 	.word syntax_error
                           000006     2 	QUOTE_IDX =TOK_IDX 
                           000007     3 	TOK_IDX=TOK_IDX+1 
                           000006    51     DELIM_LAST=TOK_IDX-1 
                                     52 ; literal values 
      000BFF                         53     _code_entry syntax_error,LITC_IDX ; 8 bit literal 
      008C7F 95 D3                    1 	.word syntax_error
                           000007     2 	LITC_IDX =TOK_IDX 
                           000008     3 	TOK_IDX=TOK_IDX+1 
      000C01                         54     _code_entry syntax_error,LITW_IDX  ; 16 bits literal 
      008C81 95 D3                    1 	.word syntax_error
                           000008     2 	LITW_IDX =TOK_IDX 
                           000009     3 	TOK_IDX=TOK_IDX+1 
                           000008    55     LIT_LAST=TOK_IDX-1 
                                     56 ; variable identifiers  
      000C03                         57 	_code_entry kword_let2,VAR_IDX    ; $9 integer variable  
      008C83 9A 54                    1 	.word kword_let2
                           000009     2 	VAR_IDX =TOK_IDX 
                           00000A     3 	TOK_IDX=TOK_IDX+1 
      000C05                         58 	_code_entry let_string2,STR_VAR_IDX  ; string variable 
      008C85 9A 78                    1 	.word let_string2
                           00000A     2 	STR_VAR_IDX =TOK_IDX 
                           00000B     3 	TOK_IDX=TOK_IDX+1 
                           00000A    59     SYMB_LAST=TOK_IDX-1 
                                     60 ; arithmetic operators      
      000C07                         61 	_code_entry syntax_error, ADD_IDX   ; $D 
      008C87 95 D3                    1 	.word syntax_error
                           00000B     2 	ADD_IDX =TOK_IDX 
                           00000C     3 	TOK_IDX=TOK_IDX+1 
      000C09                         62 	_code_entry syntax_error, SUB_IDX   ; $E
      008C89 95 D3                    1 	.word syntax_error
                           00000C     2 	SUB_IDX =TOK_IDX 
                           00000D     3 	TOK_IDX=TOK_IDX+1 
      000C0B                         63 	_code_entry syntax_error, DIV_IDX   ; $10 
      008C8B 95 D3                    1 	.word syntax_error
                           00000D     2 	DIV_IDX =TOK_IDX 
                           00000E     3 	TOK_IDX=TOK_IDX+1 
      000C0D                         64 	_code_entry syntax_error, MOD_IDX   ; $11
      008C8D 95 D3                    1 	.word syntax_error
                           00000E     2 	MOD_IDX =TOK_IDX 
                           00000F     3 	TOK_IDX=TOK_IDX+1 
      000C0F                         65 	_code_entry syntax_error, MULT_IDX  ; $12 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 104.
Hexadecimal [24-Bits]



      008C8F 95 D3                    1 	.word syntax_error
                           00000F     2 	MULT_IDX =TOK_IDX 
                           000010     3 	TOK_IDX=TOK_IDX+1 
                           00000F    66     OP_ARITHM_LAST=TOK_IDX-1 
                                     67 ; relational operators
      000C11                         68 	_code_entry syntax_error,REL_LE_IDX  ; 
      008C91 95 D3                    1 	.word syntax_error
                           000010     2 	REL_LE_IDX =TOK_IDX 
                           000011     3 	TOK_IDX=TOK_IDX+1 
      000C13                         69 	_code_entry syntax_error,REL_EQU_IDX ; 
      008C93 95 D3                    1 	.word syntax_error
                           000011     2 	REL_EQU_IDX =TOK_IDX 
                           000012     3 	TOK_IDX=TOK_IDX+1 
      000C15                         70 	_code_entry syntax_error,REL_GE_IDX  ;  
      008C95 95 D3                    1 	.word syntax_error
                           000012     2 	REL_GE_IDX =TOK_IDX 
                           000013     3 	TOK_IDX=TOK_IDX+1 
      000C17                         71 	_code_entry syntax_error,REL_LT_IDX  ;  
      008C97 95 D3                    1 	.word syntax_error
                           000013     2 	REL_LT_IDX =TOK_IDX 
                           000014     3 	TOK_IDX=TOK_IDX+1 
      000C19                         72 	_code_entry syntax_error,REL_GT_IDX  ;  
      008C99 95 D3                    1 	.word syntax_error
                           000014     2 	REL_GT_IDX =TOK_IDX 
                           000015     3 	TOK_IDX=TOK_IDX+1 
      000C1B                         73 	_code_entry syntax_error,REL_NE_IDX  ; 
      008C9B 95 D3                    1 	.word syntax_error
                           000015     2 	REL_NE_IDX =TOK_IDX 
                           000016     3 	TOK_IDX=TOK_IDX+1 
                           000015    74     OP_REL_LAST=TOK_IDX-1 
                                     75 ; boolean operators 
      000C1D                         76     _code_entry syntax_error, NOT_IDX    ; $19
      008C9D 95 D3                    1 	.word syntax_error
                           000016     2 	NOT_IDX =TOK_IDX 
                           000017     3 	TOK_IDX=TOK_IDX+1 
      000C1F                         77     _code_entry syntax_error, AND_IDX    ; $1A 
      008C9F 95 D3                    1 	.word syntax_error
                           000017     2 	AND_IDX =TOK_IDX 
                           000018     3 	TOK_IDX=TOK_IDX+1 
      000C21                         78     _code_entry syntax_error, OR_IDX     ; $1B 
      008CA1 95 D3                    1 	.word syntax_error
                           000018     2 	OR_IDX =TOK_IDX 
                           000019     3 	TOK_IDX=TOK_IDX+1 
                           000018    79     BOOL_OP_LAST=TOK_IDX-1 
                                     80 ; keywords 
      000C23                         81     _code_entry kword_dim, DIM_IDX       ; $1F 
      008CA3 9C 73                    1 	.word kword_dim
                           000019     2 	DIM_IDX =TOK_IDX 
                           00001A     3 	TOK_IDX=TOK_IDX+1 
      000C25                         82     _code_entry kword_end, END_IDX       ; $21 
      008CA5 A2 5A                    1 	.word kword_end
                           00001A     2 	END_IDX =TOK_IDX 
                           00001B     3 	TOK_IDX=TOK_IDX+1 
      000C27                         83     _code_entry kword_for, FOR_IDX       ; $22
      008CA7 A1 23                    1 	.word kword_for
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 105.
Hexadecimal [24-Bits]



                           00001B     2 	FOR_IDX =TOK_IDX 
                           00001C     3 	TOK_IDX=TOK_IDX+1 
      000C29                         84     _code_entry kword_next, NEXT_IDX     ; $27 
      008CA9 A1 77                    1 	.word kword_next
                           00001C     2 	NEXT_IDX =TOK_IDX 
                           00001D     3 	TOK_IDX=TOK_IDX+1 
      000C2B                         85     _code_entry kword_gosub, GOSUB_IDX   ; $23 
      008CAB A1 EE                    1 	.word kword_gosub
                           00001D     2 	GOSUB_IDX =TOK_IDX 
                           00001E     3 	TOK_IDX=TOK_IDX+1 
      000C2D                         86     _code_entry kword_return, RET_IDX    ; $2A
      008CAD A2 0E                    1 	.word kword_return
                           00001E     2 	RET_IDX =TOK_IDX 
                           00001F     3 	TOK_IDX=TOK_IDX+1 
      000C2F                         87     _code_entry kword_goto, GOTO_IDX     ; $24 
      008CAF A1 CF                    1 	.word kword_goto
                           00001F     2 	GOTO_IDX =TOK_IDX 
                           000020     3 	TOK_IDX=TOK_IDX+1 
      000C31                         88     _code_entry kword_if, IF_IDX         ; $25 
      008CB1 A0 3F                    1 	.word kword_if
                           000020     2 	IF_IDX =TOK_IDX 
                           000021     3 	TOK_IDX=TOK_IDX+1 
      000C33                         89     _code_entry syntax_error,THEN_IDX 
      008CB3 95 D3                    1 	.word syntax_error
                           000021     2 	THEN_IDX =TOK_IDX 
                           000022     3 	TOK_IDX=TOK_IDX+1 
      000C35                         90     _code_entry kword_let, LET_IDX       ; $26 
      008CB5 9A 43                    1 	.word kword_let
                           000022     2 	LET_IDX =TOK_IDX 
                           000023     3 	TOK_IDX=TOK_IDX+1 
      000C37                         91 	_code_entry kword_remark, REM_IDX    ; $29 
      008CB7 97 6B                    1 	.word kword_remark
                           000023     2 	REM_IDX =TOK_IDX 
                           000024     3 	TOK_IDX=TOK_IDX+1 
      000C39                         92     _code_entry syntax_error, STEP_IDX   ; $2B 
      008CB9 95 D3                    1 	.word syntax_error
                           000024     2 	STEP_IDX =TOK_IDX 
                           000025     3 	TOK_IDX=TOK_IDX+1 
      000C3B                         93     _code_entry kword_stop, STOP_IDX     ; $2C
      008CBB A2 84                    1 	.word kword_stop
                           000025     2 	STOP_IDX =TOK_IDX 
                           000026     3 	TOK_IDX=TOK_IDX+1 
      000C3D                         94     _code_entry kword_con, CON_IDX 
      008CBD A2 CF                    1 	.word kword_con
                           000026     2 	CON_IDX =TOK_IDX 
                           000027     3 	TOK_IDX=TOK_IDX+1 
      000C3F                         95     _code_entry syntax_error, TO_IDX     ; $2D
      008CBF 95 D3                    1 	.word syntax_error
                           000027     2 	TO_IDX =TOK_IDX 
                           000028     3 	TOK_IDX=TOK_IDX+1 
                           000027    96     KWORD_LAST=TOK_IDX-1 
                                     97 ; functions
      000C41                         98 	_code_entry func_abs, ABS_IDX         ; $41
      008CC1 A4 83                    1 	.word func_abs
                           000028     2 	ABS_IDX =TOK_IDX 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 106.
Hexadecimal [24-Bits]



                           000029     3 	TOK_IDX=TOK_IDX+1 
      000C43                         99     _code_entry func_peek, PEEK_IDX         ; $4D 
      008CC3 A0 30                    1 	.word func_peek
                           000029     2 	PEEK_IDX =TOK_IDX 
                           00002A     3 	TOK_IDX=TOK_IDX+1 
      000C45                        100     _code_entry func_random, RND_IDX        ; $50
      008CC5 A4 93                    1 	.word func_random
                           00002A     2 	RND_IDX =TOK_IDX 
                           00002B     3 	TOK_IDX=TOK_IDX+1 
      000C47                        101     _code_entry func_sign, SGN_IDX 
      008CC7 A4 B4                    1 	.word func_sign
                           00002B     2 	SGN_IDX =TOK_IDX 
                           00002C     3 	TOK_IDX=TOK_IDX+1 
      000C49                        102     _code_entry func_len, LEN_IDX  
      008CC9 A4 CE                    1 	.word func_len
                           00002C     2 	LEN_IDX =TOK_IDX 
                           00002D     3 	TOK_IDX=TOK_IDX+1 
      000C4B                        103     _code_entry func_ticks, TICKS_IDX 
      008CCB A4 6D                    1 	.word func_ticks
                           00002D     2 	TICKS_IDX =TOK_IDX 
                           00002E     3 	TOK_IDX=TOK_IDX+1 
      000C4D                        104     _code_entry func_char, CHAR_IDX
      008CCD A4 70                    1 	.word func_char
                           00002E     2 	CHAR_IDX =TOK_IDX 
                           00002F     3 	TOK_IDX=TOK_IDX+1 
      000C4F                        105     _code_entry func_key, KEY_IDX  
      008CCF A0 11                    1 	.word func_key
                           00002F     2 	KEY_IDX =TOK_IDX 
                           000030     3 	TOK_IDX=TOK_IDX+1 
                           00002F   106     FUNC_LAST=TOK_IDX-1                     
                                    107 ; commands 
      000C51                        108     _code_entry cmd_sleep,SLEEP_IDX 
      008CD1 A4 5A                    1 	.word cmd_sleep
                           000030     2 	SLEEP_IDX =TOK_IDX 
                           000031     3 	TOK_IDX=TOK_IDX+1 
      000C53                        109     _code_entry cmd_tone,TONE_IDX 
      008CD3 A2 66                    1 	.word cmd_tone
                           000031     2 	TONE_IDX =TOK_IDX 
                           000032     3 	TOK_IDX=TOK_IDX+1 
      000C55                        110     _code_entry cmd_tab, TAB_IDX 
      008CD5 A5 DF                    1 	.word cmd_tab
                           000032     2 	TAB_IDX =TOK_IDX 
                           000033     3 	TOK_IDX=TOK_IDX+1 
      000C57                        111     _code_entry cmd_auto, AUTO_IDX 
      008CD7 A6 0B                    1 	.word cmd_auto
                           000033     2 	AUTO_IDX =TOK_IDX 
                           000034     3 	TOK_IDX=TOK_IDX+1 
      000C59                        112     _code_entry cmd_himem, HIMEM_IDX 
      008CD9 A6 C4                    1 	.word cmd_himem
                           000034     2 	HIMEM_IDX =TOK_IDX 
                           000035     3 	TOK_IDX=TOK_IDX+1 
      000C5B                        113     _code_entry cmd_lomem, LOMEM_IDX 
      008CDB A6 E5                    1 	.word cmd_lomem
                           000035     2 	LOMEM_IDX =TOK_IDX 
                           000036     3 	TOK_IDX=TOK_IDX+1 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 107.
Hexadecimal [24-Bits]



      000C5D                        114     _code_entry cmd_del, DEL_IDX 
      008CDD A6 53                    1 	.word cmd_del
                           000036     2 	DEL_IDX =TOK_IDX 
                           000037     3 	TOK_IDX=TOK_IDX+1 
      000C5F                        115     _code_entry cmd_clear, CLR_IDX 
      008CDF A6 44                    1 	.word cmd_clear
                           000037     2 	CLR_IDX =TOK_IDX 
                           000038     3 	TOK_IDX=TOK_IDX+1 
      000C61                        116     _code_entry cmd_input, INPUT_IDX    ; $6F
      008CE1 9F 80                    1 	.word cmd_input
                           000038     2 	INPUT_IDX =TOK_IDX 
                           000039     3 	TOK_IDX=TOK_IDX+1 
      000C63                        117     _code_entry cmd_list, LIST_IDX          ; $72
      008CE3 9D 9B                    1 	.word cmd_list
                           000039     2 	LIST_IDX =TOK_IDX 
                           00003A     3 	TOK_IDX=TOK_IDX+1 
      000C65                        118     _code_entry cmd_new, NEW_IDX            ; $73
      008CE5 A2 E7                    1 	.word cmd_new
                           00003A     2 	NEW_IDX =TOK_IDX 
                           00003B     3 	TOK_IDX=TOK_IDX+1 
      000C67                        119     _code_entry cmd_call, CALL_IDX          
      008CE7 A5 EA                    1 	.word cmd_call
                           00003B     2 	CALL_IDX =TOK_IDX 
                           00003C     3 	TOK_IDX=TOK_IDX+1 
      000C69                        120     _code_entry cmd_poke, POKE_IDX          ; $76
      008CE9 A0 1C                    1 	.word cmd_poke
                           00003C     2 	POKE_IDX =TOK_IDX 
                           00003D     3 	TOK_IDX=TOK_IDX+1 
      000C6B                        121    	_code_entry cmd_print, PRINT_IDX        ; $77
      008CEB 9E 63                    1 	.word cmd_print
                           00003D     2 	PRINT_IDX =TOK_IDX 
                           00003E     3 	TOK_IDX=TOK_IDX+1 
      000C6D                        122     _code_entry cmd_run, RUN_IDX            ; $7A
      008CED A2 27                    1 	.word cmd_run
                           00003E     2 	RUN_IDX =TOK_IDX 
                           00003F     3 	TOK_IDX=TOK_IDX+1 
      000C6F                        123     _code_entry cmd_words, WORDS_IDX        ; $85
      008CEF A5 03                    1 	.word cmd_words
                           00003F     2 	WORDS_IDX =TOK_IDX 
                           000040     3 	TOK_IDX=TOK_IDX+1 
      000C71                        124     _code_entry cmd_bye, BYE_IDX 
      008CF1 A4 49                    1 	.word cmd_bye
                           000040     2 	BYE_IDX =TOK_IDX 
                           000041     3 	TOK_IDX=TOK_IDX+1 
      000C73                        125     _code_entry cmd_save, SAVE_IDX 
      008CF3 A3 33                    1 	.word cmd_save
                           000041     2 	SAVE_IDX =TOK_IDX 
                           000042     3 	TOK_IDX=TOK_IDX+1 
      000C75                        126     _code_entry cmd_load,LOAD_IDX 
      008CF5 A3 A4                    1 	.word cmd_load
                           000042     2 	LOAD_IDX =TOK_IDX 
                           000043     3 	TOK_IDX=TOK_IDX+1 
      000C77                        127     _code_entry cmd_dir, DIR_IDX 
      008CF7 A3 E3                    1 	.word cmd_dir
                           000043     2 	DIR_IDX =TOK_IDX 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 108.
Hexadecimal [24-Bits]



                           000044     3 	TOK_IDX=TOK_IDX+1 
      000C79                        128     _code_entry cmd_erase, ERASE_IDX 
      008CF9 A2 F2                    1 	.word cmd_erase
                           000044     2 	ERASE_IDX =TOK_IDX 
                           000045     3 	TOK_IDX=TOK_IDX+1 
                           000044   129     CMD_LAST=TOK_IDX-1
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 109.
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
                                     19 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     20 ;;   compile BASIC source code to byte code
                                     21 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     22 
                                     23 	.area CODE 
                                     24 
                                     25 ;-------------------------------------
                                     26 ; search text area for a line#
                                     27 ; input:
                                     28 ;   A           0 search from lomem  
                                     29 ;			    1 search from line.addr 
                                     30 ;	X 			line# to search 
                                     31 ; output:
                                     32 ;   A           0 not found | other found 
                                     33 ;   X 			addr of line | 
                                     34 ;				inssert address if not found  
                                     35 ; use: 
                                     36 ;   Y  
                                     37 ;-------------------------------------
                           000001    38 	LL=1 ; line length 
                           000002    39 	LB=2 ; line length low byte 
                           000002    40 	VSIZE=2 
      008CFB                         41 search_lineno::
      008CFB 90 89            [ 2]   42 	pushw y 
      000C7D                         43 	_vars VSIZE
      008CFD 52 02            [ 2]    1     sub sp,#VSIZE 
      008CFF 0F 01            [ 1]   44 	clr (LL,sp)
      008D01 90 CE 00 2F      [ 2]   45 	ldw y,lomem
      008D05 4D               [ 1]   46 	tnz a 
      008D06 27 04            [ 1]   47 	jreq 2$
      008D08 90 CE 00 2B      [ 2]   48 	ldw y,line.addr  
      008D0C                         49 2$: 
      008D0C 90 C3 00 33      [ 2]   50 	cpw y,progend 
      008D10 2A 10            [ 1]   51 	jrpl 8$ 
      008D12 90 F3            [ 1]   52 	cpw x,(y)
      008D14 27 0F            [ 1]   53 	jreq 9$
      008D16 2B 0A            [ 1]   54 	jrmi 8$ 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 110.
Hexadecimal [24-Bits]



      008D18 90 E6 02         [ 1]   55 	ld a,(2,y)
      008D1B 6B 02            [ 1]   56 	ld (LB,sp),a 
      008D1D 72 F9 01         [ 2]   57 	addw y,(LL,sp)
      008D20 20 EA            [ 2]   58 	jra 2$ 
      008D22                         59 8$: ; not found 
      008D22 4F               [ 1]   60 	clr a 
      008D23 20 02            [ 2]   61 	jra 10$
      008D25                         62 9$: ; found 
      008D25 A6 FF            [ 1]   63 	ld a,#-1 
      008D27                         64 10$:
      008D27 93               [ 1]   65 	ldw x,y   
      000CA8                         66 	_drop VSIZE
      008D28 5B 02            [ 2]    1     addw sp,#VSIZE 
      008D2A 90 85            [ 2]   67 	popw y 
      008D2C 81               [ 4]   68 	ret 
                                     69 
                                     70 
                                     71 ;-------------------------------------
                                     72 ; delete line at addr
                                     73 ; input:
                                     74 ;   X 		addr of line i.e DEST for move 
                                     75 ;-------------------------------------
                           000001    76 	LLEN=1
                           000003    77 	SRC=3
                           000004    78 	VSIZE=4
      008D2D                         79 del_line: 
      008D2D 90 89            [ 2]   80 	pushw y 
      000CAF                         81 	_vars VSIZE 
      008D2F 52 04            [ 2]    1     sub sp,#VSIZE 
      008D31 E6 02            [ 1]   82 	ld a,(2,x) ; line length
      008D33 6B 02            [ 1]   83 	ld (LLEN+1,sp),a 
      008D35 0F 01            [ 1]   84 	clr (LLEN,sp)
      008D37 90 93            [ 1]   85 	ldw y,x  
      008D39 72 F9 01         [ 2]   86 	addw y,(LLEN,sp) ;SRC  
      008D3C 17 03            [ 2]   87 	ldw (SRC,sp),y  ;save source 
      008D3E 90 CE 00 33      [ 2]   88 	ldw y,progend 
      008D42 72 F2 03         [ 2]   89 	subw y,(SRC,sp) ; y=count 
      008D45 90 CF 00 18      [ 2]   90 	ldw acc16,y 
      008D49 16 03            [ 2]   91 	ldw y,(SRC,sp)    ; source
      008D4B CD 88 B0         [ 4]   92 	call move
      008D4E 90 CE 00 33      [ 2]   93 	ldw y,progend  
      008D52 72 F2 01         [ 2]   94 	subw y,(LLEN,sp)
      008D55 90 CF 00 33      [ 2]   95 	ldw progend,y
      008D59 90 CF 00 35      [ 2]   96 	ldw dvar_bgn,y 
      008D5D 90 CF 00 37      [ 2]   97 	ldw dvar_end,y   
      000CE1                         98 	_drop VSIZE     
      008D61 5B 04            [ 2]    1     addw sp,#VSIZE 
      008D63 90 85            [ 2]   99 	popw y 
      008D65 81               [ 4]  100 	ret 
                                    101 
                                    102 ;---------------------------------------------
                                    103 ; open a gap in text area to 
                                    104 ; move new line in this gap
                                    105 ; input:
                                    106 ;    X 			addr gap start 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 111.
Hexadecimal [24-Bits]



                                    107 ;    Y 			gap length 
                                    108 ; output:
                                    109 ;    X 			addr gap start 
                                    110 ;--------------------------------------------
                           000001   111 	DEST=1
                           000003   112 	SRC=3
                           000005   113 	LEN=5
                           000006   114 	VSIZE=6 
      008D66                        115 open_gap:
      008D66 C3 00 33         [ 2]  116 	cpw x,progend 
      008D69 24 2F            [ 1]  117 	jruge 9$
      000CEB                        118 	_vars VSIZE
      008D6B 52 06            [ 2]    1     sub sp,#VSIZE 
      008D6D 1F 03            [ 2]  119 	ldw (SRC,sp),x 
      008D6F 17 05            [ 2]  120 	ldw (LEN,sp),y 
      008D71 90 CF 00 18      [ 2]  121 	ldw acc16,y 
      008D75 90 93            [ 1]  122 	ldw y,x ; SRC
      008D77 72 BB 00 18      [ 2]  123 	addw x,acc16  
      008D7B 1F 01            [ 2]  124 	ldw (DEST,sp),x 
                                    125 ;compute size to move 	
      000CFD                        126 	_ldxz progend  
      008D7D BE 33                    1     .byte 0xbe,progend 
      008D7F 72 F0 03         [ 2]  127 	subw x,(SRC,sp)
      008D82 CF 00 18         [ 2]  128 	ldw acc16,x ; size to move
      008D85 1E 01            [ 2]  129 	ldw x,(DEST,sp) 
      008D87 CD 88 B0         [ 4]  130 	call move
      000D0A                        131 	_ldxz progend 
      008D8A BE 33                    1     .byte 0xbe,progend 
      008D8C 72 FB 05         [ 2]  132 	addw x,(LEN,sp)
      008D8F CF 00 33         [ 2]  133 	ldw progend,x
      008D92 CF 00 35         [ 2]  134 	ldw dvar_bgn,x 
      008D95 CF 00 37         [ 2]  135 	ldw dvar_end,x 
      000D18                        136 	_drop VSIZE
      008D98 5B 06            [ 2]    1     addw sp,#VSIZE 
      008D9A 81               [ 4]  137 9$:	ret 
                                    138 
                                    139 ;--------------------------------------------
                                    140 ; insert line in pad into program area 
                                    141 ; first search for already existing 
                                    142 ; replace existing 
                                    143 ; if new line empty delete existing one. 
                                    144 ; input:
                                    145 ;   ptr16		pointer to tokenized line  
                                    146 ; output:
                                    147 ;   none
                                    148 ;---------------------------------------------
                           000001   149 	DEST=1  ; text area insertion address 
                           000003   150 	SRC=3   ; str to insert address 
                           000005   151 	LINENO=5 ; line number 
                           000007   152 	LLEN=7 ; line length 
                           000008   153 	VSIZE=8  
      008D9B                        154 insert_line:
      008D9B 90 89            [ 2]  155 	pushw y 
      000D1D                        156 	_vars VSIZE 
      008D9D 52 08            [ 2]    1     sub sp,#VSIZE 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 112.
Hexadecimal [24-Bits]



      008D9F 72 CE 00 12      [ 5]  157 	ldw x,[ptr16]
      008DA3 1F 05            [ 2]  158 	ldw (LINENO,sp),x 
      008DA5 0F 07            [ 1]  159 	clr (LLEN,sp)
      000D27                        160 	_ldxz ptr16 
      008DA7 BE 12                    1     .byte 0xbe,ptr16 
      008DA9 E6 02            [ 1]  161 	ld a,(2,x)
      008DAB 6B 08            [ 1]  162 	ld (LLEN+1,sp),a 
      008DAD 4F               [ 1]  163 	clr a 
      008DAE 1E 05            [ 2]  164 	ldw x,(LINENO,sp)
      008DB0 CD 8C FB         [ 4]  165 	call search_lineno
      008DB3 1F 01            [ 2]  166 	ldw (DEST,sp),x 
      008DB5 4D               [ 1]  167 	tnz a 
      008DB6 27 03            [ 1]  168 	jreq 1$ ; not found 
      008DB8 CD 8D 2D         [ 4]  169 	call del_line 
      008DBB A6 04            [ 1]  170 1$: ld a,#4 
      008DBD 11 08            [ 1]  171 	cp a,(LLEN+1,sp)
      008DBF 27 3D            [ 1]  172 	jreq 9$
                                    173 ; check for space 
      000D41                        174 	_ldxz progend  
      008DC1 BE 33                    1     .byte 0xbe,progend 
      008DC3 72 FB 07         [ 2]  175 	addw x,(LLEN,sp)
      008DC6 A3 16 80         [ 2]  176 	cpw x,#tib   
      008DC9 25 08            [ 1]  177 	jrult 3$
      008DCB AE 95 54         [ 2]  178 	ldw x,#err_mem_full 
      008DCE CC 95 D5         [ 2]  179 	jp tb_error 
      008DD1 20 2B            [ 2]  180 	jra 9$  
      008DD3                        181 3$: ; create gap to insert line 
      008DD3 1E 01            [ 2]  182 	ldw x,(DEST,sp) 
      008DD5 16 07            [ 2]  183 	ldw y,(LLEN,sp)
      008DD7 CD 8D 66         [ 4]  184 	call open_gap 
                                    185 ; move new line in gap 
      008DDA 1E 07            [ 2]  186 	ldw x,(LLEN,sp)
      008DDC CF 00 18         [ 2]  187 	ldw acc16,x 
      008DDF 90 AE 17 00      [ 2]  188 	ldw y,#pad ;SRC 
      008DE3 1E 01            [ 2]  189 	ldw x,(DEST,sp) ; dest address 
      008DE5 CD 88 B0         [ 4]  190 	call move
      008DE8 1E 01            [ 2]  191 	ldw x,(DEST,sp)
      008DEA C3 00 33         [ 2]  192 	cpw x,progend 
      008DED 25 0F            [ 1]  193 	jrult 9$ 
      008DEF 1E 07            [ 2]  194 	ldw x,(LLEN,sp)
      008DF1 72 BB 00 33      [ 2]  195 	addw x,progend 
      008DF5 CF 00 33         [ 2]  196 	ldw progend,x 
      008DF8 CF 00 35         [ 2]  197 	ldw dvar_bgn,x 
      008DFB CF 00 37         [ 2]  198 	ldw dvar_end,x 
      008DFE                        199 9$:	
      000D7E                        200 	_drop VSIZE
      008DFE 5B 08            [ 2]    1     addw sp,#VSIZE 
      008E00 90 85            [ 2]  201 	popw y 
      008E02 81               [ 4]  202 	ret
                                    203 
                                    204 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    205 ;; compiler routines        ;;
                                    206 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    207 ;------------------------------------
                                    208 ; parse quoted string 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 113.
Hexadecimal [24-Bits]



                                    209 ; input:
                                    210 ;   Y 	pointer to tib 
                                    211 ;   X   pointer to output buffer 
                                    212 ; output:
                                    213 ;	buffer   parsed string
                                    214 ;------------------------------------
                           000001   215 	PREV = 1
                           000002   216 	CURR =2
                           000002   217 	VSIZE=2
      008E03                        218 parse_quote: 
      000D83                        219 	_vars VSIZE
      008E03 52 02            [ 2]    1     sub sp,#VSIZE 
      000D85                        220 	_push_op  
      000D85                          1     _decz psp+1
      008E05 3A 43                    1     .byte 0x3a,psp+1 
      008E07 72 C7 00 42      [ 4]    2     ld [psp],a 
      008E0B 4F               [ 1]  221 	clr a
      008E0C 6B 01            [ 1]  222 1$:	ld (PREV,sp),a 
      008E0E                        223 2$:	
      008E0E 91 D6 28         [ 4]  224 	ld a,([in.w],y)
      008E11 27 28            [ 1]  225 	jreq 6$
      000D93                        226 	_incz in 
      008E13 3C 29                    1     .byte 0x3c, in 
      008E15 6B 02            [ 1]  227 	ld (CURR,sp),a 
      008E17 A6 5C            [ 1]  228 	ld a,#'\
      008E19 11 01            [ 1]  229 	cp a, (PREV,sp)
      008E1B 26 0A            [ 1]  230 	jrne 3$
      008E1D 0F 01            [ 1]  231 	clr (PREV,sp)
      008E1F 7B 02            [ 1]  232 	ld a,(CURR,sp)
      008E21 AD 22            [ 4]  233 	callr convert_escape
      008E23 F7               [ 1]  234 	ld (x),a 
      008E24 5C               [ 1]  235 	incw x 
      008E25 20 E7            [ 2]  236 	jra 2$
      008E27                        237 3$:
      008E27 7B 02            [ 1]  238 	ld a,(CURR,sp)
      008E29 A1 5C            [ 1]  239 	cp a,#'\'
      008E2B 27 DF            [ 1]  240 	jreq 1$
      008E2D A1 22            [ 1]  241 	cp a,#'"
      008E2F 27 04            [ 1]  242 	jreq 5$ 
      008E31 F7               [ 1]  243 	ld (x),a 
      008E32 5C               [ 1]  244 	incw x 
      008E33 20 D9            [ 2]  245 	jra 2$
      000DB5                        246 5$: _pop_op 	
      008E35 72 C6 00 42      [ 4]    1     ld a,[psp]
      000DB9                          2     _incz psp+1 
      008E39 3C 43                    1     .byte 0x3c, psp+1 
      008E3B                        247 6$: 
      008E3B 7F               [ 1]  248 	clr (x)
      008E3C 5C               [ 1]  249 	incw x 
      008E3D 90 93            [ 1]  250 	ldw y,x 
      008E3F 5F               [ 1]  251 	clrw x 
      008E40 A6 06            [ 1]  252 	ld a,#QUOTE_IDX  
      000DC2                        253 	_drop VSIZE
      008E42 5B 02            [ 2]    1     addw sp,#VSIZE 
      008E44 81               [ 4]  254 	ret 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 114.
Hexadecimal [24-Bits]



                                    255 
                                    256 ;---------------------------------------
                                    257 ; called by parse_quote
                                    258 ; subtitute escaped character 
                                    259 ; by their ASCII value .
                                    260 ; input:
                                    261 ;   A  character following '\'
                                    262 ; output:
                                    263 ;   A  substitued char or same if not valid.
                                    264 ;---------------------------------------
      008E45                        265 convert_escape:
      008E45 89               [ 2]  266 	pushw x 
      008E46 AE 8E 5A         [ 2]  267 	ldw x,#escaped 
      008E49 F1               [ 1]  268 1$:	cp a,(x)
      008E4A 27 06            [ 1]  269 	jreq 2$
      008E4C 7D               [ 1]  270 	tnz (x)
      008E4D 27 09            [ 1]  271 	jreq 3$
      008E4F 5C               [ 1]  272 	incw x 
      008E50 20 F7            [ 2]  273 	jra 1$
      008E52 1D 8E 5A         [ 2]  274 2$: subw x,#escaped 
      008E55 9F               [ 1]  275 	ld a,xl 
      008E56 AB 07            [ 1]  276 	add a,#7
      008E58 85               [ 2]  277 3$:	popw x 
      008E59 81               [ 4]  278 	ret 
                                    279 
      008E5A 61 62 74 6E 76 66 72   280 escaped:: .asciz "abtnvfr"
             00
                                    281 
                                    282 ;-------------------------
                                    283 ; integer parser 
                                    284 ; input:
                                    285 ;   X      *output buffer (&pad[n])
                                    286 ;   Y 		point to tib 
                                    287 ;   in.w    offset in tib 
                                    288 ;   A 	    first digit|'$' 
                                    289 ; output:  
                                    290 ;   X 		int16   
                                    291 ;   acc16   int16 
                                    292 ;   in.w    updated 
                                    293 ;   Y       pad[n] 
                                    294 ;-------------------------
      008E62                        295 parse_integer: ; { -- n }
      008E62 89               [ 2]  296 	pushw x 
      008E63 72 B9 00 28      [ 2]  297 	addw y,in.w
      008E67 90 5A            [ 2]  298 	decw y   
      008E69 CD 97 DD         [ 4]  299 	call atoi16 
      008E6C 72 A2 16 80      [ 2]  300 	subw y,#tib 
      008E70 90 CF 00 28      [ 2]  301 	ldw in.w,y
      008E74 90 85            [ 2]  302 	popw y  
      008E76 81               [ 4]  303 	ret
                                    304 
                                    305 ;-------------------------------------
                                    306 ; input:
                                    307 ;   X  int16  
                                    308 ;   Y    pad[n]
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 115.
Hexadecimal [24-Bits]



                                    309 ; output:
                                    310 ;    pad   LITW_IDX,word  
                                    311 ;    y     &pad[n+3]
                                    312 ;------------------------------------
      008E77                        313 compile_integer:
      008E77 A6 08            [ 1]  314 	ld a,#LITW_IDX 
      008E79 90 F7            [ 1]  315 	ld (y),a
      008E7B 90 5C            [ 1]  316 	incw y 
      008E7D 90 FF            [ 2]  317 	LDW (Y),x 
      008E7F 72 A9 00 02      [ 2]  318 	addw y,#2
      008E83 81               [ 4]  319 	ret
                                    320 
                                    321 ;---------------------------
                                    322 ;  when lexical unit begin 
                                    323 ;  with a letter a symbol 
                                    324 ;  is expected.
                                    325 ; input:
                                    326 ;   A   first character of symbol 
                                    327 ;	X   point to output buffer 
                                    328 ;   [in.w],Y   point to input text 
                                    329 ; output:
                                    330 ;   A   string length 
                                    331 ;   [in.w],Y   point after lexical unit 
                                    332 ;---------------------------
                           000001   333 	FIRST_CHAR=1
                           000002   334 	VSIZE=2 
      008E84                        335 parse_symbol:
      000E04                        336 	_vars VSIZE 
      008E84 52 02            [ 2]    1     sub sp,#VSIZE 
      008E86 1C 00 01         [ 2]  337 	addw x,#1 ; keep space for token identifier
      008E89 1F 01            [ 2]  338 	ldw (FIRST_CHAR,sp),x  
      008E8B                        339 symb_loop: 
      008E8B F7               [ 1]  340 	ld (x), a 
      008E8C 5C               [ 1]  341 	incw x
      008E8D 91 D6 28         [ 4]  342 	ld a,([in.w],y)
      000E10                        343 	_incz in 
      008E90 3C 29                    1     .byte 0x3c, in 
      008E92 A1 24            [ 1]  344 	cp a,#'$ 
      008E94 27 05            [ 1]  345 	jreq 2$ ; string variable: LETTER+'$'  
      008E96 CD 89 10         [ 4]  346 	call is_digit ;
      008E99 24 04            [ 1]  347 	jrnc 3$ ; integer variable LETTER+DIGIT 
      008E9B                        348 2$:
      008E9B F7               [ 1]  349 	ld (x),a 
      008E9C 5C               [ 1]  350 	incw x 
      008E9D 20 07            [ 2]  351 	jra 4$
      008E9F                        352 3$:
      008E9F CD 88 FF         [ 4]  353 	call is_alpha  
      008EA2 25 E7            [ 1]  354 	jrc symb_loop 
      000E24                        355 	_decz in
      008EA4 3A 29                    1     .byte 0x3a,in 
      008EA6                        356 4$:
      008EA6 7F               [ 1]  357 	clr (x)
      008EA7 72 F0 01         [ 2]  358 	subw x,(FIRST_CHAR,sp)
      008EAA 9F               [ 1]  359 	ld a,xl
      000E2B                        360 	_drop VSIZE 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 116.
Hexadecimal [24-Bits]



      008EAB 5B 02            [ 2]    1     addw sp,#VSIZE 
      008EAD 81               [ 4]  361 	ret 
                                    362 
                                    363 ;---------------------------------
                                    364 ; some syntax checking 
                                    365 ; can be done at compile time
                                    366 ; matching '(' and ')' 
                                    367 ; FOR TO STEP must be on same line 
                                    368 ; same for IF THEN 
                                    369 ;--------------------------------
      008EAE                        370 check_syntax:
      008EAE A1 05            [ 1]  371 	cp a,#RPAREN_IDX
      008EB0 26 0D            [ 1]  372 	jrne 0$
      000E32                        373 	_pop_op 
      008EB2 72 C6 00 42      [ 4]    1     ld a,[psp]
      000E36                          2     _incz psp+1 
      008EB6 3C 43                    1     .byte 0x3c, psp+1 
      008EB8 A1 04            [ 1]  374 	cp a,#LPAREN_IDX 
      008EBA 27 48            [ 1]  375 	jreq 9$ 
      008EBC CC 95 D3         [ 2]  376 	jp syntax_error 
      008EBF                        377 0$: 
      008EBF A1 20            [ 1]  378 	cp a,#IF_IDX 
      008EC1 27 42            [ 1]  379 	jreq push_it 
      008EC3 A1 1B            [ 1]  380 	cp a,#FOR_IDX 
      008EC5 27 3E            [ 1]  381 	jreq push_it 
      008EC7 A1 21            [ 1]  382 	cp a,#THEN_IDX 
      008EC9 26 0D            [ 1]  383 	jrne 1$
      000E4B                        384 	_pop_op 
      008ECB 72 C6 00 42      [ 4]    1     ld a,[psp]
      000E4F                          2     _incz psp+1 
      008ECF 3C 43                    1     .byte 0x3c, psp+1 
      008ED1 A1 20            [ 1]  385 	cp a,#IF_IDX 
      008ED3 27 2F            [ 1]  386 	jreq 9$ 
      008ED5 CC 95 D3         [ 2]  387 	jp syntax_error 
      008ED8                        388 1$: 
      008ED8 A1 27            [ 1]  389 	cp a,#TO_IDX 
      008EDA 26 17            [ 1]  390 	jrne 3$ 
      000E5C                        391 	_pop_op 
      008EDC 72 C6 00 42      [ 4]    1     ld a,[psp]
      000E60                          2     _incz psp+1 
      008EE0 3C 43                    1     .byte 0x3c, psp+1 
      008EE2 A1 1B            [ 1]  392 	cp a,#FOR_IDX 
      008EE4 27 03            [ 1]  393 	jreq 2$ 
      008EE6 CC 95 D3         [ 2]  394 	jp syntax_error 
      008EE9 A6 27            [ 1]  395 2$: ld a,#TO_IDX 
      000E6B                        396 	_push_op 
      000E6B                          1     _decz psp+1
      008EEB 3A 43                    1     .byte 0x3a,psp+1 
      008EED 72 C7 00 42      [ 4]    2     ld [psp],a 
      008EF1 20 11            [ 2]  397 	jra 9$ 
      008EF3 A1 24            [ 1]  398 3$: cp a,#STEP_IDX 
      008EF5 26 0D            [ 1]  399 	jrne 9$ 
      000E77                        400 	_pop_op 
      008EF7 72 C6 00 42      [ 4]    1     ld a,[psp]
      000E7B                          2     _incz psp+1 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 117.
Hexadecimal [24-Bits]



      008EFB 3C 43                    1     .byte 0x3c, psp+1 
      008EFD A1 27            [ 1]  401 	cp a,#TO_IDX 
      008EFF 27 03            [ 1]  402 	jreq 9$ 
      008F01 CC 95 D3         [ 2]  403 	jp syntax_error 
      008F04                        404 9$:	
      008F04 81               [ 4]  405 	ret 
      008F05                        406 push_it:
      000E85                        407 	_push_op 
      000E85                          1     _decz psp+1
      008F05 3A 43                    1     .byte 0x3a,psp+1 
      008F07 72 C7 00 42      [ 4]    2     ld [psp],a 
      008F0B 81               [ 4]  408 	ret 
                                    409 
                                    410 ;---------------------------
                                    411 ;  token begin with a letter,
                                    412 ;  is keyword or variable. 	
                                    413 ; input:
                                    414 ;   X 		point to pad 
                                    415 ;   Y 		point to text
                                    416 ;   A 	    first letter  
                                    417 ; output:
                                    418 ;   Y		point in pad after token  
                                    419 ;   A 		token identifier
                                    420 ;   pad 	keyword|var_name  
                                    421 ;--------------------------  
                           000001   422 	TOK_POS=1
                           000003   423 	NLEN=TOK_POS+2
                           000003   424 	VSIZE=NLEN 
      008F0C                        425 parse_keyword:
      000E8C                        426 	_vars VSIZE 
      008F0C 52 03            [ 2]    1     sub sp,#VSIZE 
      008F0E 0F 03            [ 1]  427 	clr (NLEN,sp)
      008F10 1F 01            [ 2]  428 	ldw (TOK_POS,sp),x  ; where TOK_IDX should be put 
      008F12 CD 8E 84         [ 4]  429 	call parse_symbol
      008F15 6B 03            [ 1]  430 	ld (NLEN,sp),a 
      008F17 A1 01            [ 1]  431 	cp a,#1
      008F19 27 30            [ 1]  432 	jreq 3$  
                                    433  ; check in dictionary, if not found must be variable name.
      000E9B                        434 	_ldx_dict kword_dict ; dictionary entry point
      008F1B AE A8 D1         [ 2]    1         ldw x,#kword_dict+2
      008F1E 16 01            [ 2]  435 	ldw y,(TOK_POS,sp) ; name to search for
      008F20 72 A9 00 01      [ 2]  436 	addw y,#1 ; name first character 
      008F24 CD 98 25         [ 4]  437 	call search_dict
      008F27 A1 FF            [ 1]  438 	cp a,#NONE_IDX 
      008F29 26 2C            [ 1]  439 	jrne 6$
                                    440 ; not in dictionary
                                    441 ; either LETTER+'$' || LETTER+DIGIT 
      008F2B A6 02            [ 1]  442 	ld a,#2 
      008F2D 11 03            [ 1]  443 	cp a,(NLEN,sp)
      008F2F 27 03            [ 1]  444 	jreq 1$ 
      008F31 CC 95 D3         [ 2]  445     jp syntax_error 	
      008F34                        446 1$: ; 2 letters variables 
      008F34 16 01            [ 2]  447 	ldw y,(TOK_POS,sp)
      008F36 93               [ 1]  448 	ldw x,y 
      008F37 1C 00 02         [ 2]  449 	addw x,#2 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 118.
Hexadecimal [24-Bits]



      008F3A F6               [ 1]  450 	ld a,(x)
      008F3B A1 24            [ 1]  451 	cp a,#'$ 
      008F3D 26 04            [ 1]  452 	jrne 2$ 
      008F3F A6 0A            [ 1]  453 	ld a,#STR_VAR_IDX
      008F41 20 0C            [ 2]  454 	jra 5$
      008F43 CD 89 10         [ 4]  455 2$:	call is_digit 
      008F46 25 05            [ 1]  456 	jrc 4$ ; LETTER+DIGIT 
      008F48 CC 95 D3         [ 2]  457 	jp syntax_error 
      008F4B                        458 3$:
                                    459 ; one letter symbol is integer variable name 
                                    460 ; tokenize as: VAR_IDX,LETTER,NUL  
      008F4B 16 01            [ 2]  461 	ldw y,(TOK_POS,sp)
      008F4D                        462 4$:	
      008F4D A6 09            [ 1]  463 	ld a,#VAR_IDX 
      008F4F                        464 5$:
      008F4F 90 F7            [ 1]  465 	ld (y),a
      008F51 72 A9 00 03      [ 2]  466 	addw y,#3
      008F55 20 09            [ 2]  467 	jra 9$
      008F57                        468 6$:	; word in dictionary 
      008F57 16 01            [ 2]  469 	ldw y,(TOK_POS,sp)
      008F59 90 F7            [ 1]  470 	ld (y),a ; compile token 
      008F5B 90 5C            [ 1]  471 	incw y
      008F5D CD 8E AE         [ 4]  472 	call check_syntax  
      000EE0                        473 9$:	_drop VSIZE 
      008F60 5B 03            [ 2]    1     addw sp,#VSIZE 
      008F62 81               [ 4]  474 	ret  	
                                    475 
                                    476 ;------------------------------------
                                    477 ; skip character c in text starting from 'in'
                                    478 ; input:
                                    479 ;	 y 		point to text buffer
                                    480 ;    a 		character to skip
                                    481 ; output:  
                                    482 ;	'in' ajusted to new position
                                    483 ;------------------------------------
                           000001   484 	C = 1 ; local var
      008F63                        485 skip:
      008F63 88               [ 1]  486 	push a
      008F64 91 D6 28         [ 4]  487 1$:	ld a,([in.w],y)
      008F67 27 08            [ 1]  488 	jreq 2$
      008F69 11 01            [ 1]  489 	cp a,(C,sp)
      008F6B 26 04            [ 1]  490 	jrne 2$
      000EED                        491 	_incz in
      008F6D 3C 29                    1     .byte 0x3c, in 
      008F6F 20 F3            [ 2]  492 	jra 1$
      000EF1                        493 2$: _drop 1 
      008F71 5B 01            [ 2]    1     addw sp,#1 
      008F73 81               [ 4]  494 	ret
                                    495 	
                                    496 
                                    497 ;------------------------------------
                                    498 ; scan text for next lexeme
                                    499 ; compile its TOKEN_IDX and value
                                    500 ; in output buffer.  
                                    501 ; update input and output pointers 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 119.
Hexadecimal [24-Bits]



                                    502 ; input: 
                                    503 ;	X 		pointer to buffer where 
                                    504 ;	        token idx and value are compiled 
                                    505 ; use:
                                    506 ;	Y       pointer to text in tib 
                                    507 ;   in.w    offset in tib, i.e. tib[in.w]
                                    508 ; output:
                                    509 ;   A       token index  
                                    510 ;   Y       updated position in output buffer   
                                    511 ;------------------------------------
                                    512 	; use to check special character 
                                    513 	.macro _case c t  
                                    514 	ld a,#c 
                                    515 	cp a,(TCHAR,sp) 
                                    516 	jrne t
                                    517 	.endm 
                                    518 	
                                    519 ; local variables 
                           000001   520 	TCHAR=1 ; parsed character 
                           000002   521 	ATTRIB=2 ; token value  
                           000002   522 	VSIZE=2
      008F74                        523 parse_lexeme:
      000EF4                        524 	_vars VSIZE
      008F74 52 02            [ 2]    1     sub sp,#VSIZE 
      008F76 90 AE 16 80      [ 2]  525 	ldw y,#tib    	
      008F7A A6 20            [ 1]  526 	ld a,#SPACE
      008F7C CD 8F 63         [ 4]  527 	call skip
      008F7F 91 D6 28         [ 4]  528 	ld a,([in.w],y)
      008F82 26 05            [ 1]  529 	jrne 1$
      008F84 90 93            [ 1]  530 	ldw y,x 
      008F86 CC 91 09         [ 2]  531 	jp token_exit ; end of line 
      000F09                        532 1$:	_incz in 
      008F89 3C 29                    1     .byte 0x3c, in 
      008F8B 6B 01            [ 1]  533 	ld (TCHAR,sp),a ; first char of lexeme 
                                    534 ; check for quoted string
      008F8D                        535 str_tst:  	
      000F0D                        536 	_case '"' nbr_tst
      008F8D A6 22            [ 1]    1 	ld a,#'"' 
      008F8F 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      008F91 26 0C            [ 1]    3 	jrne nbr_tst
      008F93 A6 06            [ 1]  537 	ld a,#QUOTE_IDX
      008F95 88               [ 1]  538 	push a 
      008F96 F7               [ 1]  539 	ld (x),a ; compile TOKEN INDEX 
      008F97 5C               [ 1]  540 	incw x 
      008F98 CD 8E 03         [ 4]  541 	call parse_quote ; compile quoted string 
      008F9B 84               [ 1]  542 	pop a 
      008F9C CC 91 09         [ 2]  543 	jp token_exit
      008F9F                        544 nbr_tst:
                                    545 ; check for hexadecimal number 
      000F1F                        546 	_case '$' digit_test 
      008F9F A6 24            [ 1]    1 	ld a,#'$' 
      008FA1 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      008FA3 26 02            [ 1]    3 	jrne digit_test
      008FA5 20 07            [ 2]  547 	jra integer 
                                    548 ; check for decimal number 	
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 120.
Hexadecimal [24-Bits]



      008FA7                        549 digit_test: 
      008FA7 7B 01            [ 1]  550 	ld a,(TCHAR,sp)
      008FA9 CD 89 10         [ 4]  551 	call is_digit
      008FAC 24 09            [ 1]  552 	jrnc other_tests
      008FAE                        553 integer: 
      008FAE CD 8E 62         [ 4]  554 	call parse_integer 
      008FB1 CD 8E 77         [ 4]  555 	call compile_integer
      008FB4 CC 91 09         [ 2]  556 	jp token_exit 
      008FB7                        557 other_tests: 
      000F37                        558 	_case '(' bkslsh_tst 
      008FB7 A6 28            [ 1]    1 	ld a,#'(' 
      008FB9 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      008FBB 26 0B            [ 1]    3 	jrne bkslsh_tst
      008FBD A6 04            [ 1]  559 	ld a,#LPAREN_IDX 
      000F3F                        560 	_push_op 
      000F3F                          1     _decz psp+1
      008FBF 3A 43                    1     .byte 0x3a,psp+1 
      008FC1 72 C7 00 42      [ 4]    2     ld [psp],a 
      008FC5 CC 91 05         [ 2]  561 	jp token_char   	
      008FC8                        562 bkslsh_tst: ; character token 
      000F48                        563 	_case '\',rparnt_tst
      008FC8 A6 5C            [ 1]    1 	ld a,#'\' 
      008FCA 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      008FCC 26 12            [ 1]    3 	jrne rparnt_tst
      008FCE A6 07            [ 1]  564 	ld a,#LITC_IDX 
      008FD0 F7               [ 1]  565 	ld (x),a 
      008FD1 88               [ 1]  566 	push a 
      008FD2 5C               [ 1]  567 	incw x 
      008FD3 91 D6 28         [ 4]  568 	ld a,([in.w],y)
      000F56                        569 	_incz in  
      008FD6 3C 29                    1     .byte 0x3c, in 
      008FD8 F7               [ 1]  570 	ld (x),a 
      008FD9 5C               [ 1]  571 	incw x
      008FDA 90 93            [ 1]  572 	ldw y,x 
      008FDC 84               [ 1]  573 	pop a 	 
      008FDD CC 91 09         [ 2]  574 	jp token_exit
      008FE0                        575 rparnt_tst:		
      000F60                        576 	_case ')' colon_tst 
      008FE0 A6 29            [ 1]    1 	ld a,#')' 
      008FE2 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      008FE4 26 0A            [ 1]    3 	jrne colon_tst
      008FE6 A6 05            [ 1]  577 	ld a,#RPAREN_IDX  
      008FE8 CD 8E AE         [ 4]  578 	call check_syntax 
      008FEB A6 05            [ 1]  579 	ld a,#RPAREN_IDX
      008FED CC 91 05         [ 2]  580 	jp token_char
      008FF0                        581 colon_tst:
      000F70                        582 	_case ':' comma_tst 
      008FF0 A6 3A            [ 1]    1 	ld a,#':' 
      008FF2 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      008FF4 26 05            [ 1]    3 	jrne comma_tst
      008FF6 A6 01            [ 1]  583 	ld a,#COLON_IDX  
      008FF8 CC 91 05         [ 2]  584 	jp token_char  
      008FFB                        585 comma_tst:
      000F7B                        586 	_case COMMA semic_tst 
      008FFB A6 2C            [ 1]    1 	ld a,#COMMA 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 121.
Hexadecimal [24-Bits]



      008FFD 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      008FFF 26 05            [ 1]    3 	jrne semic_tst
      009001 A6 02            [ 1]  587 	ld a,#COMMA_IDX 
      009003 CC 91 05         [ 2]  588 	jp token_char
      009006                        589 semic_tst:
      000F86                        590 	_case SEMIC dash_tst
      009006 A6 3B            [ 1]    1 	ld a,#SEMIC 
      009008 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      00900A 26 05            [ 1]    3 	jrne dash_tst
      00900C A6 03            [ 1]  591 	ld a,#SCOL_IDX  
      00900E CC 91 05         [ 2]  592 	jp token_char 	
      009011                        593 dash_tst: 	
      000F91                        594 	_case '-' sharp_tst 
      009011 A6 2D            [ 1]    1 	ld a,#'-' 
      009013 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      009015 26 05            [ 1]    3 	jrne sharp_tst
      009017 A6 0C            [ 1]  595 	ld a,#SUB_IDX  
      009019 CC 91 05         [ 2]  596 	jp token_char 
      00901C                        597 sharp_tst:
      000F9C                        598 	_case '#' qmark_tst 
      00901C A6 23            [ 1]    1 	ld a,#'#' 
      00901E 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      009020 26 05            [ 1]    3 	jrne qmark_tst
      009022 A6 15            [ 1]  599 	ld a,#REL_NE_IDX  
      009024 CC 91 05         [ 2]  600 	jp token_char
      009027                        601 qmark_tst:
      000FA7                        602 	_case '?' tick_tst 
      009027 A6 3F            [ 1]    1 	ld a,#'?' 
      009029 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      00902B 26 09            [ 1]    3 	jrne tick_tst
      00902D A6 3D            [ 1]  603 	ld a,#PRINT_IDX   
      00902F F7               [ 1]  604 	ld (x),a 
      009030 5C               [ 1]  605 	incw x 
      009031 90 93            [ 1]  606 	ldw y,x 
      009033 CC 91 09         [ 2]  607 	jp token_exit
      009036                        608 tick_tst: ; comment 
      000FB6                        609 	_case TICK plus_tst 
      009036 A6 27            [ 1]    1 	ld a,#TICK 
      009038 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      00903A 26 2F            [ 1]    3 	jrne plus_tst
      00903C A6 23            [ 1]  610 	ld a,#REM_IDX 
      00903E F7               [ 1]  611 	ld (x),a 
      00903F 5C               [ 1]  612 	incw x
      009040                        613 copy_comment:
      009040 90 AE 16 80      [ 2]  614 	ldw y,#tib 
      009044 72 B9 00 28      [ 2]  615 	addw y,in.w
      009048 90 89            [ 2]  616 	pushw y 
      00904A CD 88 A0         [ 4]  617 	call strcpy
      00904D 72 F2 01         [ 2]  618 	subw y,(1,sp)
      009050 90 5C            [ 1]  619 	incw y ; strlen+1
      009052 90 89            [ 2]  620 	pushw y  
      009054 72 FB 01         [ 2]  621 	addw x,(1,sp) 
      009057 90 93            [ 1]  622 	ldw y,x 
      009059 85               [ 2]  623 	popw x 
      00905A 72 FB 01         [ 2]  624 	addw x,(1,sp)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 122.
Hexadecimal [24-Bits]



      00905D 5A               [ 2]  625 	decw x 
      00905E 1D 16 80         [ 2]  626 	subw x,#tib 
      009061 CF 00 28         [ 2]  627 	ldw in.w,x 
      000FE4                        628 	_drop 2 
      009064 5B 02            [ 2]    1     addw sp,#2 
      009066 A6 23            [ 1]  629 	ld a,#REM_IDX
      009068 CC 91 09         [ 2]  630 	jp token_exit 
      00906B                        631 plus_tst:
      000FEB                        632 	_case '+' star_tst 
      00906B A6 2B            [ 1]    1 	ld a,#'+' 
      00906D 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      00906F 26 05            [ 1]    3 	jrne star_tst
      009071 A6 0B            [ 1]  633 	ld a,#ADD_IDX  
      009073 CC 91 05         [ 2]  634 	jp token_char 
      009076                        635 star_tst:
      000FF6                        636 	_case '*' slash_tst 
      009076 A6 2A            [ 1]    1 	ld a,#'*' 
      009078 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      00907A 26 05            [ 1]    3 	jrne slash_tst
      00907C A6 0F            [ 1]  637 	ld a,#MULT_IDX  
      00907E CC 91 05         [ 2]  638 	jp token_char 
      009081                        639 slash_tst: 
      001001                        640 	_case '/' prcnt_tst 
      009081 A6 2F            [ 1]    1 	ld a,#'/' 
      009083 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      009085 26 05            [ 1]    3 	jrne prcnt_tst
      009087 A6 0D            [ 1]  641 	ld a,#DIV_IDX  
      009089 CC 91 05         [ 2]  642 	jp token_char 
      00908C                        643 prcnt_tst:
      00100C                        644 	_case '%' eql_tst 
      00908C A6 25            [ 1]    1 	ld a,#'%' 
      00908E 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      009090 26 05            [ 1]    3 	jrne eql_tst
      009092 A6 0E            [ 1]  645 	ld a,#MOD_IDX 
      009094 CC 91 05         [ 2]  646 	jp token_char  
                                    647 ; 1 or 2 character tokens 	
      009097                        648 eql_tst:
      001017                        649 	_case '=' gt_tst 		
      009097 A6 3D            [ 1]    1 	ld a,#'=' 
      009099 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      00909B 26 05            [ 1]    3 	jrne gt_tst
      00909D A6 11            [ 1]  650 	ld a,#REL_EQU_IDX 
      00909F CC 91 05         [ 2]  651 	jp token_char 
      0090A2                        652 gt_tst:
      001022                        653 	_case '>' lt_tst 
      0090A2 A6 3E            [ 1]    1 	ld a,#'>' 
      0090A4 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      0090A6 26 21            [ 1]    3 	jrne lt_tst
      0090A8 A6 14            [ 1]  654 	ld a,#REL_GT_IDX 
      0090AA 6B 02            [ 1]  655 	ld (ATTRIB,sp),a 
      0090AC 91 D6 28         [ 4]  656 	ld a,([in.w],y)
      00102F                        657 	_incz in 
      0090AF 3C 29                    1     .byte 0x3c, in 
      0090B1 A1 3D            [ 1]  658 	cp a,#'=
      0090B3 26 04            [ 1]  659 	jrne 1$
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 123.
Hexadecimal [24-Bits]



      0090B5 A6 12            [ 1]  660 	ld a,#REL_GE_IDX  
      0090B7 20 4C            [ 2]  661 	jra token_char  
      0090B9 A1 3C            [ 1]  662 1$: cp a,#'<
      0090BB 26 04            [ 1]  663 	jrne 2$
      0090BD A6 15            [ 1]  664 	ld a,#REL_NE_IDX  
      0090BF 20 44            [ 2]  665 	jra token_char 
      0090C1 72 5A 00 29      [ 1]  666 2$: dec in
      0090C5 7B 02            [ 1]  667 	ld a,(ATTRIB,sp)
      0090C7 20 3C            [ 2]  668 	jra token_char 	 
      0090C9                        669 lt_tst:
      001049                        670 	_case '<' other
      0090C9 A6 3C            [ 1]    1 	ld a,#'<' 
      0090CB 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      0090CD 26 21            [ 1]    3 	jrne other
      0090CF A6 13            [ 1]  671 	ld a,#REL_LT_IDX  
      0090D1 6B 02            [ 1]  672 	ld (ATTRIB,sp),a 
      0090D3 91 D6 28         [ 4]  673 	ld a,([in.w],y)
      001056                        674 	_incz in 
      0090D6 3C 29                    1     .byte 0x3c, in 
      0090D8 A1 3D            [ 1]  675 	cp a,#'=
      0090DA 26 04            [ 1]  676 	jrne 1$
      0090DC A6 10            [ 1]  677 	ld a,#REL_LE_IDX 
      0090DE 20 25            [ 2]  678 	jra token_char 
      0090E0 A1 3E            [ 1]  679 1$: cp a,#'>
      0090E2 26 04            [ 1]  680 	jrne 2$
      0090E4 A6 15            [ 1]  681 	ld a,#REL_NE_IDX  
      0090E6 20 1D            [ 2]  682 	jra token_char 
      0090E8 72 5A 00 29      [ 1]  683 2$: dec in 
      0090EC 7B 02            [ 1]  684 	ld a,(ATTRIB,sp)
      0090EE 20 15            [ 2]  685 	jra token_char 	
      0090F0                        686 other: ; not a special character 	 
      0090F0 7B 01            [ 1]  687 	ld a,(TCHAR,sp)
      0090F2 CD 88 FF         [ 4]  688 	call is_alpha 
      0090F5 25 03            [ 1]  689 	jrc 30$ 
      0090F7 CC 95 D3         [ 2]  690 	jp syntax_error 
      0090FA                        691 30$: 
      0090FA CD 8F 0C         [ 4]  692 	call parse_keyword
      0090FD A1 23            [ 1]  693 	cp a,#REM_IDX  
      0090FF 26 08            [ 1]  694 	jrne token_exit   
      009101 93               [ 1]  695 	ldw x,y 
      009102 CC 90 40         [ 2]  696 	jp copy_comment
      009105                        697 token_char:
      009105 F7               [ 1]  698 	ld (x),a 
      009106 5C               [ 1]  699 	incw x
      009107 90 93            [ 1]  700 	ldw y,x 
      009109                        701 token_exit:
      001089                        702 	_drop VSIZE 
      009109 5B 02            [ 2]    1     addw sp,#VSIZE 
      00910B 81               [ 4]  703 	ret
                                    704 
                                    705 
                                    706 ;-----------------------------------
                                    707 ; create token list fromm text line 
                                    708 ; save this list in pad buffer 
                                    709 ;  compiled line format: 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 124.
Hexadecimal [24-Bits]



                                    710 ;    line_no  2 bytes {0...32767}
                                    711 ;    line length    1 byte  
                                    712 ;    tokens list  variable length 
                                    713 ;   
                                    714 ; input:
                                    715 ;   none
                                    716 ; used variables:
                                    717 ;   in.w  		 3|count, i.e. index in buffer
                                    718 ;   count        length of line | 0  
                                    719 ;   basicptr    
                                    720 ;   pad buffer   compiled BASIC line  
                                    721 ;
                                    722 ; If there is a line number copy pad 
                                    723 ; in program space. 
                                    724 ;-----------------------------------
                           000001   725 	XSAVE=1
                           000002   726 	VSIZE=2
      00910C                        727 compile::
      00108C                        728 	_vars VSIZE 
      00910C 52 02            [ 2]    1     sub sp,#VSIZE 
      00910E 55 00 2F 00 2D   [ 1]  729 	mov basicptr,lomem
      009113 72 1A 00 3B      [ 1]  730 	bset flags,#FCOMP 
      001097                        731 	_rst_pending
      009117 AE 00 54         [ 2]    1     ldw x,#pending_stack+PENDING_STACK_SIZE
      00109A                          2     _strxz psp 
      00911A BF 42                    1     .byte 0xbf,psp 
      00911C 4F               [ 1]  732 	clr a 
      00911D 5F               [ 1]  733 	clrw x
      00911E CF 17 00         [ 2]  734 	ldw pad,x ; line# in destination buffer 
      009121 C7 17 02         [ 1]  735 	ld pad+2,a ; line length  
      0010A4                        736 	_clrz in.w 
      009124 3F 28                    1     .byte 0x3f, in.w 
      0010A6                        737 	_clrz in  ; offset in input text buffer 
      009126 3F 29                    1     .byte 0x3f, in 
      009128 C6 16 80         [ 1]  738 	ld a,tib 
      00912B CD 89 10         [ 4]  739 	call is_digit
      00912E 24 1B            [ 1]  740 	jrnc 1$ 
      0010B0                        741 	_incz in 
      009130 3C 29                    1     .byte 0x3c, in 
      009132 AE 17 03         [ 2]  742 	ldw x,#pad+3
      009135 90 AE 16 80      [ 2]  743 	ldw y,#tib   
      009139 CD 8E 62         [ 4]  744 	call parse_integer 
      00913C A3 00 01         [ 2]  745 	cpw x,#1
      00913F 2F 05            [ 1]  746 	jrslt 0$
      009141 CF 17 00         [ 2]  747 	ldw pad,x 
      009144 20 05            [ 2]  748 	jra 1$ 
      009146 A6 01            [ 1]  749 0$:	ld a,#ERR_SYNTAX 
      009148 CC 95 D5         [ 2]  750 	jp tb_error
      00914B                        751 1$:	 
      00914B 90 AE 17 03      [ 2]  752 	ldw y,#pad+3 
      00914F 90 A3 17 80      [ 2]  753 2$:	cpw y,#stack_full 
      009153 25 05            [ 1]  754 	jrult 3$
      009155 A6 0A            [ 1]  755 	ld a,#ERR_MEM_FULL 
      009157 CC 95 D5         [ 2]  756 	jp tb_error 
      00915A                        757 3$:	
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 125.
Hexadecimal [24-Bits]



      00915A 93               [ 1]  758 	ldw x,y 
      00915B CD 8F 74         [ 4]  759 	call parse_lexeme 
      00915E 4D               [ 1]  760 	tnz a 
      00915F 26 EE            [ 1]  761 	jrne 2$ 
                                    762 ; compilation completed  
      0010E1                        763 	_pending_empty 
      0010E1                          1     _ldaz psp+1 
      009161 B6 43                    1     .byte 0xb6,psp+1 
      009163 A0 54            [ 1]    2     sub a,#pending_stack+PENDING_STACK_SIZE
      009165 27 0D            [ 1]  764 	jreq 4$
      0010E7                        765 	_pop_op 
      009167 72 C6 00 42      [ 4]    1     ld a,[psp]
      0010EB                          2     _incz psp+1 
      00916B 3C 43                    1     .byte 0x3c, psp+1 
      00916D A1 27            [ 1]  766 	cp a,#TO_IDX 
      00916F 27 03            [ 1]  767 	jreq 4$ 
      009171 CC 95 D3         [ 2]  768 	jp syntax_error 
      009174                        769 4$:
      009174 90 7F            [ 1]  770 	clr (y)
      009176 90 5C            [ 1]  771 	incw y 
      009178 72 A2 17 00      [ 2]  772 	subw y,#pad ; compiled line length 
      00917C 90 9F            [ 1]  773     ld a,yl
      00917E AE 17 00         [ 2]  774 	ldw x,#pad 
      001101                        775 	_strxz ptr16 
      009181 BF 12                    1     .byte 0xbf,ptr16 
      009183 E7 02            [ 1]  776 	ld (2,x),a 
      009185 FE               [ 2]  777 	ldw x,(x)  ; line# 
      009186 27 08            [ 1]  778 	jreq 10$
      009188 CD 8D 9B         [ 4]  779 	call insert_line ; in program space 
      00110B                        780 	_clrz  count
      00918B 3F 2A                    1     .byte 0x3f, count 
      00918D 4F               [ 1]  781 	clr  a ; not immediate command  
      00918E 20 0F            [ 2]  782 	jra  11$ 
      009190                        783 10$: ; line# is zero 
                                    784 ; for immediate execution from pad buffer.
      001110                        785 	_ldxz ptr16  
      009190 BE 12                    1     .byte 0xbe,ptr16 
      009192 E6 02            [ 1]  786 	ld a,(2,x)
      001114                        787 	_straz count
      009194 B7 2A                    1     .byte 0xb7,count 
      001116                        788 	_strxz line.addr
      009196 BF 2B                    1     .byte 0xbf,line.addr 
      009198 1C 00 03         [ 2]  789 	addw x,#LINE_HEADER_SIZE
      00111B                        790 	_strxz basicptr
      00919B BF 2D                    1     .byte 0xbf,basicptr 
      00919D 90 93            [ 1]  791 	ldw y,x
      00919F                        792 11$:
      00111F                        793 	_drop VSIZE 
      00919F 5B 02            [ 2]    1     addw sp,#VSIZE 
      0091A1 72 1B 00 3B      [ 1]  794 	bres flags,#FCOMP 
      0091A5 81               [ 4]  795 	ret 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 126.
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
                                     19 ;---------------------------------------
                                     20 ;  decompiler
                                     21 ;  decompile bytecode to text source
                                     22 ;  used by command LIST
                                     23 ;---------------------------------------
                                     24 
                           000000    25 .if SEPARATE 
                                     26     .module DECOMPILER 
                                     27     .include "config.inc"
                                     28 
                                     29     .area CODE 
                                     30 .endif 
                                     31 
                                     32 ;--------------------------
                                     33 ;  align text in buffer 
                                     34 ;  by  padding left  
                                     35 ;  with  SPACE 
                                     36 ; input:
                                     37 ;   X      str*
                                     38 ;   A      width  
                                     39 ; output:
                                     40 ;   A      strlen
                                     41 ;   X      ajusted
                                     42 ;--------------------------
                           000001    43 	WIDTH=1 ; column width 
                           000002    44 	SLEN=2  ; string length 
                           000002    45 	VSIZE=2 
      0091A6                         46 right_align::
      001126                         47 	_vars VSIZE 
      0091A6 52 02            [ 2]    1     sub sp,#VSIZE 
      0091A8 6B 01            [ 1]   48 	ld (WIDTH,sp),a 
      0091AA CD 88 86         [ 4]   49 	call strlen 
      0091AD 6B 02            [ 1]   50 0$:	ld (SLEN,sp),a  
      0091AF 11 01            [ 1]   51 	cp a,(WIDTH,sp) 
      0091B1 2A 09            [ 1]   52 	jrpl 1$
      0091B3 5A               [ 2]   53 	decw x
      0091B4 A6 20            [ 1]   54 	ld a,#SPACE 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 127.
Hexadecimal [24-Bits]



      0091B6 F7               [ 1]   55 	ld (x),a  
      0091B7 7B 02            [ 1]   56 	ld a,(SLEN,sp)
      0091B9 4C               [ 1]   57 	inc a 
      0091BA 20 F1            [ 2]   58 	jra 0$ 
      0091BC 7B 02            [ 1]   59 1$: ld a,(SLEN,sp)	
      00113E                         60 	_drop VSIZE 
      0091BE 5B 02            [ 2]    1     addw sp,#VSIZE 
      0091C0 81               [ 4]   61 	ret 
                                     62 
                                     63 ;--------------------------
                                     64 ; print quoted string 
                                     65 ; converting control character
                                     66 ; to backslash sequence
                                     67 ; input:
                                     68 ;   X        char *
                                     69 ;-----------------------------
      0091C1                         70 prt_quote:
      0091C1 A6 22            [ 1]   71 	ld a,#'"
      0091C3 CD 85 2C         [ 4]   72 	call putc 
      0091C6 90 89            [ 2]   73 	pushw y 
      0091C8 CD 97 A7         [ 4]   74 	call skip_string 
      0091CB 85               [ 2]   75 	popw x  
      0091CC F6               [ 1]   76 1$:	ld a,(x)
      0091CD 5C               [ 1]   77 	incw x 
      0091CE 72 5A 00 2A      [ 1]   78 	dec count 
      0091D2 4D               [ 1]   79 	tnz a 
      0091D3 27 2E            [ 1]   80 	jreq 9$ 
      0091D5 A1 20            [ 1]   81 	cp a,#SPACE 
      0091D7 25 0C            [ 1]   82 	jrult 3$
      0091D9 CD 85 2C         [ 4]   83 	call putc 
      0091DC A1 5C            [ 1]   84 	cp a,#'\ 
      0091DE 26 EC            [ 1]   85 	jrne 1$ 
      0091E0                         86 2$:
      0091E0 CD 85 2C         [ 4]   87 	call putc 
      0091E3 20 E7            [ 2]   88 	jra 1$
      0091E5 88               [ 1]   89 3$: push a 
      0091E6 A6 5C            [ 1]   90 	ld a,#'\
      0091E8 CD 85 2C         [ 4]   91 	call putc  
      0091EB 84               [ 1]   92 	pop a 
      0091EC A0 07            [ 1]   93 	sub a,#7
      00116E                         94 	_straz acc8 
      0091EE B7 19                    1     .byte 0xb7,acc8 
      0091F0 72 5F 00 18      [ 1]   95 	clr acc16
      0091F4 89               [ 2]   96 	pushw x
      0091F5 AE 8E 5A         [ 2]   97 	ldw x,#escaped 
      0091F8 72 BB 00 18      [ 2]   98 	addw x,acc16 
      0091FC F6               [ 1]   99 	ld a,(x)
      0091FD CD 85 2C         [ 4]  100 	call putc 
      009200 85               [ 2]  101 	popw x
      009201 20 C9            [ 2]  102 	jra 1$
      009203                        103 9$:
      009203 A6 22            [ 1]  104 	ld a,#'"
      009205 CD 85 2C         [ 4]  105 	call putc  
      009208 81               [ 4]  106 	ret
                                    107 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 128.
Hexadecimal [24-Bits]



                                    108 ;--------------------------
                                    109 ; print variable name  
                                    110 ; input:
                                    111 ;   X    variable name
                                    112 ; output:
                                    113 ;   none 
                                    114 ;--------------------------
      009209                        115 prt_var_name:
      009209 9E               [ 1]  116 	ld a,xh 
      00920A A4 7F            [ 1]  117 	and a,#0x7f 
      00920C CD 85 2C         [ 4]  118 	call putc 
      00920F 9F               [ 1]  119 	ld a,xl 
      009210 CD 85 2C         [ 4]  120 	call putc 
      009213 81               [ 4]  121 	ret 
                                    122 
                                    123 ;----------------------------------
                                    124 ; search name in dictionary
                                    125 ; from its token index  
                                    126 ; input:
                                    127 ;   a       	token index   
                                    128 ; output:
                                    129 ;   A           token index | 0 
                                    130 ;   X 			*name  | 0 
                                    131 ;--------------------------------
                           000001   132 	TOKEN=1  ; TOK_IDX 
                           000002   133 	NFIELD=TOKEN+1 ; NAME FIELD 
                           000004   134 	SKIP=NFIELD+2 
                           000005   135 	VSIZE=SKIP+1 
      009214                        136 tok_to_name:
      001194                        137 	_vars VSIZE 
      009214 52 05            [ 2]    1     sub sp,#VSIZE 
      009216 0F 04            [ 1]  138 	clr (SKIP,sp) 
      009218 6B 01            [ 1]  139 	ld (TOKEN,sp),a 
      00921A AE A9 4E         [ 2]  140 	ldw x, #all_words+2 ; name field 	
      00921D 1F 02            [ 2]  141 1$:	ldw (NFIELD,sp),x
      00921F F6               [ 1]  142 	ld a,(x)
      009220 AB 02            [ 1]  143 	add a,#2 
      009222 6B 05            [ 1]  144 	ld (SKIP+1,sp),a 
      009224 72 FB 04         [ 2]  145 	addw x,(SKIP,sp)
      009227 F6               [ 1]  146 	ld a,(x) ; TOK_IDX     
      009228 11 01            [ 1]  147 	cp a,(TOKEN,sp)
      00922A 27 0B            [ 1]  148 	jreq 2$
      00922C 1E 02            [ 2]  149 	ldw x,(NFIELD,sp) ; name field 
      00922E 1D 00 02         [ 2]  150 	subw x,#2 ; link field 
      009231 FE               [ 2]  151 	ldw x,(x) 
      009232 26 E9            [ 1]  152 	jrne 1$
      009234 4F               [ 1]  153 	clr a 
      009235 20 03            [ 2]  154 	jra 9$
      009237 1E 02            [ 2]  155 2$: ldw x,(NFIELD,sp)
      009239 5C               [ 1]  156 	incw x 
      0011BA                        157 9$:	_drop VSIZE
      00923A 5B 05            [ 2]    1     addw sp,#VSIZE 
      00923C 81               [ 4]  158 	ret
                                    159 
                                    160 ;-------------------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 129.
Hexadecimal [24-Bits]



                                    161 ; decompile tokens list 
                                    162 ; to original text line 
                                    163 ; input:
                                    164 ;   A      0 don't align line number 
                                    165 ;          !0 align it. 
                                    166 ;   line.addr start of line 
                                    167 ;   Y,basicptr  at first token 
                                    168 ;   count     stop position.
                                    169 ;------------------------------------
                           000001   170 	PSTR=1     ;  1 word 
                           000003   171 	ALIGN=3
                           000004   172 	LAST_BC=4
                           000004   173 	VSIZE=4
      00923D                        174 decompile::
      00923D 3B 00 0F         [ 1]  175 	push base 
      009240 35 0A 00 0F      [ 1]  176 	mov base,#10
      0011C4                        177 	_vars VSIZE
      009244 52 04            [ 2]    1     sub sp,#VSIZE 
      009246 6B 03            [ 1]  178 	ld (ALIGN,sp),a 
      0011C8                        179 	_ldxz line.addr
      009248 BE 2B                    1     .byte 0xbe,line.addr 
      00924A FE               [ 2]  180 	ldw x,(x)
      00924B 4F               [ 1]  181 	clr a ; unsigned conversion  
      00924C CD 88 39         [ 4]  182 	call itoa
      00924F 0D 03            [ 1]  183 	tnz (ALIGN,sp)
      009251 27 05            [ 1]  184 	jreq 1$  
      009253 A6 05            [ 1]  185 	ld a,#5 
      009255 CD 91 A6         [ 4]  186 	call right_align 
      009258 CD 85 A3         [ 4]  187 1$:	call puts 
      00925B CD 86 06         [ 4]  188 	call space
      0011DE                        189 	_ldyz basicptr
      00925E 90 BE 2D                 1     .byte 0x90,0xbe,basicptr 
      009261                        190 decomp_loop:
      0011E1                        191 	_ldaz count 
      009261 B6 2A                    1     .byte 0xb6,count 
      009263 26 03            [ 1]  192 	jrne 0$
      009265 CC 93 26         [ 2]  193 	jp decomp_exit 
      009268                        194 0$:	
      009268 72 5A 00 2A      [ 1]  195 	dec count 
      0011EC                        196 	_next_token
      0011EC                          1         _get_char 
      00926C 90 F6            [ 1]    1         ld a,(y)    ; 1 cy 
      00926E 90 5C            [ 1]    2         incw y      ; 1 cy 
      009270 4D               [ 1]  197 	tnz a 
      009271 26 03            [ 1]  198 	jrne 1$
      009273 CC 93 26         [ 2]  199 	jp decomp_exit   
      009276 A1 06            [ 1]  200 1$:	cp a,#QUOTE_IDX 
      009278 26 03            [ 1]  201 	jrne 2$
      00927A CC 93 20         [ 2]  202 	jp quoted_string 
      00927D A1 09            [ 1]  203 2$:	cp a,#VAR_IDX 
      00927F 26 03            [ 1]  204 	jrne 3$
      009281 CC 92 CC         [ 2]  205 	jp variable 
      009284 A1 23            [ 1]  206 3$:	cp a,#REM_IDX 
      009286 26 03            [ 1]  207 	jrne 4$
      009288 CC 93 14         [ 2]  208 	jp comment 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 130.
Hexadecimal [24-Bits]



      00928B                        209 4$:	
      00928B A1 0A            [ 1]  210 	cp a,#STR_VAR_IDX 
      00928D 26 03            [ 1]  211 	jrne 5$
      00928F CC 92 CC         [ 2]  212 	jp variable 
      009292 A1 07            [ 1]  213 5$:	cp a,#LITC_IDX 
      009294 26 10            [ 1]  214 	jrne 6$ 
      009296 A6 5C            [ 1]  215 	ld a,#'\ 
      009298 CD 85 2C         [ 4]  216 	call putc 
      00121B                        217 	_get_char 
      00929B 90 F6            [ 1]    1         ld a,(y)    ; 1 cy 
      00929D 90 5C            [ 1]    2         incw y      ; 1 cy 
      00121F                        218 	_decz count 
      00929F 3A 2A                    1     .byte 0x3a,count 
      0092A1 CD 85 2C         [ 4]  219 	call putc 
      0092A4 20 21            [ 2]  220 	jra prt_space 
      0092A6 A1 08            [ 1]  221 6$:	cp a,#LITW_IDX 
      0092A8 26 02            [ 1]  222 	jrne 7$
      0092AA 20 3B            [ 2]  223 	jra lit_word
      0092AC                        224 7$:	
                                    225 ; print command,funcion or operator 	 
      0092AC 6B 04            [ 1]  226 	ld (LAST_BC,sp),a
      0092AE CD 92 14         [ 4]  227 	call tok_to_name 
      0092B1 4D               [ 1]  228 	tnz a 
      0092B2 26 03            [ 1]  229 	jrne 9$
      0092B4 CC 93 26         [ 2]  230 	jp decomp_exit
      0092B7                        231 9$:	
      0092B7 CD 88 86         [ 4]  232 	call strlen 
      0092BA A1 02            [ 1]  233 	cp a,#2 
      0092BC 2A 06            [ 1]  234 	jrpl 10$
      0092BE F6               [ 1]  235 	ld a,(x)
      0092BF CD 85 2C         [ 4]  236 	call putc 
      0092C2 20 9D            [ 2]  237 	jra decomp_loop 
      0092C4                        238 10$:
      0092C4 CD 85 A3         [ 4]  239 	call puts
      0092C7                        240 prt_space:
      0092C7 CD 86 06         [ 4]  241 	call space 
      0092CA 20 95            [ 2]  242 	jra decomp_loop
                                    243 ; print variable name 	
      0092CC                        244 variable: ; VAR_IDX 
      0092CC 90 F6            [ 1]  245 	ld a,(y)
      0092CE A4 7F            [ 1]  246 	and a,#127 
      0092D0 CD 85 2C         [ 4]  247 	call putc 
      0092D3 90 E6 01         [ 1]  248 	ld a,(1,y) 
      0092D6 CD 85 2C         [ 4]  249 	call putc 
      0092D9 72 5A 00 2A      [ 1]  250 	dec count 
      0092DD 72 5A 00 2A      [ 1]  251 	dec count   
      0092E1 72 A9 00 02      [ 2]  252 	addw y,#2
      0092E5 20 E0            [ 2]  253 	jra prt_space
                                    254 ; print literal integer  
      0092E7                        255 lit_word: ; LITW_IDX 
      001267                        256 	_get_word
      001267                          1         _get_addr
      0092E7 93               [ 1]    1         ldw x,y     ; 1 cy 
      0092E8 FE               [ 2]    2         ldw x,(x)   ; 2 cy 
      0092E9 72 A9 00 02      [ 2]    3         addw y,#2   ; 2 cy 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 131.
Hexadecimal [24-Bits]



      0092ED 5D               [ 2]  257 	tnzw x 
      0092EE 2A 1F            [ 1]  258 	jrpl 1$
      0092F0 7B 04            [ 1]  259 	ld a,(LAST_BC,sp)
      0092F2 A1 1D            [ 1]  260 	cp a,#GOSUB_IDX 
      0092F4 2B 19            [ 1]  261 	jrmi 1$ 
      0092F6 A1 1F            [ 1]  262 	cp a,#GOTO_IDX 
      0092F8 22 15            [ 1]  263 	jrugt 1$ 
      0092FA 1D 80 00         [ 2]  264 	subw x,#0x8000
      0092FD 72 BB 00 2F      [ 2]  265 	addw x,lomem
      009301 90 89            [ 2]  266 	pushw y 
      009303 FE               [ 2]  267 	ldw x,(x)
      009304 90 93            [ 1]  268 	ldw y,x ; line #
      009306 1E 01            [ 2]  269 	ldw x,(1,sp) ; basicptr
      009308 1D 00 02         [ 2]  270 	subw x,#2 ; 
      00930B FF               [ 2]  271 	ldw (x),y
      00930C 93               [ 1]  272 	ldw x,y   
      00930D 90 85            [ 2]  273 	popw y 
      00930F                        274 1$:	 
      00930F CD 88 2E         [ 4]  275 	call print_int 
      009312 20 B3            [ 2]  276 	jra prt_space 	
                                    277 ; print comment	
      009314                        278 comment: ; REM_IDX 
      009314 A6 27            [ 1]  279 	ld a,#''
      009316 CD 85 2C         [ 4]  280 	call putc
      009319 93               [ 1]  281 	ldw x,y
      00931A CD 85 A3         [ 4]  282 	call puts 
      00931D CC 93 26         [ 2]  283 	jp decomp_exit 
                                    284 ; print quoted string 	
      009320                        285 quoted_string:	
      009320 CD 91 C1         [ 4]  286 	call prt_quote  
      009323 CC 92 C7         [ 2]  287 	jp prt_space
                                    288 ; print \letter 	
                           000000   289 .if 0
                                    290 letter: 
                                    291 	ld a,#'\ 
                                    292 	call putc 
                                    293 	_get_char 
                                    294 	dec count   
                                    295 	call putc  
                                    296 	jp prt_space 
                                    297 .endif 
      009326                        298 decomp_exit: 
      009326 CD 85 E9         [ 4]  299 	call new_line 
      0012A9                        300 	_drop VSIZE 
      009329 5B 04            [ 2]    1     addw sp,#VSIZE 
      00932B 32 00 0F         [ 1]  301 	pop base 
      00932E 81               [ 4]  302 	ret 
                                    303 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 132.
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
                                     19 
                                     20 ;----------------------------------
                                     21 ;    file system 
                                     22 ; file header:
                                     23 ;   sign field:  2 bytes .ascii "PB" 
                                     24 ;   program size: 1 word 
                                     25 ;   file name: 12 bytes 
                                     26 ;      name is 11 charaters maximum to be zero terminated  
                                     27 ;   data: n bytes 
                                     28 ;  
                                     29 ;   file sector is 256 bytes, this is 
                                     30 ;   minimum allocation unit.   
                                     31 ;----------------------------------
                                     32 
                           000000    33 .if SEPARATE 
                                     34     .module FILES
                                     35     .include "config.inc"
                                     36 
                                     37 	.area CODE 
                                     38 .endif 
                                     39 
                                     40 
                                     41 ;---------------------------------
                                     42 ;  files.asm macros 
                                     43 ;---------------------------------
                                     44 
                                     45 
                           005042    46 SIGNATURE="PB" 
      00932F 58 58                   47 ERASED: .ascii "XX" ; erased file, replace signature. 
                           000000    48 FILE_SIGN_FIELD = 0 ; signature offset 2 bytes 
                           000002    49 FILE_SIZE_FIELD = 2 ; size offset 2 bytes 
                           000004    50 FILE_NAME_FIELD = 4 ; file name 12 byte 
                           000010    51 FILE_HEADER_SIZE = 16 ; bytes 
                           000010    52 FILE_DATA= FILE_HEADER_SIZE ; data offset 
                           000100    53 FSECTOR_SIZE=256 ; file sector size  
                           00000C    54 FNAME_MAX_LEN=12 
                                     55 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 133.
Hexadecimal [24-Bits]



                                     56 
                                     57 ;-------------------------------
                                     58 ; search a BASIC file in spi eeprom  
                                     59 ; 
                                     60 ; The file name is identified 
                                     61 ; input:
                                     62 ;    x      *fname 
                                     63 ;    farptr   start address in file system 
                                     64 ; output: 
                                     65 ;    A        0 not found | 1 found
                                     66 ;    farptr   file address in eeprom   
                                     67 ;-------------------------------
                           000001    68 	FNAME=1 
                           000003    69 	YSAVE=FNAME+2 
                           000004    70 	VSIZE=YSAVE+1 
      009331                         71 search_file:
      0012B1                         72 	_vars VSIZE
      009331 52 04            [ 2]    1     sub sp,#VSIZE 
      009333 17 03            [ 2]   73 	ldw (YSAVE,sp),y  
      009335 1F 01            [ 2]   74 	ldw (FNAME,sp),x
      009337 CD 94 8B         [ 4]   75 	call first_file  
      00933A 27 19            [ 1]   76 1$: jreq 7$  
      00933C AE 00 58         [ 2]   77     ldw x,#file_header+FILE_NAME_FIELD
      00933F 16 01            [ 2]   78 	ldw y,(FNAME,sp)
      009341 CD 88 91         [ 4]   79 	call strcmp 
      009344 27 0B            [ 1]   80 	jreq 4$ 
      009346 AE 00 54         [ 2]   81 	ldw x,#file_header 
      009349 CD 94 CF         [ 4]   82 	call skip_to_next
      00934C CD 94 90         [ 4]   83 	call next_file 
      00934F 20 E9            [ 2]   84 	jra 1$  
      009351                         85 4$: ; file found  
      009351 A6 01            [ 1]   86 	ld a,#1 
      009353 20 01            [ 2]   87 	jra 8$  
      009355                         88 7$: ; not found 
      009355 4F               [ 1]   89 	clr a 
      009356                         90 8$:	
      009356 16 03            [ 2]   91 	ldw y,(YSAVE,sp)
      0012D8                         92 	_drop VSIZE 
      009358 5B 04            [ 2]    1     addw sp,#VSIZE 
      00935A 81               [ 4]   93 	ret 
                                     94 
                                     95 ;-----------------------------------
                                     96 ; erase program file
                                     97 ; replace signature by "XX. 
                                     98 ; input:
                                     99 ;   farptr    file address in eeprom  
                                    100 ;-----------------------------------
      00935B                        101 erase_file:
      00935B A6 58            [ 1]  102 	ld a,#'X 
      00935D AE 00 54         [ 2]  103 	ldw x,#file_header
      009360 F7               [ 1]  104 	ld (x),a 
      009361 E7 01            [ 1]  105 	ld (1,x),a
      009363 A6 02            [ 1]  106 	ld a,#2 
      009365 CD 8A B6         [ 4]  107 	call eeprom_write 
      009368 81               [ 4]  108 	ret 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 134.
Hexadecimal [24-Bits]



                                    109 
                                    110 ;--------------------------------------
                                    111 ; reclaim erased file space that 
                                    112 ; fit size 
                                    113 ; input:
                                    114 ;    X     minimum size to reclaim 
                                    115 ; output:
                                    116 ;    A     0 no fit | 1 fit found 
                                    117 ;    farptr   fit address 
                                    118 ;--------------------------------------
                           000001   119 	NEED=1
                           000003   120 	SMALL_FIT=NEED+2
                           000005   121 	YSAVE=SMALL_FIT+2 
                           000006   122 	VSIZE=YSAVE+1
      009369                        123 reclaim_space:
      0012E9                        124 	_vars VSIZE 
      009369 52 06            [ 2]    1     sub sp,#VSIZE 
      00936B 17 05            [ 2]  125 	ldw (YSAVE,sp),y 
      00936D 1F 01            [ 2]  126 	ldw (NEED,sp),x 
      00936F AE FF FF         [ 2]  127 	ldw x,#-1 
      009372 1F 03            [ 2]  128 	ldw (SMALL_FIT,sp),x 
      0012F4                        129 	_clrz farptr  
      009374 3F 11                    1     .byte 0x3f, farptr 
      009376 5F               [ 1]  130 	clrw x
      0012F7                        131 	_strxz ptr16 
      009377 BF 12                    1     .byte 0xbf,ptr16 
      009379                        132 1$:	
      009379 CD 8B 77         [ 4]  133 	call addr_to_page
      00937C A3 02 00         [ 2]  134 	cpw x,#512 
      00937F 2A 29            [ 1]  135 	jrpl 7$ ; to end  
      009381 AE 00 10         [ 2]  136 	ldw x,#FILE_HEADER_SIZE
      009384 90 AE 00 54      [ 2]  137 	ldw y,#file_header
      009388 CD 8A E2         [ 4]  138 	call eeprom_read 
      00938B AE 00 54         [ 2]  139 	ldw x,#file_header  
      00938E FE               [ 2]  140 	ldw x,(x)
      00938F A3 93 2F         [ 2]  141 	cpw x,#ERASED 
      009392 27 05            [ 1]  142 	jreq 4$ 
      009394 CD 94 CF         [ 4]  143 3$:	call skip_to_next
      009397 20 E0            [ 2]  144 	jra 1$ 
      009399                        145 4$: ; check size 
      009399 AE 00 54         [ 2]  146 	ldw x,#file_header  
      00939C EE 02            [ 2]  147 	ldw x,(FILE_SIZE_FIELD,x)
      00939E 13 01            [ 2]  148 	cpw x,(NEED,sp)
      0093A0 25 F2            [ 1]  149 	jrult 3$ 
      0093A2 13 03            [ 2]  150 	cpw x,(SMALL_FIT,sp)
      0093A4 22 EE            [ 1]  151 	jrugt 3$ 
      0093A6 1F 03            [ 2]  152 	ldw (SMALL_FIT,sp),x  
      0093A8 20 EA            [ 2]  153 	jra 3$ 
      0093AA                        154 7$: ; to end of file system 
      0093AA 4F               [ 1]  155 	clr a 
      0093AB 1E 03            [ 2]  156 	ldw x,(SMALL_FIT,sp)
      0093AD A3 FF FF         [ 2]  157 	cpw x,#-1
      0093B0 27 02            [ 1]  158 	jreq 9$ 
      0093B2 A6 01            [ 1]  159 	ld a,#1
      0093B4                        160 9$:	
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 135.
Hexadecimal [24-Bits]



      0093B4 16 05            [ 2]  161 	ldw y,(YSAVE,sp)
      001336                        162 	_drop VSIZE  
      0093B6 5B 06            [ 2]    1     addw sp,#VSIZE 
      0093B8 81               [ 4]  163 	ret 
                                    164 
                                    165 ;--------------------------
                                    166 ; load file in RAM 
                                    167 ; input:
                                    168 ;   farptr   file address 
                                    169 ;   file_header   file header data 
                                    170 ;--------------------------
                           000001   171 	FSIZE=1
                           000003   172 	YSAVE=FSIZE+2
                           000004   173 	VSIZE=YSAVE+1
      0093B9                        174 load_file:
      001339                        175 	_vars VSIZE 
      0093B9 52 04            [ 2]    1     sub sp,#VSIZE 
      0093BB 17 03            [ 2]  176 	ldw (YSAVE,sp),y
      0093BD AE 00 10         [ 2]  177 	ldw x,#FILE_HEADER_SIZE 
      0093C0 CD 94 D9         [ 4]  178 	call incr_farptr 	
      0093C3 AE 00 54         [ 2]  179 	ldw x,#file_header  
      0093C6 EE 02            [ 2]  180 	ldw x,(FILE_SIZE_FIELD,x)
      0093C8 1F 01            [ 2]  181 	ldw (FSIZE,sp),x 
      0093CA 90 CE 00 2F      [ 2]  182 	ldw y,lomem 
      0093CE CD 8A E2         [ 4]  183 	call eeprom_read 
      0093D1 CE 00 2F         [ 2]  184 	ldw x,lomem 
      0093D4 72 FB 01         [ 2]  185 	addw x,(FSIZE,sp)
      001357                        186 	_strxz progend 
      0093D7 BF 33                    1     .byte 0xbf,progend 
      001359                        187 	_strxz dvar_bgn
      0093D9 BF 35                    1     .byte 0xbf,dvar_bgn 
      00135B                        188 	_strxz dvar_end 
      0093DB BF 37                    1     .byte 0xbf,dvar_end 
      0093DD                        189 9$:
      0093DD 16 03            [ 2]  190 	ldw y,(YSAVE,sp)
      00135F                        191 	_drop VSIZE 
      0093DF 5B 04            [ 2]    1     addw sp,#VSIZE 
      0093E1 81               [ 4]  192 	ret 
                                    193 
                                    194 ;--------------------------------------
                                    195 ; save program file 
                                    196 ; input:
                                    197 ;    farptr     address in eeprom 
                                    198 ;    X          file name 
                                    199 ;--------------------------------------
                           000001   200 	TO_WRITE=1
                           000003   201 	DONE=TO_WRITE+2
                           000005   202 	FNAME=DONE+2 
                           000005   203 	XSAVE=FNAME
                           000007   204 	YSAVE=XSAVE+2 
                           000008   205 	VSIZE=YSAVE+1
      0093E2                        206 save_file:
      001362                        207 	_vars VSIZE 
      0093E2 52 08            [ 2]    1     sub sp,#VSIZE 
      0093E4 17 07            [ 2]  208 	ldw (YSAVE,sp),y 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 136.
Hexadecimal [24-Bits]



      0093E6 1F 05            [ 2]  209 	ldw (FNAME,sp),x 
      0093E8 AE 00 54         [ 2]  210 	ldw x,#file_header
      0093EB A6 50            [ 1]  211 	ld a,#'P 
      0093ED F7               [ 1]  212 	ld (x),a 
      0093EE A6 42            [ 1]  213 	ld a,#'B 
      0093F0 E7 01            [ 1]  214 	ld (1,x),a
      0093F2 90 CE 00 33      [ 2]  215 	ldw y,progend 
      0093F6 72 B2 00 2F      [ 2]  216 	subw y,lomem
      0093FA EF 02            [ 2]  217 	ldw (FILE_SIZE_FIELD,X),y
      0093FC 17 01            [ 2]  218 	ldw (TO_WRITE,sp),y 
      0093FE 1C 00 04         [ 2]  219 	addw x,#FILE_NAME_FIELD 
      009401 16 05            [ 2]  220 	ldw y,(FNAME,sp)
      009403 CD 88 A0         [ 4]  221 	call strcpy 
      009406 A6 10            [ 1]  222 	ld a,#FILE_HEADER_SIZE
      009408 AE 00 54         [ 2]  223 	ldw x,#file_header
      00940B 6F 0F            [ 1]  224 	clr (FILE_HEADER_SIZE-1,x) ; in case name is longer that FNAME_MAX_LEN
      00940D CD 8A B6         [ 4]  225 	call eeprom_write 
      009410 AE 00 10         [ 2]  226 	ldw x,#FILE_HEADER_SIZE 
      009413 CD 94 D9         [ 4]  227 	call incr_farptr
      009416 CE 00 2F         [ 2]  228 	ldw x,lomem 
      009419 1F 05            [ 2]  229 	ldw (XSAVE,sp),x 
      00941B AE 00 F0         [ 2]  230 	ldw x,#FSECTOR_SIZE-FILE_HEADER_SIZE 
      00941E                        231 1$: 
      00941E 13 01            [ 2]  232 	cpw x,(TO_WRITE,sp)
      009420 23 02            [ 2]  233 	jrule 2$ 
      009422 1E 01            [ 2]  234 	ldw x,(TO_WRITE,sp)
      009424 1F 03            [ 2]  235 2$: ldw (DONE,sp),x
      009426 9F               [ 1]  236 	ld a,xl 
      009427 1E 05            [ 2]  237 	ldw x,(XSAVE,sp)
      009429 CD 8A B6         [ 4]  238 	call eeprom_write 
      00942C 1E 03            [ 2]  239 	ldw x,(DONE,sp)
      00942E CD 94 D9         [ 4]  240 	call incr_farptr
      009431 1E 01            [ 2]  241 	ldw x,(TO_WRITE,sp)
      009433 72 F0 03         [ 2]  242 	subw x,(DONE,sp)
      009436 1F 01            [ 2]  243 	ldw (TO_WRITE,sp),x 
      009438 27 0C            [ 1]  244 	jreq 9$ 
      00943A 1E 05            [ 2]  245 	ldw x,(XSAVE,sp)
      00943C 72 FB 03         [ 2]  246 	addw x,(DONE,sp)
      00943F 1F 05            [ 2]  247 	ldw (XSAVE,sp),x 
      009441 AE 01 00         [ 2]  248 	ldw x,#FSECTOR_SIZE
      009444 20 D8            [ 2]  249 	jra 1$ 
      009446                        250 9$:
      009446 16 07            [ 2]  251 	ldw y,(YSAVE,sp)
      0013C8                        252 	_drop VSIZE 
      009448 5B 08            [ 2]    1     addw sp,#VSIZE 
      00944A 81               [ 4]  253 	ret 
                                    254 
                                    255 ;---------------------------
                                    256 ; search free page in eeprom 
                                    257 ; output:
                                    258 ;    A     0 no free | 1 free 
                                    259 ;    farptr  address free 
                                    260 ;---------------------------
      00944B                        261 search_free:
      0013CB                        262 	_clrz farptr 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 137.
Hexadecimal [24-Bits]



      00944B 3F 11                    1     .byte 0x3f, farptr 
      00944D 5F               [ 1]  263 	clrw x 
      0013CE                        264 	_strxz ptr16 
      00944E BF 12                    1     .byte 0xbf,ptr16 
      009450 90 AE 00 54      [ 2]  265 1$:	ldw y,#file_header 
      009454 AE 00 10         [ 2]  266 	ldw x,#FILE_HEADER_SIZE 
      009457 CD 8A E2         [ 4]  267 	call eeprom_read 
      00945A AE 00 54         [ 2]  268 	ldw x,#file_header
      00945D FE               [ 2]  269 	ldw x,(x)
      0013DE                        270 	_strxz acc16
      00945E BF 18                    1     .byte 0xbf,acc16 
      009460 AE FF FF         [ 2]  271 	ldw x,#-1 
      009463 C3 00 18         [ 2]  272 	cpw x,acc16 
      009466 27 20            [ 1]  273 	jreq 6$   ; erased page, take it 
      009468 AE 50 42         [ 2]  274 	ldw x,#SIGNATURE
      00946B C3 00 18         [ 2]  275 	cpw x,acc16 
      00946E 27 0A            [ 1]  276 	jreq 4$ 
      009470 AE 93 2F         [ 2]  277 	ldw x,#ERASED
      009473 C3 00 18         [ 2]  278 	cpw x,acc16  
      009476 27 02            [ 1]  279 	jreq 4$ 
      009478 20 0E            [ 2]  280 	jra 6$ ; no "PB" or "XX" take it 
      00947A                        281 4$: ; try next 
      00947A CD 94 CF         [ 4]  282 	call skip_to_next 
      00947D CD 8B 77         [ 4]  283 	call addr_to_page 
      009480 A3 02 00         [ 2]  284 	cpw x,#512 
      009483 2B CB            [ 1]  285 	jrmi 1$
      009485 4F               [ 1]  286 	clr a  
      009486 20 02            [ 2]  287 	jra 9$ 
      009488                        288 6$: ; found free 
      009488 A6 01            [ 1]  289 	ld a,#1
      00948A                        290 9$:	
      00948A 81               [ 4]  291 	ret 
                                    292 
                                    293 
                                    294 ;---------------------------------------
                                    295 ;  search first file 
                                    296 ;  input: 
                                    297 ;    none 
                                    298 ;  output:
                                    299 ;     A     0 none | 1 found 
                                    300 ;  farptr   file address 
                                    301 ;   pad     file header 
                                    302 ;-----------------------------------------
      00948B                        303 first_file:
      00140B                        304 	_clrz farptr 
      00948B 3F 11                    1     .byte 0x3f, farptr 
      00948D 5F               [ 1]  305 	clrw x 
      00140E                        306 	_strxz ptr16 
      00948E BF 12                    1     .byte 0xbf,ptr16 
                                    307 ; search next file 
      009490                        308 next_file: 
      009490 90 89            [ 2]  309 	pushw y 
      009492                        310 1$:	
      009492 CD 8B 77         [ 4]  311 	call addr_to_page
      009495 A3 02 00         [ 2]  312 	cpw x,#512
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 138.
Hexadecimal [24-Bits]



      009498 2A 2D            [ 1]  313 	jrpl 4$ 
      00949A AE 00 10         [ 2]  314 	ldw x,#FILE_HEADER_SIZE 
      00949D 90 AE 00 54      [ 2]  315 	ldw y,#file_header  
      0094A1 CD 8A E2         [ 4]  316 	call eeprom_read 
      0094A4 AE 00 54         [ 2]  317 	ldw x,#file_header
      0094A7 FE               [ 2]  318 	ldw x,(x) ; signature 
      001428                        319 	_strxz acc16 
      0094A8 BF 18                    1     .byte 0xbf,acc16 
      0094AA AE 50 42         [ 2]  320 	ldw x,#SIGNATURE  
      0094AD C3 00 18         [ 2]  321 	cpw x,acc16 
      0094B0 27 18            [ 1]  322 	jreq 8$  
      0094B2 AE FF FF         [ 2]  323 	ldw x,#-1 
      0094B5 C3 00 18         [ 2]  324 	cpw x,acc16 
      0094B8 27 0D            [ 1]  325 	jreq 4$ ; end of files 	
      0094BA A3 93 2F         [ 2]  326 	cpw x,#ERASED 
      0094BD 26 08            [ 1]  327 	jrne 4$ 
      0094BF                        328 2$:
      0094BF AE 00 54         [ 2]  329 	ldw x,#file_header 
      0094C2 CD 94 CF         [ 4]  330 	call skip_to_next 
      0094C5 20 CB            [ 2]  331 	jra 1$ 
      0094C7                        332 4$: ; no more file 
      0094C7 4F               [ 1]  333 	clr a
      0094C8 20 02            [ 2]  334 	jra 9$  
      0094CA A6 01            [ 1]  335 8$: ld a,#1 
      0094CC                        336 9$: 	
      0094CC 90 85            [ 2]  337 	popw y 
      0094CE 81               [ 4]  338 	ret 
                                    339 
                                    340 ;----------------------------
                                    341 ;  skip to next program
                                    342 ;  in file system  
                                    343 ; input:
                                    344 ;     X       address of buffer containing file HEADER data 
                                    345 ;    farptr   actual program address in eeprom 
                                    346 ; output:
                                    347 ;    farptr   updated to next sector after program   
                                    348 ;----------------------------
      0094CF                        349 skip_to_next:
      0094CF EE 02            [ 2]  350 	ldw x,(FILE_SIZE_FIELD,x)
      0094D1 1C 00 10         [ 2]  351 	addw x,#FILE_HEADER_SIZE 
      0094D4 1C 00 FF         [ 2]  352 	addw x,#FSECTOR_SIZE-1 
      0094D7 4F               [ 1]  353 	clr a 
      0094D8 97               [ 1]  354 	ld xl,a 
                                    355 
                                    356 ;----------------------
                                    357 ; input: 
                                    358 ;    X     increment 
                                    359 ; output:
                                    360 ;   farptr += X 
                                    361 ;---------------------
      0094D9                        362 incr_farptr:
      0094D9 72 BB 00 12      [ 2]  363 	addw x,ptr16 
      00145D                        364 	_strxz ptr16  
      0094DD BF 12                    1     .byte 0xbf,ptr16 
      0094DF 4F               [ 1]  365 	clr a 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 139.
Hexadecimal [24-Bits]



      0094E0 C9 00 11         [ 1]  366 	adc a,farptr 
      001463                        367 	_straz farptr 
      0094E3 B7 11                    1     .byte 0xb7,farptr 
      0094E5 81               [ 4]  368 	ret 
                                    369 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 140.
Hexadecimal [24-Bits]



                                      1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                      2 ;;   pomme BASIC error messages 
                                      3 ;;   addresses indexed table 
                                      4 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                      5 
                                      6 	; macro to create err_msg table 
                                      7 	.macro _err_entry msg_addr, error_code 
                                      8 	.word msg_addr  
                                      9 	error_code==ERR_IDX 
                                     10 	ERR_IDX=ERR_IDX+1
                                     11 	.endm 
                                     12 
                           000000    13 	ERR_IDX=0
                                     14 
                                     15 ; array of pointers to 
                                     16 ; error_messages strings table.	
      0094E6                         17 err_msg_idx:  
                                     18 
      001466                         19 	_err_entry 0,ERR_NONE 
      0094E6 00 00                    1 	.word 0  
                           000000     2 	ERR_NONE==ERR_IDX 
                           000001     3 	ERR_IDX=ERR_IDX+1
      001468                         20 	_err_entry err_syntax,ERR_SYNTAX 
      0094E8 95 0C                    1 	.word err_syntax  
                           000001     2 	ERR_SYNTAX==ERR_IDX 
                           000002     3 	ERR_IDX=ERR_IDX+1
      00146A                         21 	_err_entry err_gt32767,ERR_GT32767 
      0094EA 95 13                    1 	.word err_gt32767  
                           000002     2 	ERR_GT32767==ERR_IDX 
                           000003     3 	ERR_IDX=ERR_IDX+1
      00146C                         22 	_err_entry err_gt255,ERR_GT255 
      0094EC 95 1A                    1 	.word err_gt255  
                           000003     2 	ERR_GT255==ERR_IDX 
                           000004     3 	ERR_IDX=ERR_IDX+1
      00146E                         23 	_err_entry err_bad_branch,ERR_BAD_BRANCH 
      0094EE 95 1F                    1 	.word err_bad_branch  
                           000004     2 	ERR_BAD_BRANCH==ERR_IDX 
                           000005     3 	ERR_IDX=ERR_IDX+1
      001470                         24 	_err_entry err_bad_return,ERR_BAD_RETURN 
      0094F0 95 2A                    1 	.word err_bad_return  
                           000005     2 	ERR_BAD_RETURN==ERR_IDX 
                           000006     3 	ERR_IDX=ERR_IDX+1
      001472                         25 	_err_entry err_bad_next,ERR_BAD_NEXT 
      0094F2 95 35                    1 	.word err_bad_next  
                           000006     2 	ERR_BAD_NEXT==ERR_IDX 
                           000007     3 	ERR_IDX=ERR_IDX+1
      001474                         26 	_err_entry err_gt8_gosub,ERR_GOSUBS 
      0094F4 95 3E                    1 	.word err_gt8_gosub  
                           000007     2 	ERR_GOSUBS==ERR_IDX 
                           000008     3 	ERR_IDX=ERR_IDX+1
      001476                         27 	_err_entry err_gt8_fors, ERR_FORS 
      0094F6 95 48                    1 	.word err_gt8_fors  
                           000008     2 	ERR_FORS==ERR_IDX 
                           000009     3 	ERR_IDX=ERR_IDX+1
      001478                         28 	_err_entry err_end, ERR_END 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 141.
Hexadecimal [24-Bits]



      0094F8 95 50                    1 	.word err_end  
                           000009     2 	ERR_END==ERR_IDX 
                           00000A     3 	ERR_IDX=ERR_IDX+1
      00147A                         29 	_err_entry err_mem_full, ERR_MEM_FULL
      0094FA 95 54                    1 	.word err_mem_full  
                           00000A     2 	ERR_MEM_FULL==ERR_IDX 
                           00000B     3 	ERR_IDX=ERR_IDX+1
      00147C                         30 	_err_entry err_too_long, ERR_TOO_LONG 
      0094FC 95 5D                    1 	.word err_too_long  
                           00000B     2 	ERR_TOO_LONG==ERR_IDX 
                           00000C     3 	ERR_IDX=ERR_IDX+1
      00147E                         31 	_err_entry err_dim, ERR_DIM 
      0094FE 95 66                    1 	.word err_dim  
                           00000C     2 	ERR_DIM==ERR_IDX 
                           00000D     3 	ERR_IDX=ERR_IDX+1
      001480                         32 	_err_entry err_range, ERR_RANGE 
      009500 95 6A                    1 	.word err_range  
                           00000D     2 	ERR_RANGE==ERR_IDX 
                           00000E     3 	ERR_IDX=ERR_IDX+1
      001482                         33 	_err_entry err_str_ovfl, ERR_STR_OVFL 
      009502 95 70                    1 	.word err_str_ovfl  
                           00000E     2 	ERR_STR_OVFL==ERR_IDX 
                           00000F     3 	ERR_IDX=ERR_IDX+1
      001484                         34 	_err_entry err_string, ERR_STRING 
      009504 95 79                    1 	.word err_string  
                           00000F     2 	ERR_STRING==ERR_IDX 
                           000010     3 	ERR_IDX=ERR_IDX+1
      001486                         35 	_err_entry err_retype, ERR_RETYPE 
      009506 95 80                    1 	.word err_retype  
                           000010     2 	ERR_RETYPE==ERR_IDX 
                           000011     3 	ERR_IDX=ERR_IDX+1
      001488                         36 	_err_entry err_prog_only, ERR_PROG_ONLY  
      009508 95 8C                    1 	.word err_prog_only  
                           000011     2 	ERR_PROG_ONLY==ERR_IDX 
                           000012     3 	ERR_IDX=ERR_IDX+1
      00148A                         37 	_err_entry err_div0, ERR_DIV0 
      00950A 95 99                    1 	.word err_div0  
                           000012     2 	ERR_DIV0==ERR_IDX 
                           000013     3 	ERR_IDX=ERR_IDX+1
                                     38 
                                     39 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     40 ; error messages strings table 
                                     41 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      00950C                         42 error_messages: 
                                     43 
      00950C 53 59 4E 54 41 58 00    44 err_syntax: .asciz "SYNTAX"
      009513 3E 33 32 37 36 37 00    45 err_gt32767: .asciz ">32767" 
      00951A 3E 32 35 35 00          46 err_gt255: .asciz ">255" 
      00951F 42 41 44 20 42 52 41    47 err_bad_branch: .asciz "BAD BRANCH" 
             4E 43 48 00
      00952A 42 41 44 20 52 45 54    48 err_bad_return: .asciz "BAD RETURN" 
             55 52 4E 00
      009535 42 41 44 20 4E 45 58    49 err_bad_next: .asciz "BAD NEXT" 
             54 00
      00953E 3E 38 20 47 4F 53 55    50 err_gt8_gosub: .asciz ">8 GOSUBS"  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 142.
Hexadecimal  42-Bits]



             42 53 00
      009546 53 00 3E 38 20 46 4F    51 err_gt8_fors: .asciz ">8 FORS" 
             52
      00954E 53 00 45 4E             52 err_end: .asciz "END" 
      009552 44 00 4D 45 4D 20 46    53 err_mem_full: .asciz "MEM FULL" 
             55 4C
      00955B 4C 00 54 4F 4F 20 4C    54 err_too_long: .asciz "TOO LONG" 
             4F 4E
      009564 47 00 44 49             55 err_dim: .asciz "DIM" 
      009568 4D 00 52 41 4E 47       56 err_range: .asciz "RANGE"
      00956E 45 00 53 54 52 20 4F    57 err_str_ovfl: .asciz "STR OVFL" 
             56 46
      009577 4C 00 53 54 52 49 4E    58 err_string: .asciz "STRING" 
      00957E 47 00 52 45 54 59 50    59 err_retype: .asciz "RETYPE LINE" 
             45 20 4C 49 4E
      00958A 45 00 50 52 4F 47 52    60 err_prog_only: .asciz "PROGRAM ONLY" 
             41 4D 20 4F 4E 4C
      009597 59 00 44 49 56 20 42    61 err_div0: .asciz "DIV BY 0" 
             59 20
                                     62 
                                     63 ;-------------------------------------
      0095A0 30 00 0A 72 75 6E 20    64 rt_msg: .asciz "\nrun time error, "
             74 69 6D 65 20 65 72
             72 6F 72 2C
      0095B2 20 00 0A 63 6F 6D 70    65 comp_msg: .asciz "\ncompile error, "
             69 6C 65 20 65 72 72
             6F 72 2C
      0095C3 20 00 2A 2A 2A          66 err_stars: .asciz "*** " 
      0095C8 20 00 20 45 52 52 4F    67 err_err: .asciz " ERROR \n" 
             52 20
                                     68 
      001553                         69 syntax_error::
      0095D1 0A 00            [ 1]   70 	ld a,#ERR_SYNTAX 
      0095D3                         71 tb_error::
      0095D3 A6 01 00 3B 19   [ 2]   72 	btjt flags,#FCOMP,1$
      0095D5 88               [ 1]   73 	push a 
      0095D5 72 0A 00         [ 2]   74 	ldw x, #rt_msg 
      0095D8 3B 19 88         [ 4]   75 	call puts
      0095DB AE               [ 1]   76 0$:	pop a 
      0095DC 95 A2            [ 4]   77 	callr print_err_msg
      0095DE CD 85 A3 84      [ 2]   78 	subw y, line.addr 
      0095E2 AD 35            [ 1]   79 	ld a,yl 
      0095E4 72 B2            [ 1]   80 	sub a,#LINE_HEADER_SIZE 
      00156C                         81 	_ldxz line.addr 
      0095E6 00 2B                    1     .byte 0xbe,line.addr 
      0095E8 90 9F A0         [ 4]   82 	call prt_basic_line
      0095EB 03 BE            [ 2]   83 	jra 6$
      001573                         84 1$:	
      0095ED 2B               [ 1]   85 	push a 
      0095EE CD 9E 55         [ 2]   86 	ldw x,#comp_msg
      0095F1 20 1F 23         [ 4]   87 	call puts 
      0095F3 84               [ 1]   88 	pop a 
      0095F3 88 AE            [ 4]   89 	callr print_err_msg
      0095F5 95 B4 CD         [ 2]   90 	ldw x,#tib
      0095F8 85 A3 84         [ 4]   91 	call puts 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 143.
Hexadecimal [24-Bits]



      0095FB AD 1C            [ 1]   92 	ld a,#CR 
      0095FD AE 16 80         [ 4]   93 	call putc
      001588                         94 	_ldxz in.w
      009600 CD 85                    1     .byte 0xbe,in.w 
      009602 A3 A6 0D         [ 4]   95 	call spaces
      009605 CD 85            [ 1]   96 	ld a,#'^
      009607 2C BE 28         [ 4]   97 	call putc 
      001592                         98 6$:
      00960A CD 86 0C         [ 2]   99 	ldw x,#STACK_EMPTY 
      00960D A6               [ 1]  100     ldw sp,x
      00960E 5E CD 85         [ 2]  101 	jp warm_start 
                                    102 	
                                    103 ;------------------------
                                    104 ; print error message 
                                    105 ; input:
                                    106 ;    A   error code 
                                    107 ; output:
                                    108 ;	 none 
                                    109 ;------------------------
      001599                        110 print_err_msg:
      009611 2C               [ 1]  111 	push a 
      009612 AE 15 45         [ 2]  112 	ldw x,#err_stars 
      009612 AE 17 FF         [ 4]  113 	call puts
      009615 94               [ 1]  114 	pop a 
      009616 CC               [ 1]  115 	clrw x 
      009617 97               [ 1]  116 	ld xl,a 
      009618 28               [ 2]  117 	sllw x 
      009619 1C 14 66         [ 2]  118 	addw x,#err_msg_idx 
      009619 88               [ 2]  119 	ldw x,(x)
      00961A AE 95 C5         [ 4]  120 	call puts 
      00961D CD 85 A3         [ 2]  121 	ldw x,#err_err 
      009620 84 5F 97         [ 4]  122 	call puts 
      009623 58               [ 4]  123 	ret 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 144.
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
                                     19 ;--------------------------------------
                                     20 ;   Implementation of Tiny BASIC
                                     21 ;   REF: https://en.wikipedia.org/wiki/Li-Chen_Wang#Palo_Alto_Tiny_BASIC
                                     22 ;   Palo Alto BASIC is 4th version of TinyBasic
                                     23 ;   DATE: 2019-12-17
                                     24 ;
                                     25 ;--------------------------------------------------
                                     26 ;     implementation information
                                     27 ;
                                     28 ; *  integer are 16 bits two's complement  
                                     29 ;
                                     30 ; *  register Y is used as basicptr    
                                     31 ; 
                                     32 ;    IMPORTANT: when a routine use Y it must preserve 
                                     33 ;               its content and restore it at exit.
                                     34 ;               This hold only when BASIC is running  
                                     35 ;               
                                     36 ; *  BASIC function return their value registers 
                                     37 ;    A character 
                                     38 ;	 X integer || address 
                                     39 ; 
                                     40 ;  * variables return their value in X 
                                     41 ;
                                     42 ;--------------------------------------------------- 
                                     43 
                           000000    44 SEPARATE=0 
                                     45 
                           000000    46 .if SEPARATE 
                                     47     .module TINY_BASIC 
                                     48     .include "config.inc"
                                     49 
                                     50 	.area CODE 
                                     51 .endif 
                                     52 
                                     53 
                                     54 ;---------------------------------------
                                     55 ;   BASIC configuration parameters
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 145.
Hexadecimal [24-Bits]



                                     56 ;---------------------------------------
                           001500    57 MAX_CODE_SIZE=5376 ; 42*BLOCK_SIZE multiple of BLOCK_SIZE=128 bytes  
                           000080    58 MIN_VAR_SIZE=BLOCK_SIZE ; FREE_RAM-MAX_CODE_SIZE 128 bytes 
                           000010    59 PENDING_STACK_SIZE= 16 ; pending operation stack 
                                     60 
                                     61 ;--------------------------------------
                                     62     .area DATA
      000028                         63 	.org APP_VARS_START_ADR 
                                     64 ;--------------------------------------	
                                     65 
                                     66 ; keep the following 3 variables in this order 
      000028                         67 in.w::  .blkb 1 ; used by compiler 
      000029                         68 in::    .blkb 1 ; low byte of in.w 
      00002A                         69 count:: .blkb 1 ; current BASIC line length and tib text length  
      00002B                         70 line.addr:: .blkw 1 ; BASIC line start at this address. 
      00002D                         71 basicptr::  .blkw 1  ; BASIC interperter program pointer.
                                     72 ;data_line:: .blkw 1  ; data line address 
                                     73 ;data_ptr:  .blkw 1  ; point to DATA in line 
      00002F                         74 lomem:: .blkw 1 ; tokenized BASIC area beginning address 
      000031                         75 himem:: .blkw 1 ; tokenized BASIC area end before this address 
      000033                         76 progend:: .blkw 1 ; address end of BASIC program 
      000035                         77 dvar_bgn:: .blkw 1 ; DIM variables start address 
      000037                         78 dvar_end:: .blkw 1 ; DIM variables end address 
      000039                         79 heap_free:: .blkw 1 ; free RAM growing down from tib 
      00003B                         80 flags:: .blkb 1 ; various boolean flags
      00003C                         81 auto_line: .blkw 1 ; automatic line number  
      00003E                         82 auto_step: .blkw 1 ; automatic lein number increment 
                                     83 ; chain_level: .blkb 1 ; increment for each CHAIN command 
      000040                         84 for_nest: .blkb 1 ; nesting level of FOR...NEXT , maximum 8 
      000041                         85 gosub_nest: .blkb 1 ; nesting level of GOSUB, maximum 8 
                                     86 ; pending stack is used by compiler to check syntax, like matching pair 
      000042                         87 psp: .blkw 1 ; pending_stack pointer 
      000044                         88 pending_stack: .blkb PENDING_STACK_SIZE ; pending operations stack 
      000054                         89 file_header: .blkb FILE_HEADER_SIZE ; buffer to hold file header structure 
                                     90 
                                     91 ;------------------------------
                                     92 	.area DATA
      000100                         93 	.org 0x100 
                                     94 ;-------------------------------
                                     95 ; BASIC programs compiled here
      000100                         96 free_ram: 
                                     97 
                                     98 
                                     99 	.area CODE 
                                    100 
                                    101 ;-------------------------------------
                                    102 ;-----------------------
                                    103 ;  display system 
                                    104 ;  information 
                                    105 ;-----------------------
                           000001   106 	MAJOR=1
                           000000   107 	MINOR=0
                           000000   108 	REV=0
                                    109 		
      009624 1C 94 E6 FE CD 85 A3   110 copyright_info: .asciz "\npomme BASIC\nCopyright, Jacques Deschenes 2023\nversion "
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 146.
Hexadecimal  AE-Bits]



             42 41 53 49 43 0A 43
             6F 70 79 72 69 67 68
             74 2C 20 4A 61 63 71
             75 65 73 20 44 65 73
             63 68 65 6E 65 73 20
             32 30 32 33 0A 76 65
             72 73 69 6F 6E 20 00
                                    111 
      0015EA                        112 print_copyright:
      00962C 95 CA CD         [ 1]  113 	push base 
      00962F 85 A3 81 0F      [ 1]  114 	mov base, #10 
      000028 AE 15 B2         [ 2]  115 	ldw x,#copyright_info 
      000028 CD 05 23         [ 4]  116 	call puts 
      000029 A6 01            [ 1]  117 	ld a,#MAJOR 
      00002A CD 07 AC         [ 4]  118 	call prt_i8
      00002B CD 05 59         [ 4]  119 	call bksp  
      00002D A6 2E            [ 1]  120 	ld a,#'.
      00002F CD 04 AC         [ 4]  121 	call putc 
      000031 A6 00            [ 1]  122 	ld a,#MINOR
      000033 CD 07 AC         [ 4]  123 	call prt_i8   
      000035 CD 05 59         [ 4]  124 	call bksp 
      000037 A6 52            [ 1]  125 	ld a,#'R 
      000039 CD 04 AC         [ 4]  126 	call putc 
      00003B A6 00            [ 1]  127 	ld a,#REV 
      00003C CD 07 AC         [ 4]  128 	call prt_i8
      00003E A6 0D            [ 1]  129 	ld a,#CR 
      000040 CD 04 AC         [ 4]  130 	call putc
      000041 32 00 0F         [ 1]  131 	pop base 
      000042 81               [ 4]  132 	ret
                                    133 
                                    134 ;------------------------------
                                    135 ;  les variables ne sont pas 
                                    136 ;  réinitialisées.
                                    137 ;-----------------------------
      000044                        138 warm_init:
      000054 AE 04 C1         [ 2]  139 	ldw x,#uart_putc 
      000100 CF 00 1A         [ 2]  140 	ldw out,x ; standard output   
      000100                        141 	_clrz flags 
      009632 0A 70                    1     .byte 0x3f, flags 
      009634 6F 6D 6D 65      [ 1]  142 	mov base,#10 
      00162B                        143 	_rst_pending 
      009638 20 42 41         [ 2]    1     ldw x,#pending_stack+PENDING_STACK_SIZE
      00162E                          2     _strxz psp 
      00963B 53 49                    1     .byte 0xbf,psp 
      00963D 43               [ 4]  144 	ret 
                                    145 
                                    146 ;---------------------------
                                    147 ; reset BASIC system variables 
                                    148 ; and clear BASIC program 
                                    149 ; variables  
                                    150 ;---------------------------
      001631                        151 reset_basic:
      00963E 0A               [ 2]  152 	pushw x 
      00963F 43 6F 70         [ 2]  153 	ldw x,#free_ram 
      001635                        154 	_strxz lomem
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 147.
Hexadecimal [24-Bits]



      009642 79 72                    1     .byte 0xbf,lomem 
      001637                        155 	_strxz progend  
      009644 69 67                    1     .byte 0xbf,progend 
      001639                        156 	_strxz dvar_bgn 
      009646 68 74                    1     .byte 0xbf,dvar_bgn 
      00163B                        157 	_strxz dvar_end
      009648 2C 20                    1     .byte 0xbf,dvar_end 
      00964A 4A 61 63         [ 2]  158 	ldw x,#tib 
      001640                        159 	_strxz himem 
      00964D 71 75                    1     .byte 0xbf,himem 
      001642                        160 	_strxz heap_free 
      00964F 65 73                    1     .byte 0xbf,heap_free 
      001644                        161 	_clrz flags
      009651 20 44                    1     .byte 0x3f, flags 
      009653 65               [ 1]  162 	clrw x 
      001647                        163 	_strxz for_nest 
      009654 73 63                    1     .byte 0xbf,for_nest 
      001649                        164 	_strxz psp 
      009656 68 65                    1     .byte 0xbf,psp 
      009658 6E 65            [ 1]  165 	ld a,#10 
      00164D                        166 	_straz auto_line 
      00965A 73 20                    1     .byte 0xb7,auto_line 
      00164F                        167 	_straz auto_step  
      00965C 32 30                    1     .byte 0xb7,auto_step 
      00965E 32               [ 2]  168 	popw x
      00965F 33               [ 4]  169 	ret 
                                    170 
      001653                        171 P1BASIC:: 
                                    172 ; enable SPI for file system 
      009660 0A 76 65         [ 4]  173 	call spi_enable 
                                    174 ; reset hardware stack 
      009663 72 73 69         [ 2]  175     ldw x,#STACK_EMPTY 
      009666 6F               [ 1]  176     ldw sp,x 
                                    177 ; upper case letters
      009667 6E 20 00 0A      [ 1]  178 	bset sys_flags,#FSYS_UPPER	
      00966A CD 16 31         [ 4]  179 	call reset_basic
                                    180 ; initialize operation pending stack 	
      001661                        181 	_rst_pending 
      00966A 3B 00 0F         [ 2]    1     ldw x,#pending_stack+PENDING_STACK_SIZE
      001664                          2     _strxz psp 
      00966D 35 0A                    1     .byte 0xbf,psp 
      00966F 00 0F AE         [ 4]  182 	call print_copyright ; display system information
      009672 96 32 CD         [ 4]  183 	call free 
                                    184 ; set ctrl_c_vector
      009675 85 A3 A6         [ 2]  185 	ldw x,#ctrl_c_stop 
      00166F                        186 	_strxz ctrl_c_vector 
      009678 01 CD                    1     .byte 0xbf,ctrl_c_vector 
                                    187 ; RND function seed 
                                    188 ; must be initialized 
                                    189 ; to value other than 0.
                                    190 ; take values from ROM space 
      00967A 88 2C CD         [ 2]  191 	ldw x,0x6000
      00967D 85               [ 2]  192 	ldw x,(x)
      00967E D9 A6 2E         [ 2]  193 	ldw seedy,x  
      009681 CD 85 2C         [ 2]  194 	ldw x,0x6006 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 148.
Hexadecimal [24-Bits]



      009684 A6               [ 2]  195 	ldw x,(x)
      009685 00 CD 88         [ 2]  196 	ldw seedx,x  
      009688 2C CD            [ 2]  197 	jra warm_start 
                                    198 
      00968A 85 D9 A6 52 CD 85 2C   199 ctrl_c_msg: .asciz "\nSTOPPED AT " 	
             A6 00 CD 88 2C A6
                                    200 ;-------------------------------
                                    201 ; while a program is running 
                                    202 ; CTRL+C end program
                                    203 ;--------------------------- 
      00168E                        204 ctrl_c_stop: 
      009697 0D CD 85         [ 2]  205 	ldw x,#ctrl_c_msg 
      00969A 2C 32 00         [ 4]  206 	call puts 
      00969D 0F 81 2B         [ 2]  207 	ldw x,line.addr 
      00969F FE               [ 2]  208 	ldw x,(x)
      00969F AE 85 41         [ 4]  209 	call print_int
      0096A2 CF 00 1A         [ 4]  210 	call new_line 
      0096A5 3F 3B 35         [ 2]  211 	ldw x,#STACK_EMPTY 
      0096A8 0A               [ 1]  212 	ldw sp,x
      0096A9 00 0F AE 00      [ 1]  213 	bres flags,#FRUN
      0096AD 54 BF            [ 2]  214 	jra cmd_line 
      0016A8                        215 warm_start:
      0096AF 42 81 1F         [ 4]  216 	call warm_init
                                    217 ;----------------------------
                                    218 ;   BASIC interpreter
                                    219 ;----------------------------
      0096B1                        220 cmd_line: ; user interface 
      0096B1 89 AE            [ 1]  221 	ld a,#CR 
      0096B3 01 00 BF         [ 4]  222 	call putc 
      0096B6 2F BF            [ 1]  223 	ld a,#'> 
      0096B8 33 BF 35         [ 4]  224 	call putc
      0096BB BF 37            [ 1]  225 	push #0 
                                    226 ;	clr tib
      0096BD AE 16 80 BF 31   [ 2]  227 	btjf flags,#FAUTO,1$ 
      0016BC                        228 	_ldxz auto_line 
      0096C2 BF 39                    1     .byte 0xbe,auto_line 
      0096C4 3F 3B 5F         [ 4]  229 	call itoa
      0096C7 BF 40            [ 1]  230 	ld (1,sp),a  
      0096C9 BF 42            [ 1]  231 	ldw y,x 
      0096CB A6 0A B7         [ 2]  232 	ldw x,#tib 
      0096CE 3C B7 3E         [ 4]  233 	call strcpy 
      0016CB                        234 	_ldxz auto_line 
      0096D1 85 81                    1     .byte 0xbe,auto_line 
      0096D3 72 BB 00 3E      [ 2]  235 	addw x,auto_step 
      0016D1                        236 	_strxz auto_line
      0096D3 CD 89                    1     .byte 0xbf,auto_line 
      0096D5 30               [ 1]  237 1$: pop a 
      0096D6 AE 17 FF         [ 4]  238 	call readln
      0096D9 94               [ 1]  239 	tnz a 
      0096DA 72 14            [ 1]  240 	jreq cmd_line
      0096DC 00 0A CD         [ 4]  241 	call compile
      0096DF 96               [ 1]  242 	tnz a 
      0096E0 B1 AE            [ 1]  243 	jreq cmd_line ; not direct command
                                    244 
                                    245 ;; direct command 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 149.
Hexadecimal [24-Bits]



                                    246 ;; interpret 
                                    247 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    248 ;; This is the interpreter loop
                                    249 ;; for each BASIC code line.
                                    250 ;; 10 cycles  
                                    251 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
      0016E0                        252 do_nothing: 
      0016E0                        253 interp_loop:   
      0016E0                        254     _next_cmd ; command bytecode, 2 cy  
      0016E0                          1         _get_char       ; 2 cy 
      0096E2 00 54            [ 1]    1         ld a,(y)    ; 1 cy 
      0096E4 BF 42            [ 1]    2         incw y      ; 1 cy 
      0016E4                        255 	_jp_code ; 8 cy + 2 cy for jump back to interp_loop  
      0016E4                          1         _code_addr 
      0096E6 CD               [ 1]    1         clrw x   ; 1 cy 
      0096E7 96               [ 1]    2         ld xl,a  ; 1 cy 
      0096E8 6A               [ 2]    3         sllw x   ; 2 cy 
      0096E9 CD A7 13         [ 2]    4         ldw x,(code_addr,x) ; 2 cy 
      0096EC AE               [ 2]    2         jp (x)
                                    256 
                                    257 ;---------------------
                                    258 ; BASIC: REM | ' 
                                    259 ; skip comment to end of line 
                                    260 ;---------------------- 
      0016EB                        261 kword_remark::
      0096ED 97 0E BF 1C      [ 2]  262 	ldw y,line.addr 
      0096F1 CE 60 00         [ 1]  263 	ld a,(2,y) ; line length 
      0016F2                        264 	_straz in  
      0096F4 FE CF                    1     .byte 0xb7,in 
      0096F6 00 0D CE 60      [ 2]  265 	addw y,in.w   
                                    266 
                                    267 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    268 ; move basicptr to first token 
                                    269 ; of next line 
                                    270 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0016F8                        271 next_line:
      0096FA 06 FE CF 00 0B   [ 2]  272 	btjf flags,#FRUN,cmd_line
      0096FF 20 27 0A 53      [ 2]  273 	cpw y,progend
      009703 54 4F            [ 1]  274 	jrmi 1$
      001703                        275 0$:
      009705 50 50            [ 1]  276 	ld a,#ERR_END 
      009707 45 44 20         [ 2]  277 	jp tb_error 
                                    278 ;	jp kword_end 
      001708                        279 1$:	
      001708                        280 	_stryz line.addr 
      00970A 41 54 20                 1     .byte 0x90,0xbf,line.addr 
      00970D 00 A9 00 03      [ 2]  281 	addw y,#LINE_HEADER_SIZE
      00970E 72 0F 00 3B 03   [ 2]  282 	btjf flags,#FTRACE,2$
      00970E AE 97 01         [ 4]  283 	call prt_line_no 
      001717                        284 2$:	
      001717                        285   _next 
      009711 CD 85 A3         [ 2]    1         jp interp_loop 
                                    286 
                                    287 
                                    288 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 150.
Hexadecimal [24-Bits]



                                    289 ;------------------------
                                    290 ; when TRACE is active 
                                    291 ; print line number to 
                                    292 ; be executed by VM
                                    293 ;------------------------
      00171A                        294 prt_line_no:
      009714 CE 00 2B FE      [ 5]  295 	ldw x,[line.addr] 
      009718 CD 88 2E         [ 4]  296 	call print_int 
      00971B CD 85            [ 1]  297 	ld a,#CR 
      00971D E9 AE 17         [ 4]  298 	call putc 
      009720 FF               [ 4]  299 	ret 
                                    300 
                                    301 
                                    302 ;-------------------------
                                    303 ;  skip .asciz in BASIC line 
                                    304 ;  name 
                                    305 ;  input:
                                    306 ;     x		* string 
                                    307 ;  output:
                                    308 ;     none 
                                    309 ;-------------------------
      001727                        310 skip_string:
      009721 94 72            [ 1]  311 	ld a,(y)
      009723 11 00            [ 1]  312 	jreq 8$
      009725 3B 20            [ 1]  313 1$:	incw y
      009727 03 F6            [ 1]  314 	ld a,(y)
      009728 26 FA            [ 1]  315 	jrne 1$  
      009728 CD 96            [ 1]  316 8$: incw y
      00972A 9F               [ 4]  317 	ret 
                                    318 
                                    319 ;-------------------------------
                                    320 ; called when an intger token 
                                    321 ; is expected. can be LIT_IDX 
                                    322 ; or LITW_IDX 
                                    323 ; program fail if not integer 
                                    324 ;------------------------------
      00972B                        325 expect_integer:
      001734                        326 	_next_token 
      001734                          1         _get_char 
      00972B A6 0D            [ 1]    1         ld a,(y)    ; 1 cy 
      00972D CD 85            [ 1]    2         incw y      ; 1 cy 
      00972F 2C A6            [ 1]  327 	cp a,#LITW_IDX 
      009731 3E CD            [ 1]  328 	jreq 0$
      009733 85 2C 4B         [ 2]  329 	jp syntax_error
      00173F                        330 0$:	_get_word 
      00173F                          1         _get_addr
      009736 00               [ 1]    1         ldw x,y     ; 1 cy 
      009737 72               [ 2]    2         ldw x,(x)   ; 2 cy 
      009738 0D 00 3B 17      [ 2]    3         addw y,#2   ; 2 cy 
      00973C BE               [ 4]  331 	ret 
                                    332 
                                    333 
                                    334 ;--------------------------
                                    335 ; input:
                                    336 ;   A      character 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 151.
Hexadecimal [24-Bits]



                                    337 ; output:
                                    338 ;   A      digit 
                                    339 ;   Cflag   1 ok, 0 failed 
                                    340 ; use:
                                    341 ;   base
                                    342 ;------------------------------   
      001746                        343 char_to_digit:
      00973D 3C CD            [ 1]  344 	sub a,#'0
      00973F 88 39            [ 1]  345 	jrmi 9$ 
      009741 6B 01            [ 1]  346 	cp a,#10
      009743 90 93            [ 1]  347 	jrmi 5$
      009745 AE 16            [ 1]  348 	cp a,#17 
      009747 80 CD            [ 1]  349 	jrmi 9$   
      009749 88 A0            [ 1]  350 	sub a,#7 
      00974B BE 3C 72         [ 1]  351 	cp a,base 
      00974E BB 00            [ 1]  352 	jrpl 9$	 
      009750 3E               [ 1]  353 5$: scf ; ok 
      009751 BF               [ 4]  354 	ret 
      009752 3C               [ 1]  355 9$: rcf ; failed 
      009753 84               [ 4]  356 	ret 
                                    357 
                                    358 ;------------------------------------
                                    359 ; convert pad content in integer
                                    360 ; input:
                                    361 ;    Y		* .asciz to convert
                                    362 ; output:
                                    363 ;    X        int16_t
                                    364 ;    Y        * .asciz after integer  
                                    365 ;    acc16    int16_t 
                                    366 ; use:
                                    367 ;   base 
                                    368 ;------------------------------------
                                    369 	; local variables
                           000001   370 	N=1 ; INT_SIZE  
                           000003   371 	DIGIT=N+INT_SIZE 
                           000005   372 	SIGN=DIGIT+INT_SIZE ; 1 byte, 
                           000005   373 	VSIZE=SIGN   
      00175D                        374 atoi16::
      00175D                        375 	_vars VSIZE
      009754 CD 86            [ 2]    1     sub sp,#VSIZE 
                                    376 ; conversion made on stack 
      009756 79 4D 27 D1      [ 1]  377 	mov base, #10 ; defaul conversion base 
      00975A CD 91            [ 1]  378 	clr (DIGIT,sp)
      00975C 0C               [ 1]  379 	clrw x 
      001766                        380 	_i16_store N   
      00975D 4D 27            [ 2]    1     ldw (N,sp),x 
      00975F CB 05            [ 1]  381 	clr (SIGN,sp)
      009760 90 F6            [ 1]  382 	ld a,(y)
      009760 27 2B            [ 1]  383 	jreq 9$  ; completed if 0
      009760 90 F6            [ 1]  384 	cp a,#'-
      009762 90 5C            [ 1]  385 	jrne 1$ 
      009764 5F 97            [ 1]  386 	cpl (SIGN,sp)
      009766 58 DE            [ 2]  387 	jra 2$
      001776                        388 1$:  
      009768 8C 71            [ 1]  389 	cp a,#'$ 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 152.
Hexadecimal [24-Bits]



      00976A FC 0A            [ 1]  390 	jrne 3$ 
      00976B 35 10 00 0F      [ 1]  391 	mov base,#16 ; hexadecimal base 
      00976B 90 CE            [ 1]  392 2$:	incw y
      00976D 00 2B            [ 1]  393 	ld a,(y)
      00976F 90 E6            [ 1]  394 	jreq 9$ 
      001784                        395 3$:	; char to digit 
      009771 02 B7 29         [ 4]  396 	call char_to_digit
      009774 72 B9            [ 1]  397 	jrnc 9$
      009776 00 28            [ 1]  398 	ld (DIGIT+1,sp),a 
      009778                        399 	_i16_fetch N  ; X=N 
      009778 72 01            [ 2]    1     ldw x,(N,sp)
      00178D                        400 	_ldaz base   
      00977A 00 3B                    1     .byte 0xb6,base 
      00977C AE 90 C3         [ 4]  401 	call umul16_8      
      00977F 00 33 2B         [ 2]  402 	addw x,(DIGIT,sp)
      001795                        403 	_i16_store N  
      009782 05 01            [ 2]    1     ldw (N,sp),x 
      009783 20 E5            [ 2]  404 	jra 2$
      001799                        405 9$:	_i16_fetch N
      009783 A6 09            [ 2]    1     ldw x,(N,sp)
      009785 CC 95            [ 1]  406 	tnz (SIGN,sp)
      009787 D5 01            [ 1]  407     jreq 10$
      009788 50               [ 2]  408     negw x
      0017A0                        409 10$:
      0017A0                        410 	_strxz acc16  
      009788 90 BF                    1     .byte 0xbf,acc16 
      0017A2                        411 	_drop VSIZE
      00978A 2B 72            [ 2]    1     addw sp,#VSIZE 
      00978C A9               [ 4]  412 	ret
                                    413 
                                    414 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    415 ;;   pomme BASIC  operators,
                                    416 ;;   commands and functions 
                                    417 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    418 
                                    419 ;---------------------------------
                                    420 ; dictionary search 
                                    421 ; input:
                                    422 ;	X 		dictionary entry point, name field  
                                    423 ;   y		.asciz name to search 
                                    424 ; output:
                                    425 ;  A		TOKEN_IDX  
                                    426 ;---------------------------------
                           000001   427 	NLEN=1 ; cmd length 
                           000003   428 	XSAVE=NLEN+2
                           000005   429 	YSAVE=XSAVE+2
                           000006   430 	VSIZE=YSAVE+1
      0017A5                        431 search_dict::
      0017A5                        432 	_vars VSIZE 
      00978D 00 03            [ 2]    1     sub sp,#VSIZE 
      00978F 72 0F            [ 1]  433 	clr (NLEN,sp)
      009791 00 3B            [ 2]  434 	ldw (YSAVE,sp),y 
      0017AB                        435 search_next:
      009793 03 CD            [ 2]  436 	ldw (XSAVE,sp),x 
                                    437 ; get name length in dictionary	
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 153.
Hexadecimal [24-Bits]



      009795 97               [ 1]  438 	ld a,(x)
      009796 9A 02            [ 1]  439 	ld (NLEN+1,sp),a  
      009797 16 05            [ 2]  440 	ldw y,(YSAVE,sp) ; name pointer 
      009797 CC               [ 1]  441 	incw x 
      009798 97 60 11         [ 4]  442 	call strcmp 
      00979A 27 0C            [ 1]  443 	jreq str_match 
      0017B8                        444 no_match:
      00979A 72 CE            [ 2]  445 	ldw x,(XSAVE,sp) 
      00979C 00 2B CD         [ 2]  446 	subw x,#2 ; move X to link field
      00979F 88 2E            [ 1]  447 	ld a,#NONE_IDX   
      0097A1 A6               [ 2]  448 	ldw x,(x) ; next word link 
      0097A2 0D CD            [ 1]  449 	jreq search_exit  ; not found  
                                    450 ;try next 
      0097A4 85 2C            [ 2]  451 	jra search_next
      0017C4                        452 str_match:
      0097A6 81 03            [ 2]  453 	ldw x,(XSAVE,sp)
      0097A7 72 FB 01         [ 2]  454 	addw x,(NLEN,sp)
                                    455 ; move x to token field 	
      0097A7 90 F6 27         [ 2]  456 	addw x,#2 ; to skip length byte and 0 at end  
      0097AA 06               [ 1]  457 	ld a,(x) ; token index
      0017CD                        458 search_exit: 
      0017CD                        459 	_drop VSIZE 
      0097AB 90 5C            [ 2]    1     addw sp,#VSIZE 
      0097AD 90               [ 4]  460 	ret 
                                    461 
                                    462 
                                    463 ;---------------------
                                    464 ; check if next token
                                    465 ;  is of expected type 
                                    466 ; input:
                                    467 ;   A 		 expected token attribute
                                    468 ;  ouput:
                                    469 ;   none     if fail call syntax_error 
                                    470 ;--------------------
      0017D0                        471 expect:
      0097AE F6               [ 1]  472 	push a 
      0017D1                        473 	_next_token 
      0017D1                          1         _get_char 
      0097AF 26 FA            [ 1]    1         ld a,(y)    ; 1 cy 
      0097B1 90 5C            [ 1]    2         incw y      ; 1 cy 
      0097B3 81 01            [ 1]  474 	cp a,(1,sp)
      0097B4 27 03            [ 1]  475 	jreq 1$
      0097B4 90 F6 90         [ 2]  476 	jp syntax_error
      0097B7 5C               [ 1]  477 1$: pop a 
      0097B8 A1               [ 4]  478 	ret 
                                    479 
                                    480 ;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    481 ; parse arguments list 
                                    482 ; between ()
                                    483 ;;;;;;;;;;;;;;;;;;;;;;;;;;
      0017DE                        484 func_args:
      0017DE                        485 	_next_token 
      0017DE                          1         _get_char 
      0097B9 08 27            [ 1]    1         ld a,(y)    ; 1 cy 
      0097BB 03 CC            [ 1]    2         incw y      ; 1 cy 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 154.
Hexadecimal [24-Bits]



      0097BD 95 D3            [ 1]  486 	cp a,#LPAREN_IDX 
      0097BF 93 FE            [ 1]  487 	jreq arg_list 
      0097C1 72 A9 00         [ 2]  488 	jp syntax_error 
                                    489 
                                    490 ; expected to continue in arg_list 
                                    491 ; caller must check for RPAREN_IDX 
                                    492 
                                    493 ;-------------------------------
                                    494 ; parse embedded BASIC routines 
                                    495 ; arguments list.
                                    496 ; arg_list::=  expr[','expr]*
                                    497 ; all arguments are of int24_t type
                                    498 ; and pushed on stack 
                                    499 ; input:
                                    500 ;   none
                                    501 ; output:
                                    502 ;   stack{n}   arguments pushed on stack
                                    503 ;   A  	number of arguments pushed on stack  
                                    504 ;--------------------------------
                           000004   505 	ARGN=4 
                           000002   506 	ARG_SIZE=INT_SIZE 
      0017E9                        507 arg_list:
      0097C4 02 81            [ 1]  508 	push #0 ; arguments counter
      0097C6 90 7D            [ 1]  509 	tnz (y)
      0097C6 A0 30            [ 1]  510 	jreq 7$ 
      0017EF                        511 1$:	 
      0097C8 2B               [ 1]  512 	pop a 
      0097C9 11               [ 2]  513 	popw x 
      0097CA A1 0A            [ 2]  514 	sub sp, #ARG_SIZE
      0097CC 2B               [ 2]  515 	pushw x 
      0097CD 0B               [ 1]  516 	inc a 
      0097CE A1               [ 1]  517 	push a
      0097CF 11 2B 09         [ 4]  518 	call expression 
      0017F9                        519 	_i16_store ARGN   
      0097D2 A0 07            [ 2]    1     ldw (ARGN,sp),x 
      0017FB                        520 	_next_token 
      0017FB                          1         _get_char 
      0097D4 C1 00            [ 1]    1         ld a,(y)    ; 1 cy 
      0097D6 0F 2A            [ 1]    2         incw y      ; 1 cy 
      0097D8 02 99            [ 1]  521 	cp a,#COMMA_IDX 
      0097DA 81 98            [ 1]  522 	jreq 1$ 
      0097DC 81 05            [ 1]  523 	cp a,#RPAREN_IDX 
      0097DD 27 02            [ 1]  524 	jreq 7$ 
      001807                        525 	_unget_token 
      0097DD 52 05            [ 2]    1         decw y
      001809                        526 7$:	
      0097DF 35               [ 1]  527 	pop a
      0097E0 0A               [ 4]  528 	ret  
                                    529 
                                    530 ;--------------------------------
                                    531 ;   BASIC commnands 
                                    532 ;--------------------------------
                                    533 
                           000000   534 .if 0
                                    535 ;----------------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 155.
Hexadecimal [24-Bits]



                                    536 ; BASIC: MULDIV(expr1,expr2,expr3)
                                    537 ; return expr1*expr2/expr3 
                                    538 ; product result is int32_t and 
                                    539 ; divisiont is int32_t/int16_t
                                    540 ;----------------------------------
                                    541 	DBL_SIZE=4 
                                    542 muldiv:
                                    543 	call func_args 
                                    544 	cp a,#3 
                                    545 	jreq 1$
                                    546 	jp syntax_error
                                    547 1$: 
                                    548 	ldw x,(5,sp) ; expr1
                                    549 	ldw y,(3,sp) ; expr2
                                    550 	call multiply 
                                    551 	ldw (5,sp),x  ;int32_t 15..0
                                    552 	ldw (3,sp),y  ;int32_t 31..16
                                    553 	popw x        ; expr3 
                                    554 	call div32_16 ; int32_t/expr3 
                                    555 	_drop DBL_SIZE
                                    556 	ret 
                                    557 .endif 
                                    558 
                                    559 ;--------------------------------
                                    560 ;  arithmetic and relational 
                                    561 ;  routines
                                    562 ;  operators precedence
                                    563 ;  highest to lowest
                                    564 ;  operators on same row have 
                                    565 ;  same precedence and are executed
                                    566 ;  from left to right.
                                    567 ;	'*','/','%'
                                    568 ;   '-','+'
                                    569 ;   '=','>','<','>=','<=','<>','><'
                                    570 ;   '<>' and '><' are equivalent for not equal.
                                    571 ;--------------------------------
                                    572 
                                    573 
                                    574 ;---------------------
                                    575 ; return array element
                                    576 ; address from var(expr)
                                    577 ; input:
                                    578 ;   X       
                                    579 ;   A 		ARRAY_IDX
                                    580 ; output:
                                    581 ;	X 		element address 
                                    582 ;----------------------
      00180B                        583 get_array_element:
                           000000   584 .if 0
                                    585 	call func_args 
                                    586 	cp a,#1
                                    587 	jreq 1$
                                    588 	jp syntax_error
                                    589 1$: _i16_pop 
                                    590     ; ignore A, index < 65536 in any case 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 156.
Hexadecimal [24-Bits]



                                    591 	; check for bounds 
                                    592 ;	cpw x,array_size 
                                    593 	jrule 3$
                                    594 ; bounds {1..array_size}	
                                    595 2$: ld a,#ERR_RANGE  
                                    596 	jp tb_error 
                                    597 3$: 
                                    598 	tnzw  x
                                    599 	jreq 2$ 
                                    600 	ld a,#INT_SIZE   
                                    601 	mul x,a 
                                    602 	ldw acc16,x   
                                    603 	ldw x,end_free_ram ; array start at this point  
                                    604 	subw x,acc16
                                    605 .endif 
      0097E1 00               [ 4]  606 	ret 
                                    607 
                                    608 
                                    609 ;***********************************
                                    610 ;   expression parse,execute 
                                    611 ;***********************************
                                    612 
                                    613 ;-----------------------------------
                                    614 ; factor ::= ['+'|'-'|e]  var | @ |
                                    615 ;			 integer | function |
                                    616 ;			 '('expression')' 
                                    617 ; output:
                                    618 ;     X     factor value 
                                    619 ; ---------------------------------
                           000001   620 	NEG=1
                           000001   621 	VSIZE=1
      00180C                        622 factor:
      00180C                        623 	_vars VSIZE 
      0097E2 0F 0F            [ 2]    1     sub sp,#VSIZE 
      0097E4 03 5F            [ 1]  624 	clr (NEG,sp)
      001810                        625 	_next_token
      001810                          1         _get_char 
      0097E6 1F 01            [ 1]    1         ld a,(y)    ; 1 cy 
      0097E8 0F 05            [ 1]    2         incw y      ; 1 cy 
      0097EA 90 F6            [ 1]  626 	cp a,#CMD_END
      0097EC 27 2B            [ 1]  627 	jrugt 1$ 
      0097EE A1 2D 26         [ 2]  628 	jp syntax_error
      00181B                        629 1$:
      0097F1 04 03            [ 1]  630 	cp a,#ADD_IDX 
      0097F3 05 20            [ 1]  631 	jreq 2$
      0097F5 08 0C            [ 1]  632 	cp a,#SUB_IDX 
      0097F6 26 06            [ 1]  633 	jrne 4$ 
      0097F6 A1 24            [ 1]  634 	cpl (NEG,sp)
      001825                        635 2$:	
      001825                        636 	_next_token
      001825                          1         _get_char 
      0097F8 26 0A            [ 1]    1         ld a,(y)    ; 1 cy 
      0097FA 35 10            [ 1]    2         incw y      ; 1 cy 
      001829                        637 4$:
      0097FC 00 0F            [ 1]  638 	cp a,#LITW_IDX 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 157.
Hexadecimal [24-Bits]



      0097FE 90 5C            [ 1]  639 	jrne 5$
      00182D                        640 	_get_word 
      00182D                          1         _get_addr
      009800 90               [ 1]    1         ldw x,y     ; 1 cy 
      009801 F6               [ 2]    2         ldw x,(x)   ; 2 cy 
      009802 27 15 00 02      [ 2]    3         addw y,#2   ; 2 cy 
      009804 20 30            [ 2]  641 	jra 18$
      001835                        642 5$: 
      009804 CD 97            [ 1]  643 	cp a,#LITC_IDX 
      009806 C6 24            [ 1]  644 	jrne 6$
      001839                        645 	_get_char 
      009808 10 6B            [ 1]    1         ld a,(y)    ; 1 cy 
      00980A 04 1E            [ 1]    2         incw y      ; 1 cy 
      00980C 01               [ 1]  646 	clrw x 
      00980D B6               [ 1]  647 	ld xl,a
      00980E 0F CD            [ 2]  648 	jra 18$  	
      001841                        649 6$:
      009810 83 78            [ 1]  650 	cp a,#VAR_IDX 
      009812 72 FB            [ 1]  651 	jrne 8$
      009814 03 1F 01         [ 4]  652 	call get_var_adr 
      009817 20 E5 1E         [ 4]  653 	call get_array_adr 
      00981A 01               [ 2]  654 	ldw x,(x)
      00981B 0D 05            [ 2]  655 	jra 18$ 	
      00184E                        656 8$:
      00981D 27 01            [ 1]  657 	cp a,#LPAREN_IDX
      00981F 50 0C            [ 1]  658 	jrne 10$
      009820 CD 18 B2         [ 4]  659 	call expression
      001855                        660 	_i16_push
      009820 BF               [ 2]    1     pushw X
      009821 18 5B            [ 1]  661 	ld a,#RPAREN_IDX 
      009823 05 81 D0         [ 4]  662 	call expect
      009825                        663 	_i16_pop 
      009825 52               [ 2]    1     popw x 
      009826 06 0F            [ 2]  664 	jra 18$ 
      00185E                        665 10$: ; must be a function 
      00185E                        666 	_call_code
      00185E                          1         _code_addr  ; 6 cy  
      009828 01               [ 1]    1         clrw x   ; 1 cy 
      009829 17               [ 1]    2         ld xl,a  ; 1 cy 
      00982A 05               [ 2]    3         sllw x   ; 2 cy 
      00982B DE 0B F1         [ 2]    4         ldw x,(code_addr,x) ; 2 cy 
      00982B 1F               [ 4]    2         call (x)    ; 4 cy 
      001865                        667 18$: 
      00982C 03 F6            [ 1]  668 	tnz (NEG,sp)
      00982E 6B 02            [ 1]  669 	jreq 20$
      009830 16               [ 2]  670 	negw x   
      00186A                        671 20$:
      00186A                        672 	_drop VSIZE
      009831 05 5C            [ 2]    1     addw sp,#VSIZE 
      009833 CD               [ 4]  673 	ret
                                    674 
                                    675 
                                    676 ;-----------------------------------
                                    677 ; term ::= factor ['*'|'/'|'%' factor]* 
                                    678 ; output:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 158.
Hexadecimal [24-Bits]



                                    679 ;   X    	term  value 
                                    680 ;-----------------------------------
                           000001   681 	N1=1 ; left operand   
                           000003   682 	YSAVE=N1+INT_SIZE   
                           000005   683 	MULOP=YSAVE+ADR_SIZE
                           000005   684 	VSIZE=INT_SIZE+ADR_SIZE+1    
      00186D                        685 term:
      00186D                        686 	_vars VSIZE
      009834 88 91            [ 2]    1     sub sp,#VSIZE 
                                    687 ; first factor 	
      009836 27 0C 0C         [ 4]  688 	call factor
      009838                        689 	_i16_store N1 ; left operand 
      009838 1E 03            [ 2]    1     ldw (N1,sp),x 
      001874                        690 term01:	 ; check for  operator '*'|'/'|'%' 
      001874                        691 	_next_token
      001874                          1         _get_char 
      00983A 1D 00            [ 1]    1         ld a,(y)    ; 1 cy 
      00983C 02 A6            [ 1]    2         incw y      ; 1 cy 
      00983E FF FE            [ 1]  692 	ld (MULOP,sp),a
      009840 27 0B            [ 1]  693 	cp a,#DIV_IDX 
      009842 20 E7            [ 1]  694 	jrmi 0$ 
      009844 A1 0F            [ 1]  695 	cp a,#MULT_IDX
      009844 1E 03            [ 2]  696 	jrule 1$ 
      001882                        697 0$:	_unget_token
      009846 72 FB            [ 2]    1         decw y
      009848 01 1C            [ 2]  698 	jra term_exit 
      001886                        699 1$:	; got *|/|%
                                    700 ;second factor
      00984A 00 02 F6         [ 4]  701 	call factor
      00984D 17 03            [ 2]  702 	ldw (YSAVE,sp),y ; save y 
      00984D 5B 06            [ 2]  703 	ldw y,(N1,sp)
                                    704 ; select operation 	
      00984F 81 05            [ 1]  705 	ld a,(MULOP,sp) 
      009850 A1 0F            [ 1]  706 	cp a,#MULT_IDX 
      009850 88 90            [ 1]  707 	jrne 3$
                                    708 ; '*' operator
      009852 F6 90 5C         [ 4]  709 	call multiply 
      009855 11 01            [ 2]  710 	jra 5$
      009857 27 03            [ 1]  711 3$: cp a,#DIV_IDX 
      009859 CC 95            [ 1]  712 	jrne 4$ 
                                    713 ; '/' operator	
      00985B D3               [ 1]  714 	exgw x,y 
      00985C 84 81 EE         [ 4]  715 	call divide 
      00985E 20 05            [ 2]  716 	jra 5$ 
      0018A2                        717 4$: ; '%' operator
      00985E 90               [ 1]  718 	exgw x,y 
      00985F F6 90 5C         [ 4]  719 	call divide  
      009862 A1               [ 1]  720 	exgw x,y 
      0018A7                        721 5$: 
      0018A7                        722 	_i16_store N1
      009863 04 27            [ 2]    1     ldw (N1,sp),x 
      009865 03 CC            [ 2]  723 	ldw y,(YSAVE,sp) 
      009867 95 D3            [ 2]  724 	jra term01 
      009869                        725 term_exit:
      0018AD                        726 	_i16_fetch N1
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 159.
Hexadecimal [24-Bits]



      009869 4B 00            [ 2]    1     ldw x,(N1,sp)
      0018AF                        727 	_drop VSIZE 
      00986B 90 7D            [ 2]    1     addw sp,#VSIZE 
      00986D 27               [ 4]  728 	ret 
                                    729 
                                    730 ;-------------------------------
                                    731 ;  expr ::= term [['+'|'-'] term]*
                                    732 ;  result range {-16777215..16777215}
                                    733 ;  output:
                                    734 ;     X   expression value     
                                    735 ;-------------------------------
                           000001   736 	N1=1 ;left operand 
                           000003   737 	YSAVE=N1+INT_SIZE ;   
                           000005   738 	OP=YSAVE+ADR_SIZE ; 1
                           000005   739 	VSIZE=INT_SIZE+ADR_SIZE+1
      0018B2                        740 expression:
      0018B2                        741 	_vars VSIZE 
      00986E 1A 05            [ 2]    1     sub sp,#VSIZE 
                                    742 ; first term 	
      00986F CD 18 6D         [ 4]  743 	call term
      0018B7                        744 	_i16_store N1 
      00986F 84 85            [ 2]    1     ldw (N1,sp),x 
      0018B9                        745 1$:	; operator '+'|'-'
      0018B9                        746 	_next_token
      0018B9                          1         _get_char 
      009871 52 02            [ 1]    1         ld a,(y)    ; 1 cy 
      009873 89 4C            [ 1]    2         incw y      ; 1 cy 
      009875 88 CD            [ 1]  747 	ld (OP,sp),a 
      009877 99 32            [ 1]  748 	cp a,#ADD_IDX 
      009879 1F 04            [ 1]  749 	jreq 2$
      00987B 90 F6            [ 1]  750 	cp a,#SUB_IDX 
      00987D 90 5C            [ 1]  751 	jreq 2$ 
      0018C7                        752 	_unget_token 
      00987F A1 02            [ 2]    1         decw y
      009881 27 EC            [ 2]  753 	jra 9$ 
      0018CB                        754 2$: ; second term 
      009883 A1 05 27         [ 4]  755 	call term
      009886 02 90            [ 2]  756 	ldw (YSAVE,sp),y 
      009888 5A               [ 1]  757 	exgw x,y 
      009889                        758 	_i16_fetch N1
      009889 84 81            [ 2]    1     ldw x,(N1,sp)
      00988B 17 01            [ 2]  759 	ldw (N1,sp),y ; right operand   
      00988B 81 05            [ 1]  760 	ld a,(OP,sp)
      00988C A1 0B            [ 1]  761 	cp a,#ADD_IDX 
      00988C 52 01            [ 1]  762 	jrne 4$
                                    763 ; '+' operator
      00988E 0F 01 90         [ 2]  764 	ADDW X,(N1,SP)
      009891 F6 90            [ 2]  765 	jra 5$ 
      0018E0                        766 4$:	; '-' operator 
      009893 5C A1 01         [ 2]  767 	SUBW X,(N1,SP)
      0018E3                        768 5$:
      0018E3                        769 	_i16_store N1
      009896 22 03            [ 2]    1     ldw (N1,sp),x 
      009898 CC 95            [ 2]  770 	ldw y,(YSAVE,sp)
      00989A D3 D0            [ 2]  771 	jra 1$
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 160.
Hexadecimal [24-Bits]



      00989B                        772 9$:
      0018E9                        773 	_i16_fetch N1 
      00989B A1 0B            [ 2]    1     ldw x,(N1,sp)
      0018EB                        774 	_drop VSIZE 
      00989D 27 06            [ 2]    1     addw sp,#VSIZE 
      00989F A1               [ 4]  775 	ret 
                                    776 
                                    777 ;---------------------------------------------
                                    778 ; rel ::= expr [rel_op expr]
                                    779 ; rel_op ::=  '=','<','>','>=','<=','<>','><'
                                    780 ;  relation return  integer , zero is false 
                                    781 ;  output:
                                    782 ;	 X		relation result   
                                    783 ;---------------------------------------------
                                    784   ; local variables
                           000001   785 	N1=1 ; left expression 
                           000003   786 	YSAVE=N1+INT_SIZE   
                           000005   787 	REL_OP=YSAVE+ADR_SIZE  ;  
                           000005   788 	VSIZE=INT_SIZE+ADR_SIZE+1 ; bytes  
      0018EE                        789 relation: 
      0018EE                        790 	_vars VSIZE
      0098A0 0C 26            [ 2]    1     sub sp,#VSIZE 
      0098A2 06 03 01         [ 4]  791 	call expression
      0098A5                        792 	_i16_store N1 
      0098A5 90 F6            [ 2]    1     ldw (N1,sp),x 
                                    793 ; expect rel_op or leave 
      0018F5                        794 	_next_token 
      0018F5                          1         _get_char 
      0098A7 90 5C            [ 1]    1         ld a,(y)    ; 1 cy 
      0098A9 90 5C            [ 1]    2         incw y      ; 1 cy 
      0098A9 A1 08            [ 1]  795 	ld (REL_OP,sp),a 
      0098AB 26 08            [ 1]  796 	cp a,#REL_LE_IDX
      0098AD 93 FE            [ 1]  797 	jrmi 1$
      0098AF 72 A9            [ 1]  798 	cp a,#OP_REL_LAST 
      0098B1 00 02            [ 2]  799 	jrule 2$ 
      001903                        800 1$:	_unget_token 
      0098B3 20 30            [ 2]    1         decw y
      0098B5 20 3C            [ 2]  801 	jra 9$ 
      001907                        802 2$:	; expect another expression
      0098B5 A1 07 26         [ 4]  803 	call expression
      0098B8 08 90            [ 2]  804 	ldw (YSAVE,sp),y 
      0098BA F6               [ 1]  805 	exgw x,y 
      00190D                        806 	_i16_fetch N1
      0098BB 90 5C            [ 2]    1     ldw x,(N1,sp)
      0098BD 5F 97            [ 2]  807 	ldw (N1,sp),y ; right expression  
      0098BF 20 24            [ 2]  808 	cpw x,(N1,sp)
      0098C1 2F 0A            [ 1]  809 	jrslt 4$
      0098C1 A1 09            [ 1]  810 	jrne 5$
                                    811 ; i1==i2 
      0098C3 26 09            [ 1]  812 	ld a,(REL_OP,sp)
      0098C5 CD 9B            [ 1]  813 	cp a,#REL_LT_IDX 
      0098C7 A3 CD            [ 1]  814 	jrpl 7$ ; relation false 
      0098C9 9C 02            [ 2]  815 	jra 6$  ; relation true 
      00191F                        816 4$: ; i1<i2
      0098CB FE 20            [ 1]  817 	ld a,(REL_OP,sp)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 161.
Hexadecimal [24-Bits]



      0098CD 17 13            [ 1]  818 	cp a,#REL_LT_IDX 
      0098CE 27 14            [ 1]  819 	jreq 6$ ; relation true 
      0098CE A1 04            [ 1]  820 	cp a,#REL_LE_IDX 
      0098D0 26 0C            [ 1]  821 	jreq 6$  ; relation true
      0098D2 CD 99            [ 2]  822 	jra 54$
      00192B                        823 5$: ; i1>i2
      0098D4 32 89            [ 1]  824 	ld a,(REL_OP,sp)
      0098D6 A6 05            [ 1]  825 	cp a,#REL_GT_IDX 
      0098D8 CD 98            [ 1]  826 	jreq 6$ ; relation true 
      0098DA 50 85            [ 1]  827 	cp a,#REL_GE_IDX 
      0098DC 20 07            [ 1]  828 	jreq 6$ ; relation true 
      0098DE                        829 54$:
      0098DE 5F 97            [ 1]  830 	cp a,#REL_NE_IDX 
      0098E0 58 DE            [ 1]  831 	jrne 7$ ; relation false 
      001939                        832 6$: ; TRUE  ; relation true 
      0098E2 8C 71 FD         [ 2]  833 	LDW X,#-1
      0098E5 20 01            [ 2]  834 	jra 8$ 
      00193E                        835 7$:	; FALSE 
      0098E5 0D               [ 1]  836 	clrw x
      00193F                        837 8$: 
      0098E6 01 27            [ 2]  838 	ldw y,(YSAVE,sp) 
      0098E8 01 50            [ 2]  839 	jra 10$ 
      0098EA                        840 9$:	
      001943                        841 	_i16_fetch N1
      0098EA 5B 01            [ 2]    1     ldw x,(N1,sp)
      001945                        842 10$:
      001945                        843 	_drop VSIZE
      0098EC 81 05            [ 2]    1     addw sp,#VSIZE 
      0098ED 81               [ 4]  844 	ret 
                                    845 
                                    846 
                                    847 ;-------------------------------------------
                                    848 ;  AND factor:  [NOT] relation 
                                    849 ;  output:
                                    850 ;     X      boolean value 
                                    851 ;-------------------------------------------
                           000001   852 	NOT_OP=1
      001948                        853 and_factor:
      0098ED 52 05            [ 1]  854 	push #0 
      00194A                        855 0$:	_next_token  
      00194A                          1         _get_char 
      0098EF CD 98            [ 1]    1         ld a,(y)    ; 1 cy 
      0098F1 8C 1F            [ 1]    2         incw y      ; 1 cy 
      0098F3 01 01            [ 1]  856 	cp a,#CMD_END 
      0098F4 22 03            [ 1]  857 	jrugt 1$
      0098F4 90 F6 90         [ 2]  858 	jp syntax_error
      0098F7 5C 6B            [ 1]  859 1$:	cp a,#NOT_IDX  
      0098F9 05 A1            [ 1]  860 	jrne 2$ 
      0098FB 0D 2B            [ 1]  861 	cpl (NOT_OP,sp)
      0098FD 04 A1            [ 2]  862 	jra 4$
      00195D                        863 2$:
      00195D                        864 	_unget_token 
      0098FF 0F 23            [ 2]    1         decw y
      00195F                        865 4$:
      009901 04 90 5A         [ 4]  866 	call relation
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 162.
Hexadecimal [24-Bits]



      001962                        867 5$:	
      009904 20 27            [ 1]  868 	tnz (NOT_OP,sp)
      009906 27 01            [ 1]  869 	jreq 8$
      009906 CD               [ 2]  870 	cplw x  
      001967                        871 8$:
      001967                        872 	_drop 1  
      009907 98 8C            [ 2]    1     addw sp,#1 
      009909 17               [ 4]  873     ret 
                                    874 
                                    875 
                                    876 ;--------------------------------------------
                                    877 ;  AND operator as priority over OR||XOR 
                                    878 ;  format: and_factor [AND and_factor]*
                                    879 ;          
                                    880 ;  output:
                                    881 ;    X      boolean value  
                                    882 ;--------------------------------------------
                           000001   883 	B1=1 
                           000002   884 	VSIZE=INT_SIZE 
      00196A                        885 and_cond:
      00196A                        886 	_vars VSIZE 
      00990A 03 16            [ 2]    1     sub sp,#VSIZE 
      00990C 01 7B 05         [ 4]  887 	call and_factor
      00196F                        888 	_i16_store B1 
      00990F A1 0F            [ 2]    1     ldw (B1,sp),x 
      001971                        889 1$: _next_token 
      001971                          1         _get_char 
      009911 26 05            [ 1]    1         ld a,(y)    ; 1 cy 
      009913 CD 83            [ 1]    2         incw y      ; 1 cy 
      009915 C7 20            [ 1]  890 	cp a,#AND_IDX  
      009917 0F A1            [ 1]  891 	jreq 3$  
      001979                        892 	_unget_token 
      009919 0D 26            [ 2]    1         decw y
      00991B 06 51            [ 2]  893 	jra 9$ 
      00991D CD 84 6E         [ 4]  894 3$:	call and_factor  
      009920 20               [ 1]  895 	rlwa x 
      009921 05 01            [ 1]  896 	and a,(B1,sp)
      009922 02               [ 1]  897 	rlwa x 
      009922 51 CD            [ 1]  898 	and a, (B1+1,sp)
      009924 84               [ 1]  899 	rlwa x 
      001987                        900 	_i16_store B1 
      009925 6E 51            [ 2]    1     ldw (B1,sp),x 
      009927 20 E6            [ 2]  901 	jra 1$  
      00198B                        902 9$:	
      00198B                        903 	_i16_fetch B1 
      009927 1F 01            [ 2]    1     ldw x,(B1,sp)
      00198D                        904 	_drop VSIZE 
      009929 16 03            [ 2]    1     addw sp,#VSIZE 
      00992B 20               [ 4]  905 	ret 	 
                                    906 
                                    907 ;--------------------------------------------
                                    908 ; condition for IF and UNTIL 
                                    909 ; operators: OR,XOR 
                                    910 ; format:  and_cond [ OP and_cond ]* 
                                    911 ; output:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 163.
Hexadecimal [24-Bits]



                                    912 ;    stack   value 
                                    913 ;--------------------------------------------
                           000001   914 	B1=1 ; left bool 
                           000003   915 	OP=B1+INT_SIZE ; 1 bytes 
                           000003   916 	VSIZE=INT_SIZE+1
      001990                        917 condition:
      001990                        918 	_vars VSIZE 
      00992C C7 03            [ 2]    1     sub sp,#VSIZE 
      00992D CD 19 6A         [ 4]  919 	call and_cond
      001995                        920 	_i16_store B1
      00992D 1E 01            [ 2]    1     ldw (B1,sp),x 
      001997                        921 1$:	_next_token 
      001997                          1         _get_char 
      00992F 5B 05            [ 1]    1         ld a,(y)    ; 1 cy 
      009931 81 5C            [ 1]    2         incw y      ; 1 cy 
      009932 A1 18            [ 1]  922 	cp a,#OR_IDX  
      009932 52 05            [ 1]  923 	jreq 2$
                           000000   924 .if 0	
                                    925 	cp a,#XOR_IDX 
                                    926 	jreq 2$
                                    927 .endif
      00199F                        928 	_unget_token 
      009934 CD 98            [ 2]    1         decw y
      009936 ED 1F            [ 2]  929 	jra 9$ 
      009938 01 03            [ 1]  930 2$:	ld (OP,sp),a ; boolean operator  
      009939 CD 19 6A         [ 4]  931 	call and_cond
      009939 90 F6            [ 1]  932 	ld a,(OP,sp)
                           000000   933 .if 0
                                    934 	cp a,#XOR_IDX  
                                    935 	jreq 5$
                                    936 .endif  
      0019AA                        937 4$: ; B1 = B1 OR X   
      00993B 90               [ 1]  938 	rlwa x 
      00993C 5C 6B            [ 1]  939 	or a,(B1,SP)
      00993E 05               [ 1]  940 	rlwa x 
      00993F A1 0B            [ 1]  941 	or a,(B1+1,SP) 
      009941 27               [ 1]  942 	rlwa x 
      009942 08 A1            [ 2]  943 	jra 6$  
      0019B3                        944 5$: ; B1 = B1 XOR X 
      009944 0C               [ 1]  945 	RLWA X 
      009945 27 04            [ 1]  946 	XOR A,(B1,SP)
      009947 90               [ 1]  947 	RLWA X 
      009948 5A 20            [ 1]  948 	XOR A,(B1+1,SP)
      00994A 1E               [ 1]  949 	RLWA X 
      00994B                        950 6$: 
      0019BA                        951 	_i16_store B1 
      00994B CD 98            [ 2]    1     ldw (B1,sp),x 
      00994D ED 17            [ 2]  952 	jra 1$ 
      0019BE                        953 9$:	 
      0019BE                        954 	_i16_fetch B1 ; result in X 
      00994F 03 51            [ 2]    1     ldw x,(B1,sp)
      0019C0                        955 	_drop VSIZE
      009951 1E 01            [ 2]    1     addw sp,#VSIZE 
      009953 17               [ 4]  956 	ret 
                                    957 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 164.
Hexadecimal [24-Bits]



                           000000   958 .if 0
                                    959 ;--------------------------------------------
                                    960 ; BASIC: HEX 
                                    961 ; select hexadecimal base for integer print
                                    962 ;---------------------------------------------
                                    963 cmd_hex_base:
                                    964 	mov base,#16 
                                    965 	_next  
                                    966 
                                    967 ;--------------------------------------------
                                    968 ; BASIC: DEC 
                                    969 ; select decimal base for integer print
                                    970 ;---------------------------------------------
                                    971 cmd_dec_base:
                                    972 	mov base,#10
                                    973 	_next 
                                    974 
                                    975 
                                    976 ;------------------------------
                                    977 ; BASIC: SIZE 
                                    978 ; command that print 
                                    979 ; program start addres and size 
                                    980 ;------------------------------
                                    981 cmd_size:
                                    982 	push base 
                                    983 	ldw x,#PROG_ADDR 
                                    984 	call puts 
                                    985 	_ldxz lomem     
                                    986 	mov base,#16 
                                    987 	call print_int
                                    988 	ldw x,#PROG_SIZE 
                                    989 	call puts 
                                    990 	_ldxz himem 
                                    991 	subw x,lomem 
                                    992 	mov base,#10 
                                    993 	call print_int
                                    994 	ldw x,#STR_BYTES 
                                    995 	call puts  
                                    996 	pop base 
                                    997 	_next 
                                    998 
                                    999 .endif 
                                   1000 
                                   1001 
                                   1002 ;-----------------------------
                                   1003 ; BASIC: LET var=expr 
                                   1004 ; variable assignement 
                                   1005 ; output:
                                   1006 ;-----------------------------
                           000001  1007 	VAR_ADR=1  ; 2 bytes 
                           000003  1008 	VALUE=VAR_ADR+2 ;INT_SIZE 
                           000004  1009 	VSIZE=2*INT_SIZE 
      0019C3                       1010 kword_let::
      0019C3                       1011 	_vars VSIZE 
      009954 01 7B            [ 2]    1     sub sp,#VSIZE 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 165.
Hexadecimal [24-Bits]



      0019C5                       1012 	_next_token ; VAR_IDX || STR_VAR_IDX 
      0019C5                          1         _get_char 
      009956 05 A1            [ 1]    1         ld a,(y)    ; 1 cy 
      009958 0B 26            [ 1]    2         incw y      ; 1 cy 
      00995A 05 72            [ 1] 1013 	cp a,#VAR_IDX
      00995C FB 01            [ 1] 1014 	jreq let_int_var
      00995E 20 03            [ 1] 1015 	cp a,#STR_VAR_IDX 
      009960 27 25            [ 1] 1016 	jreq let_string
      009960 72 F0 01         [ 2] 1017 	jp syntax_error
      009963                       1018 kword_let2: 	
      0019D4                       1019 	_vars VSIZE 
      009963 1F 01            [ 2]    1     sub sp,#VSIZE 
      0019D6                       1020 let_int_var:
      009965 16 03 20         [ 4] 1021 	call get_var_adr  
      009968 D0 1B 82         [ 4] 1022 	call get_array_adr
      009969 1F 01            [ 2] 1023 	ldw (VAR_ADR,sp),x 
      009969 1E 01            [ 1] 1024 	ld a,#REL_EQU_IDX 
      00996B 5B 05 81         [ 4] 1025 	call expect 
                                   1026 ; var assignment 
      00996E CD 19 90         [ 4] 1027 	call condition
      0019E6                       1028 	_i16_store VALUE
      00996E 52 05            [ 2]    1     ldw (VALUE,sp),x 
      009970 CD 99            [ 2] 1029 	ldw x,(VAR_ADR,sp) 
      009972 32 1F            [ 1] 1030 	ld a,(VALUE,sp)
      009974 01               [ 1] 1031 	ld (x),a 
      009975 90 F6            [ 1] 1032 	ld a,(VALUE+1,sp)
      009977 90 5C            [ 1] 1033 	ld (1,x),a 
      0019F1                       1034 9$: _drop VSIZE 	
      009979 6B 05            [ 2]    1     addw sp,#VSIZE 
      0019F3                       1035 	_next  
      00997B A1 10 2B         [ 2]    1         jp interp_loop 
                                   1036 
                                   1037 
                                   1038 ;-----------------------
                                   1039 ; BASIC: LET l$="string" 
                                   1040 ;        ||  l$="string"
                                   1041 ;------------------------
                           000001  1042 	TEMP=1 ; temporary storage 
                           000003  1043 	DEST_SIZE=TEMP+2 
                           000005  1044 	DEST_ADR=DEST_SIZE+2  
                           000007  1045 	SRC_ADR=DEST_ADR+2 
                           000009  1046 	SIZE=SRC_ADR+2 
                           00000A  1047 	VSIZE2=SIZE+1
      0019F6                       1048 let_string:
      0019F6                       1049 	_drop VSIZE
      00997E 04 A1            [ 2]    1     addw sp,#VSIZE 
      0019F8                       1050 let_string2:	 
      0019F8                       1051 	_vars VSIZE2 
      009980 15 23            [ 2]    1     sub sp,#VSIZE2 
      009982 04 90            [ 1] 1052 	clr (SIZE,sp)
      009984 5A 20            [ 1] 1053 	clr (DEST_SIZE,sp)
      009986 3C 1B 23         [ 4] 1054 	call get_var_adr 
      009987 1F 01            [ 2] 1055 	ldw (TEMP,sp),x 
      009987 CD 99            [ 2] 1056 	ldw x,(2,x)
      009989 32               [ 1] 1057 	ld a,(x)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 166.
Hexadecimal [24-Bits]



      00998A 17               [ 1] 1058 	incw x 
      00998B 03 51            [ 2] 1059 	ldw (DEST_ADR,sp),x 
      00998D 1E 01            [ 1] 1060 	ld (DEST_SIZE+1,sp),a 
      00998F 17 01            [ 2] 1061 	ldw x,(TEMP,sp) ; var address 
      009991 13 01 2F         [ 4] 1062 	call get_string_slice 
      009994 0A 26            [ 2] 1063 	ldw (TEMP,sp),x ; slice address 
      009996 14 7B 05         [ 2] 1064 	subw x,(DEST_ADR,sp) ; count character skipped 
      009999 A1 13 2A         [ 2] 1065 	subw x,(DEST_SIZE,sp)
      00999C 21               [ 2] 1066 	negw x  
      00999D 20 1A            [ 2] 1067 	ldw (DEST_SIZE,sp),x ; space left in array 
      00999F 1E 01            [ 2] 1068 	ldw x,(TEMP,sp)
      00999F 7B 05            [ 2] 1069 	ldw (DEST_ADR,sp),x 
      0099A1 A1 13            [ 1] 1070 	ld a,#REL_EQU_IDX 
      0099A3 27 14 A1         [ 4] 1071 	call expect 
      0099A6 10 27            [ 1] 1072 	ld a,(y)
      0099A8 10 20            [ 1] 1073 	cp a,#QUOTE_IDX
      0099AA 0A 20            [ 1] 1074 	jrne 4$
      0099AB 90 5C            [ 1] 1075 	incw y 
      0099AB 7B               [ 1] 1076 	ldw x,y
      0099AC 05 A1            [ 2] 1077 	ldw (SRC_ADR,sp),x  
      0099AE 14 27 08         [ 4] 1078 	call strlen  ; copy count 
      0099B1 A1 12            [ 1] 1079 	ld (SIZE+1,sp),a
      0099B3 27 04 09         [ 2] 1080 	addw y,(SIZE,sp)
      0099B5 90 5C            [ 1] 1081 	incw y 
      0099B5 A1 15            [ 2] 1082 	ldw x,(DEST_SIZE,sp)
      0099B7 26 05            [ 2] 1083 	cpw x,(SIZE,sp) 
      0099B9 24 05            [ 1] 1084 	jruge 1$ 
      0099B9 AE FF            [ 1] 1085 0$:	ld a,#ERR_STR_OVFL 
      0099BB FF 20 01         [ 2] 1086 	jp tb_error 
      0099BE                       1087 1$: 
      0099BE 5F 09            [ 2] 1088 	ldw x,(SIZE,sp) 
      0099BF                       1089 	_strxz acc16 
      0099BF 16 03                    1     .byte 0xbf,acc16 
      0099C1 20 02            [ 2] 1090 	jra 5$ 
      0099C3                       1091 4$: ; VAR$ expression 
      0099C3 1E 01            [ 1] 1092 	ld a,#STR_VAR_IDX
      0099C5 CD 17 D0         [ 4] 1093 	call expect 
      0099C5 5B 05 81         [ 4] 1094 	call get_var_adr 
      0099C8 CD 1A 75         [ 4] 1095 	call get_string_slice
      0099C8 4B 00            [ 2] 1096 	ldw (SRC_ADR,sp),x   
      001A57                       1097 	_clrz acc16 
      0099CA 90 F6                    1     .byte 0x3f, acc16 
      001A59                       1098 	_straz acc8 
      0099CC 90 5C                    1     .byte 0xb7,acc8 
      0099CE A1 01            [ 1] 1099 	ld (SIZE+1,sp),a 
      0099D0 22 03            [ 1] 1100 	cp a,(DEST_SIZE+1,sp)
      0099D2 CC 95            [ 1] 1101 	jrugt 0$
      001A61                       1102 5$:
      0099D4 D3 A1            [ 2] 1103 	ldw x,(DEST_ADR,sp) 
      0099D6 16 26            [ 2] 1104 	ldw (TEMP,sp),y ; save basic pc   
      0099D8 04 03            [ 2] 1105 	ldw y,(SRC_ADR,sp)
      0099DA 01 20 02         [ 4] 1106 	call move 
      0099DD 72 FB 09         [ 2] 1107 	addw x,(SIZE,sp)
      0099DD 90               [ 1] 1108 	clr (x)
      001A6E                       1109 6$: 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 167.
Hexadecimal [24-Bits]



      0099DE 5A 01            [ 2] 1110 	ldw y,(TEMP,sp) ; restore basic pc 
      0099DF                       1111 9$:	_drop VSIZE2 
      0099DF CD 99            [ 2]    1     addw sp,#VSIZE2 
      001A72                       1112 	_next 
      0099E1 6E 16 E0         [ 2]    1         jp interp_loop 
                                   1113 
                                   1114 ;----------------------
                                   1115 ; extract a slice 
                                   1116 ; from string variable
                                   1117 ; str(val1[,val2]) 
                                   1118 ; or complete string 
                                   1119 ; if no indices 
                                   1120 ; input:
                                   1121 ;   X     var_adr
                                   1122 ;   Y     point to (expr,expr)
                                   1123 ;   ptr16 destination
                                   1124 ; ouput:
                                   1125 ;   A    slice length 
                                   1126 ;   X    slice address   
                                   1127 ;----------------------
                           000001  1128 	VAL2=1 
                           000003  1129 	VAL1=VAL2+INT_SIZE 
                           000005  1130 	CHAR_ARRAY=VAL1+INT_SIZE 
                           000007  1131 	RES_LEN=CHAR_ARRAY+INT_SIZE  
                           000009  1132 	YTEMP=RES_LEN+INT_SIZE 
                           000008  1133 	VSIZE=4*INT_SIZE 
      0099E2                       1134 get_string_slice:
      001A75                       1135 	_vars VSIZE
      0099E2 0D 01            [ 2]    1     sub sp,#VSIZE 
      0099E4 27 01            [ 1] 1136 	clr (RES_LEN,sp)
      0099E6 53 02            [ 2] 1137 	ldw x,(2,x) ; char array 
      0099E7 1F 05            [ 2] 1138 	ldw (CHAR_ARRAY,sp),x 
      0099E7 5B               [ 1] 1139 	ld a,(x)
      0099E8 01 81            [ 1] 1140 	ld (RES_LEN+1,sp),a ; reserved space  
                                   1141 ; default slice to entire string 
      0099EA 0F 03            [ 1] 1142 	clr (VAL1,sp)
      0099EA 52 02            [ 1] 1143 	ld a,#1 
      0099EC CD 99            [ 1] 1144 	ld (VAL1+1,sp),a
      0099EE C8 1F            [ 1] 1145 	clr (VAL2,sp)
      0099F0 01               [ 1] 1146 	incw x 
      0099F1 90 F6 90         [ 4] 1147 	call strlen
      0099F4 5C A1            [ 1] 1148 	ld (VAL2+1,sp),a 
      0099F6 17 27            [ 1] 1149 	ld a,(y)
      0099F8 04 90            [ 1] 1150 	cp a,#LPAREN_IDX 
      0099FA 5A 20            [ 1] 1151 	jreq 1$
      0099FC 0E CD            [ 2] 1152 	jra 4$  
      001A96                       1153 1$:  
      0099FE 99 C8            [ 1] 1154 	incw y 
      009A00 02 14 01         [ 4] 1155 	call expression
      009A03 02 14 02         [ 2] 1156 	cpw x,#1 
      009A06 02 1F            [ 1] 1157 	jrpl 2$ 
      009A08 01 20            [ 1] 1158 0$:	ld a,#ERR_STR_OVFL 
      009A0A E6 15 55         [ 2] 1159 	jp tb_error 
      009A0B 13 01            [ 2] 1160 2$:	cpw x,(VAL2,sp)
      009A0B 1E 01            [ 1] 1161 	jrugt 0$ 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 168.
Hexadecimal [24-Bits]



      009A0D 5B 02            [ 2] 1162 	ldw (VAL1,sp),x 
      009A0F 81 F6            [ 1] 1163 	ld a,(y)
      009A10 A1 05            [ 1] 1164 	cp a,#RPAREN_IDX 
      009A10 52 03            [ 1] 1165 	jrne 3$
      009A12 CD 99            [ 1] 1166 	incw y 
      009A14 EA 1F            [ 2] 1167 	jra 4$
      001AB5                       1168 3$: 
      009A16 01 90            [ 1] 1169 	ld a,#COMMA_IDX 
      009A18 F6 90 5C         [ 4] 1170 	call expect 
      009A1B A1 18 27         [ 4] 1171 	call expression 
      009A1E 04 90            [ 2] 1172 	cpw x,(VAL2,sp)
      009A20 5A 20            [ 1] 1173 	jrugt 0$ 
      009A22 1B 6B            [ 2] 1174 	ldw (VAL2,sp),x
      009A24 03 CD            [ 1] 1175 	ld a,#RPAREN_IDX 
      009A26 99 EA 7B         [ 4] 1176 	call expect 
      001AC8                       1177 4$: ; length and slice address 
      009A29 03 01            [ 2] 1178 	ldw x,(VAL2,sp)
      009A2A 72 F0 03         [ 2] 1179 	subw x,(VAL1,sp)
      009A2A 02               [ 1] 1180 	incw x 
      009A2B 1A               [ 1] 1181 	ld a,xl ; slice length 
      009A2C 01 02            [ 2] 1182 	ldw x,(CHAR_ARRAY,sp)
      009A2E 1A 02 02         [ 2] 1183 	addw x,(VAL1,sp)
      001AD4                       1184 	_drop VSIZE 
      009A31 20 07            [ 2]    1     addw sp,#VSIZE 
      009A33 81               [ 4] 1185 	ret 
                                   1186 
                                   1187 
                                   1188 ;-----------------------
                                   1189 ; allocate data space 
                                   1190 ; on heap 
                                   1191 ; reserve to more bytes 
                                   1192 ; than required 
                                   1193 ; input: 
                                   1194 ;    X     size 
                                   1195 ; output:
                                   1196 ;    X     addr 
                                   1197 ;------------------------
      001AD7                       1198 heap_alloc:
      009A33 02 18 01         [ 2] 1199 	addw x,#2 
      009A36 02               [ 2] 1200 	pushw x 
      009A37 18 02 02         [ 2] 1201 	ldw x,heap_free 
      009A3A 72 B0 00 37      [ 2] 1202 	subw x,dvar_end 
      009A3A 1F 01            [ 2] 1203 	cpw x,(1,sp)
      009A3C 20 D9            [ 1] 1204 	jruge 1$
      009A3E A6 0A            [ 1] 1205 	ld a,#ERR_MEM_FULL 
      009A3E 1E 01 5B         [ 2] 1206 	jp tb_error 
      009A41 03 81 39         [ 2] 1207 1$: ldw x,heap_free 
      009A43 72 F0 01         [ 2] 1208 	subw x,(1,sp)
      001AF1                       1209 	_strxz heap_free 
      009A43 52 04                    1     .byte 0xbf,heap_free 
      001AF3                       1210 	_drop 2 
      009A45 90 F6            [ 2]    1     addw sp,#2 
      009A47 90               [ 4] 1211 	ret 
                                   1212 
                                   1213 ;---------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 169.
Hexadecimal [24-Bits]



                                   1214 ; create scalar variable 
                                   1215 ; and initialize to 0.
                                   1216 ; abort program if mem full 
                                   1217 ; input:
                                   1218 ;   x    var_name 
                                   1219 ; output:
                                   1220 ;   x    var_addr 
                                   1221 ;-----------------------------
                           000001  1222 	VNAME=1 
                           000002  1223 	VSIZE=2 
      001AF6                       1224 create_var:
      001AF6                       1225 	_vars VSIZE 
      009A48 5C A1            [ 2]    1     sub sp,#VSIZE 
      009A4A 09 27            [ 2] 1226 	ldw (VNAME,sp),x 
      009A4C 09 A1 0A         [ 2] 1227 	ldw x,heap_free 
      009A4F 27 25 CC 95      [ 2] 1228 	subw x,dvar_end 
      009A53 D3 00 04         [ 2] 1229 	cpw x,#4 
      009A54 24 05            [ 1] 1230 	jruge 1$ 
      009A54 52 04            [ 1] 1231 	ld a,#ERR_MEM_FULL
      009A56 CC 15 55         [ 2] 1232 	jp tb_error 
      001B0B                       1233 1$: 
      009A56 CD 9B A3         [ 2] 1234 	ldw x,dvar_end 
      009A59 CD 9C            [ 1] 1235 	ld a,(VNAME,sp)
      009A5B 02               [ 1] 1236 	ld (x),a 
      009A5C 1F 01            [ 1] 1237 	ld a,(VNAME+1,sp)
      009A5E A6 11            [ 1] 1238 	ld (1,x),a 
      009A60 CD 98            [ 1] 1239 	clr (2,x)
      009A62 50 CD            [ 1] 1240 	clr (3,x)
      009A64 9A               [ 2] 1241 	pushw x 
      009A65 10 1F 03         [ 2] 1242 	addw x,#4 
      001B1D                       1243 	_strxz dvar_end 
      009A68 1E 01                    1     .byte 0xbf,dvar_end 
      009A6A 7B               [ 2] 1244 	popw x ; var address 
      001B20                       1245 	_drop VSIZE  
      009A6B 03 F7            [ 2]    1     addw sp,#VSIZE 
      009A6D 7B               [ 4] 1246 	ret 
                                   1247 
                                   1248 ;------------------------
                                   1249 ; last token was VAR_IDX 
                                   1250 ; next is VAR_NAME 
                                   1251 ; extract name
                                   1252 ; search var 
                                   1253 ; return data field address 
                                   1254 ; input:
                                   1255 ;   Y      *var_name 
                                   1256 ; output:
                                   1257 ;   y       Y+2 
                                   1258 ;   X       var address
                                   1259 ; ------------------------
                           000001  1260 	F_ARRAY=1
                           000002  1261 	VNAME=2 
                           000003  1262 	VSIZE=3 
      001B23                       1263 get_var_adr:
      001B23                       1264 	_vars VSIZE
      009A6E 04 E7            [ 2]    1     sub sp,#VSIZE 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 170.
Hexadecimal [24-Bits]



      009A70 01 5B            [ 1] 1265 	clr (F_ARRAY,sp)
      001B27                       1266 	_get_word 
      001B27                          1         _get_addr
      009A72 04               [ 1]    1         ldw x,y     ; 1 cy 
      009A73 CC               [ 2]    2         ldw x,(x)   ; 2 cy 
      009A74 97 60 00 02      [ 2]    3         addw y,#2   ; 2 cy 
      009A76 1F 02            [ 2] 1267 	ldw (VNAME,sp),x 
      009A76 5B 04            [ 1] 1268 	ld a,(y) 
      009A78 A1 04            [ 1] 1269 	cp a,#LPAREN_IDX 
      009A78 52 0A            [ 1] 1270 	jrne 1$ 
      009A7A 0F 09            [ 1] 1271 	cpl (F_ARRAY,sp)
      009A7C 0F               [ 1] 1272 	ld  a,xh 
      009A7D 03 CD            [ 1] 1273 	or a,#128 
      009A7F 9B               [ 1] 1274 	ld xh,a 
      009A80 A3 1F            [ 1] 1275 	ld (VNAME,sp),a 
      001B3D                       1276 1$: 
      009A82 01 EE 02         [ 4] 1277 	call search_var
      009A85 F6               [ 2] 1278 	tnzw x 
      009A86 5C 1F            [ 1] 1279 	jrne 9$ ; found 
                                   1280 ; not found, if scalar create it 
      009A88 05 6B            [ 1] 1281 	tnz (F_ARRAY,sp)
      009A8A 04 1E            [ 1] 1282 	jreq 2$ 
                                   1283 ; this array doesn't exist
                                   1284 ; check for var(1) form 
      009A8C 01 CD 9A         [ 4] 1285 	call check_for_idx_1
      001B4A                       1286 2$:	 	
      009A8F F5 1F            [ 1] 1287 	ld a,(VNAME+1,sp)
      009A91 01 72            [ 1] 1288 	cp a,#'$ 
      009A93 F0 05            [ 1] 1289 	jrne 8$
      009A95 72 F0            [ 1] 1290 	ld a,#ERR_DIM 
      009A97 03 50 1F         [ 2] 1291 	jp tb_error
      001B55                       1292 8$:	
      009A9A 03 1E            [ 2] 1293 	ldw x,(VNAME,sp)
                                   1294 ; it's not an array 
      009A9C 01               [ 1] 1295 	ld a,xh 
      009A9D 1F 05            [ 1] 1296 	and a,#127 
      009A9F A6               [ 1] 1297 	ld xh,a 
      009AA0 11 CD 98         [ 4] 1298 	call create_var	
      001B5E                       1299 9$:
      001B5E                       1300 	_drop VSIZE 
      009AA3 50 90            [ 2]    1     addw sp,#VSIZE 
      009AA5 F6               [ 4] 1301 	ret 
                                   1302 
                                   1303 ;-------------------------
                                   1304 ; a scalar variable can be 
                                   1305 ; addressed as var(1)
                                   1306 ; check for it 
                                   1307 ; fail if not that form 
                                   1308 ; input: 
                                   1309 ;   X     var address 
                                   1310 ;   Y     *next token after varname
                                   1311 ;-------------------------
      001B61                       1312 check_for_idx_1: 
      009AA6 A1 06 26         [ 2] 1313 	addw x,#2 ; 
      009AA9 20               [ 2] 1314 	pushw x ; save value  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 171.
Hexadecimal [24-Bits]



      009AAA 90 5C            [ 1] 1315 	ld a,(y)
      009AAC 93 1F            [ 1] 1316 	cp a,#LPAREN_IDX 
      009AAE 07 CD            [ 1] 1317 	jrne 3$ 
      009AB0 88 86 6B         [ 4] 1318 	call func_args 
      009AB3 0A 72            [ 1] 1319 	cp a,#1 
      009AB5 F9 09            [ 1] 1320 	jreq 2$
      009AB7 90 5C 1E         [ 2] 1321 1$:	jp syntax_error  
      001B75                       1322 2$:
      001B75                       1323 	_i16_pop 
      009ABA 03               [ 2]    1     popw x 
      009ABB 13 09 24         [ 2] 1324 	cpw x,#1 
      009ABE 05 A6            [ 1] 1325 	jreq 3$
      009AC0 0E CC            [ 1] 1326 	ld a,#ERR_RANGE  
      009AC2 95 D5 55         [ 4] 1327 	call tb_error  
      009AC4                       1328 3$:
      009AC4 1E               [ 2] 1329 	popw x 
      009AC5 09               [ 4] 1330     ret 
                                   1331 
                                   1332 
                                   1333 ;--------------------------
                                   1334 ; get array element address
                                   1335 ; input:
                                   1336 ;   X     var addr  
                                   1337 ; output:
                                   1338 ;    X     element address 
                                   1339 ;---------------------------
                           000001  1340 	IDX=1 
                           000003  1341 	SIZE_FIELD=IDX+INT_SIZE 
                           000004  1342 	VSIZE=2*INT_SIZE 
      001B82                       1343 get_array_adr:
      001B82                       1344 	_vars VSIZE
      009AC6 BF 18            [ 2]    1     sub sp,#VSIZE 
      009AC8 20               [ 1] 1345 	tnz (x)
      009AC9 17 05            [ 1] 1346 	jrmi 10$ 
                                   1347 ; scalar data field follow name
                                   1348 ; check for 'var(1)' format 	
      009ACA CD 1B 61         [ 4] 1349 	call check_for_idx_1
      009ACA A6 0A            [ 2] 1350 	jra 9$ 
      001B8C                       1351 10$:	 
      009ACC CD 98            [ 2] 1352 	ldw x,(2,x) ; array data address 
      009ACE 50 CD            [ 2] 1353 	ldw (SIZE_FIELD,sp),x ; array size field 
      009AD0 9B A3            [ 1] 1354 	ld a,(y)
      009AD2 CD 9A            [ 1] 1355 	cp a,#LPAREN_IDX  
      009AD4 F5 1F            [ 1] 1356 	jreq 0$ 
      009AD6 07 3F 18         [ 2] 1357 	addw x,#2 
      009AD9 B7 19            [ 2] 1358 	jra 9$ 
      001B9B                       1359 0$:
      009ADB 6B 0A 11         [ 4] 1360 	call func_args 
      009ADE 04 22            [ 1] 1361 	cp a,#1 
      009AE0 DE 03            [ 1] 1362 	jreq 1$ 
      009AE1 CC 15 53         [ 2] 1363 	jp syntax_error 
      001BA5                       1364 1$: _i16_pop 
      009AE1 1E               [ 2]    1     popw x 
      009AE2 05               [ 2] 1365 	tnzw x 
      009AE3 17 01            [ 1] 1366 	jreq 2$ 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 172.
Hexadecimal [24-Bits]



      009AE5 16 07            [ 2] 1367 	ldw (IDX,sp),x 
      009AE7 CD 88            [ 2] 1368 	ldw x,(SIZE_FIELD,sp)
      009AE9 B0               [ 2] 1369 	ldw x,(x) ; array size 
      009AEA 72 FB            [ 2] 1370 	cpw x,(IDX,sp)
      009AEC 09 7F            [ 1] 1371 	jrpl 3$ 
      009AEE                       1372 2$: 
      009AEE 16 01            [ 1] 1373 	ld a,#ERR_RANGE 
      009AF0 5B 0A CC         [ 2] 1374 	jp tb_error 
      001BB7                       1375 3$: 
      009AF3 97 60            [ 2] 1376 	ldw x,(IDX,sp) 
      009AF5 58               [ 2] 1377 	sllw x ; 2*IDX  
      009AF5 52 08 0F         [ 2] 1378 	addw x,(SIZE_FIELD,sp)
      001BBD                       1379 9$:
      001BBD                       1380 	_drop VSIZE 
      009AF8 07 EE            [ 2]    1     addw sp,#VSIZE 
      009AFA 02               [ 4] 1381 	ret 
                                   1382 
                                   1383 
                                   1384 
                           000000  1385 .if 0
                                   1386 ;--------------------------
                                   1387 ; return constant/dvar value 
                                   1388 ; from it's record address
                                   1389 ; input:
                                   1390 ;	X	*record 
                                   1391 ; output:
                                   1392 ;   X   value
                                   1393 ;--------------------------
                                   1394 get_value: ; -- i 
                                   1395 	ld a,(x) ; record size 
                                   1396 	and a,#NAME_MAX_LEN
                                   1397 	add a,#2 
                                   1398 	push a 
                                   1399 	push #0 
                                   1400 	addw x,(1,sp)
                                   1401 	ldw x,(x)
                                   1402 	_drop 2
                                   1403 	ret 
                                   1404 .endif 
                                   1405 
                                   1406 
                           000000  1407 .if 0
                                   1408 ;--------------------------
                                   1409 ; BASIC: EEFREE 
                                   1410 ; eeprom_free 
                                   1411 ; search end of data  
                                   1412 ; in EEPROM 
                                   1413 ; input:
                                   1414 ;    none 
                                   1415 ; output:
                                   1416 ;    A:X     address free
                                   1417 ;-------------------------
                                   1418 func_eefree:
                                   1419 eefree:
                                   1420 	ldw x,#EEPROM_BASE 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 173.
Hexadecimal [24-Bits]



                                   1421 1$:	mov acc8,#8 ; count 8 consecutive zeros
                                   1422     cpw x,#EEPROM_BASE+EEPROM_SIZE-8
                                   1423 	jruge 8$ ; no free space 
                                   1424 2$: ld a,(x)
                                   1425 	jrne 3$
                                   1426 	incw x 
                                   1427 	dec acc8 
                                   1428 	jrne 2$
                                   1429 	subw x,#8 
                                   1430 	jra 9$  
                                   1431 3$: ld a,(x)
                                   1432 	incw x
                                   1433 	tnz a  
                                   1434 	jrne 3$
                                   1435 	decw x   
                                   1436 	jra 1$ 
                                   1437 8$: clrw x ; no free space 
                                   1438 9$: clr a 
                                   1439 	ldw free_eeprom,x ; save in system variable 
                                   1440 	ret 
                                   1441 .endif 
                                   1442 
                                   1443 
                                   1444 ;-----------------------
                                   1445 ; get string reserved 
                                   1446 ; space 
                                   1447 ; input:
                                   1448 ;   X     string data pointer 
                                   1449 ; output:
                                   1450 ;   X      space 
                                   1451 ;-----------------------------
      001BC0                       1452 get_string_space:
      009AFB 1F               [ 2] 1453 	ldw x,(x) ; data address 
      009AFC 05               [ 1] 1454 	ld a,(x) ; space size 
      009AFD F6               [ 1] 1455 	clrw x
      009AFE 6B               [ 1] 1456 	ld xl,a 
      009AFF 08               [ 4] 1457 	ret 
                                   1458 
                                   1459 ;--------------------------
                                   1460 ; search dim var_name 
                                   1461 ; format of record 
                                   1462 ;  field | size 
                                   1463 ;------------------- 
                                   1464 ;  name | {2} byte, for array bit 15 of name is set
                                   1465 ;  data:  
                                   1466 ;  	integer | INT_SIZE 
                                   1467 ;  	str   | len(str)+1, counted string 
                                   1468 ;  	array | size=2 byte, data=size*INT_SIZE   
                                   1469 ;  
                                   1470 ; input:
                                   1471 ;    X     name
                                   1472 ; output:
                                   1473 ;    X     address|0
                                   1474 ; use:
                                   1475 ;   A,Y, acc16 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 174.
Hexadecimal [24-Bits]



                                   1476 ;-------------------------
                           000001  1477 	VAR_NAME=1 ; target name pointer 
                                   1478 ;	WLKPTR=VAR_NAME+2   ; walking pointer in RAM 
                           000003  1479 	SKIP=VAR_NAME+2
                           000004  1480 	VSIZE=SKIP+1  
      001BC5                       1481 search_var:
      009B00 0F 03            [ 2] 1482 	pushw y 
      001BC7                       1483 	_vars VSIZE
      009B02 A6 01            [ 2]    1     sub sp,#VSIZE 
                                   1484 ; reset bit 7 
      009B04 6B               [ 1] 1485 	ld a,xh 
      009B05 04 0F            [ 1] 1486 	and a,#127
      009B07 01               [ 1] 1487     ld xh,a 
      009B08 5C CD            [ 2] 1488 	ldw (VAR_NAME,sp),x
      009B0A 88 86 6B 02      [ 2] 1489 	ldw y,dvar_bgn
      001BD3                       1490 1$:	
      009B0E 90 F6 A1 04      [ 2] 1491 	cpw y, dvar_end
      009B12 27 02            [ 1] 1492 	jrpl 7$ ; no match found 
      009B14 20               [ 1] 1493 	ldw x,y 
      009B15 32               [ 2] 1494 	ldw x,(x)
                                   1495 ; reset bit 7 
      009B16 9E               [ 1] 1496 	ld a,xh 
      009B16 90 5C            [ 1] 1497 	and a,#127
      009B18 CD               [ 1] 1498     ld xh,a 
      009B19 99 32            [ 2] 1499 	cpw x,(VAR_NAME,sp)
      009B1B A3 00            [ 1] 1500 	jreq 8$ ; match  
                                   1501 ; skip this one 	
      009B1D 01 2A 05 A6      [ 2] 1502 	addw y,#4 
      009B21 0E CC            [ 2] 1503 	jra 1$ 
      009B23 95 D5            [ 1] 1504 	ld a,(y)
      001BEB                       1505 7$: ; no match found 
      009B25 13 01            [ 1] 1506 	clrw y 
      001BED                       1507 8$: ; match found 
      009B27 22               [ 1] 1508 	ldw x,y  ; variable address 
      001BEE                       1509 9$:	_DROP VSIZE
      009B28 F7 1F            [ 2]    1     addw sp,#VSIZE 
      009B2A 03 90            [ 2] 1510 	popw y 
      009B2C F6               [ 4] 1511 	ret 
                                   1512 
                                   1513 ;---------------------------------
                                   1514 ; BASIC: DIM var_name(expr) [,var_name(expr)]* 
                                   1515 ; create named variables at end 
                                   1516 ; of BASIC program. 
                                   1517 ; value are not initialized 
                                   1518 ; bit 7 of first character of name 
                                   1519 ; is set for string and array variables 
                                   1520 ;---------------------------------
                           000001  1521 	HEAP_ADR=1 
                           000003  1522 	DIM_SIZE=HEAP_ADR+ADR_SIZE 
                           000005  1523 	VAR_NAME=DIM_SIZE+INT_SIZE
                           000007  1524 	VAR_ADR=VAR_NAME+NAME_SIZE  
                           000009  1525 	VAR_TYPE=VAR_ADR+ADR_SIZE 
                           000009  1526 	VSIZE=4*INT_SIZE+1 
      001BF3                       1527 kword_dim:
      001BF3                       1528 	_vars VSIZE
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 175.
Hexadecimal [24-Bits]



      009B2D A1 05            [ 2]    1     sub sp,#VSIZE 
      001BF5                       1529 dim_next: 
      001BF5                       1530 	_next_token
      001BF5                          1         _get_char 
      009B2F 26 04            [ 1]    1         ld a,(y)    ; 1 cy 
      009B31 90 5C            [ 1]    2         incw y      ; 1 cy 
      009B33 20 13            [ 1] 1531 	ld (VAR_TYPE,sp),a 
      009B35 93               [ 1] 1532 	ldw x,y 
      009B35 A6 02 CD 98      [ 2] 1533 	addw y,#2 
      009B39 50               [ 2] 1534 	ldw x,(x) ; var name 
                                   1535 ; set bit 7 for string or array 
      009B3A CD               [ 1] 1536 	ld a,xh 
      009B3B 99 32            [ 1] 1537 	or a,#128 
      009B3D 13               [ 1] 1538 	ld xh,a 
      009B3E 01 22            [ 2] 1539 	ldw (VAR_NAME,sp),x 
      009B40 DF 1F 01         [ 4] 1540 	call search_var  
      009B43 A6               [ 2] 1541 	tnzw x 
      009B44 05 CD            [ 1] 1542 	jreq 1$ ; doesn't exist 
                                   1543 ; if string or integer array 
                                   1544 ; abort with error 
      009B46 98 50            [ 2] 1545 	ldw (VAR_ADR,sp),x
      009B48 7D               [ 1] 1546 	tnz (x)
      009B48 1E 01            [ 1] 1547 	jrpl 0$  ; it is a scalar will be transformed in array 
      009B4A 72 F0            [ 1] 1548 	ld a,#ERR_DIM ; string or array already exist 
      009B4C 03 5C 9F         [ 2] 1549 	jp tb_error
      009B4F 1E 05            [ 1] 1550 0$: or a,#128 ; make it array  
      009B51 72               [ 1] 1551 	ld (x),a 
      009B52 FB 03            [ 2] 1552 	jra 2$ 	
      001C1C                       1553 1$:
      009B54 5B 08            [ 2] 1554 	ldw x,(VAR_NAME,sp)
      009B56 81 1A F6         [ 4] 1555 	call create_var
      009B57 1F 07            [ 2] 1556 	ldw (VAR_ADR,sp),x  
      001C23                       1557 2$: 
      009B57 1C 00 02         [ 4] 1558 	call func_args 
      009B5A 89 CE            [ 1] 1559 	cp a,#1
      009B5C 00 39            [ 1] 1560 	jreq 21$
      009B5E 72 B0 00         [ 2] 1561 	jp syntax_error 
      001C2D                       1562 21$: _i16_pop 
      009B61 37               [ 2]    1     popw x 
      009B62 13 01            [ 2] 1563 	ldw (DIM_SIZE,sp),x 
      009B64 24 05 A6         [ 2] 1564 	cpw x,#1 
      009B67 0A CC            [ 1] 1565 	jrpl 4$ 
      001C35                       1566 3$:
      009B69 95 D5            [ 1] 1567 	ld a,#ERR_RANGE ; array or string must be 1 or more  
      009B6B CE 00 39         [ 2] 1568 	jp tb_error 
      009B6E 72 F0            [ 1] 1569 4$: ld a,(VAR_TYPE,sp)
      009B70 01 BF            [ 1] 1570 	cp a,#VAR_IDX 
      009B72 39 5B            [ 1] 1571 	jreq 5$ 
      009B74 02 81 00         [ 2] 1572 	cpw x,#256 
      009B76 2B 0C            [ 1] 1573 	jrmi 42$ ; string too big
                                   1574 ; remove created var 
      001C45                       1575 	_ldxz dvar_end 
      009B76 52 02                    1     .byte 0xbe,dvar_end 
      009B78 1F 01 CE         [ 2] 1576 	subw x,#4 
      001C4A                       1577 	_strxz dvar_end 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 176.
Hexadecimal [24-Bits]



      009B7B 00 39                    1     .byte 0xbf,dvar_end 
      009B7D 72 B0            [ 1] 1578 	ld a,#ERR_GT255
      009B7F 00 37 A3         [ 2] 1579 	jp tb_error
      001C51                       1580 42$:
      009B82 00 04 24         [ 4] 1581 	call heap_alloc 
      009B85 05 A6            [ 2] 1582 	ldw (HEAP_ADR,sp),x 
                                   1583 ; put size in high byte 
                                   1584 ; 0 in low byte  
      009B87 0A CC            [ 1] 1585 	ld a,(DIM_SIZE+1,sp)
      009B89 95 D5            [ 1] 1586 	ld (DIM_SIZE,sp),a  
      009B8B 0F 04            [ 1] 1587 	clr (DIM_SIZE+1,sp)
      009B8B CE 00            [ 2] 1588 	jra 7$ 
      001C5E                       1589 5$: ; integer array 
      009B8D 37               [ 2] 1590 	sllw x  
      009B8E 7B 01 F7         [ 4] 1591 	call heap_alloc 
      009B91 7B 02            [ 2] 1592 	ldw (HEAP_ADR,sp),x 
      001C64                       1593 7$: 	
                                   1594 ; initialize size field 
      009B93 E7 01            [ 1] 1595 	ld a,(DIM_SIZE,sp)
      009B95 6F               [ 1] 1596 	ld (x),a
      009B96 02 6F            [ 1] 1597 	ld a,(DIM_SIZE+1,sp) 
      009B98 03 89            [ 1] 1598 	ld (1,x),a 
      001C6B                       1599 8$: ; initialize pointer in variable 
      009B9A 1C 00            [ 2] 1600 	ldw x,(VAR_ADR,sp)
      009B9C 04 BF            [ 1] 1601 	ld a,(HEAP_ADR,sp)
      009B9E 37 85            [ 1] 1602 	ld (2,x),a 
      009BA0 5B 02            [ 1] 1603 	ld a,(HEAP_ADR+1,sp)
      009BA2 81 03            [ 1] 1604 	ld (3,x),a 
      009BA3                       1605 	_next_token 
      001C75                          1         _get_char 
      009BA3 52 03            [ 1]    1         ld a,(y)    ; 1 cy 
      009BA5 0F 01            [ 1]    2         incw y      ; 1 cy 
      009BA7 93 FE            [ 1] 1606 	cp a,#COMMA_IDX 
      009BA9 72 A9            [ 1] 1607 	jrne 9$
      009BAB 00 02 1F         [ 2] 1608 	jp dim_next 
      001C80                       1609 9$: 
      001C80                       1610 	_unget_token 	
      009BAE 02 90            [ 2]    1         decw y
      001C82                       1611 	_drop VSIZE 
      009BB0 F6 A1            [ 2]    1     addw sp,#VSIZE 
      001C84                       1612 	_next 
      009BB2 04 26 08         [ 2]    1         jp interp_loop 
                                   1613 
                                   1614 
                                   1615 ;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1616 ; return program size 
                                   1617 ;;;;;;;;;;;;;;;;;;;;;;;;;;
      001C87                       1618 prog_size:
      001C87                       1619 	_ldxz progend
      009BB5 03 01                    1     .byte 0xbe,progend 
      009BB7 9E AA 80 95      [ 2] 1620 	subw x,lomem 
      009BBB 6B               [ 4] 1621 	ret 
                                   1622 
                                   1623 ;----------------------------
                                   1624 ; print program information 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 177.
Hexadecimal [24-Bits]



                                   1625 ;---------------------------
      001C8E                       1626 program_info: 
      009BBC 02 00 0F         [ 1] 1627 	push base 
      009BBD AE 1C D1         [ 2] 1628 	ldw x,#PROG_ADDR 
      009BBD CD 9C 45         [ 4] 1629 	call puts 
      001C97                       1630 	_ldxz lomem 
      009BC0 5D 26                    1     .byte 0xbe,lomem 
      009BC2 1B 0D 01 27      [ 1] 1631 	mov base,#16 
      009BC6 03 CD 9B         [ 4] 1632 	call print_int
      009BC9 E1 0A 00 0F      [ 1] 1633 	mov base,#10  
      009BCA AE 1C E3         [ 2] 1634 	ldw x,#PROG_SIZE
      009BCA 7B 03 A1         [ 4] 1635 	call puts 
      009BCD 24 26 05         [ 4] 1636 	call prog_size 
      009BD0 A6 0C CC         [ 4] 1637 	call print_int 
      009BD3 95 D5 F4         [ 2] 1638 	ldw x,#STR_BYTES 
      009BD5 CD 05 23         [ 4] 1639 	call puts
      001CB6                       1640 	_ldxz lomem
      009BD5 1E 02                    1     .byte 0xbe,lomem 
      009BD7 9E A4 7F         [ 2] 1641 	cpw x,#app 
      009BDA 95 CD            [ 1] 1642 	jrult 2$
      009BDC 9B 76 FB         [ 2] 1643 	ldw x,#FLASH_MEM 
      009BDE 20 03            [ 2] 1644 	jra 3$
      009BDE 5B 03 81         [ 2] 1645 2$: ldw x,#RAM_MEM 	 
      009BE1 CD 05 23         [ 4] 1646 3$:	call puts 
      009BE1 1C 00            [ 1] 1647 	ld a,#CR 
      009BE3 02 89 90         [ 4] 1648 	call putc
      009BE6 F6 A1 04         [ 1] 1649 	pop base 
      009BE9 26               [ 4] 1650 	ret 
                                   1651 
      009BEA 15 CD 98 5E A1 01 27  1652 PROG_ADDR: .asciz "program address: "
             03 CC 95 D3 72 65 73
             73 3A 20 00
      009BF5 2C 20 70 72 6F 67 72  1653 PROG_SIZE: .asciz ", program size: "
             61 6D 20 73 69 7A 65
             3A 20 00
      009BF5 85 A3 00 01 27 05 A6  1654 STR_BYTES: .asciz " bytes" 
      009BFC 0D CD 95 D5 46 4C 41  1655 FLASH_MEM: .asciz " in FLASH memory" 
             53 48 20 6D 65 6D 6F
             72 79 00
      009C00 20 69 6E 20 52 41 4D  1656 RAM_MEM:   .asciz " in RAM memory" 
             20 6D 65 6D 6F 72 79
             00
                                   1657 
                                   1658 
                                   1659 ;----------------------------
                                   1660 ; BASIC: LIST [[start][-end]]
                                   1661 ; list program lines 
                                   1662 ; form start to end 
                                   1663 ; if empty argument list then 
                                   1664 ; list all.
                                   1665 ;----------------------------
                           000001  1666 	FIRST=1
                           000003  1667 	LAST=3 
                           000005  1668 	LN_PTR=5
                           000006  1669 	VSIZE=6
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 178.
Hexadecimal [24-Bits]



      001D1B                       1670 cmd_list:
      009C00 85 81 87         [ 4] 1671 	call prog_size 
      009C02 22 03            [ 1] 1672 	jrugt 1$
      009C02 52 04 7D         [ 2] 1673 	jp cmd_line 
      001D23                       1674 1$:
      001D23                       1675 	 _vars VSIZE
      009C05 2B 05            [ 2]    1     sub sp,#VSIZE 
      001D25                       1676 	_ldxz lomem 
      009C07 CD 9B                    1     .byte 0xbe,lomem 
      009C09 E1 20            [ 2] 1677 	ldw (LN_PTR,sp),x 
      009C0B 31               [ 2] 1678 	ldw x,(x) 
      009C0C 1F 01            [ 2] 1679 	ldw (FIRST,sp),x ; list from first line 
      009C0C EE 02 1F         [ 2] 1680 	ldw x,#MAX_LINENO ; biggest line number 
      009C0F 03 90            [ 2] 1681 	ldw (LAST,sp),x 
      001D31                       1682 	_next_token
      001D31                          1         _get_char 
      009C11 F6 A1            [ 1]    1         ld a,(y)    ; 1 cy 
      009C13 04 27            [ 1]    2         incw y      ; 1 cy 
      009C15 05               [ 1] 1683 	tnz a 
      009C16 1C 00            [ 1] 1684 	jreq print_listing 
      009C18 02 20            [ 1] 1685 	cp a,#SUB_IDX 
      009C1A 22 22            [ 1] 1686 	jreq list_to
      009C1B 90 5A            [ 2] 1687 	decw y    
      009C1B CD 98 5E         [ 4] 1688 	call expect_integer 
      009C1E A1 01            [ 2] 1689 	ldw (FIRST,sp),x	
      001D43                       1690 	_next_token
      001D43                          1         _get_char 
      009C20 27 03            [ 1]    1         ld a,(y)    ; 1 cy 
      009C22 CC 95            [ 1]    2         incw y      ; 1 cy 
      009C24 D3               [ 1] 1691 	tnz a 
      009C25 85 5D            [ 1] 1692 	jrne 2$ 
      009C27 27 09            [ 2] 1693 	ldw (LAST,sp),x  
      009C29 1F 01            [ 2] 1694 	jra  print_listing 
      001D4E                       1695 2$: 
      009C2B 1E 03            [ 1] 1696 	cp a,#SUB_IDX  
      009C2D FE 13            [ 1] 1697 	jreq 3$ 
      009C2F 01 2A 05         [ 2] 1698 	jp syntax_error
      009C32                       1699 3$: _next_token 
      001D55                          1         _get_char 
      009C32 A6 0D            [ 1]    1         ld a,(y)    ; 1 cy 
      009C34 CC 95            [ 1]    2         incw y      ; 1 cy 
      009C36 D5               [ 1] 1700 	tnz a 
      009C37 27 07            [ 1] 1701 	jreq print_listing
      009C37 1E 01            [ 2] 1702 	decw y	 
      001D5E                       1703 list_to: ; listing will stop at this line
      009C39 58 72 FB         [ 4] 1704     call expect_integer 
      009C3C 03 03            [ 2] 1705 	ldw (LAST,sp),x
      009C3D                       1706 print_listing:
                                   1707 ; skip lines smaller than FIRST 
      009C3D 5B 04            [ 2] 1708 	ldw y,(LN_PTR,sp)
      001D65                       1709 	 _clrz acc16 
      009C3F 81 18                    1     .byte 0x3f, acc16 
      009C40 93               [ 1] 1710 1$:	ldw x,y 
      009C40 FE               [ 2] 1711 	ldw x,(x)
      009C41 F6 5F            [ 2] 1712 	cpw x,(FIRST,sp)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 179.
Hexadecimal [24-Bits]



      009C43 97 81            [ 1] 1713 	jrpl 2$
      009C45 90 E6 02         [ 1] 1714 	ld a,(2,y)
      001D70                       1715 	_straz acc8
      009C45 90 89                    1     .byte 0xb7,acc8 
      009C47 52 04 9E A4      [ 2] 1716 	addw y,acc16
      009C4B 7F 95 1F 01      [ 2] 1717 	cpw y,progend 
      009C4F 90 CE            [ 1] 1718 	jrpl list_exit 
      009C51 00 35            [ 2] 1719 	jra 1$
      009C53 17 05            [ 2] 1720 2$: ldw (LN_PTR,sp),y 	
      001D80                       1721 list_loop:
      009C53 90 C3            [ 2] 1722 	ldw x,(LN_PTR,sp)
      009C55 00 37 2A         [ 2] 1723 	ldw line.addr,x 
      009C58 12 93            [ 1] 1724 	ld a,(2,x) 
      009C5A FE 9E            [ 1] 1725 	sub a,#LINE_HEADER_SIZE
      009C5C A4 7F 95         [ 4] 1726 	call prt_basic_line
      009C5F 13 01            [ 2] 1727 	ldw x,(LN_PTR,sp)
      009C61 27 0A            [ 1] 1728 	ld a,(2,x)
      001D90                       1729 	_straz acc8
      009C63 72 A9                    1     .byte 0xb7,acc8 
      001D92                       1730 	_clrz acc16 
      009C65 00 04                    1     .byte 0x3f, acc16 
      009C67 20 EA 90 F6      [ 2] 1731 	addw x,acc16
      009C6B C3 00 33         [ 2] 1732 	cpw x,progend 
      009C6B 90 5F            [ 1] 1733 	jrpl list_exit
      009C6D 1F 05            [ 2] 1734 	ldw (LN_PTR,sp),x
      009C6D 93               [ 2] 1735 	ldw x,(x)
      009C6E 5B 04            [ 2] 1736 	cpw x,(LAST,sp)  
      009C70 90 85            [ 1] 1737 	jrsle list_loop
      001DA4                       1738 list_exit:
      001DA4                       1739 	_drop VSIZE 
      009C72 81 06            [ 2]    1     addw sp,#VSIZE 
      009C73 CD 1C 8E         [ 4] 1740 	call program_info
      009C73 52 09 AB         [ 2] 1741 	jp cmd_line 
                                   1742 
                                   1743 
      009C75 57 41 52 4E 49 4E 47  1744 LINES_REJECTED: .asciz "WARNING: lines missing in this program.\n"
             3A 20 6C 69 6E 65 73
             20 6D 69 73 73 69 6E
             67 20 69 6E 20 74 68
             69 73 20 70 72 6F 67
             72 61 6D 2E 0A 00
                                   1745 
                           000000  1746 .if 0
                                   1747 ;--------------------------
                                   1748 ; BASIC: EDIT label 
                                   1749 ;  copy program in FLASH 
                                   1750 ;  to RAM for edition 
                                   1751 ;-------------------------
                                   1752 cmd_edit:
                                   1753 	ld a,#LABEL_IDX 
                                   1754 	call expect  
                                   1755 	pushw y
                                   1756 	call skip_label 
                                   1757 	popw x 
                                   1758 	pushw y 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 180.
Hexadecimal [24-Bits]



                                   1759 	incw x 
                                   1760 	call search_file 
                                   1761     jrne 1$ 
                                   1762 	ldw x,#ERR_NOT_FILE 
                                   1763 	jp tb_error 
                                   1764 1$: 
                                   1765 	ldw y,x ; file address 
                                   1766 	ldw x,(2,x) ; program size 
                                   1767 	addw x,#FILE_HEADER_SIZE  
                                   1768 	ldw acc16,x  ; bytes to copy 
                                   1769 	ldw x,#rsign ; destination address 
                                   1770 	call move  
                                   1771 	ldw x,#free_ram 
                                   1772 	ldw lomem,x 
                                   1773 	addw x,rsize  
                                   1774 	ldw himem,x
                                   1775 	popw y  
                                   1776 	_next 
                                   1777 .endif 
                                   1778 
                                   1779 ;---------------------------------
                                   1780 ; decompile line from token list
                                   1781 ; and print it. 
                                   1782 ; input:
                                   1783 ;   A       stop at this position 
                                   1784 ;   X 		pointer at line
                                   1785 ; output:
                                   1786 ;   none 
                                   1787 ;----------------------------------	
      001DD5                       1788 prt_basic_line:
      001DD5                       1789 	_straz count 
      009C75 90 F6                    1     .byte 0xb7,count 
      009C77 90 5C 6B         [ 2] 1790 	addw x,#LINE_HEADER_SIZE  
      009C7A 09 93 72         [ 2] 1791 	ldw basicptr,x
      009C7D A9 00            [ 1] 1792     ldw y,x 
      009C7F 02 FE 9E         [ 4] 1793 	call decompile
                                   1794 ;call new_line 
      009C82 AA               [ 4] 1795 	ret 
                                   1796 
                                   1797 ;---------------------------------
                                   1798 ; BASIC: PRINT|? arg_list 
                                   1799 ; print values from argument list
                                   1800 ;----------------------------------
                           000001  1801 	SEMICOL=1
                           000001  1802 	VSIZE=1
      001DE3                       1803 cmd_print:
      001DE3                       1804 	_vars VSIZE 
      009C83 80 95            [ 2]    1     sub sp,#VSIZE 
      001DE5                       1805 reset_semicol:
      009C85 1F 05            [ 1] 1806 	clr (SEMICOL,sp)
      001DE7                       1807 prt_loop:
      001DE7                       1808 	_next_token	
      001DE7                          1         _get_char 
      009C87 CD 9C            [ 1]    1         ld a,(y)    ; 1 cy 
      009C89 45 5D            [ 1]    2         incw y      ; 1 cy 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 181.
Hexadecimal [24-Bits]



      009C8B 27 0F            [ 1] 1809 	cp a,#CMD_END 
      009C8D 1F 07            [ 1] 1810 	jrugt 0$
      001DEF                       1811 	_unget_token
      009C8F 7D 2A            [ 2]    1         decw y
      009C91 05 A6            [ 2] 1812 	jra 8$
      001DF3                       1813 0$:	
      009C93 0C CC            [ 1] 1814 	cp a,#QUOTE_IDX
      009C95 95 D5            [ 1] 1815 	jreq 1$
      009C97 AA 80            [ 1] 1816 	cp a,#STR_VAR_IDX 
      009C99 F7 20            [ 1] 1817 	jreq 2$ 
      009C9B 07 03            [ 1] 1818 	cp a,#SCOL_IDX  
      009C9C 27 28            [ 1] 1819 	jreq 4$
      009C9C 1E 05            [ 1] 1820 	cp a,#COMMA_IDX
      009C9E CD 9B            [ 1] 1821 	jreq 5$	
      009CA0 76 1F            [ 1] 1822 	cp a,#CHAR_IDX 
      009CA2 07 2B            [ 1] 1823 	jreq 6$
      009CA3 20 36            [ 2] 1824 	jra 7$ 
      001E09                       1825 1$:	; print string 
      009CA3 CD               [ 1] 1826 	ldw x,y 
      009CA4 98 5E A1         [ 4] 1827 	call puts
      009CA7 01 27            [ 1] 1828 	ldw y,x  
      009CA9 03 CC            [ 2] 1829 	jra reset_semicol
      001E11                       1830 2$:	; print string variable  
      009CAB 95 D3 85         [ 4] 1831 	call get_var_adr 
      009CAE 1F 03 A3         [ 4] 1832 	call get_string_slice 
      009CB1 00               [ 1] 1833 	tnz a 
      009CB2 01 2A            [ 1] 1834 	jreq 22$   
      009CB4 05               [ 1] 1835 	push a
      009CB5                       1836 21$: 
      009CB5 A6               [ 1] 1837 	ld a,(x)
      009CB6 0D               [ 1] 1838 	incw x 
      009CB7 CC 95 D5         [ 4] 1839 	call putc
      009CBA 7B 09            [ 1] 1840 	dec (1,sp)
      009CBC A1 09            [ 1] 1841 	jrne 21$ 
      009CBE 27               [ 1] 1842 	pop a  
      001E25                       1843 22$:
      009CBF 1E A3            [ 2] 1844 	jra reset_semicol 
      001E27                       1845 4$: ; set semi-colon  state 
      009CC1 01 00            [ 1] 1846 	cpl (SEMICOL,sp)
      009CC3 2B 0C            [ 2] 1847 	jra prt_loop 
      001E2B                       1848 5$: ; skip to next terminal tabulation
                                   1849      ; terminal TAB are 8 colons 
      009CC5 BE 37            [ 1] 1850      ld a,#9 
      009CC7 1D 00 04         [ 4] 1851 	 call putc 
      009CCA BF 37            [ 2] 1852 	 jra reset_semicol
      001E32                       1853 6$: ; appelle la foncton CHAR()
      001E32                       1854 	_call_code 
      001E32                          1         _code_addr  ; 6 cy  
      009CCC A6               [ 1]    1         clrw x   ; 1 cy 
      009CCD 03               [ 1]    2         ld xl,a  ; 1 cy 
      009CCE CC               [ 2]    3         sllw x   ; 2 cy 
      009CCF 95 D5 F1         [ 2]    4         ldw x,(code_addr,x) ; 2 cy 
      009CD1 FD               [ 4]    2         call (x)    ; 4 cy 
      009CD1 CD               [ 1] 1855 	rrwa x 
      009CD2 9B 57 1F         [ 4] 1856 	call putc 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 182.
Hexadecimal [24-Bits]



      009CD5 01 7B            [ 2] 1857 	jra reset_semicol	 	    
      001E3F                       1858 7$:	
      001E3F                       1859 	_unget_token 
      009CD7 04 6B            [ 2]    1         decw y
      009CD9 03 0F 04         [ 4] 1860 	call condition
      009CDC 20 06 AE         [ 4] 1861 	call print_int
      009CDE CD 05 86         [ 4] 1862 	call space
      009CDE 58 CD 9B         [ 2] 1863 	jp reset_semicol 
      001E4D                       1864 8$:
      009CE1 57 1F            [ 1] 1865 	tnz (SEMICOL,sp)
      009CE3 01 05            [ 1] 1866 	jrne 9$
      009CE4 A6 0D            [ 1] 1867 	ld a,#CR 
      009CE4 7B 03 F7         [ 4] 1868     call putc 
      001E56                       1869 9$:	
      001E56                       1870 	_drop VSIZE 
      009CE7 7B 04            [ 2]    1     addw sp,#VSIZE 
      001E58                       1871 	_next
      009CE9 E7 01 E0         [ 2]    1         jp interp_loop 
                                   1872 
                                   1873 ;----------------------
                                   1874 ; 'save_context' and
                                   1875 ; 'rest_context' must be 
                                   1876 ; called at the same 
                                   1877 ; call stack depth 
                                   1878 ; i.e. SP must have the 
                                   1879 ; same value at  
                                   1880 ; entry point of both 
                                   1881 ; routine. 
                                   1882 ;---------------------
                           000004  1883 	CTXT_SIZE=4 ; size of saved data 
                                   1884 ;--------------------
                                   1885 ; save current BASIC
                                   1886 ; interpreter context 
                                   1887 ; on stack 
                                   1888 ;--------------------
      009CEB                       1889 	_argofs 0 
                           000002     1     ARG_OFS=2+0 
      001E5B                       1890 	_arg LNADR 1 
                           000003     1     LNADR=ARG_OFS+1 
      001E5B                       1891 	_arg BPTR 3
                           000005     1     BPTR=ARG_OFS+3 
      001E5B                       1892 save_context:
      009CEB 1E 07            [ 2] 1893 	ldw (BPTR,sp),y 
      001E5D                       1894 	_ldxz line.addr
      009CED 7B 01                    1     .byte 0xbe,line.addr 
      009CEF E7 02            [ 2] 1895 	ldw (LNADR,sp),x 
      009CF1 7B               [ 4] 1896 	ret
                                   1897 
                                   1898 ;-----------------------
                                   1899 ; restore previously saved 
                                   1900 ; BASIC interpreter context 
                                   1901 ; from stack 
                                   1902 ;-------------------------
      001E62                       1903 rest_context:
      009CF2 02 E7            [ 2] 1904 	ldw x,(LNADR,sp)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 183.
Hexadecimal [24-Bits]



      009CF4 03 90 F6         [ 2] 1905 	ldw line.addr,x 
      009CF7 90 5C            [ 2] 1906 	ldw y,(BPTR,sp)
      009CF9 A1               [ 4] 1907 	ret
                                   1908 
                                   1909 
                                   1910 ;-----------------------
                                   1911 ; ask user to retype 
                                   1912 ; input value 
                                   1913 ;----------------------
      001E6A                       1914 retype:
      009CFA 02 26 03         [ 4] 1915 	call new_line
      009CFD CC 9C 75         [ 2] 1916 	ldw x,#err_retype 
      009D00 CD 05 23         [ 4] 1917 	call puts 
      009D00 90 5A 5B         [ 4] 1918 	call new_line 
      009D03 09               [ 4] 1919 	ret 
                                   1920 
                                   1921 ;--------------------------
                                   1922 ; readline from terminal 
                                   1923 ; and parse it in pad 
                                   1924 ;-------------------------
      001E77                       1925 input_prompt:
      009D04 CC 97            [ 1] 1926 	ld a,#'? 
      009D06 60 04 AC         [ 4] 1927 	call putc 
      009D07 81               [ 4] 1928 	ret 
                                   1929 
                                   1930 ;-----------------------
                                   1931 ; print variable name 
                                   1932 ; input:
                                   1933 ;    X    var name 
                                   1934 ; use:
                                   1935 ;   A 
                                   1936 ;-----------------------
      001E7D                       1937 print_var_name:
      009D07 BE               [ 1] 1938 	ld a,xh 
      009D08 33 72            [ 1] 1939 	and a,#127 
      009D0A B0 00 2F         [ 4] 1940 	call uart_putc 
      009D0D 81               [ 1] 1941 	ld a,xl 
      009D0E A4 7F            [ 1] 1942 	and a,#127 
      009D0E 3B 00 0F         [ 4] 1943 	call uart_putc 
      009D11 AE               [ 4] 1944 	ret  
                                   1945 
                                   1946 ;--------------------------
                                   1947 ; input integer to variable 
                                   1948 ; input:
                                   1949 ;   X     var name 
                                   1950 ; output:
                                   1951 ;   X      value 
                                   1952 ;----------------------------
                           000001  1953 	N=1
                           000003  1954 	DIGIT=N+INT_SIZE 
                           000005  1955 	SIGN=DIGIT+INT_SIZE
                           000006  1956 	COUNT=SIGN+1 
                           000006  1957  	VSIZE=COUNT  
      001E8A                       1958 input_integer:
      001E8A                       1959 	_vars VSIZE 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 184.
Hexadecimal [24-Bits]



      009D12 9D 51            [ 2]    1     sub sp,#VSIZE 
      009D14 CD 85            [ 1] 1960 	clr (DIGIT,sp)
      009D16 A3 BE 2F         [ 4] 1961 	call print_var_name 
      009D19 35 10 00         [ 4] 1962 	call input_prompt  
      009D1C 0F               [ 1] 1963 	clrw x 
      009D1D CD 88            [ 2] 1964 	ldw (N,sp),x 
      009D1F 2E 35            [ 2] 1965 	ldw (SIGN,sp),x
      009D21 0A 00 0F AE      [ 1] 1966 	mov base,#10
      009D25 9D 63 CD         [ 4] 1967 	call getc 
      009D28 85 A3            [ 1] 1968 	cp a,#'- 
      009D2A CD 9D            [ 1] 1969 	jrne 1$ 
      009D2C 07 CD            [ 1] 1970 	cpl (SIGN,sp)
      009D2E 88 2E            [ 2] 1971 	jra 2$ 
      009D30 AE 9D            [ 1] 1972 1$: cp a,#'$ 
      009D32 74 CD            [ 1] 1973 	jrne 3$ 
      009D34 85 A3 BE 2F      [ 1] 1974 	mov base,#16  
      009D38 A3 A9 80         [ 4] 1975 2$: call getc
      009D3B 25 05            [ 1] 1976 3$: cp a,#BS 
      009D3D AE 9D            [ 1] 1977 	jrne 4$ 
      009D3F 7B 20            [ 1] 1978 	tnz (COUNT,sp)
      009D41 03 AE            [ 1] 1979 	jreq 2$ 
      009D43 9D 8C CD         [ 4] 1980 	call bksp 
      009D46 85 A3            [ 2] 1981 	ldw x,(N,sp)
      001EC0                       1982 	_ldaz base 
      009D48 A6 0D                    1     .byte 0xb6,base 
      009D4A CD               [ 2] 1983 	div x,a 
      009D4B 85 2C            [ 2] 1984 	ldw (N,sp),x
      009D4D 32 00            [ 1] 1985 	dec (COUNT,sp)
      009D4F 0F 81            [ 2] 1986 	jra 2$  
      001EC9                       1987 4$:	
      009D51 70 72 6F         [ 4] 1988 	call uart_putc 
      009D54 67 72            [ 1] 1989 	cp a,#CR 
      009D56 61 6D            [ 1] 1990 	jreq 7$ 
      009D58 20 61 64         [ 4] 1991 	call char_to_digit 
      009D5B 64 72            [ 1] 1992 	jrnc 9$
      009D5D 65 73            [ 1] 1993 	inc (COUNT,sp)
      009D5F 73 3A            [ 1] 1994 	ld (DIGIT+1,sp),a 
      009D61 20 00            [ 2] 1995 	ldw x,(N,sp)
      001EDB                       1996 	_ldaz base 
      009D63 2C 20                    1     .byte 0xb6,base 
      009D65 70 72 6F         [ 4] 1997 	call umul16_8
      009D68 67 72 61         [ 2] 1998 	addw x,(DIGIT,sp)
      009D6B 6D 20            [ 2] 1999 	ldw (N,sp),x
      009D6D 73 69            [ 2] 2000 	jra 2$  	
      009D6F 7A 65            [ 2] 2001 7$: ldw x,(N,sp)
      009D71 3A 20            [ 1] 2002 	tnz (SIGN,sp)
      009D73 00 20            [ 1] 2003 	jreq 8$ 
      009D75 62               [ 2] 2004 	negw x 
      001EEE                       2005 8$: 
      009D76 79               [ 1] 2006 	scf ; success 	
      001EEF                       2007 9$:	
      001EEF                       2008 	_drop VSIZE 
      009D77 74 65            [ 2]    1     addw sp,#VSIZE 
      009D79 73               [ 4] 2009 	ret 
                                   2010 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 185.
Hexadecimal [24-Bits]



                                   2011 ;---------------------------------------
                                   2012 ; input value for string variable 
                                   2013 ; accumulate all character up to CR 
                                   2014 ; input:
                                   2015 ;   X     var name  
                                   2016 ; output:
                                   2017 ;   X     *tib 
                                   2018 ;-------------------------------------- 
      001EF2                       2019 input_string:
      009D7A 00 20 69         [ 4] 2020 	call print_var_name 
      009D7D 6E 20 46         [ 4] 2021 	call input_prompt 
      009D80 4C               [ 1] 2022 	clr a 
      009D81 41 53 48         [ 4] 2023 	call readln 
      009D84 20 6D 65         [ 2] 2024 	ldw x,#tib 
      009D87 6D               [ 4] 2025 	ret 
                                   2026 
                                   2027 ;------------------------------------------
                                   2028 ; BASIC: INPUT [string],var[,var]
                                   2029 ; input value in variables 
                                   2030 ; [string] optionally can be used as prompt 
                                   2031 ;-----------------------------------------
                           000001  2032 	BPTR=1
                           000003  2033 	VAR_VALUE=BPTR+2
                           000005  2034 	VAR_ADR =VAR_VALUE+2
                           000006  2035 	VSIZE=3*INT_SIZE  
      001F00                       2036 cmd_input:
      009D88 6F 72 79 00 20   [ 2] 2037 	btjt flags,#FRUN,1$ 
      009D8D 69 6E            [ 1] 2038 	ld a,#ERR_PROG_ONLY
      009D8F 20 52 41         [ 2] 2039 	jp tb_error 
      001F0A                       2040 1$: 
      001F0A                       2041 	_vars VSIZE 
      009D92 4D 20            [ 2]    1     sub sp,#VSIZE 
      009D94 6D 65            [ 1] 2042 	ld a,(y) 
      009D96 6D 6F            [ 1] 2043 	cp a,#QUOTE_IDX 
      009D98 72 79            [ 1] 2044 	jrne 2$ 
      009D9A 00 5C            [ 1] 2045 	incw y 
      009D9B 93               [ 1] 2046 	ldw x,y  
      009D9B CD 9D 07         [ 4] 2047 	call puts 
      009D9E 22 03            [ 1] 2048 	ldw y,x 
      009DA0 CC 97 2B         [ 4] 2049 	call new_line
      009DA3                       2050 	_next_token 
      001F1D                          1         _get_char 
      009DA3 52 06            [ 1]    1         ld a,(y)    ; 1 cy 
      009DA5 BE 2F            [ 1]    2         incw y      ; 1 cy 
      009DA7 1F 05            [ 1] 2051 	cp a,#COMMA_IDX 
      009DA9 FE 1F            [ 1] 2052 	jreq 2$  
      009DAB 01 AE 7F         [ 2] 2053 	jp syntax_error 
      001F28                       2054 2$:
      001F28                       2055 	_next_token
      001F28                          1         _get_char 
      009DAE FF 1F            [ 1]    1         ld a,(y)    ; 1 cy 
      009DB0 03 90            [ 1]    2         incw y      ; 1 cy 
      009DB2 F6 90            [ 1] 2056 	cp a,#CMD_END+1  
      009DB4 5C 4D            [ 1] 2057 	jrmi input_exit  
      009DB6 27 2B            [ 1] 2058     cp a,#VAR_IDX
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 186.
Hexadecimal [24-Bits]



      009DB8 A1 0C            [ 1] 2059 	jreq 4$
      009DBA 27 22            [ 1] 2060 	cp a,#STR_VAR_IDX 
      009DBC 90 5A            [ 1] 2061 	jreq 8$ 
      009DBE CD 97 B4         [ 2] 2062 	jp syntax_error 
      001F3B                       2063 4$: 
      009DC1 1F               [ 1] 2064 	ldw x,y 
      009DC2 01               [ 2] 2065 	ldw x,(x)
      009DC3 90 F6            [ 2] 2066 	ldw (VAR_ADR,sp),x ; var name 
      009DC5 90 5C            [ 2] 2067 5$:	ldw x,(VAR_ADR,sp) 
      009DC7 4D 26 04         [ 4] 2068 	call input_integer 
      009DCA 1F 03            [ 1] 2069 	jrc 6$ 
      009DCC 20 15 6A         [ 4] 2070 	call retype 
      009DCE 20 F4            [ 2] 2071 	jra 5$ 	  
      001F4B                       2072 6$: 
      009DCE A1 0C            [ 2] 2073 	ldw (VAR_VALUE,sp),x 
      009DD0 27 03 CC         [ 4] 2074 	call get_var_adr 
      009DD3 95 D3 90         [ 4] 2075 	call get_array_adr 
      009DD6 F6 90            [ 1] 2076 	ld a,(VAR_VALUE,sp)
      009DD8 5C               [ 1] 2077 	ld (x),a 
      009DD9 4D 27            [ 1] 2078 	ld a,(VAR_VALUE+1,sp)
      009DDB 07 90            [ 1] 2079 	ld (1,x),a 
      001F5A                       2080 7$: 
      001F5A                       2081 	_next_token 
      001F5A                          1         _get_char 
      009DDD 5A F6            [ 1]    1         ld a,(y)    ; 1 cy 
      009DDE 90 5C            [ 1]    2         incw y      ; 1 cy 
      009DDE CD 97            [ 1] 2082 	cp a,#COMMA_IDX 
      009DE0 B4 1F            [ 1] 2083 	jreq 2$
      001F62                       2084 	_unget_token   
      009DE2 03 5A            [ 2]    1         decw y
      009DE3 20 26            [ 2] 2085 	jra input_exit ; all variables done
      001F66                       2086 8$: ;input string 
      009DE3 16               [ 1] 2087 	ldw x,y
      009DE4 05               [ 2] 2088 	ldw x,(x)
      009DE5 3F 18            [ 2] 2089 	ldw (VAR_ADR,sp),x ; save var name 
      009DE7 93 FE 13         [ 4] 2090 	call input_string  
      009DEA 01 2A 11         [ 4] 2091 	call get_var_adr 
      009DED 90 E6            [ 2] 2092 	ldw (VAR_ADR,sp),x ; needed later 
      009DEF 02 B7 19         [ 4] 2093 	call get_string_slice 
      009DF2 72 B9            [ 2] 2094 	ldw (BPTR,sp),y  
      009DF4 00 18 90 C3      [ 2] 2095 	ldw y,#tib
      009DF8 00 33 2A         [ 4] 2096 	call strcpy 
      009DFB 28 20 E9         [ 2] 2097 	ldw x,#tib 
      009DFE 17 05 06         [ 4] 2098 	call strlen 
      009E00 1E 05            [ 2] 2099 	ldw x,(VAR_ADR,sp)
      009E00 1E               [ 2] 2100 	ldw x,(x)
      009E01 05               [ 1] 2101 	ld (x),a 
      009E02 CF 00            [ 2] 2102 	ldw y,(BPTR,sp)
      009E04 2B E6            [ 2] 2103 	jra 7$   	 
      001F8C                       2104 input_exit:
      001F8C                       2105 	_drop VSIZE 
      009E06 02 A0            [ 2]    1     addw sp,#VSIZE 
      001F8E                       2106 	_next  
      009E08 03 CD 9E         [ 2]    1         jp interp_loop 
                                   2107 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 187.
Hexadecimal [24-Bits]



                                   2108 ;---------------------
                                   2109 ;BASIC: KEY
                                   2110 ; wait for a character 
                                   2111 ; received from STDIN 
                                   2112 ; input:
                                   2113 ;	none 
                                   2114 ; output:
                                   2115 ;	x  character 
                                   2116 ;---------------------
      001F91                       2117 func_key:
      009E0B 55               [ 1] 2118 	clrw x 
      009E0C 1E 05 E6         [ 4] 2119 	call qgetc 
      009E0F 02 B7            [ 1] 2120 	jreq 9$ 
      009E11 19 3F 18         [ 4] 2121 	call getc 
      009E14 72               [ 1] 2122 	rlwa x  
      001F9B                       2123 9$:
      009E15 BB               [ 4] 2124 	ret 
                                   2125 
                           000000  2126 .if 0
                                   2127 ;---------------------
                                   2128 ; BASIC: WAIT addr,mask[,xor_mask]
                                   2129 ; read in loop 'addr'  
                                   2130 ; apply & 'mask' to value 
                                   2131 ; loop while result==0.  
                                   2132 ; 'xor_mask' is used to 
                                   2133 ; invert the wait logic.
                                   2134 ; i.e. loop while not 0.
                                   2135 ;---------------------
                                   2136 	XMASK=1 ; INT_SIZE  
                                   2137 	MASK=XMASK+INT_SIZE  
                                   2138 	ADDR=MASK+INT_SIZE 
                                   2139 	VSIZE= 3*INT_SIZE 
                                   2140 cmd_wait: 
                                   2141 	call arg_list 
                                   2142 	cp a,#2
                                   2143 	jruge 0$
                                   2144 	jp syntax_error 
                                   2145 0$:	cp a,#3
                                   2146 	jreq 1$
                                   2147 	push #0 ; XMASK=0 
                                   2148 	push #0 
                                   2149 	push #0 
                                   2150 1$: 
                                   2151 	ldw x,(ADDR+1,sp) ; 16 bits address
                                   2152 2$:	ld a,(x)
                                   2153 	and a,(MASK+2,sp)
                                   2154 	xor a,(XMASK+2,sp)
                                   2155 	jreq 2$ 
                                   2156 	_drop VSIZE 
                                   2157 	_next 
                                   2158 
                                   2159 ; table of power of 2 for {0..7}
                                   2160 power2: .byte 1,2,4,8,16,32,64,128
                                   2161 
                                   2162 ;---------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 188.
Hexadecimal [24-Bits]



                                   2163 ; BASIC: BSET addr,#bit
                                   2164 ; set bit at 'addr' corresponding 
                                   2165 ; correspond to macchine with same name 
                                   2166 ; 2^^bit or [addr]
                                   2167 ; arguments:
                                   2168 ; 	addr 	memory address RAM|PERIPHERAL 
                                   2169 ;   bit		{0..7}
                                   2170 ; output:
                                   2171 ;	none 
                                   2172 ;--------------------------
                                   2173 	BIT=1 
                                   2174 	ADDR=BIT+INT_SIZE 
                                   2175 cmd_bit_set:
                                   2176 	call arg_list 
                                   2177 	cp a,#2	 
                                   2178 	jreq 1$ 
                                   2179 	jp syntax_error
                                   2180 1$: 
                                   2181 	ldw x,#power2
                                   2182 	addw x,(BIT+1,sp) 
                                   2183 	ld a,(x)
                                   2184 	ldw x,(ADDR+1,sp)
                                   2185     or a,(x)
                                   2186 	ld (x),a 
                                   2187 	_drop 2*INT_SIZE 
                                   2188 	_next 
                                   2189 
                                   2190 ;---------------------
                                   2191 ; BASIC: BRES addr,#bit 
                                   2192 ; reset a bit at 'addr'  
                                   2193 ; correspond to macchine with same name 
                                   2194 ; ~2^^bit and [addr]
                                   2195 ; arguments:
                                   2196 ; 	addr 	memory address RAM|PERIPHERAL 
                                   2197 ;   bit 	{0..7}  
                                   2198 ; output:
                                   2199 ;	none 
                                   2200 ;--------------------------
                                   2201 	BIT=1 
                                   2202 	ADDR=BIT+INT_SIZE 
                                   2203 cmd_bit_reset:
                                   2204 	call arg_list 
                                   2205 	cp a,#2  
                                   2206 	jreq 1$ 
                                   2207 	jp syntax_error
                                   2208 1$:  
                                   2209 	ldw x,#power2
                                   2210 	addw x,(BIT+1,sp) 
                                   2211 	ld a,(x)
                                   2212 	cpl a 
                                   2213 	ldw x,(ADDR+1,sp)
                                   2214 	and a,(x)
                                   2215 	ld (x),a 
                                   2216 	_drop 2*INT_SIZE 
                                   2217 	_next 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 189.
Hexadecimal [24-Bits]



                                   2218 
                                   2219 ;---------------------
                                   2220 ; BASIC: BTOGL addr,bit 
                                   2221 ; toggle bit at 'addr' corresponding 
                                   2222 ; 2^^bit xor [addr]
                                   2223 ; arguments:
                                   2224 ; 	addr 	memory address RAM|PERIPHERAL 
                                   2225 ;   bit	    bit to invert      
                                   2226 ; output:
                                   2227 ;	none 
                                   2228 ;--------------------------
                                   2229 	BIT=1 
                                   2230 	ADDR=BIT+INT_SIZE 
                                   2231 cmd_bit_toggle:
                                   2232 	call arg_list 
                                   2233 	cp a,#2 
                                   2234 	jreq 1$ 
                                   2235 	jp syntax_error
                                   2236 1$: 
                                   2237 	ldw x,#power2
                                   2238 	addw x,(BIT+1,sp) 
                                   2239 	ld a,(x)
                                   2240 	ldw x,(ADDR+1,sp) 
                                   2241 	xor a,(x)
                                   2242 	ld (x),a 
                                   2243 	_drop 2*INT_SIZE 
                                   2244 	_next 
                                   2245 
                                   2246 ;---------------------
                                   2247 ; BASIC: BTEST(addr,bit)
                                   2248 ; return bit value at 'addr' 
                                   2249 ; bit is in range {0..7}.
                                   2250 ; arguments:
                                   2251 ; 	addr 		memory address RAM|PERIPHERAL 
                                   2252 ;   bit 	    bit position {0..7}  
                                   2253 ; output:
                                   2254 ;	A:X       0|1 bit value  
                                   2255 ;--------------------------
                                   2256 	BIT=1 
                                   2257 	ADDR=BIT+INT_SIZE 
                                   2258 func_bit_test:
                                   2259 	call func_args 
                                   2260 	cp a,#2
                                   2261 	jreq 0$
                                   2262 	jp syntax_error
                                   2263 0$:	
                                   2264 	ldw x,#power2 
                                   2265 	addw x,(BIT+1,sp)
                                   2266 	ld a,(x)
                                   2267 	ldw x,(ADDR+1,sp)   
                                   2268     and a,(x) 
                                   2269 	jreq 1$
                                   2270 	ld a,#1
                                   2271 1$:	 
                                   2272 	clrw x 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 190.
Hexadecimal [24-Bits]



                                   2273 	rlwa x 
                                   2274 	_drop 2*INT_SIZE 
                                   2275 	ret 
                                   2276 .endif 
                                   2277 
                                   2278 ;--------------------
                                   2279 ; BASIC: POKE addr,byte
                                   2280 ; put a byte at addr 
                                   2281 ;--------------------
                           000001  2282 	VALUE=1
                           000003  2283 	POK_ADR=VALUE+INT_SIZE 
      001F9C                       2284 cmd_poke:
      009E16 00 18 C3         [ 4] 2285 	call arg_list 
      009E19 00 33            [ 1] 2286 	cp a,#2
      009E1B 2A 07            [ 1] 2287 	jreq 1$
      009E1D 1F 05 FE         [ 2] 2288 	jp syntax_error
      001FA6                       2289 1$:	
      001FA6                       2290 	_i16_fetch POK_ADR ; address   
      009E20 13 03            [ 2]    1     ldw x,(POK_ADR,sp)
      009E22 2D DC            [ 1] 2291 	ld a,(VALUE+1,sp) 
      009E24 F7               [ 1] 2292 	ld (x),a 
      001FAB                       2293 	_drop 2*INT_SIZE 
      009E24 5B 06            [ 2]    1     addw sp,#2*INT_SIZE 
      001FAD                       2294 	_next 
      009E26 CD 9D 0E         [ 2]    1         jp interp_loop 
                                   2295 
                                   2296 ;-----------------------
                                   2297 ; BASIC: PEEK(addr)
                                   2298 ; get the byte at addr 
                                   2299 ; input:
                                   2300 ;	none 
                                   2301 ; output:
                                   2302 ;	X 		value 
                                   2303 ;-----------------------
      001FB0                       2304 func_peek:
      009E29 CC 97 2B         [ 4] 2305 	call func_args
      009E2C 57 41            [ 1] 2306 	cp a,#1 
      009E2E 52 4E            [ 1] 2307 	jreq 1$
      009E30 49 4E 47         [ 2] 2308 	jp syntax_error
      001FBA                       2309 1$: _i16_pop ; address  
      009E33 3A               [ 2]    1     popw x 
      009E34 20               [ 1] 2310 	ld a,(x)
      009E35 6C               [ 1] 2311 	clrw x 
      009E36 69               [ 1] 2312 	ld xl,a 
      009E37 6E               [ 4] 2313 	ret 
                                   2314 
                                   2315 ;---------------------------
                                   2316 ; BASIC IF expr : instructions
                                   2317 ; evaluate expr and if true 
                                   2318 ; execute instructions on same line. 
                                   2319 ;----------------------------
      001FBF                       2320 kword_if: 
      009E38 65 73            [ 1] 2321 	ld a,(y)
      009E3A 20 6D            [ 1] 2322 	cp a,#STR_VAR_IDX 
      009E3C 69 73            [ 1] 2323 	jreq if_string 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 191.
Hexadecimal [24-Bits]



      009E3E 73 69            [ 1] 2324 	cp a,#QUOTE_IDX
      009E40 6E 67            [ 1] 2325 	jreq if_string 
      009E42 20 69 6E         [ 4] 2326 	call condition
      009E45 20               [ 2] 2327 	tnzw x 
      009E46 74 68            [ 1] 2328 	jrne 1$ 
      009E48 69 73 20         [ 2] 2329 	jp kword_remark 
      009E4B 70 72            [ 1] 2330 1$: ld a,#THEN_IDX 
      009E4D 6F 67 72         [ 4] 2331 	call expect 
      001FD7                       2332 cond_accepted: 
      009E50 61 6D            [ 1] 2333 	ld a,(y)
      009E52 2E 0A            [ 1] 2334 	cp a,#LITW_IDX 
      009E54 00 03            [ 1] 2335 	jrne 2$ 
      009E55 CC 21 4F         [ 2] 2336 	jp kword_goto
      001FE0                       2337 2$:	_next  
      009E55 B7 2A 1C         [ 2]    1         jp interp_loop 
                                   2338 ;-------------------------
                                   2339 ; if string condition 
                                   2340 ;--------------------------
                           000001  2341 	STR1=1 
                           000003  2342 	STR1_LEN=STR1+2
                           000005  2343 	STR2=STR1_LEN+2
                           000007  2344 	STR2_LEN=STR2+2 
                           000009  2345 	OP_REL=STR2_LEN+2 
                           00000A  2346 	YSAVE=OP_REL+1
                           00000B  2347 	VSIZE=YSAVE+1
      001FE3                       2348 if_string: 
      001FE3                       2349 	_vars VSIZE
      009E58 00 03            [ 2]    1     sub sp,#VSIZE 
      009E5A CF 00            [ 1] 2350 	clr (STR1_LEN,sp)
      009E5C 2D 90            [ 1] 2351 	clr (STR2_LEN,sp)
      009E5E 93 CD            [ 1] 2352 	incw y
      009E60 92 3D            [ 1] 2353 	cp a,#QUOTE_IDX
      009E62 81 10            [ 1] 2354 	jrne 1$ 
      009E63 17 01            [ 2] 2355 	ldw (STR1,sp),y 
      009E63 52               [ 1] 2356 	ldw x,y 
      009E64 01 08 06         [ 4] 2357 	call strlen 
      009E65 6B 04            [ 1] 2358 	ld (STR1_LEN+1,sp),a
      009E65 0F 01 03         [ 2] 2359 	addw x,(STR1_LEN,sp)
      009E67 5C               [ 1] 2360 	incw x 
      009E67 90 F6            [ 1] 2361 	ldw y,x  
      009E69 90 5C            [ 2] 2362 	jra 2$ 
      001FFF                       2363 1$:	  
      009E6B A1 01 22         [ 4] 2364 	call get_var_adr 
      009E6E 04 90 5A         [ 4] 2365 	call get_string_slice 	
      009E71 20 5A            [ 2] 2366 	ldw (STR1,sp),x 
      009E73 6B 04            [ 1] 2367 	ld (STR1_LEN+1,sp),a 
      009E73 A1 06            [ 1] 2368 2$: ld a,(y)
      009E75 27 12            [ 1] 2369 	cp a,#REL_LE_IDX 
      009E77 A1 0A            [ 1] 2370 	jrmi 3$ 
      009E79 27 16            [ 1] 2371 	cp a,#OP_REL_LAST 
      009E7B A1 03            [ 2] 2372 	jrule 4$
      002013                       2373 3$:	
      009E7D 27 28 A1         [ 2] 2374 	jp syntax_error 
      002016                       2375 4$: 
      009E80 02 27            [ 1] 2376 	ld (OP_REL,sp),a 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 192.
Hexadecimal [24-Bits]



      009E82 28 A1            [ 1] 2377 	incw y 
                                   2378 ;expect second string 	
      00201A                       2379 	_next_token 
      00201A                          1         _get_char 
      009E84 2E 27            [ 1]    1         ld a,(y)    ; 1 cy 
      009E86 2B 20            [ 1]    2         incw y      ; 1 cy 
      009E88 36 06            [ 1] 2380 	cp a,#QUOTE_IDX
      009E89 26 10            [ 1] 2381 	jrne 5$ 
      009E89 93 CD            [ 2] 2382 	ldw (STR2,sp),y 
      009E8B 85               [ 1] 2383 	ldw x,y 
      009E8C A3 90 93         [ 4] 2384 	call strlen 
      009E8F 20 D4            [ 1] 2385 	ld (STR2_LEN+1,sp),a 
      009E91 72 FB 07         [ 2] 2386 	addw x,(STR2_LEN,sp)
      009E91 CD               [ 1] 2387 	incw x 
      009E92 9B A3            [ 1] 2388 	ldw y,x 
      009E94 CD 9A            [ 2] 2389 	jra 54$
      009E96 F5 4D            [ 1] 2390 5$: cp a,#STR_VAR_IDX
      009E98 27 0B            [ 1] 2391 	jrne 3$
      009E9A 88 1B 23         [ 4] 2392 	call get_var_adr 
      009E9B CD 1A 75         [ 4] 2393 	call get_string_slice 
      009E9B F6 5C            [ 2] 2394 	ldw (STR2,sp),x 
      009E9D CD 85            [ 1] 2395 	ld (STR2_LEN+1,sp),a
      002040                       2396 54$:
      009E9F 2C 0A            [ 1] 2397 	ld a,#THEN_IDX 
      009EA1 01 26 F7         [ 4] 2398 	call expect
                                   2399 ; compare strings 
      009EA4 84 0A            [ 2] 2400 	ldw (YSAVE,sp),y 
      009EA5 1E 01            [ 2] 2401 	ldw x,(STR1,sp)
      009EA5 20 BE            [ 2] 2402 	ldw y,(STR2,sp)
      009EA7                       2403 6$:
      009EA7 03 01            [ 1] 2404 	tnz (STR1_LEN+1,sp) 
      009EA9 20 BC            [ 1] 2405 	jreq 7$ 
      009EAB 0D 08            [ 1] 2406 	tnz (STR2_LEN+1,sp)
      009EAB A6 09            [ 1] 2407 	jreq 7$ 
      009EAD CD               [ 1] 2408 	ld a,(x)
      009EAE 85 2C            [ 1] 2409 	cp a,(y)
      009EB0 20 B3            [ 1] 2410 	jrne 8$ 
      009EB2 5C               [ 1] 2411 	incw x 
      009EB2 5F 97            [ 1] 2412 	incw y 
      009EB4 58 DE            [ 1] 2413 	dec (STR1_LEN+1,sp)
      009EB6 8C 71            [ 1] 2414 	dec (STR2_LEN+1,sp)
      009EB8 FD 01            [ 2] 2415 	jra 6$ 
      002061                       2416 7$: ; string end  
      009EBA CD 85            [ 1] 2417 	ld a,(STR1_LEN+1,sp)
      009EBC 2C 20            [ 1] 2418 	cp a,(STR2_LEN+1,sp)
      002065                       2419 8$: ; no match  
      009EBE A6 0C            [ 1] 2420 	jrmi 9$ 
      009EBF 26 16            [ 1] 2421 	jrne 10$ 
                                   2422 ; STR1 == STR2  
      009EBF 90 5A            [ 1] 2423 	ld a,(OP_REL,sp)
      009EC1 CD 9A            [ 1] 2424 	cp a,#REL_EQU_IDX 
      009EC3 10 CD            [ 1] 2425 	jreq 11$ 
      009EC5 88 2E            [ 1] 2426 	jrmi 11$ 
      009EC7 CD 86            [ 2] 2427 	jra 13$ 
      002073                       2428 9$: ; STR1 < STR2 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 193.
Hexadecimal [24-Bits]



      009EC9 06 CC            [ 1] 2429 	ld a,(OP_REL,sp)
      009ECB 9E 65            [ 1] 2430 	cp a,#REL_LT_IDX 
      009ECD 27 10            [ 1] 2431 	jreq 11$
      009ECD 0D 01            [ 1] 2432 	cp a,#REL_LE_IDX  
      009ECF 26 05            [ 1] 2433 	jreq 11$
      009ED1 A6 0D            [ 2] 2434 	jra 13$  
      00207F                       2435 10$: ; STR1 > STR2 
      009ED3 CD 85            [ 1] 2436 	ld a,(OP_REL,sp)
      009ED5 2C 14            [ 1] 2437 	cp a,#REL_GT_IDX 
      009ED6 27 04            [ 1] 2438 	jreq 11$ 
      009ED6 5B 01            [ 1] 2439 	cp a,#REL_GE_IDX 
      009ED8 CC 97            [ 1] 2440 	jrne 13$ 
      002089                       2441 11$: ; accepted
      009EDA 60 0A            [ 2] 2442 	ldw y,(YSAVE,sp)
      009EDB                       2443 	_drop VSIZE 
      009EDB 17 05            [ 2]    1     addw sp,#VSIZE 
      009EDD BE 2B            [ 1] 2444 	ld a,(y)
      009EDF 1F 03            [ 1] 2445 	cp a,#LITW_IDX 
      009EE1 81 03            [ 1] 2446 	jrne 12$
      009EE2 CC 21 4F         [ 2] 2447 	jp kword_goto 
      002096                       2448 12$: _next 
      009EE2 1E 03 CF         [ 2]    1         jp interp_loop 
      002099                       2449 13$: ; rejected 
      009EE5 00 2B            [ 2] 2450 	ldw y,(YSAVE,sp)
      00209B                       2451 	_drop VSIZE
      009EE7 16 05            [ 2]    1     addw sp,#VSIZE 
      009EE9 81 16 EB         [ 2] 2452 	jp kword_remark  
      009EEA                       2453 	_next 
      009EEA CD 85 E9         [ 2]    1         jp interp_loop 
                                   2454 
                                   2455 
                                   2456 ;------------------------
                                   2457 ; BASIC: FOR var=expr 
                                   2458 ; set variable to expression 
                                   2459 ; leave variable address 
                                   2460 ; on stack and set
                                   2461 ; FLOOP bit in 'flags'
                                   2462 ;-----------------
                           000001  2463 	FSTEP=1  ; variable increment int16
                           000003  2464 	LIMIT=FSTEP+INT_SIZE ; loop limit, int16  
                           000005  2465 	CVAR=LIMIT+INT_SIZE   ; control variable data field 
                           000007  2466 	LN_ADDR=CVAR+2   ;  line.addr saved
                           000009  2467 	BPTR=LN_ADDR+2 ; basicptr saved
                           00000A  2468 	VSIZE=BPTR+1  
      0020A3                       2469 kword_for: ; { -- var_addr }
      0020A3                       2470 	_vars VSIZE
      009EED AE 95            [ 2]    1     sub sp,#VSIZE 
      0020A5                       2471 	_ldaz for_nest 
      009EEF 80 CD                    1     .byte 0xb6,for_nest 
      009EF1 85 A3            [ 1] 2472 	cp a,#8 
      009EF3 CD 85            [ 1] 2473 	jrmi 1$ 
      009EF5 E9 81            [ 1] 2474 	ld a,#ERR_FORS
      009EF7 CC 15 55         [ 2] 2475 	jp tb_error 
      009EF7 A6               [ 1] 2476 1$: inc a 
      0020B1                       2477 	_straz for_nest 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 194.
Hexadecimal [24-Bits]



      009EF8 3F CD                    1     .byte 0xb7,for_nest 
      009EFA 85 2C 81         [ 2] 2478 	ldw x,#1 
      009EFD 1F 01            [ 2] 2479 	ldw (FSTEP,sp),x  
      009EFD 9E A4            [ 1] 2480 	ld a,#VAR_IDX 
      009EFF 7F CD 85         [ 4] 2481 	call expect 
      009F02 41 9F A4         [ 4] 2482 	call get_var_adr
      009F05 7F CD 85         [ 2] 2483 	addw x,#2 
      009F08 41 81            [ 2] 2484 	ldw (CVAR,sp),x  ; control variable 
      009F0A                       2485 	_strxz ptr16 
      009F0A 52 06                    1     .byte 0xbf,ptr16 
      009F0C 0F 03            [ 1] 2486 	ld a,#REL_EQU_IDX 
      009F0E CD 9E FD         [ 4] 2487 	call expect 
      009F11 CD 9E F7         [ 4] 2488 	call expression
      009F14 5F 1F 01 1F      [ 5] 2489 	ldw [ptr16],x
      009F18 05 35            [ 1] 2490 	ld a,#TO_IDX 
      009F1A 0A 00 0F         [ 4] 2491 	call expect 
                                   2492 ;-----------------------------------
                                   2493 ; BASIC: TO expr 
                                   2494 ; second part of FOR loop initilization
                                   2495 ; leave limit on stack and set 
                                   2496 ; FTO bit in 'flags'
                                   2497 ;-----------------------------------
      0020D8                       2498 kword_to: ; { var_addr -- var_addr limit step }
      009F1D CD 85 50         [ 4] 2499     call expression   
      0020DB                       2500 2$:
      009F20 A1 2D            [ 2] 2501 	ldw (LIMIT,sp),x
      0020DD                       2502 	_next_token 
      0020DD                          1         _get_char 
      009F22 26 04            [ 1]    1         ld a,(y)    ; 1 cy 
      009F24 03 05            [ 1]    2         incw y      ; 1 cy 
      009F26 20 08            [ 1] 2503 	cp a,#STEP_IDX 
      009F28 A1 24            [ 1] 2504 	jreq kword_step
      0020E5                       2505 	_unget_token
      009F2A 26 07            [ 2]    1         decw y
      009F2C 35 10            [ 2] 2506 	jra store_loop_addr 
                                   2507 
                                   2508 ;----------------------------------
                                   2509 ; BASIC: STEP expr 
                                   2510 ; optional third par of FOR loop
                                   2511 ; initialization. 	
                                   2512 ;------------------------------------
      0020E9                       2513 kword_step: ; {var limit -- var limit step}
      009F2E 00 0F CD         [ 4] 2514     call expression 
      0020EC                       2515 2$:	
      009F31 85 50            [ 2] 2516 	ldw (FSTEP,sp),x ; step
                                   2517 ; leave loop back entry point on stack 
      0020EE                       2518 store_loop_addr:
      009F33 A1 08            [ 2] 2519 	ldw (BPTR,sp),y 
      0020F0                       2520 	_ldxz line.addr 
      009F35 26 12                    1     .byte 0xbe,line.addr 
      009F37 0D 06            [ 2] 2521 	ldw (LN_ADDR,sp),x   
      0020F4                       2522 	_next 
      009F39 27 F5 CD         [ 2]    1         jp interp_loop 
                                   2523 
                                   2524 ;--------------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 195.
Hexadecimal [24-Bits]



                                   2525 ; BASIC: NEXT var 
                                   2526 ; FOR loop control 
                                   2527 ; increment variable with step 
                                   2528 ; and compare with limit 
                                   2529 ; loop if threshold not crossed.
                                   2530 ; else stack. 
                                   2531 ;--------------------------------
                           000002  2532 	OFS=2 ; offset added by pushw y 
      0020F7                       2533 kword_next: ; {var limit step retl1 -- [var limit step ] }
                                   2534 ; skip over variable name 
      0020F7                       2535 	_tnz for_nest 
      009F3C 85 D9                    1     .byte 0x3d,for_nest 
      009F3E 1E 01            [ 1] 2536 	jrne 1$ 
      009F40 B6 0F            [ 1] 2537 	ld a,#ERR_BAD_NEXT 
      009F42 62 1F 01         [ 2] 2538 	jp tb_error
      002100                       2539 1$:
      009F45 0A 06 20 E7      [ 2] 2540 	addw y,#3 ; ignore variable token 
      009F49 1E 05            [ 2] 2541 	ldw x,(CVAR,sp)
      002106                       2542 	_strxz ptr16 
      009F49 CD 85                    1     .byte 0xbf,ptr16 
                                   2543 	; increment variable 
      009F4B 41               [ 2] 2544 	ldw x,(x)  ; get var value 
      009F4C A1 0D 27         [ 2] 2545 	addw x,(FSTEP,sp) ; var+step 
      009F4F 17 CD 97 C6      [ 5] 2546 	ldw [ptr16],x 
      009F53 24 1A 0C         [ 2] 2547 	subw x,(LIMIT,sp) 
      002113                       2548 	_strxz acc16 
      009F56 06 6B                    1     .byte 0xbf,acc16 
      009F58 04 1E            [ 1] 2549 	jreq loop_back
      002117                       2550 	_ldaz acc16 
      009F5A 01 B6                    1     .byte 0xb6,acc16 
      009F5C 0F CD            [ 1] 2551 	xor a,(FSTEP,sp)
      009F5E 83 78            [ 1] 2552 	jrpl loop_done 
      00211D                       2553 loop_back:
      009F60 72 FB            [ 2] 2554 	ldw y,(BPTR,sp)
      009F62 03 1F            [ 2] 2555 	ldw x,(LN_ADDR,sp)
      009F64 01 20 C9         [ 2] 2556 	ldw line.addr,x 
      002124                       2557 1$:	_next 
      009F67 1E 01 0D         [ 2]    1         jp interp_loop 
      002127                       2558 loop_done:
      002127                       2559 	_decz for_nest 
      009F6A 05 27                    1     .byte 0x3a,for_nest 
                                   2560 	; remove loop data from stack  
      002129                       2561 	_drop VSIZE 
      009F6C 01 50            [ 2]    1     addw sp,#VSIZE 
      009F6E                       2562 	_next 
      009F6E 99 16 E0         [ 2]    1         jp interp_loop 
                                   2563 
                                   2564 ;----------------------------
                                   2565 ; called by goto/gosub
                                   2566 ; to get target line number 
                                   2567 ; output:
                                   2568 ;    x    line address 
                                   2569 ;---------------------------
      009F6F                       2570 get_target_line:
      009F6F 5B 06 81         [ 4] 2571 	call expression 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 196.
Hexadecimal [24-Bits]



      009F72                       2572 target01: 
      009F72 CD               [ 1] 2573 	clr a 
      009F73 9E FD CD 9E F7   [ 2] 2574 	btjf flags,#FRUN,2$ 
      009F78 4F CD 86 79      [ 4] 2575 0$:	cpw x,[line.addr] 
      009F7C AE 16            [ 1] 2576 	jrult 2$ ; search from lomem 
      009F7E 80 81            [ 1] 2577 	jrugt 1$
      009F80 CE 00 2B         [ 2] 2578 	ldw x,line.addr
      009F80 72               [ 1] 2579 1$:	cpl a  ; search from this line#
      002143                       2580 2$: 	
      009F81 00 00 3B         [ 4] 2581 	call search_lineno 
      009F84 05               [ 1] 2582 	tnz a ; 0 if not found  
      009F85 A6 11            [ 1] 2583 	jrne 3$ 
      009F87 CC 95            [ 1] 2584 	ld a,#ERR_BAD_BRANCH  
      009F89 D5 15 55         [ 2] 2585 	jp tb_error 
      009F8A                       2586 3$:
      009F8A 52               [ 4] 2587 	ret 
                                   2588 
                                   2589 ;------------------------
                                   2590 ; BASIC: GOTO line# 
                                   2591 ; jump to line# 
                                   2592 ; here cstack is 2 call deep from interpreter 
                                   2593 ;------------------------
      00214F                       2594 kword_goto:
      00214F                       2595 kword_goto_1:
      009F8B 06 90 F6         [ 4] 2596 	call get_target_line
      009F8E A1 06 26 16 90   [ 2] 2597 	btjt flags,#FRUN,1$
                                   2598 ; goto line# from command line 
      009F93 5C 93 CD 85      [ 1] 2599 	bset flags,#FRUN 
      00215B                       2600 1$:
      00215B                       2601 jp_to_target:
      009F97 A3 90 93         [ 2] 2602 	ldw line.addr,x 
      009F9A CD 85 E9         [ 2] 2603 	addw x,#LINE_HEADER_SIZE
      009F9D 90 F6            [ 1] 2604 	ldw y,x   
      009F9F 90 5C A1 02 27   [ 2] 2605 	btjf flags,#FTRACE,9$ 
      009FA4 03 CC 95         [ 4] 2606 	call prt_line_no 
      00216B                       2607 9$:	_next
      009FA7 D3 16 E0         [ 2]    1         jp interp_loop 
                                   2608 
                                   2609 
                                   2610 ;--------------------
                                   2611 ; BASIC: GOSUB line#
                                   2612 ; basic subroutine call
                                   2613 ; actual line# and basicptr 
                                   2614 ; are saved on stack
                                   2615 ;--------------------
                           000001  2616 	RET_BPTR=1 ; basicptr return point 
                           000003  2617 	RET_LN_ADDR=3  ; line.addr return point 
                           000004  2618 	VSIZE=4 
      009FA8                       2619 kword_gosub:
      00216E                       2620 kword_gosub_1:
      00216E                       2621 	_ldaz gosub_nest 
      009FA8 90 F6                    1     .byte 0xb6,gosub_nest 
      009FAA 90 5C            [ 1] 2622 	cp a,#8 
      009FAC A1 02            [ 1] 2623 	jrmi 1$
      009FAE 2B 5C            [ 1] 2624 	ld a,#ERR_GOSUBS
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 197.
Hexadecimal [24-Bits]



      009FB0 A1 09 27         [ 2] 2625 	jp tb_error 
      009FB3 07               [ 1] 2626 1$: inc a
      00217A                       2627 	_straz gosub_nest 
      009FB4 A1 0A                    1     .byte 0xb7,gosub_nest 
      009FB6 27 2E CC         [ 4] 2628 	call get_target_line 
      009FB9 95 D3 12         [ 2] 2629 	ldw ptr16,x ; target line address 
      009FBB                       2630 kword_gosub_2: 
      002182                       2631 	_vars VSIZE  
      009FBB 93 FE            [ 2]    1     sub sp,#VSIZE 
                                   2632 ; save BASIC subroutine return point.   
      009FBD 1F 05            [ 2] 2633 	ldw (RET_BPTR,sp),y 
      002186                       2634 	_ldxz line.addr 
      009FBF 1E 05                    1     .byte 0xbe,line.addr 
      009FC1 CD 9F            [ 2] 2635 	ldw (RET_LN_ADDR,sp),x
      00218A                       2636 	_ldxz ptr16  
      009FC3 0A 25                    1     .byte 0xbe,ptr16 
      009FC5 05 CD            [ 2] 2637 	jra jp_to_target
                                   2638 
                                   2639 ;------------------------
                                   2640 ; BASIC: RETURN 
                                   2641 ; exit from BASIC subroutine 
                                   2642 ;------------------------
      00218E                       2643 kword_return:
      009FC7 9E EA 20 F4      [ 1] 2644 	tnz gosub_nest 
      009FCB 26 05            [ 1] 2645 	jrne 1$ 
      009FCB 1F 03            [ 1] 2646 	ld a,#ERR_BAD_RETURN 
      009FCD CD 9B A3         [ 2] 2647 	jp tb_error 
      002199                       2648 1$:
      002199                       2649 	_decz gosub_nest
      009FD0 CD 9C                    1     .byte 0x3a,gosub_nest 
      009FD2 02 7B            [ 2] 2650 	ldw y,(RET_BPTR,sp) 
      009FD4 03 F7            [ 2] 2651 	ldw x,(RET_LN_ADDR,sp)
      009FD6 7B 04 E7         [ 2] 2652 	ldw line.addr,x 
      0021A2                       2653 	_drop VSIZE 
      009FD9 01 04            [ 2]    1     addw sp,#VSIZE 
      009FDA                       2654 	_next 
      009FDA 90 F6 90         [ 2]    1         jp interp_loop 
                                   2655 
                                   2656 ;----------------------------------
                                   2657 ; BASIC: RUN [line#]
                                   2658 ; run BASIC program in RAM
                                   2659 ;----------------------------------- 
      0021A7                       2660 cmd_run: 
      009FDD 5C A1 02 27 C6   [ 2] 2661 	btjf flags,#FRUN,1$  
      0021AC                       2662 	_next ; already running 
      009FE2 90 5A 20         [ 2]    1         jp interp_loop 
      0021AF                       2663 1$: 
      009FE5 26 25 B1         [ 4] 2664 	call clear_state 
      009FE6 AE 17 FF         [ 2] 2665 	ldw x,#STACK_EMPTY
      009FE6 93               [ 1] 2666 	ldw sp,x 
      009FE7 FE 1F 05         [ 4] 2667 	call arg_list 
      009FEA CD               [ 1] 2668 	tnz  a 
      009FEB 9F 72            [ 1] 2669 	jreq 2$
      0021BC                       2670 	_i16_pop
      009FED CD               [ 2]    1     popw x 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 198.
Hexadecimal [24-Bits]



      009FEE 9B               [ 1] 2671 	clr a  
      009FEF A3 1F 05         [ 4] 2672 	call search_lineno 
      009FF2 CD               [ 1] 2673 	tnz a
      009FF3 9A F5            [ 1] 2674 	jrne 3$ 
      009FF5 17 01            [ 1] 2675 	ld a,#ERR_RANGE 
      009FF7 90 AE 16         [ 2] 2676 	jp tb_error 
      0021C9                       2677 2$:
      009FFA 80 CD 88         [ 2] 2678 	ldw x,lomem 
      0021CC                       2679 3$:
      0021CC                       2680 	_strxz line.addr 
      009FFD A0 AE                    1     .byte 0xbf,line.addr 
      009FFF 16 80 CD         [ 2] 2681 	addw x,#LINE_HEADER_SIZE
      00A002 88 86            [ 1] 2682 	ldw y,x 
      00A004 1E 05 FE F7      [ 1] 2683 	bset flags,#FRUN 
      0021D7                       2684 	_next 
      00A008 16 01 20         [ 2]    1         jp interp_loop 
                                   2685 
                                   2686 
                                   2687 ;----------------------
                                   2688 ; BASIC: END
                                   2689 ; end running program
                                   2690 ;---------------------- 
                           000001  2691 	CHAIN_LN=1 
                           000003  2692 	CHAIN_BP=3
                           000005  2693 	CHAIN_TXTBGN=5
                           000007  2694 	CHAIN_TXTEND=7
                           000008  2695 	CHAIN_CNTX_SIZE=8  
      0021DA                       2696 kword_end: 
                           000000  2697 .if 0
                                   2698 ; check for chained program 
                                   2699 	tnz chain_level
                                   2700 	jreq 8$
                                   2701 ; restore chain context 
                                   2702 	dec chain_level 
                                   2703 	ldw x,(CHAIN_LN,sp) ; chain saved in and count  
                                   2704 	ldw line.addr,x 
                                   2705 ;	ld a,(2,x)
                                   2706 ;	_straz count 
                                   2707 	ldw Y,(CHAIN_BP,sp) ; chain saved basicptr 
                                   2708 ;	ldw basicptr,Y 
                                   2709 	ldw x,(CHAIN_TXTBGN,sp)
                                   2710 	ldw lomem,x 
                                   2711 	ldw x,(CHAIN_TXTEND,sp)
                                   2712 	ldw himem,x 
                                   2713 	_drop CHAIN_CNTX_SIZE ; CHAIN saved data size  
                                   2714 	_next
                                   2715 .endif 	   
      0021DA                       2716 8$: ; clean stack 
      00A00B CE 17 FF         [ 2] 2717 	ldw x,#STACK_EMPTY
      00A00C 94               [ 1] 2718 	ldw sp,x 
      0021DE                       2719 	_rst_pending 
      00A00C 5B 06 CC         [ 2]    1     ldw x,#pending_stack+PENDING_STACK_SIZE
      0021E1                          2     _strxz psp 
      00A00F 97 60                    1     .byte 0xbf,psp 
      00A011 CC 16 A8         [ 2] 2720 	jp warm_start
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 199.
Hexadecimal [24-Bits]



                                   2721 
                                   2722 ;-----------------------
                                   2723 ; BASIC: TONE expr1,expr2
                                   2724 ; use TIMER2 channel 1
                                   2725 ; to produce a tone 
                                   2726 ; arguments:
                                   2727 ;    expr1   frequency 
                                   2728 ;    expr2   duration msec.
                                   2729 ;---------------------------
                           000001  2730 	DURATION=1 
                           000003  2731 	FREQ=DURATION+INT_SIZE
                           000005  2732 	YSAVE=FREQ+INT_SIZE 
                           000006  2733 	VSIZE=2*INT_SIZE+2    
      0021E6                       2734 cmd_tone:
      00A011 5F CD            [ 2] 2735 	pushw y
      00A013 85 4A 27         [ 4] 2736 	call arg_list 
      00A016 04 CD            [ 1] 2737 	cp a,#2 
      00A018 85 50            [ 1] 2738 	jreq 0$ 
      00A01A 02 15 53         [ 2] 2739 	jp syntax_error
      00A01B                       2740 0$:  
      00A01B 81 05            [ 2] 2741 	ldw (YSAVE,sp),y 
      00A01C                       2742 	_i16_fetch  FREQ 
      00A01C CD 98            [ 2]    1     ldw x,(FREQ,sp)
      00A01E 69 A1            [ 1] 2743 	ldw y,x 
      0021F8                       2744 	_i16_fetch  DURATION 
      00A020 02 27            [ 2]    1     ldw x,(DURATION,sp)
      00A022 03 CC 95         [ 4] 2745 	call tone  
      00A025 D3 05            [ 2] 2746 	ldw y,(YSAVE,sp)
      00A026                       2747 	_drop VSIZE 
      00A026 1E 03            [ 2]    1     addw sp,#VSIZE 
      002201                       2748 	_next 
      00A028 7B 02 F7         [ 2]    1         jp interp_loop 
                                   2749 
                                   2750 
                                   2751 ;-----------------------
                                   2752 ; BASIC: STOP
                                   2753 ; stop progam execution  
                                   2754 ; without resetting pointers 
                                   2755 ; the program is resumed
                                   2756 ; with RUN 
                                   2757 ;-------------------------
      002204                       2758 kword_stop:
      00A02B 5B 04 CC 97 60   [ 2] 2759 	btjt flags,#FRUN,2$
      00A030                       2760 	_next 
      00A030 CD 98 5E         [ 2]    1         jp interp_loop 
      00220C                       2761 2$:	 
                                   2762 ; create space on cstack to save context 
      00A033 A1 01 27         [ 2] 2763 	ldw x,#stop_msg 
      00A036 03 CC 95         [ 4] 2764 	call puts 
      002212                       2765 	_ldxz line.addr
      00A039 D3 85                    1     .byte 0xbe,line.addr 
      00A03B F6               [ 2] 2766 	ldw x,(x)
      00A03C 5F 97 81         [ 4] 2767 	call print_int 
      00A03F AE 22 3D         [ 2] 2768 	ldw x,#con_msg 
      00A03F 90 F6 A1         [ 4] 2769 	call puts 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 200.
Hexadecimal [24-Bits]



      00221E                       2770 	_vars CTXT_SIZE ; context size 
      00A042 0A 27            [ 2]    1     sub sp,#CTXT_SIZE 
      00A044 1E A1 06         [ 4] 2771 	call save_context 
      00A047 27 1A CD 9A      [ 1] 2772 	bres flags,#FRUN 
      00A04B 10 5D 26 03      [ 1] 2773 	bset flags,#FSTOP
      00A04F CC 97 6B         [ 2] 2774 	jp cmd_line  
                                   2775 
      00A052 A6 21 CD 98 50 20 61  2776 stop_msg: .asciz "\nSTOP at line "
             74 20 6C 69 6E 65 20
             00
      00A057 2C 20 43 4F 4E 20 74  2777 con_msg: .asciz ", CON to resume.\n"
             6F 20 72 65 73 75 6D
             65 2E 0A 00
                                   2778 
                                   2779 ;--------------------------------------
                                   2780 ; BASIC: CON 
                                   2781 ; continue execution after a STOP 
                                   2782 ;--------------------------------------
      00224F                       2783 kword_con:
      00A057 90 F6 A1 08 26   [ 2] 2784 	btjt flags,#FSTOP,1$ 
      002254                       2785 	_next 
      00A05C 03 CC A1         [ 2]    1         jp interp_loop 
      002257                       2786 1$:
      00A05F CF CC 97         [ 4] 2787 	call rest_context 
      00225A                       2788 	_drop CTXT_SIZE
      00A062 60 04            [ 2]    1     addw sp,#CTXT_SIZE 
      00A063 72 19 00 3B      [ 1] 2789 	bres flags,#FSTOP 
      00A063 52 0B 0F 03      [ 1] 2790 	bset flags,#FRUN 
      00A067 0F 07 90         [ 2] 2791 	jp interp_loop
                                   2792 
                                   2793 ;-----------------------
                                   2794 ; BASIC: SCR (NEW)
                                   2795 ; from command line only 
                                   2796 ; free program memory
                                   2797 ; and clear variables 
                                   2798 ;------------------------
      002267                       2799 cmd_scr: 
      002267                       2800 cmd_new: 
      00A06A 5C A1 06 26 10   [ 2] 2801 0$:	btjt flags,#FRUN,9$
      00A06F 17 01 93         [ 4] 2802 	call reset_basic 
      00226F                       2803 9$:	_next 
      00A072 CD 88 86         [ 2]    1         jp interp_loop 
                                   2804 
                                   2805 ;-----------------------------------
                                   2806 ; BASIC: ERASE "name" || \F  
                                   2807 ;  options:
                                   2808 ;   "name"    erase that program only  
                                   2809 ;     \F    erase all spi eeprom  
                                   2810 ;-----------------------------------
                           000001  2811 	LIMIT=1  ; 24 bits address 
                           000003  2812 	VSIZE = 3 
      002272                       2813 cmd_erase:
      00A075 6B 04 72 FB 03   [ 2] 2814 	btjf flags,#FRUN,0$
      002277                       2815 	_next 
      00A07A 5C 90 93         [ 2]    1         jp interp_loop 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 201.
Hexadecimal [24-Bits]



      00227A                       2816 0$:
      00227A                       2817 	_clrz farptr
      00A07D 20 0A                    1     .byte 0x3f, farptr 
      00A07F 5F               [ 1] 2818 	clrw x 
      00227D                       2819 	_strxz ptr16  
      00A07F CD 9B                    1     .byte 0xbf,ptr16 
      00227F                       2820 	_next_token
      00227F                          1         _get_char 
      00A081 A3 CD            [ 1]    1         ld a,(y)    ; 1 cy 
      00A083 9A F5            [ 1]    2         incw y      ; 1 cy 
      00A085 1F 01            [ 1] 2821 	cp a,#QUOTE_IDX 
      00A087 6B 04            [ 1] 2822 	jrne not_file
      002287                       2823 erase_program: 
      00A089 90               [ 1] 2824 	ldw x,y
      00A08A F6 A1 10         [ 4] 2825 	call skip_string  
      00A08D 2B 04 A1         [ 4] 2826 	call search_file
      00A090 15               [ 1] 2827 	tnz a 
      00A091 23 03            [ 1] 2828 	jreq 9$  ; not found 
      00A093                       2829 8$:	
      00A093 CC 95 D3         [ 4] 2830 	call erase_file  
      00A096                       2831 9$:	
      00A096 6B 09            [ 1] 2832 	clr (y)
      002296                       2833 	_next 
      00A098 90 5C 90         [ 2]    1         jp interp_loop 
      002299                       2834 not_file: 
      00A09B F6 90            [ 1] 2835 	cp a,#LITC_IDX 
      00A09D 5C A1            [ 1] 2836 	jreq 0$ 
      00A09F 06 26 10         [ 2] 2837 	jp syntax_error	
      0022A0                       2838 0$: _get_char 
      00A0A2 17 05            [ 1]    1         ld a,(y)    ; 1 cy 
      00A0A4 93 CD            [ 1]    2         incw y      ; 1 cy 
      00A0A6 88 86            [ 1] 2839 	and a,#0XDF 
      00A0A8 6B 08            [ 1] 2840 1$: cp a,#'F 
      00A0AA 72 FB            [ 1] 2841 	jreq 2$
      00A0AC 07 5C 90         [ 2] 2842 	jp syntax_error 
      0022AD                       2843 2$: 
      00A0AF 93 20 0E         [ 4] 2844 	call eeprom_erase_chip 
      0022B0                       2845 	_next 
      00A0B2 A1 0A 26         [ 2]    1         jp interp_loop 
                                   2846 	
                                   2847 ;---------------------------------------
                                   2848 ; BASIC: SAVE "name" 
                                   2849 ; save program to spi eeprom 
                                   2850 ; if file already exist, replace it.
                                   2851 ;--------------------------------------
      0022B3                       2852 cmd_save:
      00A0B5 DD CD 9B A3 CD   [ 2] 2853 	btjf flags,#FRUN,0$
      0022B8                       2854 	_next 
      00A0BA 9A F5 1F         [ 2]    1         jp interp_loop 
      0022BB                       2855 0$:
      00A0BD 05 6B 08         [ 2] 2856 	ldw x,progend  
      00A0C0 72 B0 00 2F      [ 2] 2857 	subw x,lomem 
      00A0C0 A6 21            [ 1] 2858 	jreq 6$ 
      0022C4                       2859 	_next_token 
      0022C4                          1         _get_char 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 202.
Hexadecimal [24-Bits]



      00A0C2 CD 98            [ 1]    1         ld a,(y)    ; 1 cy 
      00A0C4 50 17            [ 1]    2         incw y      ; 1 cy 
      00A0C6 0A 1E            [ 1] 2860 	cp a,#QUOTE_IDX
      00A0C8 01 16            [ 1] 2861 	jreq 1$ 
      00A0CA 05 15 53         [ 2] 2862 	jp syntax_error 
      00A0CB 93               [ 1] 2863 1$: ldw x,y 
      00A0CB 0D 04 27         [ 4] 2864 	call skip_string 
      00A0CE 12               [ 2] 2865 	pushw x 
      00A0CF 0D 08 27         [ 4] 2866 	call search_free
      00A0D2 0E F6            [ 1] 2867 	jrne 4$ 
      00A0D4 90 F1 26         [ 2] 2868 	ldw x,progend 
      00A0D7 0D 5C 90 5C      [ 2] 2869 	subw x,lomem 
      00A0DB 0A 04 0A         [ 4] 2870 	call reclaim_space 
      00A0DE 08 20            [ 1] 2871 	jreq 8$ 
      0022E5                       2872 4$: 
      00A0E0 EA               [ 2] 2873 	popw x 
      00A0E1 CD 13 62         [ 4] 2874 	call save_file
      00A0E1 7B 04            [ 2] 2875 	jra 9$ 
      0022EB                       2876 6$: 
      00A0E3 11 08 FF         [ 2] 2877 	ldw x,#no_prog  
      00A0E5 CD 05 23         [ 4] 2878 	call puts 
      00A0E5 2B 0C            [ 2] 2879 	jra 9$ 
      0022F3                       2880 8$: 
      00A0E7 26               [ 2] 2881 	popw x 
      00A0E8 16 7B 09         [ 2] 2882 	ldw x,#no_space 
      00A0EB A1 11 27         [ 4] 2883 	call puts 
      0022FA                       2884 9$:
      00A0EE 1A 2B            [ 1] 2885 	clr (y)
      0022FC                       2886 	_next 
      00A0F0 18 20 26         [ 2]    1         jp interp_loop 
                                   2887 
      00A0F3 4E 6F 20 70 72 6F 67  2888 no_prog: .asciz "No program in RAM."
             72 61 6D 20 69 6E 20
             52 41 4D 2E 00
      00A0F3 7B 09 A1 13 27 10 A1  2889 no_space: .asciz "file system full." 
             10 27 0C 20 1A 66 75
             6C 6C 2E 00
                                   2890 
                                   2891 ;-----------------------
                                   2892 ;BASIC: LOAD "fname"
                                   2893 ; load file in RAM 
                                   2894 ;-----------------------
      00A0FF                       2895 cmd_load: 
      00A0FF 7B 09 A1 14 27   [ 2] 2896 	btjf flags,#FRUN,0$
      002329                       2897 	_next 
      00A104 04 A1 12         [ 2]    1         jp interp_loop 
      00232C                       2898 0$:
      00232C                       2899 	_next_token 
      00232C                          1         _get_char 
      00A107 26 10            [ 1]    1         ld a,(y)    ; 1 cy 
      00A109 90 5C            [ 1]    2         incw y      ; 1 cy 
      00A109 16 0A            [ 1] 2900 	cp a,#QUOTE_IDX
      00A10B 5B 0B            [ 1] 2901 	jreq 1$ 
      00A10D 90 F6 A1         [ 2] 2902 	jp syntax_error
      002337                       2903 1$:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 203.
Hexadecimal [24-Bits]



      00A110 08               [ 1] 2904 	ldw x,y 
      00A111 26 03 CC         [ 4] 2905 	call skip_string 
      00A114 A1 CF CC         [ 4] 2906 	call search_file 
      00A117 97 60            [ 1] 2907 	jrne 2$ ; file found   
      00A119 AE 23 53         [ 2] 2908 	ldw x,#not_a_file 
      00A119 16 0A 5B         [ 4] 2909 	call puts 
      00A11C 0B CC            [ 2] 2910 	jra 9$ 
      002348                       2911 2$: 
      00A11E 97 6B CC         [ 4] 2912 	call reset_basic 
      00A121 97 60 39         [ 4] 2913 	call load_file
      00A123                       2914 9$: 
      00A123 52 0A            [ 1] 2915 	clr (y)
      002350                       2916 	_next  
      00A125 B6 40 A1         [ 2]    1         jp interp_loop 
                                   2917 
      00A128 08 2B 05 A6 08 CC 95  2918 not_a_file: .asciz "file not found\n"
             D5 4C B7 40 AE 00 01
             1F 01
                                   2919 
                                   2920 
                                   2921 ;---------------------
                                   2922 ; BASIC: DIR 
                                   2923 ; list programs saved 
                                   2924 ; in flash 
                                   2925 ;--------------------
                           000001  2926 	FCNT=1
      002363                       2927 cmd_dir:
      00A138 A6 09 CD 98 50   [ 2] 2928 	btjf flags,#FRUN,0$
      002368                       2929 	_next 
      00A13D CD 9B A3         [ 2]    1         jp interp_loop 
      00236B                       2930 0$:
      00A140 1C 00            [ 1] 2931 	push #0
      00A142 02 1F            [ 1] 2932 	push #0 
      00A144 05 BF 12         [ 4] 2933 	call first_file 
      002372                       2934 1$:	 
      00A147 A6 11            [ 1] 2935 	jreq 9$ 
      00A149 CD 98            [ 2] 2936 	ldw x,(FCNT,sp)
      00A14B 50               [ 1] 2937 	incw x 
      00A14C CD 99            [ 2] 2938 	ldw (FCNT,sp),x
      00A14E 32 72 CF         [ 2] 2939 	ldw x,#file_header+FILE_NAME_FIELD
      00A151 00               [ 2] 2940 	pushw x 
      00A152 12 A6 27         [ 4] 2941 	call puts
      00A155 CD               [ 2] 2942 	popw x 
      00A156 98 50 06         [ 4] 2943 	call strlen
      00A158 88               [ 1] 2944 	push a 
      00A158 CD 99            [ 1] 2945 	push #0
      00A15A 32 00 0C         [ 2] 2946 	ldw x,#FNAME_MAX_LEN 
      00A15B 72 F0 01         [ 2] 2947 	subw x,(1,sp) 
      00A15B 1F 03 90         [ 4] 2948 	call spaces 
      002390                       2949 	_drop 2  
      00A15E F6 90            [ 2]    1     addw sp,#2 
      00A160 5C A1 24         [ 2] 2950 	ldw x,#file_header+FILE_SIZE_FIELD
      00A163 27               [ 2] 2951 	ldw x,(x)
      00A164 04 90 5A         [ 4] 2952 	call print_int
      00A167 20 05 BC         [ 2] 2953 	ldw x,#file_size 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 204.
Hexadecimal [24-Bits]



      00A169 CD 05 23         [ 4] 2954 	call puts 
      00A169 CD 99 32         [ 2] 2955 	ldw x,#file_header 
      00A16C CD 14 4F         [ 4] 2956 	call skip_to_next 
      00A16C 1F 01 10         [ 4] 2957 	call next_file 
      00A16E 20 C8            [ 2] 2958 	jra 1$  
      0023AA                       2959 9$:
      00A16E 17 09 BE         [ 4] 2960 	call new_line
      00A171 2B               [ 2] 2961 	popw x 	
      00A172 1F 07 CC         [ 4] 2962 	call print_int
      00A175 97 60 C3         [ 2] 2963 	ldw x,#files_count 
      00A177 CD 05 23         [ 4] 2964 	call puts 
      00A177 3D 40            [ 1] 2965 	clr (y)
      0023B9                       2966 	_next 
      00A179 26 05 A6         [ 2]    1         jp interp_loop 
                                   2967 
      00A17C 06 CC 95 D5 73 0A 00  2968 file_size: .asciz "bytes\n"
      00A180 66 69 6C 65 73 00     2969 files_count: .asciz "files"
                                   2970 
                                   2971 
                                   2972 
                           000000  2973 .if 0
                                   2974 ;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2975 ; check if farptr address 
                                   2976 ; read only zone 
                                   2977 ;;;;;;;;;;;;;;;;;;;;;;;;;
                                   2978 check_forbidden: 
                                   2979 	tnz farptr 
                                   2980 	jrne rw_zone 
                                   2981 ; memory 0x8000..0xffff	
                                   2982 	_ldxz ptr16 
                                   2983 	cpw x,#app_space
                                   2984 	jruge rw_zone 
                                   2985 	cpw x,#OPTION_END  
                                   2986 	jrugt forbidden  
                                   2987 	cpw x,#OPTION_BASE  
                                   2988 	jruge rw_zone 
                                   2989 1$:	cpw x,#EEPROM_END 
                                   2990 	jrugt forbidden 
                                   2991 	cpw x,#EEPROM_BASE 
                                   2992 	jrult forbidden
                                   2993 	ret 
                                   2994 forbidden:
                                   2995 	ld a,#ERR_BAD_VALUE
                                   2996 	jp tb_error 
                                   2997 rw_zone:	
                                   2998 	ret 
                                   2999 
                                   3000 ;---------------------
                                   3001 ; BASIC: WRITE expr1,expr2|char|string[,expr|char|string]* 
                                   3002 ; write 1 or more byte to FLASH or EEPROM
                                   3003 ; starting at address  
                                   3004 ; input:
                                   3005 ;   expr1  	is address 
                                   3006 ;   expr2,...,exprn   are bytes to write
                                   3007 ; output:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 205.
Hexadecimal [24-Bits]



                                   3008 ;   none 
                                   3009 ;---------------------
                                   3010 cmd_write:
                                   3011 	call expression
                                   3012 	_straz farptr 
                                   3013 	_strxz ptr16
                                   3014 	call check_forbidden 
                                   3015 1$:	
                                   3016 	_next_token 
                                   3017 	cp a,#COMMA_IDX 
                                   3018 	jreq 2$ 
                                   3019 	_unget_token
                                   3020 	jra 9$ ; no more data 
                                   3021 2$:	_next_token 
                                   3022 	cp a,#LITC_IDX 
                                   3023 	jreq 4$ 
                                   3024 	cp a,#QUOTE_IDX
                                   3025 	jreq 6$
                                   3026 	_unget_token 
                                   3027 	call expression
                                   3028 3$:
                                   3029 	ld a,xl 
                                   3030 	clrw x 
                                   3031 	call write_byte
                                   3032 	jra 1$ 
                                   3033 4$: ; write character 
                                   3034 	_get_char 
                                   3035 	clrw x 
                                   3036 	call write_byte 
                                   3037 	jra 1$ 
                                   3038 6$: ; write string 
                                   3039 	clrw x 
                                   3040 7$:	ld a,(y)
                                   3041 	jreq 8$ 
                                   3042 	incw y 
                                   3043 	call write_byte 
                                   3044 	jra 7$ 
                                   3045 8$:	incw y 
                                   3046 	jra 1$ 	
                                   3047 9$:
                                   3048 	_next 
                                   3049 
                                   3050 ;---------------------
                                   3051 ; BASIC: \letter 
                                   3052 ;---------------------
                                   3053 func_back_slash:
                                   3054 	_get_char 
                                   3055 	clrw x 
                                   3056 	rlwa x 
                                   3057 	ret   
                                   3058 
                                   3059 ;----------------------------
                                   3060 ;BASIC: CHAR(expr)
                                   3061 ; évaluate expression 
                                   3062 ; and take the 7 least 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 206.
Hexadecimal [24-Bits]



                                   3063 ; bits as ASCII character
                                   3064 ; output: 
                                   3065 ; 	A:X ASCII code {0..127}
                                   3066 ;-----------------------------
                                   3067 func_char:
                                   3068 	call func_args 
                                   3069 	cp a,#1
                                   3070 	jreq 1$
                                   3071 	jp syntax_error
                                   3072 1$:	_i16_pop
                                   3073 	rrwa x 
                                   3074 	and a,#0x7f 
                                   3075 	rlwa x  
                                   3076 	ret 
                                   3077 
                                   3078 ;---------------------
                                   3079 ; BASIC: ASC(string|char|char function)
                                   3080 ; extract first character 
                                   3081 ; of string argument 
                                   3082 ; output:
                                   3083 ;    A:X    int24 
                                   3084 ;---------------------
                                   3085 func_ascii:
                                   3086 	ld a,#LPAREN_IDX
                                   3087 	call expect 
                                   3088 	_next_token 
                                   3089 	cp a,#QUOTE_IDX 
                                   3090 	jreq 1$
                                   3091 	cp a,#LITC_IDX 
                                   3092 	jreq 2$ 
                                   3093 	cp a,#CHAR_IDX  
                                   3094 	jreq 0$
                                   3095 	jp syntax_error
                                   3096 0$: ; 
                                   3097 	_call_code 
                                   3098 	jra 4$
                                   3099 1$: ; quoted string 
                                   3100 	ld a,(y)
                                   3101 	push a  
                                   3102 	call skip_string
                                   3103 	pop a  	
                                   3104 	jra 3$ 
                                   3105 2$: ; character 
                                   3106 	_get_char 
                                   3107 3$:	clrw x 
                                   3108 	rlwa x   
                                   3109 4$:	_i16_push  
                                   3110 5$:	ld a,#RPAREN_IDX 
                                   3111 	call expect
                                   3112 9$:	
                                   3113 	_i16_pop  
                                   3114 	ret 
                                   3115 
                                   3116 ;-------------------------
                                   3117 ; BASIC: UFLASH 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 207.
Hexadecimal [24-Bits]



                                   3118 ; return free flash address
                                   3119 ; scan all block starting at 
                                   3120 ; app_space and return 
                                   3121 ; address of first free block 
                                   3122 ; below extended memory.  
                                   3123 ; return 0 if no free block 
                                   3124 ; input:
                                   3125 ;  none 
                                   3126 ; output:
                                   3127 ;	X		FLASH free address
                                   3128 ;---------------------------
                                   3129 func_uflash:
                                   3130 	_clrz farptr 
                                   3131 	ldw x,#app_space  
                                   3132 	pushw x 
                                   3133 1$:	ldw ptr16,x 
                                   3134 	call scan_block
                                   3135 	tnz a  
                                   3136 	jreq 8$
                                   3137 	ldw x,(1,sp)
                                   3138 	addw x,#BLOCK_SIZE 
                                   3139 	ldw (1,sp),x 
                                   3140 	jrne 1$  
                                   3141 8$: popw x 
                                   3142 	ret 
                                   3143 
                                   3144 .endif 
                                   3145 
                                   3146 ;------------------------------
                                   3147 ; BASIC: BYE 
                                   3148 ; exit BASIC and back to monitor  
                                   3149 ;------------------------------
      0023C9                       3150 cmd_bye:
      00A180 72 A9 00 03 1E   [ 2] 3151 	btjt flags,#FRUN,9$ 
      00A185 05 BF 12 FE 72   [ 2] 3152 	btjf UART_SR,#UART_SR_TC,.
      0023D3                       3153 	_swreset
      00A18A FB 01 72 CF      [ 1]    1     mov WWDG_CR,#0X80
      0023D7                       3154 9$: _next 
      00A18E 00 12 72         [ 2]    1         jp interp_loop 
                                   3155 
                                   3156 ;-------------------------------
                                   3157 ; BASIC: SLEEP expr 
                                   3158 ; suspend execution for n msec.
                                   3159 ; input:
                                   3160 ;	none
                                   3161 ; output:
                                   3162 ;	none 
                                   3163 ;------------------------------
      0023DA                       3164 cmd_sleep:
      00A191 F0 03 BF         [ 4] 3165 	call expression
      00A194 18 27 06 B6      [ 1] 3166 	bres sys_flags,#FSYS_TIMER 
      00A198 18 18 01         [ 2] 3167 	ldw timer,x
      00A19B 2A               [10] 3168 1$:	wfi 
      00A19C 0A 00 06         [ 2] 3169 	ldw x,timer 
      00A19D 26 FA            [ 1] 3170 	jrne 1$
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 208.
Hexadecimal [24-Bits]



      0023EA                       3171 	_next 
      00A19D 16 09 1E         [ 2]    1         jp interp_loop 
                                   3172 
                                   3173 ;------------------------------
                                   3174 ; BASIC: TICKS
                                   3175 ; return msec ticks counter value 
                                   3176 ; input:
                                   3177 ; 	none 
                                   3178 ; output:
                                   3179 ;	X 	msec since reset 
                                   3180 ;-------------------------------
      0023ED                       3181 func_ticks:
      0023ED                       3182 	_ldxz ticks 
      00A1A0 07 CF                    1     .byte 0xbe,ticks 
      00A1A2 00               [ 4] 3183 	ret
                                   3184 
                                   3185 ;---------------------------------
                                   3186 ; BASIC: CHR$(expr)
                                   3187 ; return ascci character 
                                   3188 ;---------------------------------
      0023F0                       3189 func_char:
      00A1A3 2B CC            [ 1] 3190 	ld a,#LPAREN_IDX 
      00A1A5 97 60 D0         [ 4] 3191 	call expect 
      00A1A7 CD 18 B2         [ 4] 3192 	call expression 
      00A1A7 3A               [ 1] 3193 	ld a,xl 
      00A1A8 40               [ 1] 3194 	clrw x  
      00A1A9 5B 0A            [ 1] 3195 	and a,#0x7f 
      00A1AB CC               [ 1] 3196 	ld xl,a 
      00A1AC 97 60            [ 1] 3197 	ld a,#RPAREN_IDX 
      00A1AE CD 17 D0         [ 4] 3198 	call expect 
      00A1AE CD               [ 4] 3199 	ret 
                                   3200 
                                   3201 
                                   3202 ;------------------------------
                                   3203 ; BASIC: ABS(expr)
                                   3204 ; return absolute value of expr.
                                   3205 ; input:
                                   3206 ;   none
                                   3207 ; output:
                                   3208 ;   X   positive int16 
                                   3209 ;-------------------------------
      002403                       3210 func_abs:
      00A1AF 99 32 DE         [ 4] 3211 	call func_args 
      00A1B1 A1 01            [ 1] 3212 	cp a,#1 
      00A1B1 4F 72            [ 1] 3213 	jreq 0$ 
      00A1B3 01 00 3B         [ 2] 3214 	jp syntax_error
      00240D                       3215 0$: 
      00240D                       3216 	_i16_pop
      00A1B6 0C               [ 2]    1     popw x 
      00A1B7 72               [ 2] 3217 	tnzw x 
      00A1B8 C3 00            [ 1] 3218 	jrpl 1$  
      00A1BA 2B               [ 2] 3219 	negw x 
      00A1BB 25               [ 4] 3220 1$:	ret 
                                   3221 
                           000000  3222 .if 0
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 209.
Hexadecimal [24-Bits]



                                   3223 ;------------------------------
                                   3224 ; BASIC: LSHIFT(expr1,expr2)
                                   3225 ; logical shift left expr1 by 
                                   3226 ; expr2 bits 
                                   3227 ; output:
                                   3228 ; 	x 	result 
                                   3229 ;------------------------------
                                   3230 	SHIFT=1
                                   3231 	VALUE=SHIFT+INT_SIZE 
                                   3232 	VSIZE=2*INT_SIZE  
                                   3233 func_lshift:
                                   3234 	call func_args
                                   3235 	cp a,#2 
                                   3236 	jreq 1$
                                   3237 	jp syntax_error
                                   3238 1$: 
                                   3239 	ld a,(SHIFT+1,sp) ;  only low byte  
                                   3240 	_i16_fetch VALUE  
                                   3241 	tnz a 
                                   3242 	jreq 4$
                                   3243 2$:	sllw x   
                                   3244 	dec a  
                                   3245 	jrne 2$
                                   3246 4$: 
                                   3247 	_drop VSIZE 
                                   3248 	ret  
                                   3249 
                                   3250 ;------------------------------
                                   3251 ; BASIC: RSHIFT(expr1,expr2)
                                   3252 ; logical shift right expr1 by 
                                   3253 ; expr2 bits.
                                   3254 ; output:
                                   3255 ;   X 		result 
                                   3256 ;------------------------------
                                   3257 func_rshift:
                                   3258 	call func_args
                                   3259 	cp a,#2 
                                   3260 	jreq 1$
                                   3261 	jp syntax_error
                                   3262 1$: ld a,(SHIFT+1,sp) 
                                   3263 	_i16_fetch VALUE
                                   3264 	tnz a 
                                   3265 	jreq 4$
                                   3266 2$:	srlw x  
                                   3267 	dec a 
                                   3268 	jrne 2$
                                   3269 4$: 
                                   3270 	_drop VSIZE 
                                   3271 	ret 
                                   3272 
                                   3273 .endif 
                                   3274 
                                   3275 ;---------------------------------
                                   3276 ; BASIC: RND(n)
                                   3277 ; return integer [0..n-1] 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 210.
Hexadecimal [24-Bits]



                                   3278 ; ref: https://en.wikipedia.org/wiki/Xorshift
                                   3279 ;
                                   3280 ; 	x ^= x << 13;
                                   3281 ;	x ^= x >> 17;
                                   3282 ;	x ^= x << 5;
                                   3283 ;
                                   3284 ;---------------------------------
      002413                       3285 func_random:
      00A1BC 06 22 03         [ 4] 3286 	call func_args 
      00A1BF CE 00            [ 1] 3287 	cp a,#1
      00A1C1 2B 43            [ 1] 3288 	jreq 1$
      00A1C3 CC 15 53         [ 2] 3289 	jp syntax_error
      00241D                       3290 1$:
      00A1C3 CD 8C FB         [ 4] 3291 	call prng 
      00A1C6 4D 26            [ 2] 3292 	pushw y 
      00A1C8 05 A6            [ 2] 3293 	ldw y,(3,sp)
      00A1CA 04               [ 2] 3294 	divw x,y 
      00A1CB CC               [ 1] 3295 	exgw x,y 
      00A1CC 95 D5            [ 2] 3296 	popw y 
      00A1CE                       3297 	_drop 2 
      00A1CE 81 02            [ 2]    1     addw sp,#2 
      00A1CF 81               [ 4] 3298 	ret 
                                   3299 
                                   3300 ;---------------------------------
                                   3301 ; BASIC: RANDOMIZE expr 
                                   3302 ; intialize PRGN seed with expr 
                                   3303 ; or with ticks variable value 
                                   3304 ; if expr==0
                                   3305 ;---------------------------------
      00A1CF                       3306 cmd_randomize:
      00A1CF CD A1 AE         [ 4] 3307 	call expression 
      00A1D2 72 00 00         [ 4] 3308 	call set_seed 
      002431                       3309 	_next 
      00A1D5 3B 04 72         [ 2]    1         jp interp_loop 
                                   3310 
                                   3311 ;------------------------------
                                   3312 ; BASIC: SGN(expr)
                                   3313 ;    return -1 < 0 
                                   3314 ;    return 0 == 0
                                   3315 ;    return 1 > 0 
                                   3316 ;-------------------------------
      002434                       3317 func_sign:
      00A1D8 10 00 3B         [ 4] 3318 	call func_args 
      00A1DB A1 01            [ 1] 3319 	cp a,#1 
      00A1DB 27 03            [ 1] 3320 	jreq 0$ 
      00A1DB CF 00 2B         [ 2] 3321 	jp syntax_error
      00243E                       3322 0$:
      00243E                       3323 	_i16_pop  
      00A1DE 1C               [ 2]    1     popw x 
      00A1DF 00 03            [ 1] 3324 	jreq 9$
      00A1E1 90 93            [ 1] 3325 	jrmi 4$
      00A1E3 72 0F 00         [ 2] 3326 	ldw x,#1
      00A1E6 3B               [ 4] 3327 	ret
      00A1E7 03 CD 97         [ 2] 3328 4$: ldw x,#-1 
      00A1EA 9A CC 97         [ 4] 3329 call print_int   
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 211.
Hexadecimal [24-Bits]



      00A1ED 60               [ 4] 3330 9$:	ret 
                                   3331 
                                   3332 ;-----------------------------
                                   3333 ; BASIC: LEN(var$||quoted string)
                                   3334 ;  return length of string 
                                   3335 ;----------------------------
      00A1EE                       3336 func_len:
      00A1EE A6 04            [ 1] 3337 	ld a,#LPAREN_IDX 
      00A1EE B6 41 A1         [ 4] 3338 	call expect 
      002453                       3339 	_next_token 
      002453                          1         _get_char 
      00A1F1 08 2B            [ 1]    1         ld a,(y)    ; 1 cy 
      00A1F3 05 A6            [ 1]    2         incw y      ; 1 cy 
      00A1F5 07 CC            [ 1] 3340 	cp a,#QUOTE_IDX
      00A1F7 95 D5            [ 1] 3341 	jrne 2$ 
      00A1F9 4C               [ 1] 3342 	ldw x,y 
      00A1FA B7 41 CD         [ 4] 3343 	call strlen
      00A1FD A1               [ 1] 3344 	push a 
      00A1FE AE CF            [ 1] 3345 	push #0 
      00A200 00 12 01         [ 2] 3346 	addw y,(1,sp)
      00A202 90 5C            [ 1] 3347 	incw y 
      002467                       3348 	_drop 2 
      00A202 52 04            [ 2]    1     addw sp,#2 
      00A204 17 01            [ 2] 3349 	jra 9$ 
      00246B                       3350 2$:
      00A206 BE 2B            [ 1] 3351 	cp a,#STR_VAR_IDX 
      00A208 1F 03            [ 1] 3352 	jreq 3$ 
      00A20A BE 12 20         [ 2] 3353 	jp syntax_error
      002472                       3354 3$:
      00A20D CD 1B 23         [ 4] 3355 	call get_var_adr  
      00A20E EE 02            [ 2] 3356 	ldw x,(2,x) 
      00A20E 72               [ 1] 3357 	incw x 
      00A20F 5D 00 41         [ 4] 3358 	call strlen
      00247B                       3359 9$:
      00A212 26               [ 1] 3360 	clrw x 
      00A213 05               [ 1] 3361 	ld xl,a 
      00A214 A6 05            [ 1] 3362 	ld a,#RPAREN_IDX
      00A216 CC 95 D5         [ 4] 3363 	call expect 
      00A219 81               [ 4] 3364 	ret 
                                   3365 
                           000001  3366 .if 1
                                   3367 ;---------------------------------
                                   3368 ; BASIC: WORDS [\C]
                                   3369 ; affiche la listes des mots 
                                   3370 ; réservés ainsi que le nombre
                                   3371 ; de mots.
                                   3372 ; si l'option \C est présente 
                                   3373 ; affiche la valeur tokenizé des 
                                   3374 ; mots réservés 
                                   3375 ;---------------------------------
                           000001  3376 	COL_CNT=1 ; column counter 
                           000002  3377 	WCNT=COL_CNT+1 ; count words printed 
                           000003  3378 	NBR_COL=WCNT+1 ; display columns 
                           000004  3379 	WIDTH_DIV=NBR_COL+1 ; modulo divisor for column width 
                           000005  3380 	YSAVE=WIDTH_DIV+1
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 212.
Hexadecimal [24-Bits]



                           000007  3381 	XSAVE=YSAVE+2 
                           000008  3382 	VSIZE=XSAVE+1  	
      002483                       3383 cmd_words:
      002483                       3384 	_vars VSIZE
      00A219 3A 41            [ 2]    1     sub sp,#VSIZE 
      00A21B 16 01            [ 1] 3385 	ld a,#4 ; default to 4 columns 
      00A21D 1E 03            [ 1] 3386 	ld (COL_CNT,sp),a 
      00A21F CF 00            [ 1] 3387 	ld (NBR_COL,sp),a 
      00A221 2B 5B            [ 1] 3388 	clr (WCNT,sp)
      00A223 04 CC            [ 1] 3389 	ld a,#11 ; default width 10 characters + 1 
      00A225 97 60            [ 1] 3390 	ld (WIDTH_DIV,sp),a ; modulo divisor 
      00A227                       3391 	_clrz acc16  
      00A227 72 01                    1     .byte 0x3f, acc16 
      00A229 00 3B            [ 2] 3392 	ldw (YSAVE,sp),y 
      00A22B 03 CC            [ 1] 3393 	ld a,(y)
      00A22D 97 60            [ 1] 3394 	cp a,#LITC_IDX 
      00A22F 26 1F            [ 1] 3395 	jrne 1$ 
      00A22F CD A6            [ 1] 3396 	incw y 
      00249D                       3397 	_get_char 
      00A231 31 AE            [ 1]    1         ld a,(y)    ; 1 cy 
      00A233 17 FF            [ 1]    2         incw y      ; 1 cy 
      00A235 94 CD            [ 1] 3398 	cp a,#'C 
      00A237 98 69            [ 1] 3399 	jreq 0$ 
      00A239 4D 27 0D         [ 2] 3400 	jp syntax_error 
      0024A8                       3401 0$: 
      00A23C 85 4F            [ 2] 3402 	ldw (YSAVE,sp),y 
      00A23E CD 8C            [ 1] 3403 	ld a,#3 ; 3 columns when showing token bytecode
      00A240 FB 4D            [ 1] 3404 	ld (COL_CNT,sp),a  	
      00A242 26 08            [ 1] 3405 	ld (NBR_COL,sp),a 
      00A244 A6 0D            [ 1] 3406 	ld a,#10 ; column width 13 characters - 4 + 1
      00A246 CC 95            [ 1] 3407 	ld (WIDTH_DIV,sp),a ; modulo divisor 
      00A248 D5 AE 28 CE      [ 2] 3408 	ldw y,#all_words+2 ; special char. bytecode 
      00A249 20 04            [ 2] 3409 	jra 2$
      0024BA                       3410 1$: 
      00A249 CE 00 2F 51      [ 2] 3411 	ldw y,#kword_dict+2 ; show only reserved words 
      00A24C                       3412 2$:
      00A24C BF               [ 1] 3413 	ldw x,y
      00A24D 2B               [ 1] 3414 	ld a,(x)
      00A24E 1C               [ 1] 3415 	incw x  	
      00A24F 00 03            [ 2] 3416 	ldw (XSAVE,sp),x 
      00A251 90               [ 1] 3417 	clrw x 
      00A252 93               [ 1] 3418 	ld xl,a 
      00A253 72 10            [ 1] 3419 	ld a,(WIDTH_DIV,sp)
      00A255 00               [ 2] 3420 	div x,a 
      00A256 3B CC            [ 2] 3421 	ldw x,(XSAVE,sp)
      00A258 97               [ 1] 3422 	inc a 
      0024CB                       3423 	_straz acc8 	 	
      00A259 60 19                    1     .byte 0xb7,acc8 
      00A25A 7B 03            [ 1] 3424 	ld a,(NBR_COL,sp)
      00A25A A1 04            [ 1] 3425 	cp a,#4 
      00A25A AE 17            [ 1] 3426 	jreq 3$
      00A25C FF 94            [ 1] 3427 	ld a,#'$
      00A25E AE 00 54         [ 4] 3428 	call putc 
      00A261 BF 42 CC 97      [ 4] 3429 	ld a,([acc16],x)
      00A265 28 07 9C         [ 4] 3430 	call print_hex
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 213.
Hexadecimal [24-Bits]



      00A266 CD 05 86         [ 4] 3431 	call space   
      0024E2                       3432 3$:
      00A266 90 89 CD         [ 4] 3433 	call puts 
      00A269 98 69            [ 1] 3434 	inc (WCNT,sp)
      00A26B A1 02            [ 1] 3435 	dec (COL_CNT,sp)
      00A26D 27 03            [ 1] 3436 	jreq 5$
      00A26F CC 95            [ 1] 3437 	ld a,(WIDTH_DIV,sp)
      00A271 D3 00 19         [ 1] 3438 	sub a,acc8 
      00A272 2A 02            [ 1] 3439 	jrpl 4$
      00A272 17 05            [ 1] 3440 	ld a,#9
      00A274 1E               [ 1] 3441 4$: clrw x 
      00A275 03               [ 1] 3442 	ld xl,a 
      00A276 90 93 1E         [ 4] 3443 	call spaces 
      00A279 01 CD            [ 2] 3444 	jra 6$ 
      00A27B 82 B9            [ 1] 3445 5$: ld a,#CR 
      00A27D 16 05 5B         [ 4] 3446 	call putc 
      00A280 06 CC            [ 1] 3447 	ld a,(NBR_COL,sp) 
      00A282 97 60            [ 1] 3448 	ld (COL_CNT,sp),a 
      00A284 72 A2 00 02      [ 2] 3449 6$:	subw y,#2 
      00A284 72 00            [ 2] 3450 	ldw y,(y)
      00A286 00 3B            [ 1] 3451 	jrne 2$ 
      00A288 03 CC            [ 1] 3452 	ld a,#CR 
      00A28A 97 60 AC         [ 4] 3453 	call putc  
      00A28C 5F               [ 1] 3454 	clrw x 
      00A28C AE A2            [ 1] 3455 	ld a,(WCNT,sp)
      00A28E AE               [ 1] 3456 	ld xl,a 
      00A28F CD 85 A3         [ 4] 3457 	call print_int 
      00A292 BE 2B FE         [ 2] 3458 	ldw x,#words_count_msg
      00A295 CD 88 2E         [ 4] 3459 	call puts 
      00A298 AE A2            [ 2] 3460 	ldw y,(YSAVE,sp)
      002520                       3461 	_drop VSIZE 
      00A29A BD CD            [ 2]    1     addw sp,#VSIZE 
      002522                       3462 	_next 
      00A29C 85 A3 52         [ 2]    1         jp interp_loop 
      00A29F 04 CD 9E DB 72 11 00  3463 words_count_msg: .asciz " words in dictionary\n"
             3B 72 18 00 3B CC 97
             2B 0A 53 54 4F 50 20
             61
                                   3464 .endif 
                                   3465 
                                   3466 ;-----------------------------
                                   3467 ; BASIC: TIMER expr 
                                   3468 ; initialize count down timer 
                                   3469 ;-----------------------------
      00253B                       3470 cmd_set_timer:
      00A2B5 74 20 6C         [ 4] 3471 	call arg_list
      00A2B8 69 6E            [ 1] 3472 	cp a,#1 
      00A2BA 65 20            [ 1] 3473 	jreq 1$
      00A2BC 00 2C 20         [ 2] 3474 	jp syntax_error
      002545                       3475 1$: 
      002545                       3476 	_i16_pop  
      00A2BF 43               [ 2]    1     popw x 
      00A2C0 4F 4E 20 74      [ 1] 3477 	bres sys_flags,#FSYS_TIMER  
      00A2C4 6F 20 72         [ 2] 3478 	ldw timer,x
      00254D                       3479 	_next 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 214.
Hexadecimal [24-Bits]



      00A2C7 65 73 75         [ 2]    1         jp interp_loop 
                                   3480 
                                   3481 ;------------------------------
                                   3482 ; BASIC: TIMEOUT 
                                   3483 ; return state of timer 
                                   3484 ; output:
                                   3485 ;   A:X     0 not timeout 
                                   3486 ;   A:X     -1 timeout 
                                   3487 ;------------------------------
      002550                       3488 func_timeout:
      00A2CA 6D               [ 1] 3489 	clr a 
      00A2CB 65               [ 1] 3490 	clrw x 
      00A2CC 2E 0A 00 0A 02   [ 2] 3491 	btjf sys_flags,#FSYS_TIMER,1$ 
      00A2CF 43               [ 1] 3492 	cpl a 
      00A2CF 72               [ 2] 3493 	cplw x 
      00A2D0 08               [ 4] 3494 1$:	ret 
                                   3495  	
                           000000  3496 .if 0
                                   3497 ;------------------------------
                                   3498 ; BASIC: DO 
                                   3499 ; initiate a DO ... UNTIL loop 
                                   3500 ;------------------------------
                                   3501 	DOLP_ADR=1 
                                   3502 	DOLP_LN_ADDR=3
                                   3503 	VSIZE=4 
                                   3504 kword_do:
                                   3505 	_vars VSIZE 
                                   3506 	ldw (DOLP_ADR,sp),y
                                   3507 	_ldxz line.addr  
                                   3508 	ldw (DOLP_LN_ADDR,sp),x
                                   3509 	_next 
                                   3510 
                                   3511 ;--------------------------------
                                   3512 ; BASIC: UNTIL expr 
                                   3513 ; loop if exprssion is false 
                                   3514 ; else terminate loop
                                   3515 ;--------------------------------
                                   3516 kword_until: 
                                   3517 	call condition  
                                   3518 	tnz a 
                                   3519 	jrne 9$ 
                                   3520 	tnzw x 
                                   3521 	jrne 9$ 
                                   3522 	ldw y,(DOLP_ADR,sp)
                                   3523 ;	ldw basicptr,y 
                                   3524 	ldw x,(DOLP_LN_ADDR,sp)
                                   3525 	ldw line.addr,x
                                   3526 	btjf flags,#FRUN,8$ 
                                   3527 ;	ld a,(2,x)
                                   3528 ;	_straz count  
                                   3529 8$:	_next 
                                   3530 9$:	; remove loop data from stack  
                                   3531 	_drop VSIZE
                                   3532 	_next 
                                   3533 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 215.
Hexadecimal [24-Bits]



                                   3534 const_hse:
                                   3535 	ldw x,#CLK_SWR_HSE
                                   3536 	clr a 
                                   3537 	ret 
                                   3538 const_hsi:
                                   3539 	ldw x,#CLK_SWR_HSI
                                   3540 	clr a 
                                   3541 	ret 
                                   3542 .endif 
                                   3543 
                                   3544 ;-----------------------
                                   3545 ; memory area constants
                                   3546 ;-----------------------
      00255A                       3547 const_eeprom_base:
      00A2D1 00               [ 1] 3548 	clr a  
      00A2D2 3B 03 CC         [ 2] 3549 	ldw x,#EEPROM_BASE 
      00A2D5 97               [ 4] 3550 	ret 
                                   3551 
                           000000  3552 .if 0
                                   3553 ;---------------------------
                                   3554 ; BASIC: DATA 
                                   3555 ; when the interpreter find 
                                   3556 ; a DATA line it skip over 
                                   3557 ;---------------------------
                                   3558 kword_data:
                                   3559 	jp kword_remark
                                   3560 
                                   3561 ;------------------------------
                                   3562 ; check if line is data line 
                                   3563 ; if so set data_pointers 
                                   3564 ; and return true 
                                   3565 ; else move X to next line 
                                   3566 ; and return false 
                                   3567 ; input:
                                   3568 ;    X     line addr 
                                   3569 ; outpu:
                                   3570 ;    A     0 not data 
                                   3571 ;          1 data pointers set 
                                   3572 ;    X     updated to next line addr 
                                   3573 ;          if not data line 
                                   3574 ;--------------------------------
                                   3575 is_data_line:
                                   3576 	ld a,(LINE_HEADER_SIZE,x)
                                   3577 	cp a,#DATA_IDX 
                                   3578 	jrne 1$
                                   3579 	_strxz data_line 
                                   3580 	addw x,#FIRST_DATA_ITEM
                                   3581 	_strxz data_ptr  
                                   3582 	ld a,#1 
                                   3583 	ret 
                                   3584 1$: clr acc16 
                                   3585 	ld a,(2,x)
                                   3586 	ld acc8,a 
                                   3587 	addw x,acc16
                                   3588 	clr a 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 216.
Hexadecimal [24-Bits]



                                   3589 	ret  
                                   3590 
                                   3591 ;---------------------------------
                                   3592 ; BASIC: RESTORE [line#]
                                   3593 ; set data_ptr to first data line
                                   3594 ; if no DATA found pointer set to
                                   3595 ; zero.
                                   3596 ; if a line# is given as argument 
                                   3597 ; a data line with that number 
                                   3598 ; is searched and the data pointer 
                                   3599 ; is set to it. If there is no 
                                   3600 ; data line with that number 
                                   3601 ; the program is interrupted. 
                                   3602 ;---------------------------------
                                   3603 cmd_restore:
                                   3604 	clrw x 
                                   3605 	ldw data_line,x 
                                   3606 	ldw data_ptr,x 
                                   3607 	_next_token 
                                   3608 	cp a,#CMD_END 
                                   3609 	jrugt 0$ 
                                   3610 	_unget_token 
                                   3611 	_ldxz lomem 
                                   3612 	jra 4$ 
                                   3613 0$:	cp a,#LITW_IDX
                                   3614 	jreq 2$
                                   3615 1$: jp syntax_error 	 
                                   3616 2$:	_get_word 
                                   3617 	call search_lineno  
                                   3618 	tnz a  
                                   3619 	jreq data_error 
                                   3620 	call is_data_line
                                   3621 	tnz a 
                                   3622 	jrne 9$ 
                                   3623 	jreq data_error
                                   3624 4$:
                                   3625 ; search first DATA line 	
                                   3626 5$:	
                                   3627 	cpw x,himem
                                   3628 	jruge data_error 
                                   3629 	call is_data_line 
                                   3630 	tnz a 
                                   3631 	jreq 5$ 
                                   3632 9$:	_next  
                                   3633 
                                   3634 data_error:	
                                   3635     ld a,#ERR_NO_DATA 
                                   3636 	jp tb_error 
                                   3637 
                                   3638 
                                   3639 ;---------------------------------
                                   3640 ; BASIC: READ 
                                   3641 ; return next data item | data error
                                   3642 ; output:
                                   3643 ;    A:X int24  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 217.
Hexadecimal [24-Bits]



                                   3644 ;---------------------------------
                                   3645 func_read_data:
                                   3646 read01:	
                                   3647 	ldw x,data_ptr
                                   3648 	ld a,(x)
                                   3649 	incw x 
                                   3650 	tnz a 
                                   3651 	jreq 4$ ; end of line
                                   3652 	cp a,#REM_IDX
                                   3653 	jreq 4$  
                                   3654 	cp a,#COMMA_IDX 
                                   3655 	jrne 1$ 
                                   3656 	ld a,(x)
                                   3657 	incw x 
                                   3658 1$:
                                   3659 .if 0
                                   3660 	cp a,#LIT_IDX 
                                   3661 	jreq 2$
                                   3662 .endif
                                   3663 	cp a,#LITW_IDX 
                                   3664 	jreq 14$
                                   3665 	jra data_error 
                                   3666 14$: ; word 
                                   3667 	clr a 
                                   3668 	_strxz data_ptr 	
                                   3669 	ldw x,(x)
                                   3670 .if 0	
                                   3671 	jra 24$
                                   3672 2$:	; int24  
                                   3673 	ld a,(x)
                                   3674 	incw x 
                                   3675 	_strxz data_ptr 
                                   3676 	ldw x,(x)
                                   3677 24$:
                                   3678 .endif 
                                   3679 	pushw x 
                                   3680 	_ldxz data_ptr 
                                   3681 	addw x,#2 
                                   3682 	_strxz data_ptr
                                   3683 	popw x 
                                   3684 3$:
                                   3685 	ret 
                                   3686 4$: ; check if next line is DATA  
                                   3687 	_ldxz data_line
                                   3688 	ld a,(2,x)
                                   3689 	ld acc8,a
                                   3690 	clr acc16  
                                   3691 	addw x,acc16 
                                   3692 	call is_data_line 
                                   3693 	tnz a 
                                   3694 	jrne read01  
                                   3695 	jra data_error 
                                   3696 
                                   3697 ;-------------------------------
                                   3698 ; BASIC: PAD 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 218.
Hexadecimal [24-Bits]



                                   3699 ; Return pad buffer address.
                                   3700 ;------------------------------
                                   3701 const_pad_ref:
                                   3702 	ldw x,#pad 
                                   3703 	clr a
                                   3704 	ret 
                                   3705 
                                   3706 ;-------------------------------
                                   3707 ; BASIC: CHAIN label
                                   3708 ; Execute another program like it 
                                   3709 ; is a sub-routine. When the 
                                   3710 ; called program terminate 
                                   3711 ; execution continue at caller 
                                   3712 ; after CHAIN command. 
                                   3713 ; if a line# is given, the 
                                   3714 ; chained program start execution 
                                   3715 ; at this line#.
                                   3716 ;---------------------------------
                                   3717 	CHAIN_ADDR=1 
                                   3718 	CHAIN_LNADR=3
                                   3719 	CHAIN_BP=5
                                   3720 	CHAIN_TXTBGN=7 
                                   3721 	CHAIN_TXTEND=9 
                                   3722 	VSIZE=10
                                   3723 	DISCARD=2
                                   3724 cmd_chain:
                                   3725 	_vars VSIZE 
                                   3726 	clr (CHAIN_LN,sp) 
                                   3727 	clr (CHAIN_LN+1,sp)  
                                   3728 	ld a,#LABEL_IDX 
                                   3729 	call expect 
                                   3730 	pushw y 
                                   3731 	call skip_label
                                   3732 	popw x 
                                   3733 	incw x
                                   3734 	call search_file 
                                   3735 	tnzw x  
                                   3736 	jrne 1$ 
                                   3737 0$:	ld a,#ERR_BAD_VALUE
                                   3738 	jp tb_error 
                                   3739 1$: addw x,#FILE_HEADER_SIZE 
                                   3740 	ldw (CHAIN_ADDR,sp), x ; program addr 
                                   3741 ; save chain context 
                                   3742 	_ldxz line.addr 
                                   3743 	ldw (CHAIN_LNADR,sp),x 
                                   3744 	ldw (CHAIN_BP,sp),y
                                   3745 	_ldxz lomem 
                                   3746 	ldw (CHAIN_TXTBGN,sp),x
                                   3747 	_ldxz himem 
                                   3748 	ldw (CHAIN_TXTEND,sp),x  
                                   3749 ; set chained program context 	
                                   3750 	ldw x,(CHAIN_ADDR,sp)
                                   3751 	ldw line.addr,x 
                                   3752 	ldw lomem,x 
                                   3753 	subw x,#2
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 219.
Hexadecimal [24-Bits]



                                   3754 	ldw x,(x)
                                   3755 	addw x,(CHAIN_ADDR,sp)
                                   3756 	ldw himem,x  
                                   3757 	ldw y,(CHAIN_ADDR,sp)
                                   3758 	addw y,#LINE_HEADER_SIZE 
                                   3759     _incz chain_level
                                   3760 	_drop DISCARD
                                   3761 	_next 
                                   3762 
                                   3763 
                                   3764 ;-----------------------------
                                   3765 ; BASIC TRACE 0|1 
                                   3766 ; disable|enable line# trace 
                                   3767 ;-----------------------------
                                   3768 cmd_trace:
                                   3769 	_next_token
                                   3770 	cp a,#LITW_IDX
                                   3771 	jreq 1$ 
                                   3772 	jp syntax_error 
                                   3773 1$: _get_word 
                                   3774     tnzw x 
                                   3775 	jrne 2$ 
                                   3776 	bres flags,#FTRACE 
                                   3777 	_next 
                                   3778 2$: bset flags,#FTRACE 
                                   3779 	_next 
                                   3780 
                                   3781 .endif 
                                   3782 
                                   3783 ;-------------------------
                                   3784 ; BASIC: TAB expr 
                                   3785 ;  print spaces 
                                   3786 ;------------------------
      00255F                       3787 cmd_tab:
      00A2D6 60 18 B2         [ 4] 3788 	call expression  
      00A2D7 4F               [ 1] 3789 	clr a 
      00A2D7 CD               [ 1] 3790 	ld xh,a
      00A2D8 9E E2 5B         [ 4] 3791 	call spaces 
      002567                       3792 	_next 
      00A2DB 04 72 19         [ 2]    1         jp interp_loop 
                                   3793 
                                   3794 ;---------------------
                                   3795 ; BASIC: CALL expr1 [,func_arg] 
                                   3796 ; execute a function written 
                                   3797 ; in binary code.
                                   3798 ; input:
                                   3799 ;   expr1	routine address
                                   3800 ;   expr2   optional argument passed in X  
                                   3801 ; output:
                                   3802 ;    none 
                                   3803 ;---------------------
                           000001  3804 	FN_ARG=1
                           000003  3805 	FN_ADR=3
      00256A                       3806 cmd_call::
      00A2DE 00 3B 72         [ 4] 3807 	call arg_list 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 220.
Hexadecimal [24-Bits]



      00A2E1 10 00            [ 1] 3808 	cp a,#1
      00A2E3 3B CC            [ 1] 3809 	jreq 1$
      00A2E5 97 60            [ 1] 3810 	cp a,#2
      00A2E7 27 03            [ 1] 3811 	jreq 0$ 
      00A2E7 CC 15 53         [ 2] 3812 	jp syntax_error 
      002578                       3813 0$: 
      002578                       3814 	_i16_fetch FN_ADR  
      00A2E7 72 00            [ 2]    1     ldw x,(FN_ADR,sp)
      00257A                       3815 	_strxz ptr16 
      00A2E9 00 3B                    1     .byte 0xbf,ptr16 
      00257C                       3816 	_i16_pop 
      00A2EB 03               [ 2]    1     popw x 
      00257D                       3817 	_drop 2 
      00A2EC CD 96            [ 2]    1     addw sp,#2 
      00A2EE B1 CC 97 60      [ 6] 3818 	call [ptr16]
      00A2F2                       3819 	_next 
      00A2F2 72 01 00         [ 2]    1         jp interp_loop 
      002586                       3820 1$: _i16_pop 	
      00A2F5 3B               [ 2]    1     popw x 
      00A2F6 03               [ 4] 3821 	call (x)
      002588                       3822 	_next 
      00A2F7 CC 97 60         [ 2]    1         jp interp_loop 
                                   3823 
                                   3824 ;------------------------
                                   3825 ; BASIC:AUTO expr1, expr2 
                                   3826 ; enable auto line numbering
                                   3827 ;  expr1   start line number 
                                   3828 ;  expr2   line# increment 
                                   3829 ;-----------------------------
      00A2FA                       3830 cmd_auto:
      00A2FA 3F 11 5F BF 12   [ 2] 3831 	btjt flags,#FRUN,9$ 
      00A2FF 90 F6 90         [ 4] 3832 	call arg_list 
      00A302 5C A1 06         [ 2] 3833 	ldw x,#10 
      00A305 26               [ 1] 3834 	tnz a 
      00A306 12 15            [ 1] 3835 	jreq 9$ 
      00A307 A1 01            [ 1] 3836 	cp a,#1
      00A307 93 CD            [ 1] 3837 	jreq 1$
      00A309 97 A7            [ 1] 3838 	cp a,#2
      00A30B CD 93            [ 1] 3839 	jreq 0$ 
      00A30D 31 4D 27         [ 2] 3840 	jp syntax_error 
      0025A4                       3841 0$: 
      0025A4                       3842 	_i16_pop 
      00A310 03               [ 2]    1     popw x 
      00A311                       3843 1$:	
      0025A5                       3844 	_strxz auto_step 
      00A311 CD 93                    1     .byte 0xbf,auto_step 
      0025A7                       3845 	 _i16_pop 
      00A313 5B               [ 2]    1     popw x 
      00A314                       3846 	_strxz auto_line
      00A314 90 7F                    1     .byte 0xbf,auto_line 
      00A316 CC 97 60 3B      [ 1] 3847 	bset flags,#FAUTO
      00A319                       3848 9$: 
      0025AE                       3849 	_next 
      00A319 A1 07 27         [ 2]    1         jp interp_loop 
                                   3850 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 221.
Hexadecimal [24-Bits]



                                   3851 
      0025B1                       3852 clear_state:
      0025B1                       3853 	_ldxz dvar_bgn
      00A31C 03 CC                    1     .byte 0xbe,dvar_bgn 
      0025B3                       3854 	_strxz dvar_end 
      00A31E 95 D3                    1     .byte 0xbf,dvar_end 
      00A320 90 F6 90         [ 2] 3855 	ldw x,himem  
      0025B8                       3856 	_strxz heap_free  
      00A323 5C A4                    1     .byte 0xbf,heap_free 
      0025BA                       3857 	_rst_pending 
      00A325 DF A1 46         [ 2]    1     ldw x,#pending_stack+PENDING_STACK_SIZE
      0025BD                          2     _strxz psp 
      00A328 27 03                    1     .byte 0xbf,psp 
      0025BF                       3858 	_clrz gosub_nest 
      00A32A CC 95                    1     .byte 0x3f, gosub_nest 
      0025C1                       3859 	_clrz for_nest
      00A32C D3 40                    1     .byte 0x3f, for_nest 
      00A32D 81               [ 4] 3860 	ret 
                                   3861 
                                   3862 ;---------------------------
                                   3863 ; BASIC: CLR 
                                   3864 ; reset stacks 
                                   3865 ; clear all variables
                                   3866 ;----------------------------
      0025C4                       3867 cmd_clear:
      00A32D CD 8B 5A CC 97   [ 2] 3868 	btjt flags,#FRUN,9$
      00A332 60 17 FF         [ 2] 3869 	ldw x,#STACK_EMPTY
      00A333 94               [ 1] 3870 	ldw sp,x 
      00A333 72 01 00         [ 4] 3871 	call clear_state  
      0025D0                       3872 9$: 
      0025D0                       3873 	_next 
      00A336 3B 03 CC         [ 2]    1         jp interp_loop 
                                   3874 
                                   3875 ;----------------------------
                                   3876 ; BASIC: DEL val1,val2 	
                                   3877 ;  delete all programs lines 
                                   3878 ;  from val1 to val2 
                                   3879 ;----------------------------
                           000001  3880 	START_ADR=1
                           000003  3881 	END_ADR=START_ADR+ADR_SIZE 
                           000005  3882 	DEL_SIZE=END_ADR+ADR_SIZE 
                           000007  3883 	YSAVE=DEL_SIZE+INT_SIZE 
                           000008  3884 	VSIZE=4*INT_SIZE  
      0025D3                       3885 cmd_del:
      00A339 97 60 00 3B 03   [ 2] 3886 	btjf flags,#FRUN,0$
      00A33B                       3887 	_next 
      00A33B CE 00 33         [ 2]    1         jp interp_loop 
      0025DB                       3888 0$:
      0025DB                       3889 	_vars VSIZE
      00A33E 72 B0            [ 2]    1     sub sp,#VSIZE 
      00A340 00               [ 1] 3890 	clrw x  
      00A341 2F 27            [ 2] 3891 	ldw (END_ADR,sp),x  
      00A343 27 90 F6         [ 4] 3892 	call arg_list 
      00A346 90 5C            [ 1] 3893 	cp a,#2 
      00A348 A1 06            [ 1] 3894 	jreq 1$ 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 222.
Hexadecimal [24-Bits]



      00A34A 27 03            [ 1] 3895 	cp a,#1
      00A34C CC 95            [ 1] 3896 	jreq 2$ 
      00A34E D3 93 CD         [ 2] 3897 	jp syntax_error 
      0025EE                       3898 1$:	; range delete 
      0025EE                       3899 	_i16_pop ; val2   
      00A351 97               [ 2]    1     popw x 
      00A352 A7               [ 1] 3900 	clr a 
      00A353 89 CD 94         [ 4] 3901 	call search_lineno 
      00A356 4B               [ 1] 3902 	tnz a ; 0 not found 
      00A357 26 0C            [ 1] 3903 	jreq not_a_line 
                                   3904 ; this last line to be deleted 
                                   3905 ; skip at end of it 
      0025F6                       3906 	_strxz acc16 	
      00A359 CE 00                    1     .byte 0xbf,acc16 
      00A35B 33 72            [ 1] 3907 	ld a,(2,x) ; line length 
      00A35D B0               [ 1] 3908 	clrw x 
      00A35E 00               [ 1] 3909 	ld xl,a 
      00A35F 2F CD 93 69      [ 2] 3910 	addw x,acc16 
      00A363 27 0E            [ 2] 3911 	ldw (END_ADR+INT_SIZE,sp),x
      00A365                       3912 2$: 
      002602                       3913 	_i16_pop ; val1 
      00A365 85               [ 2]    1     popw x 
      00A366 CD               [ 1] 3914 	clr a 
      00A367 93 E2 20         [ 4] 3915 	call search_lineno 
      00A36A 0F               [ 1] 3916 	tnz a 
      00A36B 27 35            [ 1] 3917 	jreq not_a_line 
      00A36B AE A3            [ 2] 3918 	ldw (START_ADR,sp),x 
      00A36D 7F CD            [ 2] 3919 	ldw x,(END_ADR,sp)
      00A36F 85 A3            [ 1] 3920 	jrne 4$ 
                                   3921 ; END_ADR not set there was no val2 
                                   3922 ; skip end of this line for END_ADR 
      00A371 20 07            [ 2] 3923 	ldw x,(START_ADR,sp)
      00A373 E6 02            [ 1] 3924 	ld a,(2,x)
      00A373 85               [ 1] 3925 	clrw x 
      00A374 AE               [ 1] 3926 	ld xl,a 
      00A375 A3 92 CD         [ 2] 3927 	addw x,(START_ADR,sp)
      00A378 85 A3            [ 2] 3928 	ldw (END_ADR,sp),x 
      00A37A                       3929 4$: 
      00A37A 90 7F CC         [ 2] 3930 	subw x,(START_ADR,sp)
      00A37D 97 60            [ 2] 3931 	ldw (DEL_SIZE,sp),x 
      00A37F 4E 6F 20         [ 2] 3932 	ldw x,progend 
      00A382 70 72 6F         [ 2] 3933 	subw x,(END_ADR,sp)
      002626                       3934 	_strxz acc16 
      00A385 67 72                    1     .byte 0xbf,acc16 
      00A387 61 6D            [ 2] 3935 	ldw x,(START_ADR,sp)
      00A389 20 69            [ 2] 3936 	ldw (YSAVE,sp),y 
      00A38B 6E 20            [ 2] 3937 	ldw y,(END_ADR,sp)
      00A38D 52 41 4D         [ 4] 3938 	call move 
      002631                       3939 	_ldxz progend 
      00A390 2E 00                    1     .byte 0xbe,progend 
      00A392 66 69 6C         [ 2] 3940 	subw x,(DEL_SIZE,sp)
      002636                       3941 	_strxz progend 
      00A395 65 20                    1     .byte 0xbf,progend 
      00A397 73 79            [ 2] 3942 	ldw y,(YSAVE,sp)
      00263A                       3943 	_drop VSIZE
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 223.
Hexadecimal [24-Bits]



      00A399 73 74            [ 2]    1     addw sp,#VSIZE 
      00263C                       3944 	_next 
      00A39B 65 6D 20         [ 2]    1         jp interp_loop 
      00263F                       3945 not_a_line:
      00A39E 66 75            [ 1] 3946 	ld a,#ERR_RANGE 
      00A3A0 6C 6C 2E         [ 2] 3947 	jp tb_error 
                                   3948 
                                   3949 
                                   3950 ;-----------------------------
                                   3951 ; BASIC: HIMEM = expr 
                                   3952 ; set end memory address of
                                   3953 ; BASIC program space.
                                   3954 ;------------------------------
      002644                       3955 cmd_himem:
      00A3A3 00 01 00 3B 03   [ 2] 3956 	btjf flags,#FRUN,1$
      00A3A4                       3957 	_next 
      00A3A4 72 01 00         [ 2]    1         jp interp_loop 
      00A3A7 3B 03            [ 1] 3958 1$: ld a,#REL_EQU_IDX 
      00A3A9 CC 97 60         [ 4] 3959 	call expect 
      00A3AC CD 18 B2         [ 4] 3960 	call expression 
      00A3AC 90 F6 90         [ 2] 3961 	cpw x,lomem  
      00A3AF 5C A1            [ 2] 3962 	jrule bad_value 
      00A3B1 06 27 03         [ 2] 3963 	cpw x,#tib  
      00A3B4 CC 95            [ 1] 3964 	jruge bad_value  
      00265E                       3965 	_strxz himem
      00A3B6 D3 31                    1     .byte 0xbf,himem 
      00A3B7 20 1F            [ 2] 3966 	jra clear_prog_space  
      002662                       3967 	_next 
      00A3B7 93 CD 97         [ 2]    1         jp interp_loop 
                                   3968 ;--------------------------------
                                   3969 ; BASIC: LOWMEM = expr 
                                   3970 ; set start memory address of 
                                   3971 ; BASIC program space. 	
                                   3972 ;---------------------------------
      002665                       3973 cmd_lomem:
      00A3BA A7 CD 93 31 26   [ 2] 3974 	btjf flags,#FRUN,1$
      00266A                       3975 	_next
      00A3BF 08 AE A3         [ 2]    1         jp interp_loop 
      00A3C2 D3 CD            [ 1] 3976 1$: ld a,#REL_EQU_IDX 
      00A3C4 85 A3 20         [ 4] 3977 	call expect 
      00A3C7 06 18 B2         [ 4] 3978 	call expression 
      00A3C8 A3 01 00         [ 2] 3979 	cpw x,#free_ram 
      00A3C8 CD 96            [ 1] 3980 	jrult bad_value 
      00A3CA B1 CD 93         [ 2] 3981 	cpw x,himem  
      00A3CD B9 0F            [ 1] 3982 	jruge bad_value 
      00A3CE                       3983 	_strxz lomem
      00A3CE 90 7F                    1     .byte 0xbf,lomem 
      002681                       3984 clear_prog_space: 
      00A3D0 CC 97 60         [ 4] 3985 	call clear_state 
      002684                       3986 	_ldxz lomem 
      00A3D3 66 69                    1     .byte 0xbe,lomem 
      002686                       3987 	_strxz progend 
      00A3D5 6C 65                    1     .byte 0xbf,progend 
      00A3D7 20 6E 6F         [ 4] 3988 	call free 
      00268B                       3989 	_next 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 224.
Hexadecimal [24-Bits]



      00A3DA 74 20 66         [ 2]    1         jp interp_loop 
      00268E                       3990 bad_value:
      00A3DD 6F 75            [ 1] 3991 	ld a,#ERR_RANGE 
      00A3DF 6E 64 0A         [ 2] 3992 	jp tb_error 
                                   3993 
      002693                       3994 free: 
      00A3E2 00 00 31         [ 2] 3995 	ldw x,himem 
      00A3E3 72 B0 00 2F      [ 2] 3996 	subw x,lomem 
      00A3E3 72 01 00         [ 4] 3997 	call print_int  
      00A3E6 3B 03 CC         [ 2] 3998 	ldw x,#bytes_free   
      00A3E9 97 60 23         [ 4] 3999 	call puts 
      00A3EB 81               [ 4] 4000 	ret 
      00A3EB 4B 00 4B 00 CD 94 8B  4001 bytes_free: .asciz "bytes free" 
             72 65 65 00
                                   4002 
                                   4003 ;------------------------------
                                   4004 ;      dictionary 
                                   4005 ; format:
                                   4006 ;   link:   2 bytes 
                                   4007 ;   name_length+flags:  1 byte, bits 0:3 lenght,4:8 kw type   
                                   4008 ;   cmd_name: 16 byte max 
                                   4009 ;   code_addr: 2 bytes 
                                   4010 ;------------------------------
                                   4011 	.macro _dict_entry len,name,token_id 
                                   4012 	.word LINK  ; point to next name field 
                                   4013 	LINK=.  ; name field 
                                   4014 	.byte len  ; name length 
                                   4015 	.asciz name  ; name 
                                   4016 	.byte token_id   ; TOK_IDX 
                                   4017 	.endm 
                                   4018 
                           000000  4019 	LINK=0
                                   4020 ; respect alphabetic order for BASIC names from Z-A
                                   4021 ; this sort order is for a cleaner WORDS cmd output. 	
      00A3F2                       4022 dict_end:
      0026AF                       4023 	_dict_entry,5,"WORDS",WORDS_IDX 
      00A3F2 27 36                    1 	.word LINK  ; point to next name field 
                           0026B1     2 	LINK=.  ; name field 
      00A3F4 1E                       3 	.byte 5  ; name length 
      00A3F5 01 5C 1F 01 AE 00        4 	.asciz "WORDS"  ; name 
      00A3FB 58                       5 	.byte WORDS_IDX   ; TOK_IDX 
      0026B9                       4024 	_dict_entry,4,"TONE",TONE_IDX 
      00A3FC 89 CD                    1 	.word LINK  ; point to next name field 
                           0026BB     2 	LINK=.  ; name field 
      00A3FE 85                       3 	.byte 4  ; name length 
      00A3FF A3 85 CD 88 86           4 	.asciz "TONE"  ; name 
      00A404 88                       5 	.byte TONE_IDX   ; TOK_IDX 
      0026C2                       4025 	_dict_entry,2,"TO",TO_IDX
      00A405 4B 00                    1 	.word LINK  ; point to next name field 
                           0026C4     2 	LINK=.  ; name field 
      00A407 AE                       3 	.byte 2  ; name length 
      00A408 00 0C 72                 4 	.asciz "TO"  ; name 
      00A40B F0                       5 	.byte TO_IDX   ; TOK_IDX 
      0026C9                       4026 	_dict_entry,5,"TICKS",TICKS_IDX 
      00A40C 01 CD                    1 	.word LINK  ; point to next name field 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 225.
Hexadecimal [24-Bits]



                           0026CB     2 	LINK=.  ; name field 
      00A40E 86                       3 	.byte 5  ; name length 
      00A40F 0C 5B 02 AE 00 56        4 	.asciz "TICKS"  ; name 
      00A415 FE                       5 	.byte TICKS_IDX   ; TOK_IDX 
      0026D3                       4027 	_dict_entry,4,"THEN",THEN_IDX 
      00A416 CD 88                    1 	.word LINK  ; point to next name field 
                           0026D5     2 	LINK=.  ; name field 
      00A418 2E                       3 	.byte 4  ; name length 
      00A419 AE A4 3C CD 85           4 	.asciz "THEN"  ; name 
      00A41E A3                       5 	.byte THEN_IDX   ; TOK_IDX 
      0026DC                       4028 	_dict_entry,3,"TAB",TAB_IDX 
      00A41F AE 00                    1 	.word LINK  ; point to next name field 
                           0026DE     2 	LINK=.  ; name field 
      00A421 54                       3 	.byte 3  ; name length 
      00A422 CD 94 CF CD              4 	.asciz "TAB"  ; name 
      00A426 94                       5 	.byte TAB_IDX   ; TOK_IDX 
      0026E4                       4029 	_dict_entry,4,"STOP",STOP_IDX
      00A427 90 20                    1 	.word LINK  ; point to next name field 
                           0026E6     2 	LINK=.  ; name field 
      00A429 C8                       3 	.byte 4  ; name length 
      00A42A 53 54 4F 50 00           4 	.asciz "STOP"  ; name 
      00A42A CD                       5 	.byte STOP_IDX   ; TOK_IDX 
      0026ED                       4030 	_dict_entry,4,"STEP",STEP_IDX
      00A42B 85 E9                    1 	.word LINK  ; point to next name field 
                           0026EF     2 	LINK=.  ; name field 
      00A42D 85                       3 	.byte 4  ; name length 
      00A42E CD 88 2E AE A4           4 	.asciz "STEP"  ; name 
      00A433 43                       5 	.byte STEP_IDX   ; TOK_IDX 
      0026F6                       4031 	_dict_entry,5,"SLEEP",SLEEP_IDX 
      00A434 CD 85                    1 	.word LINK  ; point to next name field 
                           0026F8     2 	LINK=.  ; name field 
      00A436 A3                       3 	.byte 5  ; name length 
      00A437 90 7F CC 97 60 62        4 	.asciz "SLEEP"  ; name 
      00A43D 79                       5 	.byte SLEEP_IDX   ; TOK_IDX 
      002700                       4032 	_dict_entry,3,"SGN",SGN_IDX
      00A43E 74 65                    1 	.word LINK  ; point to next name field 
                           002702     2 	LINK=.  ; name field 
      00A440 73                       3 	.byte 3  ; name length 
      00A441 0A 00 66 69              4 	.asciz "SGN"  ; name 
      00A445 6C                       5 	.byte SGN_IDX   ; TOK_IDX 
      002708                       4033 	_dict_entry,3,"SCR",NEW_IDX
      00A446 65 73                    1 	.word LINK  ; point to next name field 
                           00270A     2 	LINK=.  ; name field 
      00A448 00                       3 	.byte 3  ; name length 
      00A449 53 43 52 00              4 	.asciz "SCR"  ; name 
      00A449 72                       5 	.byte NEW_IDX   ; TOK_IDX 
      002710                       4034 	_dict_entry,4,"SAVE",SAVE_IDX 
      00A44A 00 00                    1 	.word LINK  ; point to next name field 
                           002712     2 	LINK=.  ; name field 
      00A44C 3B                       3 	.byte 4  ; name length 
      00A44D 09 72 0D 52 40           4 	.asciz "SAVE"  ; name 
      00A452 FB                       5 	.byte SAVE_IDX   ; TOK_IDX 
      002719                       4035 	_dict_entry 3,"RUN",RUN_IDX
      00A453 35 80                    1 	.word LINK  ; point to next name field 
                           00271B     2 	LINK=.  ; name field 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 226.
Hexadecimal [24-Bits]



      00A455 50                       3 	.byte 3  ; name length 
      00A456 D1 CC 97 60              4 	.asciz "RUN"  ; name 
      00A45A 3E                       5 	.byte RUN_IDX   ; TOK_IDX 
      002721                       4036 	_dict_entry,3,"RND",RND_IDX
      00A45A CD 99                    1 	.word LINK  ; point to next name field 
                           002723     2 	LINK=.  ; name field 
      00A45C 32                       3 	.byte 3  ; name length 
      00A45D 72 11 00 0A              4 	.asciz "RND"  ; name 
      00A461 CF                       5 	.byte RND_IDX   ; TOK_IDX 
      002729                       4037 	_dict_entry,6,"RETURN",RET_IDX
      00A462 00 06                    1 	.word LINK  ; point to next name field 
                           00272B     2 	LINK=.  ; name field 
      00A464 8F                       3 	.byte 6  ; name length 
      00A465 CE 00 06 26 FA CC 97     4 	.asciz "RETURN"  ; name 
      00A46C 60                       5 	.byte RET_IDX   ; TOK_IDX 
      00A46D                       4038 	_dict_entry 3,"REM",REM_IDX
      00A46D BE 04                    1 	.word LINK  ; point to next name field 
                           002736     2 	LINK=.  ; name field 
      00A46F 81                       3 	.byte 3  ; name length 
      00A470 52 45 4D 00              4 	.asciz "REM"  ; name 
      00A470 A6                       5 	.byte REM_IDX   ; TOK_IDX 
      00273C                       4039 	_dict_entry 5,"PRINT",PRINT_IDX 
      00A471 04 CD                    1 	.word LINK  ; point to next name field 
                           00273E     2 	LINK=.  ; name field 
      00A473 98                       3 	.byte 5  ; name length 
      00A474 50 CD 99 32 9F 5F        4 	.asciz "PRINT"  ; name 
      00A47A A4                       5 	.byte PRINT_IDX   ; TOK_IDX 
      002746                       4040 	_dict_entry,4,"POKE",POKE_IDX 
      00A47B 7F 97                    1 	.word LINK  ; point to next name field 
                           002748     2 	LINK=.  ; name field 
      00A47D A6                       3 	.byte 4  ; name length 
      00A47E 05 CD 98 50 81           4 	.asciz "POKE"  ; name 
      00A483 3C                       5 	.byte POKE_IDX   ; TOK_IDX 
      00274F                       4041 	_dict_entry,4,"PEEK",PEEK_IDX 
      00A483 CD 98                    1 	.word LINK  ; point to next name field 
                           002751     2 	LINK=.  ; name field 
      00A485 5E                       3 	.byte 4  ; name length 
      00A486 A1 01 27 03 CC           4 	.asciz "PEEK"  ; name 
      00A48B 95                       5 	.byte PEEK_IDX   ; TOK_IDX 
      002758                       4042 	_dict_entry,2,"OR",OR_IDX  
      00A48C D3 51                    1 	.word LINK  ; point to next name field 
                           00275A     2 	LINK=.  ; name field 
      00A48D 02                       3 	.byte 2  ; name length 
      00A48D 85 5D 2A                 4 	.asciz "OR"  ; name 
      00A490 01                       5 	.byte OR_IDX   ; TOK_IDX 
      00275F                       4043 	_dict_entry,3,"NOT",NOT_IDX
      00A491 50 81                    1 	.word LINK  ; point to next name field 
                           002761     2 	LINK=.  ; name field 
      00A493 03                       3 	.byte 3  ; name length 
      00A493 CD 98 5E A1              4 	.asciz "NOT"  ; name 
      00A497 01                       5 	.byte NOT_IDX   ; TOK_IDX 
      002767                       4044 	_dict_entry,3,"NEW",NEW_IDX
      00A498 27 03                    1 	.word LINK  ; point to next name field 
                           002769     2 	LINK=.  ; name field 
      00A49A CC                       3 	.byte 3  ; name length 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 227.
Hexadecimal [24-Bits]



      00A49B 95 D3 57 00              4 	.asciz "NEW"  ; name 
      00A49D 3A                       5 	.byte NEW_IDX   ; TOK_IDX 
      00276F                       4045 	_dict_entry,4,"NEXT",NEXT_IDX 
      00A49D CD 83                    1 	.word LINK  ; point to next name field 
                           002771     2 	LINK=.  ; name field 
      00A49F 2E                       3 	.byte 4  ; name length 
      00A4A0 90 89 16 03 65           4 	.asciz "NEXT"  ; name 
      00A4A5 51                       5 	.byte NEXT_IDX   ; TOK_IDX 
      002778                       4046 	_dict_entry,3,"MOD",MOD_IDX 
      00A4A6 90 85                    1 	.word LINK  ; point to next name field 
                           00277A     2 	LINK=.  ; name field 
      00A4A8 5B                       3 	.byte 3  ; name length 
      00A4A9 02 81 44 00              4 	.asciz "MOD"  ; name 
      00A4AB 0E                       5 	.byte MOD_IDX   ; TOK_IDX 
      002780                       4047 	_dict_entry,5,"LOMEM",LOMEM_IDX 
      00A4AB CD 99                    1 	.word LINK  ; point to next name field 
                           002782     2 	LINK=.  ; name field 
      00A4AD 32                       3 	.byte 5  ; name length 
      00A4AE CD 83 50 CC 97 60        4 	.asciz "LOMEM"  ; name 
      00A4B4 35                       5 	.byte LOMEM_IDX   ; TOK_IDX 
      00278A                       4048 	_dict_entry,4,"LOAD",LOAD_IDX 
      00A4B4 CD 98                    1 	.word LINK  ; point to next name field 
                           00278C     2 	LINK=.  ; name field 
      00A4B6 5E                       3 	.byte 4  ; name length 
      00A4B7 A1 01 27 03 CC           4 	.asciz "LOAD"  ; name 
      00A4BC 95                       5 	.byte LOAD_IDX   ; TOK_IDX 
      002793                       4049 	_dict_entry 4,"LIST",LIST_IDX
      00A4BD D3 8C                    1 	.word LINK  ; point to next name field 
                           002795     2 	LINK=.  ; name field 
      00A4BE 04                       3 	.byte 4  ; name length 
      00A4BE 85 27 0C 2B 04           4 	.asciz "LIST"  ; name 
      00A4C3 AE                       5 	.byte LIST_IDX   ; TOK_IDX 
      00279C                       4050 	_dict_entry 3,"LET",LET_IDX
      00A4C4 00 01                    1 	.word LINK  ; point to next name field 
                           00279E     2 	LINK=.  ; name field 
      00A4C6 81                       3 	.byte 3  ; name length 
      00A4C7 AE FF FF CD              4 	.asciz "LET"  ; name 
      00A4CB 88                       5 	.byte LET_IDX   ; TOK_IDX 
      0027A4                       4051 	_dict_entry 3,"LEN",LEN_IDX  
      00A4CC 2E 81                    1 	.word LINK  ; point to next name field 
                           0027A6     2 	LINK=.  ; name field 
      00A4CE 03                       3 	.byte 3  ; name length 
      00A4CE A6 04 CD 98              4 	.asciz "LEN"  ; name 
      00A4D2 50                       5 	.byte LEN_IDX   ; TOK_IDX 
      0027AC                       4052 	_dict_entry,3,"KEY",KEY_IDX 
      00A4D3 90 F6                    1 	.word LINK  ; point to next name field 
                           0027AE     2 	LINK=.  ; name field 
      00A4D5 90                       3 	.byte 3  ; name length 
      00A4D6 5C A1 06 26              4 	.asciz "KEY"  ; name 
      00A4DA 10                       5 	.byte KEY_IDX   ; TOK_IDX 
      0027B4                       4053 	_dict_entry,5,"INPUT",INPUT_IDX 
      00A4DB 93 CD                    1 	.word LINK  ; point to next name field 
                           0027B6     2 	LINK=.  ; name field 
      00A4DD 88                       3 	.byte 5  ; name length 
      00A4DE 86 88 4B 00 72 F9        4 	.asciz "INPUT"  ; name 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 228.
Hexadecimal [24-Bits]



      00A4E4 01                       5 	.byte INPUT_IDX   ; TOK_IDX 
      0027BE                       4054 	_dict_entry,2,"IF",IF_IDX 
      00A4E5 90 5C                    1 	.word LINK  ; point to next name field 
                           0027C0     2 	LINK=.  ; name field 
      00A4E7 5B                       3 	.byte 2  ; name length 
      00A4E8 02 20 10                 4 	.asciz "IF"  ; name 
      00A4EB 20                       5 	.byte IF_IDX   ; TOK_IDX 
      0027C5                       4055 	_dict_entry,5,"HIMEM",HIMEM_IDX 
      00A4EB A1 0A                    1 	.word LINK  ; point to next name field 
                           0027C7     2 	LINK=.  ; name field 
      00A4ED 27                       3 	.byte 5  ; name length 
      00A4EE 03 CC 95 D3 4D 00        4 	.asciz "HIMEM"  ; name 
      00A4F2 34                       5 	.byte HIMEM_IDX   ; TOK_IDX 
      0027CF                       4056 	_dict_entry,4,"GOTO",GOTO_IDX  
      00A4F2 CD 9B                    1 	.word LINK  ; point to next name field 
                           0027D1     2 	LINK=.  ; name field 
      00A4F4 A3                       3 	.byte 4  ; name length 
      00A4F5 EE 02 5C CD 88           4 	.asciz "GOTO"  ; name 
      00A4FA 86                       5 	.byte GOTO_IDX   ; TOK_IDX 
      00A4FB                       4057 	_dict_entry,5,"GOSUB",GOSUB_IDX 
      00A4FB 5F 97                    1 	.word LINK  ; point to next name field 
                           0027DA     2 	LINK=.  ; name field 
      00A4FD A6                       3 	.byte 5  ; name length 
      00A4FE 05 CD 98 50 81 00        4 	.asciz "GOSUB"  ; name 
      00A503 1D                       5 	.byte GOSUB_IDX   ; TOK_IDX 
      0027E2                       4058 	_dict_entry,5,"ERASE",ERASE_IDX 
      00A503 52 08                    1 	.word LINK  ; point to next name field 
                           0027E4     2 	LINK=.  ; name field 
      00A505 A6                       3 	.byte 5  ; name length 
      00A506 04 6B 01 6B 03 0F        4 	.asciz "ERASE"  ; name 
      00A50C 02                       5 	.byte ERASE_IDX   ; TOK_IDX 
      0027EC                       4059 	_dict_entry,3,"FOR",FOR_IDX 
      00A50D A6 0B                    1 	.word LINK  ; point to next name field 
                           0027EE     2 	LINK=.  ; name field 
      00A50F 6B                       3 	.byte 3  ; name length 
      00A510 04 3F 18 17              4 	.asciz "FOR"  ; name 
      00A514 05                       5 	.byte FOR_IDX   ; TOK_IDX 
      0027F4                       4060 	_dict_entry,3,"END",END_IDX
      00A515 90 F6                    1 	.word LINK  ; point to next name field 
                           0027F6     2 	LINK=.  ; name field 
      00A517 A1                       3 	.byte 3  ; name length 
      00A518 07 26 1F 90              4 	.asciz "END"  ; name 
      00A51C 5C                       5 	.byte END_IDX   ; TOK_IDX 
      0027FC                       4061 	_dict_entry,3,"DIR",DIR_IDX  
      00A51D 90 F6                    1 	.word LINK  ; point to next name field 
                           0027FE     2 	LINK=.  ; name field 
      00A51F 90                       3 	.byte 3  ; name length 
      00A520 5C A1 43 27              4 	.asciz "DIR"  ; name 
      00A524 03                       5 	.byte DIR_IDX   ; TOK_IDX 
      002804                       4062 	_dict_entry,3,"DIM",DIM_IDX 
      00A525 CC 95                    1 	.word LINK  ; point to next name field 
                           002806     2 	LINK=.  ; name field 
      00A527 D3                       3 	.byte 3  ; name length 
      00A528 44 49 4D 00              4 	.asciz "DIM"  ; name 
      00A528 17                       5 	.byte DIM_IDX   ; TOK_IDX 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 229.
Hexadecimal [24-Bits]



      00280C                       4063 	_dict_entry,3,"DEL",DEL_IDX 
      00A529 05 A6                    1 	.word LINK  ; point to next name field 
                           00280E     2 	LINK=.  ; name field 
      00A52B 03                       3 	.byte 3  ; name length 
      00A52C 6B 01 6B 03              4 	.asciz "DEL"  ; name 
      00A530 A6                       5 	.byte DEL_IDX   ; TOK_IDX 
      002814                       4064 	_dict_entry,3,"CON",CON_IDX 
      00A531 0A 6B                    1 	.word LINK  ; point to next name field 
                           002816     2 	LINK=.  ; name field 
      00A533 04                       3 	.byte 3  ; name length 
      00A534 90 AE A9 4E              4 	.asciz "CON"  ; name 
      00A538 20                       5 	.byte CON_IDX   ; TOK_IDX 
      00281C                       4065 	_dict_entry,3,"CLR",CLR_IDX 
      00A539 04 16                    1 	.word LINK  ; point to next name field 
                           00281E     2 	LINK=.  ; name field 
      00A53A 03                       3 	.byte 3  ; name length 
      00A53A 90 AE A8 D1              4 	.asciz "CLR"  ; name 
      00A53E 37                       5 	.byte CLR_IDX   ; TOK_IDX 
      002824                       4066 	_dict_entry,4,"CHR$",CHAR_IDX  
      00A53E 93 F6                    1 	.word LINK  ; point to next name field 
                           002826     2 	LINK=.  ; name field 
      00A540 5C                       3 	.byte 4  ; name length 
      00A541 1F 07 5F 97 7B           4 	.asciz "CHR$"  ; name 
      00A546 04                       5 	.byte CHAR_IDX   ; TOK_IDX 
      00282D                       4067 	_dict_entry,4,"CALL",CALL_IDX
      00A547 62 1E                    1 	.word LINK  ; point to next name field 
                           00282F     2 	LINK=.  ; name field 
      00A549 07                       3 	.byte 4  ; name length 
      00A54A 4C B7 19 7B 03           4 	.asciz "CALL"  ; name 
      00A54F A1                       5 	.byte CALL_IDX   ; TOK_IDX 
      002836                       4068 	_dict_entry,3,"BYE",BYE_IDX
      00A550 04 27                    1 	.word LINK  ; point to next name field 
                           002838     2 	LINK=.  ; name field 
      00A552 0F                       3 	.byte 3  ; name length 
      00A553 A6 24 CD 85              4 	.asciz "BYE"  ; name 
      00A557 2C                       5 	.byte BYE_IDX   ; TOK_IDX 
      00283E                       4069 	_dict_entry,4,"AUTO",AUTO_IDX 
      00A558 72 D6                    1 	.word LINK  ; point to next name field 
                           002840     2 	LINK=.  ; name field 
      00A55A 00                       3 	.byte 4  ; name length 
      00A55B 18 CD 88 1C CD           4 	.asciz "AUTO"  ; name 
      00A560 86                       5 	.byte AUTO_IDX   ; TOK_IDX 
      002847                       4070 	_dict_entry,3,"AND",AND_IDX  
      00A561 06 40                    1 	.word LINK  ; point to next name field 
                           002849     2 	LINK=.  ; name field 
      00A562 03                       3 	.byte 3  ; name length 
      00A562 CD 85 A3 0C              4 	.asciz "AND"  ; name 
      00A566 02                       5 	.byte AND_IDX   ; TOK_IDX 
      00284F                       4071 kword_dict::
      00284F                       4072 	_dict_entry,3,"ABS",ABS_IDX 
      00A567 0A 01                    1 	.word LINK  ; point to next name field 
                           002851     2 	LINK=.  ; name field 
      00A569 27                       3 	.byte 3  ; name length 
      00A56A 10 7B 04 C0              4 	.asciz "ABS"  ; name 
      00A56E 00                       5 	.byte ABS_IDX   ; TOK_IDX 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 230.
Hexadecimal [24-Bits]



                                   4073 ; the following are not searched
                                   4074 ; by compiler
      002857                       4075 	_dict_entry,1,"'",REM_IDX 
      00A56F 19 2A                    1 	.word LINK  ; point to next name field 
                           002859     2 	LINK=.  ; name field 
      00A571 02                       3 	.byte 1  ; name length 
      00A572 A6 09                    4 	.asciz "'"  ; name 
      00A574 5F                       5 	.byte REM_IDX   ; TOK_IDX 
      00285D                       4076 	_dict_entry,1,"?",PRINT_IDX 
      00A575 97 CD                    1 	.word LINK  ; point to next name field 
                           00285F     2 	LINK=.  ; name field 
      00A577 86                       3 	.byte 1  ; name length 
      00A578 0C 20                    4 	.asciz "?"  ; name 
      00A57A 09                       5 	.byte PRINT_IDX   ; TOK_IDX 
      002863                       4077 	_dict_entry,1,"#",REL_NE_IDX 
      00A57B A6 0D                    1 	.word LINK  ; point to next name field 
                           002865     2 	LINK=.  ; name field 
      00A57D CD                       3 	.byte 1  ; name length 
      00A57E 85 2C                    4 	.asciz "#"  ; name 
      00A580 7B                       5 	.byte REL_NE_IDX   ; TOK_IDX 
      002869                       4078 	_dict_entry,2,"<>",REL_NE_IDX
      00A581 03 6B                    1 	.word LINK  ; point to next name field 
                           00286B     2 	LINK=.  ; name field 
      00A583 01                       3 	.byte 2  ; name length 
      00A584 72 A2 00                 4 	.asciz "<>"  ; name 
      00A587 02                       5 	.byte REL_NE_IDX   ; TOK_IDX 
      002870                       4079 	_dict_entry,1,">",REL_GT_IDX
      00A588 90 FE                    1 	.word LINK  ; point to next name field 
                           002872     2 	LINK=.  ; name field 
      00A58A 26                       3 	.byte 1  ; name length 
      00A58B B2 A6                    4 	.asciz ">"  ; name 
      00A58D 0D                       5 	.byte REL_GT_IDX   ; TOK_IDX 
      002876                       4080 	_dict_entry,1,"<",REL_LT_IDX
      00A58E CD 85                    1 	.word LINK  ; point to next name field 
                           002878     2 	LINK=.  ; name field 
      00A590 2C                       3 	.byte 1  ; name length 
      00A591 5F 7B                    4 	.asciz "<"  ; name 
      00A593 02                       5 	.byte REL_LT_IDX   ; TOK_IDX 
      00287C                       4081 	_dict_entry,2,">=",REL_GE_IDX
      00A594 97 CD                    1 	.word LINK  ; point to next name field 
                           00287E     2 	LINK=.  ; name field 
      00A596 88                       3 	.byte 2  ; name length 
      00A597 2E AE A5                 4 	.asciz ">="  ; name 
      00A59A A5                       5 	.byte REL_GE_IDX   ; TOK_IDX 
      002883                       4082 	_dict_entry,1,"=",REL_EQU_IDX 
      00A59B CD 85                    1 	.word LINK  ; point to next name field 
                           002885     2 	LINK=.  ; name field 
      00A59D A3                       3 	.byte 1  ; name length 
      00A59E 16 05                    4 	.asciz "="  ; name 
      00A5A0 5B                       5 	.byte REL_EQU_IDX   ; TOK_IDX 
      002889                       4083 	_dict_entry,2,"<=",REL_LE_IDX 
      00A5A1 08 CC                    1 	.word LINK  ; point to next name field 
                           00288B     2 	LINK=.  ; name field 
      00A5A3 97                       3 	.byte 2  ; name length 
      00A5A4 60 20 77                 4 	.asciz "<="  ; name 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 231.
Hexadecimal [24-Bits]



      00A5A7 6F                       5 	.byte REL_LE_IDX   ; TOK_IDX 
      002890                       4084 	_dict_entry,1,"*",MULT_IDX 
      00A5A8 72 64                    1 	.word LINK  ; point to next name field 
                           002892     2 	LINK=.  ; name field 
      00A5AA 73                       3 	.byte 1  ; name length 
      00A5AB 20 69                    4 	.asciz "*"  ; name 
      00A5AD 6E                       5 	.byte MULT_IDX   ; TOK_IDX 
      002896                       4085 	_dict_entry,1,"%",MOD_IDX 
      00A5AE 20 64                    1 	.word LINK  ; point to next name field 
                           002898     2 	LINK=.  ; name field 
      00A5B0 69                       3 	.byte 1  ; name length 
      00A5B1 63 74                    4 	.asciz "%"  ; name 
      00A5B3 69                       5 	.byte MOD_IDX   ; TOK_IDX 
      00289C                       4086 	_dict_entry,1,"/",DIV_IDX 
      00A5B4 6F 6E                    1 	.word LINK  ; point to next name field 
                           00289E     2 	LINK=.  ; name field 
      00A5B6 61                       3 	.byte 1  ; name length 
      00A5B7 72 79                    4 	.asciz "/"  ; name 
      00A5B9 0A                       5 	.byte DIV_IDX   ; TOK_IDX 
      0028A2                       4087 	_dict_entry,1,"-",SUB_IDX 
      00A5BA 00 9E                    1 	.word LINK  ; point to next name field 
                           0028A4     2 	LINK=.  ; name field 
      00A5BB 01                       3 	.byte 1  ; name length 
      00A5BB CD 98                    4 	.asciz "-"  ; name 
      00A5BD 69                       5 	.byte SUB_IDX   ; TOK_IDX 
      0028A8                       4088 	_dict_entry,1,"+",ADD_IDX
      00A5BE A1 01                    1 	.word LINK  ; point to next name field 
                           0028AA     2 	LINK=.  ; name field 
      00A5C0 27                       3 	.byte 1  ; name length 
      00A5C1 03 CC                    4 	.asciz "+"  ; name 
      00A5C3 95                       5 	.byte ADD_IDX   ; TOK_IDX 
      0028AE                       4089 	_dict_entry,1,'"',QUOTE_IDX
      00A5C4 D3 AA                    1 	.word LINK  ; point to next name field 
                           0028B0     2 	LINK=.  ; name field 
      00A5C5 01                       3 	.byte 1  ; name length 
      00A5C5 85 72                    4 	.asciz '"'  ; name 
      00A5C7 11                       5 	.byte QUOTE_IDX   ; TOK_IDX 
      0028B4                       4090 	_dict_entry,1,")",RPAREN_IDX 
      00A5C8 00 0A                    1 	.word LINK  ; point to next name field 
                           0028B6     2 	LINK=.  ; name field 
      00A5CA CF                       3 	.byte 1  ; name length 
      00A5CB 00 06                    4 	.asciz ")"  ; name 
      00A5CD CC                       5 	.byte RPAREN_IDX   ; TOK_IDX 
      0028BA                       4091 	_dict_entry,1,"(",LPAREN_IDX 
      00A5CE 97 60                    1 	.word LINK  ; point to next name field 
                           0028BC     2 	LINK=.  ; name field 
      00A5D0 01                       3 	.byte 1  ; name length 
      00A5D0 4F 5F                    4 	.asciz "("  ; name 
      00A5D2 72                       5 	.byte LPAREN_IDX   ; TOK_IDX 
      0028C0                       4092 	_dict_entry,1,^/";"/,SCOL_IDX
      00A5D3 01 00                    1 	.word LINK  ; point to next name field 
                           0028C2     2 	LINK=.  ; name field 
      00A5D5 0A                       3 	.byte 1  ; name length 
      00A5D6 02 43                    4 	.asciz ";"  ; name 
      00A5D8 53                       5 	.byte SCOL_IDX   ; TOK_IDX 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 232.
Hexadecimal [24-Bits]



      0028C6                       4093 	_dict_entry,1,^/","/,COMMA_IDX 
      00A5D9 81 C2                    1 	.word LINK  ; point to next name field 
                           0028C8     2 	LINK=.  ; name field 
      00A5DA 01                       3 	.byte 1  ; name length 
      00A5DA 4F AE                    4 	.asciz ","  ; name 
      00A5DC 40                       5 	.byte COMMA_IDX   ; TOK_IDX 
      0028CC                       4094 all_words:
      0028CC                       4095 	_dict_entry,1,":",COLON_IDX 
      00A5DD 00 81                    1 	.word LINK  ; point to next name field 
                           0028CE     2 	LINK=.  ; name field 
      00A5DF 01                       3 	.byte 1  ; name length 
      00A5DF CD 99                    4 	.asciz ":"  ; name 
      00A5E1 32                       5 	.byte COLON_IDX   ; TOK_IDX 
                                   4096 
      002900                       4097 	.bndry 128 
      002900                       4098 app: 
      002900                       4099 app_space:
                           000000  4100 .if 0
                                   4101 ; program to test CALL command 
                                   4102 blink:
                                   4103 	_led_toggle 
                                   4104 	ldw x,#250 
                                   4105 	_strxz timer 
                                   4106 	bres sys_flags,#FSYS_TIMER 
                                   4107 1$:	
                                   4108 	wfi 
                                   4109 	btjf sys_flags,#FSYS_TIMER,1$
                                   4110 	call qgetc 
                                   4111 	jreq blink 
                                   4112 	call getc 
                                   4113 	ret 
                                   4114 .endif 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 233.
Hexadecimal [24-Bits]

Symbol Table

    .__.$$$.=  002710 L   |     .__.ABS.=  000000 G   |     .__.CPU.=  000000 L
    .__.H$L.=  000001 L   |     ABS_IDX =  000028     |     ACK     =  000006 
    ADC_CR1 =  005401     |     ADC_CR1_=  000000     |     ADC_CR1_=  000001 
    ADC_CR1_=  000004     |     ADC_CR1_=  000005     |     ADC_CR1_=  000006 
    ADC_CR2 =  005402     |     ADC_CR2_=  000003     |     ADC_CR2_=  000004 
    ADC_CR2_=  000005     |     ADC_CR2_=  000006     |     ADC_CR2_=  000001 
    ADC_CR3 =  005403     |     ADC_CR3_=  000007     |     ADC_CR3_=  000006 
    ADC_CSR =  005400     |     ADC_CSR_=  000006     |     ADC_CSR_=  000004 
    ADC_CSR_=  000000     |     ADC_CSR_=  000001     |     ADC_CSR_=  000002 
    ADC_CSR_=  000003     |     ADC_CSR_=  000007     |     ADC_CSR_=  000005 
    ADC_DRH =  005404     |     ADC_DRL =  005405     |     ADC_TDRH=  005406 
    ADC_TDRL=  005407     |     ADD_IDX =  00000B     |     ADR_SIZE=  000002 
    AFR     =  004803     |     AFR0_ADC=  000000     |     AFR1_TIM=  000001 
    AFR2_CCO=  000002     |     AFR3_TIM=  000003     |     AFR4_TIM=  000004 
    AFR5_TIM=  000005     |     AFR6_I2C=  000006     |     AFR7_BEE=  000007 
    ALIGN   =  000003     |     AND_IDX =  000017     |     APP_VARS=  000028 G
    ARGN    =  000004     |     ARG_OFS =  000002     |     ARG_SIZE=  000002 
    ARITHM_V=  000004     |     ARROW_LE=  000080     |     ARROW_RI=  000081 
    ATTRIB  =  000002     |     AUTO_IDX=  000033     |     AWU_APR =  0050F1 
    AWU_CSR =  0050F0     |     AWU_CSR_=  000004     |     AWU_TBR =  0050F2 
    B0_MASK =  000001     |     B1      =  000001     |     B115200 =  000006 
    B19200  =  000003     |     B1_MASK =  000002     |     B230400 =  000007 
    B2400   =  000000     |     B2_MASK =  000004     |     B38400  =  000004 
    B3_MASK =  000008     |     B460800 =  000008     |     B4800   =  000001 
    B4_MASK =  000010     |     B57600  =  000005     |     B5_MASK =  000020 
    B6_MASK =  000040     |     B7_MASK =  000080     |     B921600 =  000009 
    B9600   =  000002     |   4 BACKSPAC   000B27 R   |     BAUD_RAT=  01C200 
    BEEP_BIT=  000004     |     BEEP_CSR=  0050F3     |     BEEP_MAS=  000010 
    BEEP_POR=  00000F     |     BELL    =  000007     |     BIT0    =  000000 
    BIT1    =  000001     |     BIT2    =  000002     |     BIT3    =  000003 
    BIT4    =  000004     |     BIT5    =  000005     |     BIT6    =  000006 
    BIT7    =  000007     |     BLOCK_SI=  000080     |   4 BLSKIP     000B5B R
    BOOL_OP_=  000018     |     BOOT_ROM=  006000     |     BOOT_ROM=  007FFF 
    BPTR    =  000009     |     BS      =  000008     |     BUFOUT  =  000003 
    BUF_ADR =  000001     |     BYE_IDX =  000040     |     C       =  000001 
    CALL_IDX=  00003B     |     CAN     =  000018     |     CAN_DGR =  005426 
    CAN_FPSR=  005427     |     CAN_IER =  005425     |     CAN_MCR =  005420 
    CAN_MSR =  005421     |     CAN_P0  =  005428     |     CAN_P1  =  005429 
    CAN_P2  =  00542A     |     CAN_P3  =  00542B     |     CAN_P4  =  00542C 
    CAN_P5  =  00542D     |     CAN_P6  =  00542E     |     CAN_P7  =  00542F 
    CAN_P8  =  005430     |     CAN_P9  =  005431     |     CAN_PA  =  005432 
    CAN_PB  =  005433     |     CAN_PC  =  005434     |     CAN_PD  =  005435 
    CAN_PE  =  005436     |     CAN_PF  =  005437     |     CAN_RFR =  005424 
    CAN_TPR =  005423     |     CAN_TSR =  005422     |     CC_C    =  000000 
    CC_H    =  000004     |     CC_I0   =  000003     |     CC_I1   =  000005 
    CC_N    =  000002     |     CC_V    =  000007     |     CC_Z    =  000001 
    CELL_SIZ=  000002 G   |     CFG_GCR =  007F60     |     CFG_GCR_=  000001 
    CFG_GCR_=  000000     |     CHAIN_BP=  000003     |     CHAIN_CN=  000008 
    CHAIN_LN=  000001     |     CHAIN_TX=  000005     |     CHAIN_TX=  000007 
    CHAR_ARR=  000005     |     CHAR_IDX=  00002E     |     CHIP_ERA=  0000C7 
    CHK_TIMO=  00000B G   |     CLKOPT  =  004807     |     CLKOPT_C=  000002 
    CLKOPT_E=  000003     |     CLKOPT_P=  000000     |     CLKOPT_P=  000001 
    CLK_CCOR=  0050C9     |     CLK_CKDI=  0050C6     |     CLK_CKDI=  000000 
    CLK_CKDI=  000001     |     CLK_CKDI=  000002     |     CLK_CKDI=  000003 
    CLK_CKDI=  000004     |     CLK_CMSR=  0050C3     |     CLK_CSSR=  0050C8 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 234.
Hexadecimal [24-Bits]

Symbol Table

    CLK_ECKR=  0050C1     |     CLK_ECKR=  000000     |     CLK_ECKR=  000001 
    CLK_HSIT=  0050CC     |     CLK_ICKR=  0050C0     |     CLK_ICKR=  000002 
    CLK_ICKR=  000000     |     CLK_ICKR=  000001     |     CLK_ICKR=  000003 
    CLK_ICKR=  000004     |     CLK_ICKR=  000005     |     CLK_PCKE=  0050C7 
    CLK_PCKE=  000000     |     CLK_PCKE=  000001     |     CLK_PCKE=  000007 
    CLK_PCKE=  000005     |     CLK_PCKE=  000006     |     CLK_PCKE=  000004 
    CLK_PCKE=  000002     |     CLK_PCKE=  000003     |     CLK_PCKE=  0050CA 
    CLK_PCKE=  000003     |     CLK_PCKE=  000002     |     CLK_PCKE=  000007 
    CLK_SWCR=  0050C5     |     CLK_SWCR=  000000     |     CLK_SWCR=  000001 
    CLK_SWCR=  000002     |     CLK_SWCR=  000003     |     CLK_SWIM=  0050CD 
    CLK_SWR =  0050C4     |     CLK_SWR_=  0000B4     |     CLK_SWR_=  0000E1 
    CLK_SWR_=  0000D2     |     CLR_IDX =  000037     |     CLS     =  000005 G
    CMD_END =  000001     |     CMD_LAST=  000044     |     COLON   =  00003A 
    COLON_ID=  000001     |     COL_CNT =  000001     |     COMMA   =  00002C 
    COMMA_ID=  000002     |     CON_IDX =  000026     |     COUNT   =  000006 
    CPOS    =  000001     |     CPU_A   =  007F00     |     CPU_CCR =  007F0A 
    CPU_PCE =  007F01     |     CPU_PCH =  007F02     |     CPU_PCL =  007F03 
    CPU_SPH =  007F08     |     CPU_SPL =  007F09     |     CPU_XH  =  007F04 
    CPU_XL  =  007F05     |     CPU_YH  =  007F06     |     CPU_YL  =  007F07 
    CR      =  00000D     |     CTRL_A  =  000001     |     CTRL_B  =  000002 
    CTRL_C  =  000003     |     CTRL_D  =  000004     |     CTRL_E  =  000005 
    CTRL_F  =  000006     |     CTRL_G  =  000007     |     CTRL_H  =  000008 
    CTRL_I  =  000009     |     CTRL_J  =  00000A     |     CTRL_K  =  00000B 
    CTRL_L  =  00000C     |     CTRL_M  =  00000D     |     CTRL_N  =  00000E 
    CTRL_O  =  00000F     |     CTRL_P  =  000010     |     CTRL_Q  =  000011 
    CTRL_R  =  000012     |     CTRL_S  =  000013     |     CTRL_T  =  000014 
    CTRL_U  =  000015     |     CTRL_V  =  000016     |     CTRL_W  =  000017 
    CTRL_X  =  000018     |     CTRL_Y  =  000019     |     CTRL_Z  =  00001A 
    CTXT_SIZ=  000004     |     CURR    =  000002     |     CVAR    =  000005 
    DBLDIVDN=  000005     |     DBLHI   =  000001     |     DBLLO   =  000003 
    DC1     =  000011     |     DC2     =  000012     |     DC3     =  000013 
    DC4     =  000014     |     DEBUG_BA=  007F00     |     DEBUG_EN=  007FFF 
    DELBK   =  000006 G   |     DELIM_LA=  000006     |     DEL_IDX =  000036 
    DEL_SIZE=  000005     |     DEST    =  000001     |     DEST_ADR=  000005 
    DEST_SIZ=  000003     |     DEVID_BA=  0048CD     |     DEVID_EN=  0048D8 
    DEVID_LO=  0048D2     |     DEVID_LO=  0048D3     |     DEVID_LO=  0048D4 
    DEVID_LO=  0048D5     |     DEVID_LO=  0048D6     |     DEVID_LO=  0048D7 
    DEVID_LO=  0048D8     |     DEVID_WA=  0048D1     |     DEVID_XH=  0048CE 
    DEVID_XL=  0048CD     |     DEVID_YH=  0048D0     |     DEVID_YL=  0048CF 
  4 DIG        000B87 R   |     DIGIT   =  000003     |     DIM_IDX =  000019 
    DIM_SIZE=  000003     |     DIR_IDX =  000043     |     DIVDHI  =  000001 
    DIVDLO  =  000003     |     DIVDNDHI=  00000B     |     DIVDNDLO=  00000D 
    DIVISOR =  000001     |     DIVISR  =  000005     |     DIVR    =  000005 
    DIV_IDX =  00000D     |     DLE     =  000010     |     DM_BK1RE=  007F90 
    DM_BK1RH=  007F91     |     DM_BK1RL=  007F92     |     DM_BK2RE=  007F93 
    DM_BK2RH=  007F94     |     DM_BK2RL=  007F95     |     DM_CR1  =  007F96 
    DM_CR2  =  007F97     |     DM_CSR1 =  007F98     |     DM_CSR2 =  007F99 
    DM_ENFCT=  007F9A     |     DONE    =  000003     |     DPROD   =  000003 
    DURATION=  000001     |   4 ECHO       000BED R   |     EEPROM_B=  004000 
    EEPROM_E=  0043FF     |     EEPROM_S=  000400     |     EM      =  000019 
    END_ADR =  000003     |     END_IDX =  00001A     |     ENQ     =  000005 
    EOF     =  0000FF     |   4 EOL        000B54 R   |     EOL_IDX =  000000 
    EOT     =  000004     |   4 ERASED     0012AF R   |     ERASE_ID=  000044 
    ERR_BAD_=  000004 G   |     ERR_BAD_=  000006 G   |     ERR_BAD_=  000005 G
    ERR_DIM =  00000C G   |     ERR_DIV0=  000012 G   |     ERR_END =  000009 G
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 235.
Hexadecimal [24-Bits]

Symbol Table

    ERR_FORS=  000008 G   |     ERR_GOSU=  000007 G   |     ERR_GT25=  000003 G
    ERR_GT32=  000002 G   |     ERR_IDX =  000013     |     ERR_MEM_=  00000A G
    ERR_NONE=  000000 G   |     ERR_PROG=  000011 G   |     ERR_RANG=  00000D G
    ERR_RETY=  000010 G   |     ERR_STRI=  00000F G   |     ERR_STR_=  00000E G
    ERR_SYNT=  000001 G   |     ERR_TOO_=  00000B G   |     ESC     =  00001B 
    ETB     =  000017     |     ETX     =  000003     |     EXTI_CR1=  0050A0 
    EXTI_CR2=  0050A1     |     FAUTO   =  000006     |     FCNT    =  000001 
    FCOMP   =  000005     |     FF      =  00000C     |     FHSE    =  7A1200 
    FHSI    =  F42400     |     FILE_DAT=  000010     |     FILE_HEA=  000010 
    FILE_NAM=  000004     |     FILE_SIG=  000000     |     FILE_SIZ=  000002 
    FIRST   =  000001     |     FIRST_CH=  000001     |     FIRST_DA=  000004 
    FLASH_BA=  008000     |     FLASH_CR=  00505A     |     FLASH_CR=  000002 
    FLASH_CR=  000000     |     FLASH_CR=  000003     |     FLASH_CR=  000001 
    FLASH_CR=  00505B     |     FLASH_CR=  000005     |     FLASH_CR=  000004 
    FLASH_CR=  000007     |     FLASH_CR=  000000     |     FLASH_CR=  000006 
    FLASH_DU=  005064     |     FLASH_DU=  0000AE     |     FLASH_DU=  000056 
    FLASH_EN=  017FFF     |     FLASH_FP=  00505D     |     FLASH_FP=  000000 
    FLASH_FP=  000001     |     FLASH_FP=  000002     |     FLASH_FP=  000003 
    FLASH_FP=  000004     |     FLASH_FP=  000005     |     FLASH_IA=  00505F 
    FLASH_IA=  000003     |     FLASH_IA=  000002     |     FLASH_IA=  000006 
    FLASH_IA=  000001     |     FLASH_IA=  000000     |   4 FLASH_ME   001CFB R
    FLASH_NC=  00505C     |     FLASH_NF=  00505E     |     FLASH_NF=  000000 
    FLASH_NF=  000001     |     FLASH_NF=  000002     |     FLASH_NF=  000003 
    FLASH_NF=  000004     |     FLASH_NF=  000005     |     FLASH_PU=  005062 
    FLASH_PU=  000056     |     FLASH_PU=  0000AE     |     FLASH_SI=  010000 
    FLASH_WS=  00480D     |     FLSI    =  01F400     |     FMSTR   =  000010 
    FNAME   =  000005     |     FNAME_MA=  00000C     |     FN_ADR  =  000003 
    FN_ARG  =  000001     |     FOPT    =  000001     |     FOR_IDX =  00001B 
    FREE_RAM=  001580 G   |     FREQ    =  000003     |     FRUN    =  000000 
    FS      =  00001C     |     FSECTOR_=  000100     |     FSIZE   =  000001 
    FSLEEP  =  000003     |     FSTEP   =  000001     |     FSTOP   =  000004 
    FSYS_TIM=  000000 G   |     FSYS_TON=  000001 G   |     FSYS_UPP=  000002 G
    FS_BASE =  00C000 G   |     FS_SIZE =  00C000 G   |     FTRACE  =  000007 
    FUNC_LAS=  00002F     |     F_ARRAY =  000001     |     GETC    =  000003 G
  4 GETLINE    000B19 R   |     GETLN   =  000007 G   |     GET_RND =  00000D G
    GOSUB_ID=  00001D     |   4 GOTNUMBE   000B9D R   |     GOTO_IDX=  00001F 
  4 GO_BASIC   000B0D R   |     GPIO_BAS=  005000     |     GPIO_CR1=  000003 
    GPIO_CR2=  000004     |     GPIO_DDR=  000002     |     GPIO_IDR=  000001 
    GPIO_ODR=  000000     |     GPIO_SIZ=  000005     |     GS      =  00001D 
    HEAP_ADR=  000001     |   4 HEXSHIFT   000B8A R   |     HIMEM_ID=  000034 
    HOME    =  000082     |     HSE     =  000000     |     HSECNT  =  004809 
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 236.
Hexadecimal [24-Bits]

Symbol Table

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
    I2C_WRIT=  000000     |     ICHAR   =  000001     |     IDX     =  000001 
    IF_IDX  =  000020     |     INCR    =  000001     |     INPUT_DI=  000000 
    INPUT_EI=  000001     |     INPUT_FL=  000000     |     INPUT_ID=  000038 
    INPUT_PU=  000001     |     INT_ADC2=  000016     |     INT_AUAR=  000012 
    INT_AWU =  000001     |     INT_CAN_=  000008     |     INT_CAN_=  000009 
    INT_CLK =  000002     |     INT_EXTI=  000003     |     INT_EXTI=  000004 
    INT_EXTI=  000005     |     INT_EXTI=  000006     |     INT_EXTI=  000007 
    INT_FLAS=  000018     |     INT_I2C =  000013     |     INT_SIZE=  000002 G
    INT_SPI =  00000A     |     INT_TIM1=  00000C     |     INT_TIM1=  00000B 
    INT_TIM2=  00000E     |     INT_TIM2=  00000D     |     INT_TIM3=  000010 
    INT_TIM3=  00000F     |     INT_TIM4=  000017     |     INT_TLI =  000000 
    INT_UART=  000011     |     INT_UART=  000015     |     INT_UART=  000014 
    INT_VECT=  008060     |     INT_VECT=  00800C     |     INT_VECT=  008028 
    INT_VECT=  00802C     |     INT_VECT=  008010     |     INT_VECT=  008014 
    INT_VECT=  008018     |     INT_VECT=  00801C     |     INT_VECT=  008020 
    INT_VECT=  008024     |     INT_VECT=  008068     |     INT_VECT=  008054 
    INT_VECT=  008000     |     INT_VECT=  008030     |     INT_VECT=  008038 
    INT_VECT=  008034     |     INT_VECT=  008040     |     INT_VECT=  00803C 
    INT_VECT=  008048     |     INT_VECT=  008044     |     INT_VECT=  008064 
    INT_VECT=  008008     |     INT_VECT=  008004     |     INT_VECT=  008050 
    INT_VECT=  00804C     |     INT_VECT=  00805C     |     INT_VECT=  008058 
    IPOS    =  000003     |     ITC_SPR1=  007F70     |     ITC_SPR2=  007F71 
    ITC_SPR3=  007F72     |     ITC_SPR4=  007F73     |     ITC_SPR5=  007F74 
    ITC_SPR6=  007F75     |     ITC_SPR7=  007F76     |     ITC_SPR8=  007F77 
    ITC_SPR_=  000001     |     ITC_SPR_=  000000     |     ITC_SPR_=  000003 
    IWDG_KEY=  000055     |     IWDG_KEY=  0000CC     |     IWDG_KEY=  0000AA 
    IWDG_KR =  0050E0     |     IWDG_PR =  0050E1     |     IWDG_RLR=  0050E2 
    KEY_END =  000083     |     KEY_IDX =  00002F     |     KWORD_LA=  000027 
    LAST    =  000003     |     LAST_BC =  000004     |     LB      =  000002 
    LED_BIT =  000005     |     LED_MASK=  000020     |     LED_PORT=  00500A 
    LEN     =  000005     |     LEN_IDX =  00002C     |     LET_IDX =  000022 
    LF      =  00000A     |     LIMIT   =  000001     |     LINENO  =  000005 
  4 LINES_RE   001DAC R   |     LINE_HEA=  000003     |   4 LINK    =  0028CE R
    LIST_IDX=  000039     |     LITC_IDX=  000007     |     LITW_IDX=  000008 
    LIT_LAST=  000008     |     LL      =  000001     |     LLEN    =  000007 
    LL_HB   =  000001     |     LNADR   =  000003     |     LN_ADDR =  000007 
    LN_PTR  =  000005     |     LOAD_IDX=  000042     |     LOMEM_ID=  000035 
    LPAREN_I=  000004     |     MAJOR   =  000001     |     MASKED  =  000005 
    MAX_CODE=  001500     |     MAX_LINE=  007FFF     |     MINOR   =  000000 
    MIN_VAR_=  000080     |   4 MOD8CHK    000BE4 R   |     MODE    =  000030 
    MOD_IDX =  00000E     |     MULOP   =  000005     |     MULT_IDX=  00000F 
    N       =  000001     |     N1      =  000001     |     N2      =  000003 
    NAFR    =  004804     |     NAK     =  000015     |     NAME_SIZ=  000002 
    NBR_COL =  000003     |     NCLKOPT =  004808     |     NEED    =  000001 
    NEG     =  000001     |     NEW_IDX =  00003A     |   4 NEXTCHAR   000B30 R
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 237.
Hexadecimal [24-Bits]

Symbol Table

  4 NEXTHEX    000B77 R   |   4 NEXTITEM   000B5D R   |     NEXT_IDX=  00001C 
    NFIELD  =  000002     |     NFLASH_W=  00480E     |     NHSECNT =  00480A 
    NLEN    =  000001     |     NLEN_MAS=  00000F     |     NONE_IDX=  0000FF 
    NOPT1   =  004802     |     NOPT2   =  004804     |     NOPT3   =  004806 
    NOPT4   =  004808     |     NOPT5   =  00480A     |     NOPT6   =  00480C 
    NOPT7   =  00480E     |     NOPTBL  =  00487F     |   4 NOTHEX     000B95 R
  4 NOTREAD    000BAA R   |     NOT_IDX =  000016     |     NOT_OP  =  000001 
    NUBC    =  004802     |     NUCLEO_8=  000001     |     NUCLEO_8=  000000 
    NWDGOPT =  004806     |     NWDGOPT_=  FFFFFFFD     |     NWDGOPT_=  FFFFFFFC 
    NWDGOPT_=  FFFFFFFF     |     NWDGOPT_=  FFFFFFFE     |   4 NXTPRNT    000BC0 R
  4 NonHandl   000000 R   |     OFS     =  000002     |     OFS_UART=  000002 
    OFS_UART=  000003     |     OFS_UART=  000004     |     OFS_UART=  000005 
    OFS_UART=  000006     |     OFS_UART=  000007     |     OFS_UART=  000008 
    OFS_UART=  000009     |     OFS_UART=  000001     |     OFS_UART=  000009 
    OFS_UART=  00000A     |     OFS_UART=  000000     |     OP      =  000003 
    OPT0    =  004800     |     OPT1    =  004801     |     OPT2    =  004803 
    OPT3    =  004805     |     OPT4    =  004807     |     OPT5    =  004809 
    OPT6    =  00480B     |     OPT7    =  00480D     |     OPTBL   =  00487E 
    OPTION_B=  004800     |     OPTION_E=  00487F     |     OPTION_S=  000080 
    OP_ARITH=  00000F     |     OP_REL  =  000009     |     OP_REL_L=  000015 
    OR_IDX  =  000018     |     OUTPUT_F=  000001     |     OUTPUT_O=  000000 
    OUTPUT_P=  000001     |     OUTPUT_S=  000000     |     OVRWR   =  000004 
  4 P1BASIC    001653 GR  |     PA      =  000000     |     PAD_SIZE=  000080 G
    PAGE0_SI=  000100 G   |     PAGE_ERA=  000042     |     PA_BASE =  005000 
    PA_CR1  =  005003     |     PA_CR2  =  005004     |     PA_DDR  =  005002 
    PA_IDR  =  005001     |     PA_ODR  =  005000     |     PB      =  000005 
    PB_BASE =  005005     |     PB_CR1  =  005008     |     PB_CR2  =  005009 
    PB_DDR  =  005007     |     PB_IDR  =  005006     |     PB_ODR  =  005005 
    PC      =  00000A     |     PC_BASE =  00500A     |     PC_CR1  =  00500D 
    PC_CR2  =  00500E     |     PC_DDR  =  00500C     |     PC_IDR  =  00500B 
    PC_ODR  =  00500A     |     PD      =  00000F     |     PD_BASE =  00500F 
    PD_CR1  =  005012     |     PD_CR2  =  005013     |     PD_DDR  =  005011 
    PD_IDR  =  005010     |     PD_ODR  =  00500F     |     PE      =  000014 
    PEEK_IDX=  000029     |     PENDING_=  000010     |     PE_BASE =  005014 
    PE_CR1  =  005017     |     PE_CR2  =  005018     |     PE_DDR  =  005016 
    PE_IDR  =  005015     |     PE_ODR  =  005014     |     PF      =  000019 
    PF_BASE =  005019     |     PF_CR1  =  00501C     |     PF_CR2  =  00501D 
    PF_DDR  =  00501B     |     PF_IDR  =  00501A     |     PF_ODR  =  005019 
    PG      =  00001E     |     PG_BASE =  00501E     |     PG_CR1  =  005021 
    PG_CR2  =  005022     |     PG_DDR  =  005020     |     PG_IDR  =  00501F 
    PG_ODR  =  00501E     |     PH      =  000023     |     PH_BASE =  005023 
    PH_CR1  =  005026     |     PH_CR2  =  005027     |     PH_DDR  =  005025 
    PH_IDR  =  005024     |     PH_ODR  =  005023     |     PI      =  000028 
    PI_BASE =  005028     |     PI_CR1  =  00502B     |     PI_CR2  =  00502C 
    PI_DDR  =  00502A     |     PI_IDR  =  005029     |     PI_ODR  =  005028 
    POKE_IDX=  00003C     |     POK_ADR =  000003     |   4 PRBYTE     000BE9 R
  4 PRDATA     000BD4 R   |     PREV    =  000001     |     PRINT_ID=  00003D 
    PRIORITY=  000003     |   4 PROG_ADD   001CD1 R   |   4 PROG_SIZ   001CE3 R
    PRT_INT =  000009 G   |     PRT_STR =  000008 G   |     PSTR    =  000001 
    PUTC    =  000002 G   |     QCHAR   =  000004 G   |     QUOTE_ID=  000006 
    RAM_BASE=  000000     |     RAM_END =  0017FF     |   4 RAM_MEM    001D0C R
    RAM_PG_S=  000020     |     RAM_SIZE=  001800     |     RD_STATU=  000005 
    REL_EQU_=  000011     |     REL_GE_I=  000012     |     REL_GT_I=  000014 
    REL_LE_I=  000010     |     REL_LT_I=  000013     |     REL_NE_I=  000015 
    REL_OP  =  000005     |     REM_IDX =  000023     |     RES_LEN =  000007 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 238.
Hexadecimal [24-Bits]

Symbol Table

    RET_BPTR=  000001     |     RET_IDX =  00001E     |     RET_LN_A=  000003 
    REV     =  000000     |     RND_IDX =  00002A     |     ROP     =  004800 
    RPAREN_I=  000005     |     RS      =  00001E     |     RST_SR  =  0050B3 
  4 RUN        000BB7 R   |     RUN_IDX =  00003E     |     RW_MODE_=  000000 
    RW_MODE_=  000080     |     RW_MODE_=  000040     |     RXCHAR  =  000001 
    RX_QUEUE=  000008 G   |     SAVE_IDX=  000041     |     SCOL_IDX=  000003 
    SECTOR_S=  001000     |     SECT_ERA=  0000D8     |     SEED_PRN=  00000E G
    SEMIC   =  00003B     |     SEMICOL =  000001     |     SEPARATE=  000000 
  4 SETMODE    000B59 R   |     SET_TIME=  00000A G   |     SFR_BASE=  005000 
    SFR_END =  0057FF     |     SGN_IDX =  00002B     |     SHARP   =  000023 
    SI      =  00000F     |     SIGN    =  000005     |     SIGNATUR=  005042 
    SIZE    =  000009     |     SIZE_FIE=  000003     |     SKIP    =  000003 
    SLEEP_ID=  000030     |     SLEN    =  000002     |     SLOT    =  000004 
    SMALL_FI=  000003     |     SO      =  00000E     |     SOH     =  000001 
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
    SRC     =  000003     |     SRC_ADR =  000007     |     SREMDR  =  000005 
    SR_WEL_B=  000001     |     SR_WIP_B=  000000     |     STACK_EM=  0017FF 
    STACK_SI=  000080 G   |     START_AD=  000001     |     START_TO=  00000C G
    STDOUT  =  000001     |     STEP_IDX=  000024     |     STOP_IDX=  000025 
    STOR    =  00003A     |     STORADR =  00002C     |     STR1    =  000001 
    STR1_LEN=  000003     |     STR2    =  000005     |     STR2_LEN=  000007 
  4 STR_BYTE   001CF4 R   |     STR_VAR_=  00000A     |     STX     =  000002 
    SUB     =  00001A     |     SUB_IDX =  00000C     |     SUP     =  000084 
    SWIM_CSR=  007F80     |     SYMB_LAS=  00000A     |     SYN     =  000016 
    SYS_RST =  000000 G   |     SYS_SIZE=  004000     |     SYS_TICK=  000001 
    SYS_VARS=  000004     |     SYS_VARS=  000012 G   |     TAB     =  000009 
    TAB_IDX =  000032     |     TAB_WIDT=  000004     |     TCHAR   =  000001 
    TEMP    =  000001     |     TERMIOS_=  00000E G   |     THEN_IDX=  000021 
    TIB_SIZE=  000080 G   |     TICK    =  000027     |     TICKS_ID=  00002D 
    TIM1_ARR=  005262     |     TIM1_ARR=  005263     |     TIM1_BKR=  00526D 
    TIM1_CCE=  00525C     |     TIM1_CCE=  00525D     |     TIM1_CCM=  005258 
    TIM1_CCM=  000000     |     TIM1_CCM=  000001     |     TIM1_CCM=  000004 
    TIM1_CCM=  000005     |     TIM1_CCM=  000006     |     TIM1_CCM=  000007 
    TIM1_CCM=  000002     |     TIM1_CCM=  000003     |     TIM1_CCM=  000007 
    TIM1_CCM=  000002     |     TIM1_CCM=  000004     |     TIM1_CCM=  000005 
    TIM1_CCM=  000006     |     TIM1_CCM=  000003     |     TIM1_CCM=  005259 
    TIM1_CCM=  000000     |     TIM1_CCM=  000001     |     TIM1_CCM=  000004 
    TIM1_CCM=  000005     |     TIM1_CCM=  000006     |     TIM1_CCM=  000007 
    TIM1_CCM=  000002     |     TIM1_CCM=  000003     |     TIM1_CCM=  000007 
    TIM1_CCM=  000002     |     TIM1_CCM=  000004     |     TIM1_CCM=  000005 
    TIM1_CCM=  000006     |     TIM1_CCM=  000003     |     TIM1_CCM=  00525A 
    TIM1_CCM=  000000     |     TIM1_CCM=  000001     |     TIM1_CCM=  000004 
    TIM1_CCM=  000005     |     TIM1_CCM=  000006     |     TIM1_CCM=  000007 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 239.
Hexadecimal [24-Bits]

Symbol Table

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
    TIM3_CCR=  00532D     |     TIM3_CCR=  00532E     |     TIM3_CCR=  00532F 
    TIM3_CCR=  005330     |     TIM3_CNT=  005328     |     TIM3_CNT=  005329 
    TIM3_CR1=  005320     |     TIM3_CR1=  000007     |     TIM3_CR1=  000000 
    TIM3_CR1=  000003     |     TIM3_CR1=  000001     |     TIM3_CR1=  000002 
    TIM3_EGR=  005324     |     TIM3_IER=  005321     |     TIM3_PSC=  00532A 
    TIM3_SR1=  005322     |     TIM3_SR2=  005323     |     TIM4_ARR=  005346 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 240.
Hexadecimal [24-Bits]

Symbol Table

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
    TOKEN   =  000001     |     TOK_IDX =  000045     |     TOK_POS =  000001 
  4 TONEXTIT   000BB5 R   |     TONE_IDX=  000031     |     TOS     =  000001 
    TO_IDX  =  000027     |     TO_WRITE=  000001     |     TYPE_CON=  000020 
    TYPE_DVA=  000010     |     TYPE_MAS=  0000F0     |   4 Timer4Up   000205 R
  4 TrapHand   000167 GR  |     U1      =  000001     |     UART    =  000002 
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
    UART_POR=  00500D     |     UART_POR=  00500E     |     UART_POR=  00500C 
    UART_POR=  00500B     |     UART_POR=  00500A     |     UART_RX_=  000006 
    UART_SR =  005240     |     UART_SR_=  000001     |     UART_SR_=  000004 
    UART_SR_=  000002     |     UART_SR_=  000003     |     UART_SR_=  000000 
    UART_SR_=  000005     |     UART_SR_=  000006     |     UART_SR_=  000007 
    UART_TX_=  000005     |     UBC     =  004801     |   4 UPPER      000B45 R
    US      =  00001F     |   4 UartRxHa   00040F R   |     VAL1    =  000003 
    VAL2    =  000001     |     VALUE   =  000001     |     VAR_ADR =  000005 
    VAR_IDX =  000009     |     VAR_NAME=  000005     |     VAR_TYPE=  000009 
    VAR_VALU=  000003     |     VNAME   =  000002     |     VSIZE   =  000008 
    VSIZE2  =  00000A     |     VT      =  00000B     |     WCNT    =  000002 
    WDGOPT  =  004805     |     WDGOPT_I=  000002     |     WDGOPT_L=  000003 
    WDGOPT_W=  000000     |     WDGOPT_W=  000001     |     WIDTH   =  000001 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 241.
Hexadecimal [24-Bits]

Symbol Table

    WIDTH_DI=  000004     |     WORDS_ID=  00003F     |   4 WOZMON     000B10 GR
    WR_EN   =  000006     |     WR_STATU=  000001     |     WWDG_CR =  0050D1 
    WWDG_WR =  0050D2     |     XAM     =  000000     |     XAMADR  =  00002A 
  4 XAMNEXT    000BE0 R   |   4 XAM_BLOC   000BBA R   |     XAM_BLOK=  00002E 
    XOFF    =  000013     |     XON     =  000011     |     XSAVE   =  000007 
    YSAV    =  000028     |     YSAVE   =  000007     |     YTEMP   =  000009 
  7 acc16      000018 R   |   7 acc24      000017 R   |   7 acc32      000016 R
  7 acc8       000019 R   |   4 accept_c   0006F1 R   |   4 addr_to_   000AF7 R
  4 all_word   0028CC R   |   4 and_cond   00196A R   |   4 and_fact   001948 R
  4 app        002900 R   |   4 app_spac   002900 R   |   4 arg_list   0017E9 R
  7 arithm_v   00001A R   |   4 atoi16     00175D GR  |   9 auto_lin   00003C R
  9 auto_ste   00003E R   |   4 bad_valu   00268E R   |   2 base       00000F R
  9 basicptr   00002D GR  |   4 beep_1kh   00022A GR  |   4 bkslsh_t   000F48 R
  4 bksp       000559 R   |   6 block_bu   001700 GR  |   4 buf_putc   0004B2 R
  4 bytes_fr   0026A4 R   |   4 char_to_   001746 R   |   4 check_fo   001B61 R
  4 check_sy   000E2E R   |   4 clear_pr   002681 R   |   4 clear_st   0025B1 R
  4 clock_in   000004 R   |   4 clr_scre   00056F R   |   4 cmd_auto   00258B R
  4 cmd_bye    0023C9 R   |   4 cmd_call   00256A GR  |   4 cmd_clea   0025C4 R
  4 cmd_del    0025D3 R   |   4 cmd_dir    002363 R   |   4 cmd_eras   002272 R
  4 cmd_hime   002644 R   |   4 cmd_inpu   001F00 R   |   4 cmd_line   0016AB R
  4 cmd_list   001D1B R   |   4 cmd_load   002324 R   |   4 cmd_lome   002665 R
  4 cmd_new    002267 R   |   4 cmd_poke   001F9C R   |   4 cmd_prin   001DE3 R
  4 cmd_rand   00242B R   |   4 cmd_run    0021A7 R   |   4 cmd_save   0022B3 R
  4 cmd_scr    002267 R   |   4 cmd_set_   00253B R   |   4 cmd_slee   0023DA R
  4 cmd_tab    00255F R   |   4 cmd_tone   0021E6 R   |   4 cmd_word   002483 R
  4 code_add   000BF1 R   |   4 cold_sta   0000A5 R   |   4 colon_ts   000F70 R
  4 comma_ts   000F7B R   |   4 comment    001294 R   |   4 comp_msg   001534 R
  4 compile    00108C GR  |   4 compile_   000DF7 R   |   4 con_msg    00223D R
  4 cond_acc   001FD7 R   |   4 conditio   001990 R   |   4 const_ee   00255A R
  4 convert_   000DC5 R   |   4 convert_   0004F1 R   |   4 copy_com   000FC0 R
  4 copyrigh   0015B2 R   |   9 count      00002A GR  |   4 create_b   000966 R
  4 create_v   001AF6 R   |   4 ctrl_c_m   001681 R   |   4 ctrl_c_s   00168E R
  8 ctrl_c_v   00001C R   |   4 cursor_c   00057A R   |   4 cursor_s   0005CA R
  4 dash_tst   000F91 R   |   4 dbl_sign   0003A2 R   |   4 decomp_e   0012A6 R
  4 decomp_l   0011E1 R   |   4 decompil   0011BD GR  |   4 del_line   000CAD R
  4 delete_l   00075D R   |   4 delete_u   00074F R   |   4 dict_end   0026AF R
  4 digit_te   000F27 R   |   4 dim_next   001BF5 R   |   4 display_   000787 R
  4 div32_16   0003AC R   |   4 divide     0003EE R   |   4 dneg       000399 R
  4 do_nothi   0016E0 R   |   4 dump_cod   000116 R   |   9 dvar_bgn   000035 GR
  9 dvar_end   000037 GR  |   4 eeprom_e   000A11 R   |   4 eeprom_e   000ADA R
  4 eeprom_e   000AB6 R   |   4 eeprom_p   000A86 R   |   4 eeprom_r   000A62 R
  4 eeprom_r   000A21 R   |   4 eeprom_w   000A36 R   |   4 eql_tst    001017 R
  4 erase_fi   0012DB R   |   4 erase_li   000598 R   |   4 erase_pr   002287 R
  4 err_bad_   00149F R   |   4 err_bad_   0014B5 R   |   4 err_bad_   0014AA R
  4 err_dim    0014E6 R   |   4 err_div0   001519 R   |   4 err_end    0014D0 R
  4 err_err    00154A R   |   4 err_gt25   00149A R   |   4 err_gt32   001493 R
  4 err_gt8_   0014C8 R   |   4 err_gt8_   0014BE R   |   4 err_mem_   0014D4 R
  4 err_msg_   001466 R   |   4 err_prog   00150C R   |   4 err_rang   0014EA R
  4 err_rety   001500 R   |   4 err_star   001545 R   |   4 err_str_   0014F0 R
  4 err_stri   0014F9 R   |   4 err_synt   00148C R   |   4 err_too_   0014DD R
  4 error_me   00148C R   |   4 escaped    000DDA GR  |   4 expect     0017D0 R
  4 expect_i   001734 R   |   4 expressi   0018B2 R   |   4 factor     00180C R
  2 farptr     000011 R   |   9 file_hea   000054 R   |   4 file_siz   0023BC R
  4 files_co   0023C3 R   |   4 final_te   0006EA R   |   4 first_fi   00140B R
  9 flags      00003B GR  |   2 fmstr      000010 R   |   9 for_nest   000040 R
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 242.
Hexadecimal [24-Bits]

Symbol Table

  4 free       002693 R   |   A free_ram   000100 R   |   4 func_abs   002403 R
  4 func_arg   0017DE R   |   4 func_cha   0023F0 R   |   4 func_key   001F91 R
  4 func_len   00244E R   |   4 func_pee   001FB0 R   |   4 func_ran   002413 R
  4 func_sig   002434 R   |   4 func_tic   0023ED R   |   4 func_tim   002550 R
  4 get_arra   001B82 R   |   4 get_arra   00180B R   |   4 get_esca   0004FD R
  4 get_stri   001A75 R   |   4 get_stri   001BC0 R   |   4 get_targ   00212E R
  4 get_var_   001B23 R   |   4 getc       0004D0 GR  |   9 gosub_ne   000041 R
  4 gt_tst     001022 R   |   4 heap_all   001AD7 R   |   9 heap_fre   000039 GR
  9 himem      000031 GR  |   4 if_strin   001FE3 R   |   9 in         000029 GR
  9 in.w       000028 GR  |   4 incr_far   001459 R   |   4 input_ex   001F8C R
  4 input_in   001E8A R   |   4 input_pr   001E77 R   |   4 input_st   001EF2 R
  4 insert_c   0005E2 R   |   4 insert_l   000D1B R   |   4 integer    000F2E R
  4 interp_l   0016E0 R   |   4 is_alnum   0008A7 GR  |   4 is_alpha   00087F GR
  4 is_digit   000890 GR  |   4 is_hex_d   000899 GR  |   4 itoa       0007B9 GR
  4 itoa_loo   0007DE R   |   4 jp_to_ta   00215B R   |   2 kvars_en   000016 R
  4 kword_co   00224F R   |   4 kword_di   00284F GR  |   4 kword_di   001BF3 R
  4 kword_en   0021DA R   |   4 kword_fo   0020A3 R   |   4 kword_go   00216E R
  4 kword_go   00216E R   |   4 kword_go   002182 R   |   4 kword_go   00214F R
  4 kword_go   00214F R   |   4 kword_if   001FBF R   |   4 kword_le   0019C3 GR
  4 kword_le   0019D4 R   |   4 kword_ne   0020F7 R   |   4 kword_re   0016EB GR
  4 kword_re   00218E R   |   4 kword_st   0020E9 R   |   4 kword_st   002204 R
  4 kword_to   0020D8 R   |   4 let_int_   0019D6 R   |   4 let_stri   0019F6 R
  4 let_stri   0019F8 R   |   9 line.add   00002B GR  |   4 list_exi   001DA4 R
  4 list_loo   001D80 R   |   4 list_to    001D5E R   |   4 lit_word   001267 R
  4 load_fil   001339 R   |   9 lomem      00002F GR  |   4 long_div   000384 R
  4 loop_bac   00211D R   |   4 loop_don   002127 R   |   4 lt_tst     001049 R
  4 modulo     00040A R   |   4 mon_str    000AFD R   |   4 move       000830 GR
  4 move_dow   000850 R   |   4 move_exi   00086F R   |   4 move_loo   000855 R
  4 move_str   00076D R   |   4 move_str   000776 R   |   4 move_to_   0005B8 R
  4 move_up    000842 R   |   4 multiply   000347 R   |   4 nbr_tst    000F1F R
  4 neg_acc1   0002E9 R   |   4 new_line   000569 R   |   4 next_fil   001410 R
  4 next_lin   0016F8 R   |   4 no_match   0017B8 R   |   4 no_prog    0022FF R
  4 no_space   002312 R   |   4 not_a_fi   002353 R   |   4 not_a_li   00263F R
  4 not_file   002299 R   |   4 open_gap   000CE6 R   |   4 other      001070 R
  4 other_te   000F37 R   |   8 out        00001A R   |   4 overwrit   000715 R
  6 pad        001700 GR  |   4 page_add   000AF4 R   |   4 parse_in   000DE2 R
  4 parse_ke   000E8C R   |   4 parse_le   000EF4 R   |   4 parse_qu   000D83 R
  4 parse_sy   000E04 R   |   9 pending_   000044 R   |   4 plus_tst   000FEB R
  4 prcnt_ts   00100C R   |   4 print_co   0015EA R   |   4 print_er   001599 R
  4 print_he   00079C GR  |   4 print_in   0007AE R   |   4 print_li   001D63 R
  4 print_va   001E7D R   |   4 prng       0002AE GR  |   4 prog_siz   001C87 R
  9 progend    000033 GR  |   4 program_   001C8E R   |   4 prt_basi   001DD5 R
  4 prt_i8     0007AC R   |   4 prt_line   00171A R   |   4 prt_loop   001DE7 R
  4 prt_quot   001141 R   |   4 prt_spac   001247 R   |   4 prt_var_   001189 R
  9 psp        000042 R   |   2 ptr16      000012 GR  |   2 ptr8       000013 R
  4 push_it    000E85 R   |   4 putc       0004AC R   |   4 puts       000523 GR
  4 qgetc      0004CA GR  |   4 qmark_ts   000FA7 R   |   4 quoted_s   0012A0 R
  4 readln     0005F9 GR  |   4 readln_l   000617 R   |   4 readln_q   000731 R
  4 reclaim_   0012E9 R   |   4 relation   0018EE R   |   4 reset_ba   001631 R
  4 reset_se   001DE5 R   |   4 rest_con   001E62 R   |   4 restore_   0005AD R
  4 retype     001E6A R   |   4 right_al   001126 GR  |   4 rparnt_t   000F60 R
  4 rt_msg     001522 R   |   8 rx1_head   00001E R   |   8 rx1_queu   000020 R
  8 rx1_tail   00001F R   |   4 save_con   001E5B R   |   4 save_cur   0005A4 R
  4 save_fil   001362 R   |   4 search_d   0017A5 GR  |   4 search_e   0017CD R
  4 search_f   0012B1 R   |   4 search_f   0013CB R   |   4 search_l   000C7B GR
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 243.
Hexadecimal [24-Bits]

Symbol Table

  4 search_n   0017AB R   |   4 search_v   001BC5 R   |   2 seedx      00000B R
  2 seedy      00000D R   |   4 semic_ts   000F86 R   |   4 send_csi   00052E R
  4 send_par   00053B R   |   4 set_int_   00006E GR  |   4 set_outp   000498 R
  4 set_seed   0002D0 R   |   4 sharp_ts   000F9C R   |   4 skip       000EE3 R
  4 skip_dis   00061F R   |   4 skip_str   001727 R   |   4 skip_to_   00144F R
  4 slash_ts   001001 R   |   4 sll_xy_3   0002A0 R   |   4 space      000586 R
  4 spaces     00058C GR  |   4 spi_clea   000939 R   |   4 spi_dese   000985 R
  4 spi_disa   000919 R   |   4 spi_enab   0008B0 R   |   4 spi_mode   0008FD R
  4 spi_ram_   0009F2 R   |   4 spi_ram_   0009AE R   |   4 spi_ram_   000999 R
  4 spi_ram_   0009D3 R   |   4 spi_rcv_   00095B R   |   4 spi_sele   000975 R
  4 spi_send   0009C3 R   |   4 spi_send   000945 R   |   4 srl_xy_3   0002A7 R
  6 stack_fu   001780 GR  |   6 stack_un   001800 GR  |   4 star_tst   000FF6 R
  4 stop_msg   00222E R   |   4 store_lo   0020EE R   |   4 str_matc   0017C4 R
  4 str_tst    000F0D R   |   4 strcmp     000811 GR  |   4 strcpy     000820 GR
  4 strlen     000806 GR  |   4 symb_loo   000E0B R   |   4 syntax_e   001553 GR
  2 sys_flag   00000A R   |   4 syscall_   000201 R   |   4 syscall_   000171 R
  4 target01   002131 R   |   4 tb_error   001555 GR  |   4 term       00186D R
  4 term01     001874 R   |   4 term_exi   0018AD R   |   8 term_var   000028 R
  4 test       000106 R   |   6 tib        001680 GR  |   4 tick_tst   000FB6 R
  2 ticks      000004 R   |   2 timer      000006 R   |   4 timer2_i   000025 R
  4 timer4_i   000032 R   |   4 to_hex_c   000791 GR  |   4 to_upper   000874 R
  4 tok_to_n   001194 R   |   4 token_ch   001085 R   |   4 token_ex   001089 R
  4 tone       000239 GR  |   2 tone_ms    000008 R   |   4 tone_off   000279 R
  2 trap_ret   000014 R   |   4 uart_get   0004D0 GR  |   4 uart_ini   000440 R
  4 uart_put   0004C1 GR  |   4 uart_qge   0004CA GR  |   4 udiv32_1   000372 R
  4 umstar     000307 R   |   4 umul16_8   0002F8 R   |   4 update_c   00061A R
  4 variable   00124C R   |   4 warm_ini   00161F R   |   4 warm_sta   0016A8 R
  4 words_co   002525 R   |   4 xor_seed   000284 R

ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 244.
Hexadecimal [24-Bits]

Area Table

   0 _CODE      size      0   flags    0
   1 DATA       size      0   flags    8
   2 DATA0      size     12   flags    8
   3 HOME       size     80   flags    0
   4 CODE       size   2900   flags    0
   5 SSEG       size      0   flags    8
   6 SSEG1      size    180   flags    8
   7 DATA2      size      4   flags    8
   8 DATA3      size      E   flags    8
   9 DATA4      size     3C   flags    8
   A DATA5      size      0   flags    8

