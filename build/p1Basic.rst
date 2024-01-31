ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 1.
Hexadecimal [24-Bits]



                                      1 ;;
                                      2 ; Copyright Jacques Deschênes 2019,2022,2023,2024  
                                      3 ; This file is part of p1Basic 
                                      4 ;
                                      5 ;     p1Basic is free software: you can redistribute it and/or modify
                                      6 ;     it under the terms of the GNU General Public License as published by
                                      7 ;     the Free Software Foundation, either version 3 of the License, or
                                      8 ;     (at your option) any later version.
                                      9 ;
                                     10 ;     p1Basic is distributed in the hope that it will be useful,
                                     11 ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                     12 ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                     13 ;     GNU General Public License for more details.
                                     14 ;
                                     15 ;     You should have received a copy of the GNU General Public License
                                     16 ;     along with p1Basic.  If not, see <http://www.gnu.org/licenses/>.
                                     17 ;;
                                     18 
                                     19 
                                     20     .module PROC_TABLE 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 2.
Hexadecimal [24-Bits]



                                     21     .include "../config.inc"
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



                                     22 
                                     23     .area CODE 
                                     24 
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
      008CF2                         40 code_addr:
                                     41 ; command end marker  
      000000                         42 	_code_entry next_line, EOL_IDX  ; $0 
      008CF2 97 F4                    1 	.word next_line
                           000000     2 	EOL_IDX =TOK_IDX 
                           000001     3 	TOK_IDX=TOK_IDX+1 
      000002                         43 	_code_entry do_nothing, COLON_IDX   ; $1 ':'
      008CF4 97 DC                    1 	.word do_nothing
                           000001     2 	COLON_IDX =TOK_IDX 
                           000002     3 	TOK_IDX=TOK_IDX+1 
                           000001    44     CMD_END = TOK_IDX-1 
                                     45 ; caractères délimiteurs 
      000004                         46     _code_entry syntax_error, COMMA_IDX ; $2  ',' 
      008CF6 96 73                    1 	.word syntax_error
                           000002     2 	COMMA_IDX =TOK_IDX 
                           000003     3 	TOK_IDX=TOK_IDX+1 
      000006                         47 	_code_entry syntax_error,SCOL_IDX  ; $3 ';' 
      008CF8 96 73                    1 	.word syntax_error
                           000003     2 	SCOL_IDX =TOK_IDX 
                           000004     3 	TOK_IDX=TOK_IDX+1 
      000008                         48 	_code_entry syntax_error, LPAREN_IDX ; $4 '(' 
      008CFA 96 73                    1 	.word syntax_error
                           000004     2 	LPAREN_IDX =TOK_IDX 
                           000005     3 	TOK_IDX=TOK_IDX+1 
      00000A                         49 	_code_entry syntax_error, RPAREN_IDX ; $5 ')' 
      008CFC 96 73                    1 	.word syntax_error
                           000005     2 	RPAREN_IDX =TOK_IDX 
                           000006     3 	TOK_IDX=TOK_IDX+1 
      00000C                         50 	_code_entry syntax_error, QUOTE_IDX  ; $6 '"' 
      008CFE 96 73                    1 	.word syntax_error
                           000006     2 	QUOTE_IDX =TOK_IDX 
                           000007     3 	TOK_IDX=TOK_IDX+1 
                           000006    51     DELIM_LAST=TOK_IDX-1 
                                     52 ; literal values 
      00000E                         53     _code_entry syntax_error,LITC_IDX ; 8 bit literal 
      008D00 96 73                    1 	.word syntax_error
                           000007     2 	LITC_IDX =TOK_IDX 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 39.
Hexadecimal [24-Bits]



                           000008     3 	TOK_IDX=TOK_IDX+1 
      000010                         54     _code_entry syntax_error,LITW_IDX  ; 16 bits literal 
      008D02 96 73                    1 	.word syntax_error
                           000008     2 	LITW_IDX =TOK_IDX 
                           000009     3 	TOK_IDX=TOK_IDX+1 
                           000008    55     LIT_LAST=TOK_IDX-1 
                                     56 ; variable identifiers  
      000012                         57 	_code_entry kword_let2,VAR_IDX    ; $9 integer variable  
      008D04 9A F6                    1 	.word kword_let2
                           000009     2 	VAR_IDX =TOK_IDX 
                           00000A     3 	TOK_IDX=TOK_IDX+1 
      000014                         58 	_code_entry let_string2,STR_VAR_IDX  ; string variable 
      008D06 9B 1A                    1 	.word let_string2
                           00000A     2 	STR_VAR_IDX =TOK_IDX 
                           00000B     3 	TOK_IDX=TOK_IDX+1 
                           00000A    59     SYMB_LAST=TOK_IDX-1 
                                     60 ; arithmetic operators      
      000016                         61 	_code_entry syntax_error, ADD_IDX   ; $D 
      008D08 96 73                    1 	.word syntax_error
                           00000B     2 	ADD_IDX =TOK_IDX 
                           00000C     3 	TOK_IDX=TOK_IDX+1 
      000018                         62 	_code_entry syntax_error, SUB_IDX   ; $E
      008D0A 96 73                    1 	.word syntax_error
                           00000C     2 	SUB_IDX =TOK_IDX 
                           00000D     3 	TOK_IDX=TOK_IDX+1 
      00001A                         63 	_code_entry syntax_error, DIV_IDX   ; $10 
      008D0C 96 73                    1 	.word syntax_error
                           00000D     2 	DIV_IDX =TOK_IDX 
                           00000E     3 	TOK_IDX=TOK_IDX+1 
      00001C                         64 	_code_entry syntax_error, MOD_IDX   ; $11
      008D0E 96 73                    1 	.word syntax_error
                           00000E     2 	MOD_IDX =TOK_IDX 
                           00000F     3 	TOK_IDX=TOK_IDX+1 
      00001E                         65 	_code_entry syntax_error, MULT_IDX  ; $12 
      008D10 96 73                    1 	.word syntax_error
                           00000F     2 	MULT_IDX =TOK_IDX 
                           000010     3 	TOK_IDX=TOK_IDX+1 
                           00000F    66     OP_ARITHM_LAST=TOK_IDX-1 
                                     67 ; relational operators
      000020                         68 	_code_entry syntax_error,REL_LE_IDX  ; 
      008D12 96 73                    1 	.word syntax_error
                           000010     2 	REL_LE_IDX =TOK_IDX 
                           000011     3 	TOK_IDX=TOK_IDX+1 
      000022                         69 	_code_entry syntax_error,REL_EQU_IDX ; 
      008D14 96 73                    1 	.word syntax_error
                           000011     2 	REL_EQU_IDX =TOK_IDX 
                           000012     3 	TOK_IDX=TOK_IDX+1 
      000024                         70 	_code_entry syntax_error,REL_GE_IDX  ;  
      008D16 96 73                    1 	.word syntax_error
                           000012     2 	REL_GE_IDX =TOK_IDX 
                           000013     3 	TOK_IDX=TOK_IDX+1 
      000026                         71 	_code_entry syntax_error,REL_LT_IDX  ;  
      008D18 96 73                    1 	.word syntax_error
                           000013     2 	REL_LT_IDX =TOK_IDX 
                           000014     3 	TOK_IDX=TOK_IDX+1 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 40.
Hexadecimal [24-Bits]



      000028                         72 	_code_entry syntax_error,REL_GT_IDX  ;  
      008D1A 96 73                    1 	.word syntax_error
                           000014     2 	REL_GT_IDX =TOK_IDX 
                           000015     3 	TOK_IDX=TOK_IDX+1 
      00002A                         73 	_code_entry syntax_error,REL_NE_IDX  ; 
      008D1C 96 73                    1 	.word syntax_error
                           000015     2 	REL_NE_IDX =TOK_IDX 
                           000016     3 	TOK_IDX=TOK_IDX+1 
                           000015    74     OP_REL_LAST=TOK_IDX-1 
                                     75 ; boolean operators 
      00002C                         76     _code_entry syntax_error, NOT_IDX    ; $19
      008D1E 96 73                    1 	.word syntax_error
                           000016     2 	NOT_IDX =TOK_IDX 
                           000017     3 	TOK_IDX=TOK_IDX+1 
      00002E                         77     _code_entry syntax_error, AND_IDX    ; $1A 
      008D20 96 73                    1 	.word syntax_error
                           000017     2 	AND_IDX =TOK_IDX 
                           000018     3 	TOK_IDX=TOK_IDX+1 
      000030                         78     _code_entry syntax_error, OR_IDX     ; $1B 
      008D22 96 73                    1 	.word syntax_error
                           000018     2 	OR_IDX =TOK_IDX 
                           000019     3 	TOK_IDX=TOK_IDX+1 
                           000018    79     BOOL_OP_LAST=TOK_IDX-1 
                                     80 ; keywords 
      000032                         81     _code_entry kword_dim, DIM_IDX       ; $1F 
      008D24 9D 46                    1 	.word kword_dim
                           000019     2 	DIM_IDX =TOK_IDX 
                           00001A     3 	TOK_IDX=TOK_IDX+1 
      000034                         82     _code_entry kword_end, END_IDX       ; $21 
      008D26 A3 1F                    1 	.word kword_end
                           00001A     2 	END_IDX =TOK_IDX 
                           00001B     3 	TOK_IDX=TOK_IDX+1 
      000036                         83     _code_entry kword_for, FOR_IDX       ; $22
      008D28 A1 CA                    1 	.word kword_for
                           00001B     2 	FOR_IDX =TOK_IDX 
                           00001C     3 	TOK_IDX=TOK_IDX+1 
      000038                         84     _code_entry kword_next, NEXT_IDX     ; $27 
      008D2A A2 1E                    1 	.word kword_next
                           00001C     2 	NEXT_IDX =TOK_IDX 
                           00001D     3 	TOK_IDX=TOK_IDX+1 
      00003A                         85     _code_entry kword_gosub, GOSUB_IDX   ; $23 
      008D2C A2 95                    1 	.word kword_gosub
                           00001D     2 	GOSUB_IDX =TOK_IDX 
                           00001E     3 	TOK_IDX=TOK_IDX+1 
      00003C                         86     _code_entry kword_return, RET_IDX    ; $2A
      008D2E A2 B5                    1 	.word kword_return
                           00001E     2 	RET_IDX =TOK_IDX 
                           00001F     3 	TOK_IDX=TOK_IDX+1 
      00003E                         87     _code_entry kword_goto, GOTO_IDX     ; $24 
      008D30 A2 76                    1 	.word kword_goto
                           00001F     2 	GOTO_IDX =TOK_IDX 
                           000020     3 	TOK_IDX=TOK_IDX+1 
      000040                         88     _code_entry kword_if, IF_IDX         ; $25 
      008D32 A0 E6                    1 	.word kword_if
                           000020     2 	IF_IDX =TOK_IDX 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 41.
Hexadecimal [24-Bits]



                           000021     3 	TOK_IDX=TOK_IDX+1 
      000042                         89     _code_entry syntax_error,THEN_IDX 
      008D34 96 73                    1 	.word syntax_error
                           000021     2 	THEN_IDX =TOK_IDX 
                           000022     3 	TOK_IDX=TOK_IDX+1 
      000044                         90     _code_entry kword_let, LET_IDX       ; $26 
      008D36 9A E5                    1 	.word kword_let
                           000022     2 	LET_IDX =TOK_IDX 
                           000023     3 	TOK_IDX=TOK_IDX+1 
      000046                         91 	_code_entry kword_remark, REM_IDX    ; $29 
      008D38 97 E7                    1 	.word kword_remark
                           000023     2 	REM_IDX =TOK_IDX 
                           000024     3 	TOK_IDX=TOK_IDX+1 
      000048                         92     _code_entry syntax_error, STEP_IDX   ; $2B 
      008D3A 96 73                    1 	.word syntax_error
                           000024     2 	STEP_IDX =TOK_IDX 
                           000025     3 	TOK_IDX=TOK_IDX+1 
      00004A                         93     _code_entry kword_stop, STOP_IDX     ; $2C
      008D3C A3 49                    1 	.word kword_stop
                           000025     2 	STOP_IDX =TOK_IDX 
                           000026     3 	TOK_IDX=TOK_IDX+1 
      00004C                         94     _code_entry kword_con, CON_IDX 
      008D3E A3 94                    1 	.word kword_con
                           000026     2 	CON_IDX =TOK_IDX 
                           000027     3 	TOK_IDX=TOK_IDX+1 
      00004E                         95     _code_entry syntax_error, TO_IDX     ; $2D
      008D40 96 73                    1 	.word syntax_error
                           000027     2 	TO_IDX =TOK_IDX 
                           000028     3 	TOK_IDX=TOK_IDX+1 
                           000027    96     KWORD_LAST=TOK_IDX-1 
                                     97 ; functions
      000050                         98 	_code_entry func_abs, ABS_IDX         ; $41
      008D42 A5 6E                    1 	.word func_abs
                           000028     2 	ABS_IDX =TOK_IDX 
                           000029     3 	TOK_IDX=TOK_IDX+1 
      000052                         99     _code_entry func_peek, PEEK_IDX         ; $4D 
      008D44 A0 D7                    1 	.word func_peek
                           000029     2 	PEEK_IDX =TOK_IDX 
                           00002A     3 	TOK_IDX=TOK_IDX+1 
      000054                        100     _code_entry func_random, RND_IDX        ; $50
      008D46 A5 7E                    1 	.word func_random
                           00002A     2 	RND_IDX =TOK_IDX 
                           00002B     3 	TOK_IDX=TOK_IDX+1 
      000056                        101     _code_entry func_sign, SGN_IDX 
      008D48 A5 9F                    1 	.word func_sign
                           00002B     2 	SGN_IDX =TOK_IDX 
                           00002C     3 	TOK_IDX=TOK_IDX+1 
      000058                        102     _code_entry func_len, LEN_IDX  
      008D4A A5 B7                    1 	.word func_len
                           00002C     2 	LEN_IDX =TOK_IDX 
                           00002D     3 	TOK_IDX=TOK_IDX+1 
      00005A                        103     _code_entry func_ticks, TICKS_IDX 
      008D4C A5 5A                    1 	.word func_ticks
                           00002D     2 	TICKS_IDX =TOK_IDX 
                           00002E     3 	TOK_IDX=TOK_IDX+1 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 42.
Hexadecimal [24-Bits]



      00005C                        104     _code_entry func_char, CHAR_IDX
      008D4E A5 5D                    1 	.word func_char
                           00002E     2 	CHAR_IDX =TOK_IDX 
                           00002F     3 	TOK_IDX=TOK_IDX+1 
      00005E                        105     _code_entry func_key, KEY_IDX  
      008D50 A0 B8                    1 	.word func_key
                           00002F     2 	KEY_IDX =TOK_IDX 
                           000030     3 	TOK_IDX=TOK_IDX+1 
      000060                        106     _code_entry func_chat,CHAT_IDX
      008D52 A8 26                    1 	.word func_chat
                           000030     2 	CHAT_IDX =TOK_IDX 
                           000031     3 	TOK_IDX=TOK_IDX+1 
      000062                        107     _code_entry func_cpos,CPOS_IDX   
      008D54 A8 4B                    1 	.word func_cpos
                           000031     2 	CPOS_IDX =TOK_IDX 
                           000032     3 	TOK_IDX=TOK_IDX+1 
                           000031   108     FUNC_LAST=TOK_IDX-1                     
                                    109 ; commands 
      000064                        110     _code_entry cmd_sleep,SLEEP_IDX 
      008D56 A5 47                    1 	.word cmd_sleep
                           000032     2 	SLEEP_IDX =TOK_IDX 
                           000033     3 	TOK_IDX=TOK_IDX+1 
      000066                        111     _code_entry cmd_tone,TONE_IDX 
      008D58 A3 2B                    1 	.word cmd_tone
                           000033     2 	TONE_IDX =TOK_IDX 
                           000034     3 	TOK_IDX=TOK_IDX+1 
      000068                        112     _code_entry cmd_tab, TAB_IDX 
      008D5A A6 A6                    1 	.word cmd_tab
                           000034     2 	TAB_IDX =TOK_IDX 
                           000035     3 	TOK_IDX=TOK_IDX+1 
      00006A                        113     _code_entry cmd_auto, AUTO_IDX 
      008D5C A6 D2                    1 	.word cmd_auto
                           000035     2 	AUTO_IDX =TOK_IDX 
                           000036     3 	TOK_IDX=TOK_IDX+1 
      00006C                        114     _code_entry cmd_himem, HIMEM_IDX 
      008D5E A7 8F                    1 	.word cmd_himem
                           000036     2 	HIMEM_IDX =TOK_IDX 
                           000037     3 	TOK_IDX=TOK_IDX+1 
      00006E                        115     _code_entry cmd_lomem, LOMEM_IDX 
      008D60 A7 B0                    1 	.word cmd_lomem
                           000037     2 	LOMEM_IDX =TOK_IDX 
                           000038     3 	TOK_IDX=TOK_IDX+1 
      000070                        116     _code_entry cmd_del, DEL_IDX 
      008D62 A7 1E                    1 	.word cmd_del
                           000038     2 	DEL_IDX =TOK_IDX 
                           000039     3 	TOK_IDX=TOK_IDX+1 
      000072                        117     _code_entry cmd_clear, CLR_IDX 
      008D64 A7 0F                    1 	.word cmd_clear
                           000039     2 	CLR_IDX =TOK_IDX 
                           00003A     3 	TOK_IDX=TOK_IDX+1 
      000074                        118     _code_entry cmd_input, INPUT_IDX    ; $6F
      008D66 A0 27                    1 	.word cmd_input
                           00003A     2 	INPUT_IDX =TOK_IDX 
                           00003B     3 	TOK_IDX=TOK_IDX+1 
      000076                        119     _code_entry cmd_list, LIST_IDX          ; $72
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 43.
Hexadecimal [24-Bits]



      008D68 9E 6E                    1 	.word cmd_list
                           00003B     2 	LIST_IDX =TOK_IDX 
                           00003C     3 	TOK_IDX=TOK_IDX+1 
      000078                        120     _code_entry cmd_new, NEW_IDX            ; $73
      008D6A A3 AC                    1 	.word cmd_new
                           00003C     2 	NEW_IDX =TOK_IDX 
                           00003D     3 	TOK_IDX=TOK_IDX+1 
      00007A                        121     _code_entry cmd_call, CALL_IDX          
      008D6C A6 B1                    1 	.word cmd_call
                           00003D     2 	CALL_IDX =TOK_IDX 
                           00003E     3 	TOK_IDX=TOK_IDX+1 
      00007C                        122     _code_entry cmd_poke, POKE_IDX          ; $76
      008D6E A0 C3                    1 	.word cmd_poke
                           00003E     2 	POKE_IDX =TOK_IDX 
                           00003F     3 	TOK_IDX=TOK_IDX+1 
      00007E                        123    	_code_entry cmd_print, PRINT_IDX        ; $77
      008D70 9F 0D                    1 	.word cmd_print
                           00003F     2 	PRINT_IDX =TOK_IDX 
                           000040     3 	TOK_IDX=TOK_IDX+1 
      000080                        124     _code_entry cmd_run, RUN_IDX            ; $7A
      008D72 A2 CE                    1 	.word cmd_run
                           000040     2 	RUN_IDX =TOK_IDX 
                           000041     3 	TOK_IDX=TOK_IDX+1 
      000082                        125     _code_entry cmd_words, WORDS_IDX        ; $85
      008D74 A5 EC                    1 	.word cmd_words
                           000041     2 	WORDS_IDX =TOK_IDX 
                           000042     3 	TOK_IDX=TOK_IDX+1 
      000084                        126     _code_entry cmd_bye, BYE_IDX 
      008D76 A5 36                    1 	.word cmd_bye
                           000042     2 	BYE_IDX =TOK_IDX 
                           000043     3 	TOK_IDX=TOK_IDX+1 
      000086                        127     _code_entry cmd_save, SAVE_IDX 
      008D78 A3 F8                    1 	.word cmd_save
                           000043     2 	SAVE_IDX =TOK_IDX 
                           000044     3 	TOK_IDX=TOK_IDX+1 
      000088                        128     _code_entry cmd_load,LOAD_IDX 
      008D7A A4 8B                    1 	.word cmd_load
                           000044     2 	LOAD_IDX =TOK_IDX 
                           000045     3 	TOK_IDX=TOK_IDX+1 
      00008A                        129     _code_entry cmd_dir, DIR_IDX 
      008D7C A4 CF                    1 	.word cmd_dir
                           000045     2 	DIR_IDX =TOK_IDX 
                           000046     3 	TOK_IDX=TOK_IDX+1 
      00008C                        130     _code_entry cmd_erase, ERASE_IDX 
      008D7E A3 B7                    1 	.word cmd_erase
                           000046     2 	ERASE_IDX =TOK_IDX 
                           000047     3 	TOK_IDX=TOK_IDX+1 
      00008E                        131     _code_entry cmd_randomize, RNDMIZE_IDX
      008D80 A5 96                    1 	.word cmd_randomize
                           000047     2 	RNDMIZE_IDX =TOK_IDX 
                           000048     3 	TOK_IDX=TOK_IDX+1 
      000090                        132     _code_entry cmd_cls, CLS_IDX 
      008D82 A7 FA                    1 	.word cmd_cls
                           000048     2 	CLS_IDX =TOK_IDX 
                           000049     3 	TOK_IDX=TOK_IDX+1 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 44.
Hexadecimal [24-Bits]



      000092                        133     _code_entry cmd_locate,LOCATE_IDX
      008D84 A8 0E                    1 	.word cmd_locate
                           000049     2 	LOCATE_IDX =TOK_IDX 
                           00004A     3 	TOK_IDX=TOK_IDX+1 
      000094                        134     _code_entry cmd_renum,RENUM_IDX 
      008D86 A8 4F                    1 	.word cmd_renum
                           00004A     2 	RENUM_IDX =TOK_IDX 
                           00004B     3 	TOK_IDX=TOK_IDX+1 
      000096                        135     _code_entry kword_do, DO_IDX 
      008D88 A9 71                    1 	.word kword_do
                           00004B     2 	DO_IDX =TOK_IDX 
                           00004C     3 	TOK_IDX=TOK_IDX+1 
      000098                        136     _code_entry kword_until, UNTIL_IDX
      008D8A A9 79                    1 	.word kword_until
                           00004C     2 	UNTIL_IDX =TOK_IDX 
                           00004D     3 	TOK_IDX=TOK_IDX+1 
      00009A                        137     _code_entry func_muldiv, MULDIV_IDX  
      008D8C 99 07                    1 	.word func_muldiv
                           00004D     2 	MULDIV_IDX =TOK_IDX 
                           00004E     3 	TOK_IDX=TOK_IDX+1 
                           00004D   138     CMD_LAST=TOK_IDX-1
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 45.
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
      008D8E                         41 search_lineno::
      008D8E 90 89            [ 2]   42 	pushw y 
      00009E                         43 	_vars VSIZE
      008D90 52 02            [ 2]    1     sub sp,#VSIZE 
      008D92 0F 01            [ 1]   44 	clr (LL,sp)
      008D94 90 CE 00 37      [ 2]   45 	ldw y,lomem
      008D98 4D               [ 1]   46 	tnz a 
      008D99 27 04            [ 1]   47 	jreq 2$
      008D9B 90 CE 00 33      [ 2]   48 	ldw y,line.addr  
      008D9F                         49 2$: 
      008D9F 90 C3 00 3B      [ 2]   50 	cpw y,progend 
      008DA3 2A 10            [ 1]   51 	jrpl 8$ 
      008DA5 90 F3            [ 1]   52 	cpw x,(y)
      008DA7 27 0F            [ 1]   53 	jreq 9$
      008DA9 2B 0A            [ 1]   54 	jrmi 8$ 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 46.
Hexadecimal [24-Bits]



      008DAB 90 E6 02         [ 1]   55 	ld a,(2,y)
      008DAE 6B 02            [ 1]   56 	ld (LB,sp),a 
      008DB0 72 F9 01         [ 2]   57 	addw y,(LL,sp)
      008DB3 20 EA            [ 2]   58 	jra 2$ 
      008DB5                         59 8$: ; not found 
      008DB5 4F               [ 1]   60 	clr a 
      008DB6 20 02            [ 2]   61 	jra 10$
      008DB8                         62 9$: ; found 
      008DB8 A6 FF            [ 1]   63 	ld a,#-1 
      008DBA                         64 10$:
      008DBA 93               [ 1]   65 	ldw x,y   
      0000C9                         66 	_drop VSIZE
      008DBB 5B 02            [ 2]    1     addw sp,#VSIZE 
      008DBD 90 85            [ 2]   67 	popw y 
      008DBF 81               [ 4]   68 	ret 
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
      008DC0                         79 del_line: 
      008DC0 90 89            [ 2]   80 	pushw y 
      0000D0                         81 	_vars VSIZE 
      008DC2 52 04            [ 2]    1     sub sp,#VSIZE 
      008DC4 E6 02            [ 1]   82 	ld a,(2,x) ; line length
      008DC6 6B 02            [ 1]   83 	ld (LLEN+1,sp),a 
      008DC8 0F 01            [ 1]   84 	clr (LLEN,sp)
      008DCA 90 93            [ 1]   85 	ldw y,x  
      008DCC 72 F9 01         [ 2]   86 	addw y,(LLEN,sp) ;SRC  
      008DCF 17 03            [ 2]   87 	ldw (SRC,sp),y  ;save source 
      008DD1 90 CE 00 3B      [ 2]   88 	ldw y,progend 
      008DD5 72 F2 03         [ 2]   89 	subw y,(SRC,sp) ; y=count 
      008DD8 90 CF 00 15      [ 2]   90 	ldw acc16,y 
      008DDC 16 03            [ 2]   91 	ldw y,(SRC,sp)    ; source
      008DDE CD 88 BE         [ 4]   92 	call move
      008DE1 90 CE 00 3B      [ 2]   93 	ldw y,progend  
      008DE5 72 F2 01         [ 2]   94 	subw y,(LLEN,sp)
      008DE8 90 CF 00 3B      [ 2]   95 	ldw progend,y
      008DEC 90 CF 00 3D      [ 2]   96 	ldw dvar_bgn,y 
      008DF0 90 CF 00 3F      [ 2]   97 	ldw dvar_end,y   
      000102                         98 	_drop VSIZE     
      008DF4 5B 04            [ 2]    1     addw sp,#VSIZE 
      008DF6 90 85            [ 2]   99 	popw y 
      008DF8 81               [ 4]  100 	ret 
                                    101 
                                    102 ;---------------------------------------------
                                    103 ; open a gap in text area to 
                                    104 ; move new line in this gap
                                    105 ; input:
                                    106 ;    X 			addr gap start 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 47.
Hexadecimal [24-Bits]



                                    107 ;    Y 			gap length 
                                    108 ; output:
                                    109 ;    X 			addr gap start 
                                    110 ;--------------------------------------------
                           000001   111 	DEST=1
                           000003   112 	SRC=3
                           000005   113 	LEN=5
                           000006   114 	VSIZE=6 
      008DF9                        115 open_gap:
      008DF9 C3 00 3B         [ 2]  116 	cpw x,progend 
      008DFC 24 2F            [ 1]  117 	jruge 9$
      00010C                        118 	_vars VSIZE
      008DFE 52 06            [ 2]    1     sub sp,#VSIZE 
      008E00 1F 03            [ 2]  119 	ldw (SRC,sp),x 
      008E02 17 05            [ 2]  120 	ldw (LEN,sp),y 
      008E04 90 CF 00 15      [ 2]  121 	ldw acc16,y 
      008E08 90 93            [ 1]  122 	ldw y,x ; SRC
      008E0A 72 BB 00 15      [ 2]  123 	addw x,acc16  
      008E0E 1F 01            [ 2]  124 	ldw (DEST,sp),x 
                                    125 ;compute size to move 	
      00011E                        126 	_ldxz progend  
      008E10 BE 3B                    1     .byte 0xbe,progend 
      008E12 72 F0 03         [ 2]  127 	subw x,(SRC,sp)
      008E15 CF 00 15         [ 2]  128 	ldw acc16,x ; size to move
      008E18 1E 01            [ 2]  129 	ldw x,(DEST,sp) 
      008E1A CD 88 BE         [ 4]  130 	call move
      00012B                        131 	_ldxz progend 
      008E1D BE 3B                    1     .byte 0xbe,progend 
      008E1F 72 FB 05         [ 2]  132 	addw x,(LEN,sp)
      008E22 CF 00 3B         [ 2]  133 	ldw progend,x
      008E25 CF 00 3D         [ 2]  134 	ldw dvar_bgn,x 
      008E28 CF 00 3F         [ 2]  135 	ldw dvar_end,x 
      000139                        136 	_drop VSIZE
      008E2B 5B 06            [ 2]    1     addw sp,#VSIZE 
      008E2D 81               [ 4]  137 9$:	ret 
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
      008E2E                        154 insert_line:
      008E2E 90 89            [ 2]  155 	pushw y 
      00013E                        156 	_vars VSIZE 
      008E30 52 08            [ 2]    1     sub sp,#VSIZE 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 48.
Hexadecimal [24-Bits]



      008E32 72 CE 00 0F      [ 5]  157 	ldw x,[ptr16]
      008E36 1F 05            [ 2]  158 	ldw (LINENO,sp),x 
      008E38 0F 07            [ 1]  159 	clr (LLEN,sp)
      000148                        160 	_ldxz ptr16 
      008E3A BE 0F                    1     .byte 0xbe,ptr16 
      008E3C E6 02            [ 1]  161 	ld a,(2,x)
      008E3E 6B 08            [ 1]  162 	ld (LLEN+1,sp),a 
      008E40 4F               [ 1]  163 	clr a 
      008E41 1E 05            [ 2]  164 	ldw x,(LINENO,sp)
      008E43 CD 8D 8E         [ 4]  165 	call search_lineno
      008E46 1F 01            [ 2]  166 	ldw (DEST,sp),x 
      008E48 4D               [ 1]  167 	tnz a 
      008E49 27 03            [ 1]  168 	jreq 1$ ; not found 
      008E4B CD 8D C0         [ 4]  169 	call del_line 
      008E4E A6 04            [ 1]  170 1$: ld a,#4 
      008E50 11 08            [ 1]  171 	cp a,(LLEN+1,sp)
      008E52 27 3D            [ 1]  172 	jreq 9$
                                    173 ; check for space 
      000162                        174 	_ldxz progend  
      008E54 BE 3B                    1     .byte 0xbe,progend 
      008E56 72 FB 07         [ 2]  175 	addw x,(LLEN,sp)
      008E59 A3 16 80         [ 2]  176 	cpw x,#tib   
      008E5C 25 08            [ 1]  177 	jrult 3$
      008E5E AE 95 F4         [ 2]  178 	ldw x,#err_mem_full 
      008E61 CC 96 75         [ 2]  179 	jp tb_error 
      008E64 20 2B            [ 2]  180 	jra 9$  
      008E66                        181 3$: ; create gap to insert line 
      008E66 1E 01            [ 2]  182 	ldw x,(DEST,sp) 
      008E68 16 07            [ 2]  183 	ldw y,(LLEN,sp)
      008E6A CD 8D F9         [ 4]  184 	call open_gap 
                                    185 ; move new line in gap 
      008E6D 1E 07            [ 2]  186 	ldw x,(LLEN,sp)
      008E6F CF 00 15         [ 2]  187 	ldw acc16,x 
      008E72 90 AE 17 00      [ 2]  188 	ldw y,#pad ;SRC 
      008E76 1E 01            [ 2]  189 	ldw x,(DEST,sp) ; dest address 
      008E78 CD 88 BE         [ 4]  190 	call move
      008E7B 1E 01            [ 2]  191 	ldw x,(DEST,sp)
      008E7D C3 00 3B         [ 2]  192 	cpw x,progend 
      008E80 25 0F            [ 1]  193 	jrult 9$ 
      008E82 1E 07            [ 2]  194 	ldw x,(LLEN,sp)
      008E84 72 BB 00 3B      [ 2]  195 	addw x,progend 
      008E88 CF 00 3B         [ 2]  196 	ldw progend,x 
      008E8B CF 00 3D         [ 2]  197 	ldw dvar_bgn,x 
      008E8E CF 00 3F         [ 2]  198 	ldw dvar_end,x 
      008E91                        199 9$:	
      00019F                        200 	_drop VSIZE
      008E91 5B 08            [ 2]    1     addw sp,#VSIZE 
      008E93 90 85            [ 2]  201 	popw y 
      008E95 81               [ 4]  202 	ret
                                    203 
                                    204 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    205 ;; compiler routines        ;;
                                    206 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    207 ;------------------------------------
                                    208 ; parse quoted string 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 49.
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
      008E96                        218 parse_quote: 
      0001A4                        219 	_vars VSIZE
      008E96 52 02            [ 2]    1     sub sp,#VSIZE 
      0001A6                        220 	_push_op  
      0001A6                          1     _decz psp+1
      008E98 3A 4B                    1     .byte 0x3a,psp+1 
      008E9A 72 C7 00 4A      [ 4]    2     ld [psp],a 
      008E9E 4F               [ 1]  221 	clr a
      008E9F 6B 01            [ 1]  222 1$:	ld (PREV,sp),a 
      008EA1                        223 2$:	
      008EA1 91 D6 30         [ 4]  224 	ld a,([in.w],y)
      008EA4 27 28            [ 1]  225 	jreq 6$
      0001B4                        226 	_incz in 
      008EA6 3C 31                    1     .byte 0x3c, in 
      008EA8 6B 02            [ 1]  227 	ld (CURR,sp),a 
      008EAA A6 5C            [ 1]  228 	ld a,#'\
      008EAC 11 01            [ 1]  229 	cp a, (PREV,sp)
      008EAE 26 0A            [ 1]  230 	jrne 3$
      008EB0 0F 01            [ 1]  231 	clr (PREV,sp)
      008EB2 7B 02            [ 1]  232 	ld a,(CURR,sp)
      008EB4 AD 22            [ 4]  233 	callr convert_escape
      008EB6 F7               [ 1]  234 	ld (x),a 
      008EB7 5C               [ 1]  235 	incw x 
      008EB8 20 E7            [ 2]  236 	jra 2$
      008EBA                        237 3$:
      008EBA 7B 02            [ 1]  238 	ld a,(CURR,sp)
      008EBC A1 5C            [ 1]  239 	cp a,#'\'
      008EBE 27 DF            [ 1]  240 	jreq 1$
      008EC0 A1 22            [ 1]  241 	cp a,#'"
      008EC2 27 04            [ 1]  242 	jreq 5$ 
      008EC4 F7               [ 1]  243 	ld (x),a 
      008EC5 5C               [ 1]  244 	incw x 
      008EC6 20 D9            [ 2]  245 	jra 2$
      0001D6                        246 5$: _pop_op 	
      008EC8 72 C6 00 4A      [ 4]    1     ld a,[psp]
      0001DA                          2     _incz psp+1 
      008ECC 3C 4B                    1     .byte 0x3c, psp+1 
      008ECE                        247 6$: 
      008ECE 7F               [ 1]  248 	clr (x)
      008ECF 5C               [ 1]  249 	incw x 
      008ED0 90 93            [ 1]  250 	ldw y,x 
      008ED2 5F               [ 1]  251 	clrw x 
      008ED3 A6 06            [ 1]  252 	ld a,#QUOTE_IDX  
      0001E3                        253 	_drop VSIZE
      008ED5 5B 02            [ 2]    1     addw sp,#VSIZE 
      008ED7 81               [ 4]  254 	ret 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 50.
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
      008ED8                        265 convert_escape:
      008ED8 89               [ 2]  266 	pushw x 
      008ED9 AE 8E ED         [ 2]  267 	ldw x,#escaped 
      008EDC F1               [ 1]  268 1$:	cp a,(x)
      008EDD 27 06            [ 1]  269 	jreq 2$
      008EDF 7D               [ 1]  270 	tnz (x)
      008EE0 27 09            [ 1]  271 	jreq 3$
      008EE2 5C               [ 1]  272 	incw x 
      008EE3 20 F7            [ 2]  273 	jra 1$
      008EE5 1D 8E ED         [ 2]  274 2$: subw x,#escaped 
      008EE8 9F               [ 1]  275 	ld a,xl 
      008EE9 AB 07            [ 1]  276 	add a,#7
      008EEB 85               [ 2]  277 3$:	popw x 
      008EEC 81               [ 4]  278 	ret 
                                    279 
      008EED 61 62 74 6E 76 66 72   280 escaped:: .asciz "abtnvfr"
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
      008EF5                        295 parse_integer: ; { -- n }
      008EF5 89               [ 2]  296 	pushw x 
      008EF6 72 B9 00 30      [ 2]  297 	addw y,in.w
      008EFA 90 5A            [ 2]  298 	decw y   
      008EFC CD 98 59         [ 4]  299 	call atoi16 
      008EFF 72 A2 16 80      [ 2]  300 	subw y,#tib 
      008F03 90 CF 00 30      [ 2]  301 	ldw in.w,y
      008F07 90 85            [ 2]  302 	popw y  
      008F09 81               [ 4]  303 	ret
                                    304 
                                    305 ;-------------------------------------
                                    306 ; input:
                                    307 ;   X  int16  
                                    308 ;   Y    pad[n]
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 51.
Hexadecimal [24-Bits]



                                    309 ; output:
                                    310 ;    pad   LITW_IDX,word  
                                    311 ;    y     &pad[n+3]
                                    312 ;------------------------------------
      008F0A                        313 compile_integer:
      008F0A A6 08            [ 1]  314 	ld a,#LITW_IDX 
      008F0C 90 F7            [ 1]  315 	ld (y),a
      008F0E 90 5C            [ 1]  316 	incw y 
      008F10 90 FF            [ 2]  317 	LDW (Y),x 
      008F12 72 A9 00 02      [ 2]  318 	addw y,#2
      008F16 81               [ 4]  319 	ret
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
      008F17                        335 parse_symbol:
      000225                        336 	_vars VSIZE 
      008F17 52 02            [ 2]    1     sub sp,#VSIZE 
      008F19 1C 00 01         [ 2]  337 	addw x,#1 ; keep space for token identifier
      008F1C 1F 01            [ 2]  338 	ldw (FIRST_CHAR,sp),x  
      008F1E                        339 symb_loop: 
      008F1E CD 89 02         [ 4]  340 	call to_upper 
      008F21 F7               [ 1]  341 	ld (x), a 
      008F22 5C               [ 1]  342 	incw x
      008F23 91 D6 30         [ 4]  343 	ld a,([in.w],y)
      000234                        344 	_incz in 
      008F26 3C 31                    1     .byte 0x3c, in 
      008F28 A1 24            [ 1]  345 	cp a,#'$ 
      008F2A 27 05            [ 1]  346 	jreq 2$ ; string variable: LETTER+'$'  
      008F2C CD 89 1E         [ 4]  347 	call is_digit ;
      008F2F 24 04            [ 1]  348 	jrnc 3$ ; integer variable LETTER+DIGIT 
      008F31                        349 2$:
      008F31 F7               [ 1]  350 	ld (x),a 
      008F32 5C               [ 1]  351 	incw x 
      008F33 20 07            [ 2]  352 	jra 4$
      008F35                        353 3$:
      008F35 CD 89 0D         [ 4]  354 	call is_alpha  
      008F38 25 E4            [ 1]  355 	jrc symb_loop 
      000248                        356 	_decz in
      008F3A 3A 31                    1     .byte 0x3a,in 
      008F3C                        357 4$:
      008F3C 7F               [ 1]  358 	clr (x)
      008F3D 72 F0 01         [ 2]  359 	subw x,(FIRST_CHAR,sp)
      008F40 9F               [ 1]  360 	ld a,xl
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 52.
Hexadecimal [24-Bits]



      00024F                        361 	_drop VSIZE 
      008F41 5B 02            [ 2]    1     addw sp,#VSIZE 
      008F43 81               [ 4]  362 	ret 
                                    363 
                                    364 ;---------------------------------
                                    365 ; some syntax checking 
                                    366 ; can be done at compile time
                                    367 ; matching '(' and ')' 
                                    368 ; FOR TO STEP must be on same line 
                                    369 ; same for IF THEN 
                                    370 ;--------------------------------
      008F44                        371 check_syntax:
      008F44 A1 05            [ 1]  372 	cp a,#RPAREN_IDX
      008F46 26 0D            [ 1]  373 	jrne 0$
      000256                        374 	_pop_op 
      008F48 72 C6 00 4A      [ 4]    1     ld a,[psp]
      00025A                          2     _incz psp+1 
      008F4C 3C 4B                    1     .byte 0x3c, psp+1 
      008F4E A1 04            [ 1]  375 	cp a,#LPAREN_IDX 
      008F50 27 48            [ 1]  376 	jreq 9$ 
      008F52 CC 96 73         [ 2]  377 	jp syntax_error 
      008F55                        378 0$: 
      008F55 A1 20            [ 1]  379 	cp a,#IF_IDX 
      008F57 27 42            [ 1]  380 	jreq push_it 
      008F59 A1 1B            [ 1]  381 	cp a,#FOR_IDX 
      008F5B 27 3E            [ 1]  382 	jreq push_it 
      008F5D A1 21            [ 1]  383 	cp a,#THEN_IDX 
      008F5F 26 0D            [ 1]  384 	jrne 1$
      00026F                        385 	_pop_op 
      008F61 72 C6 00 4A      [ 4]    1     ld a,[psp]
      000273                          2     _incz psp+1 
      008F65 3C 4B                    1     .byte 0x3c, psp+1 
      008F67 A1 20            [ 1]  386 	cp a,#IF_IDX 
      008F69 27 2F            [ 1]  387 	jreq 9$ 
      008F6B CC 96 73         [ 2]  388 	jp syntax_error 
      008F6E                        389 1$: 
      008F6E A1 27            [ 1]  390 	cp a,#TO_IDX 
      008F70 26 17            [ 1]  391 	jrne 3$ 
      000280                        392 	_pop_op 
      008F72 72 C6 00 4A      [ 4]    1     ld a,[psp]
      000284                          2     _incz psp+1 
      008F76 3C 4B                    1     .byte 0x3c, psp+1 
      008F78 A1 1B            [ 1]  393 	cp a,#FOR_IDX 
      008F7A 27 03            [ 1]  394 	jreq 2$ 
      008F7C CC 96 73         [ 2]  395 	jp syntax_error 
      008F7F A6 27            [ 1]  396 2$: ld a,#TO_IDX 
      00028F                        397 	_push_op 
      00028F                          1     _decz psp+1
      008F81 3A 4B                    1     .byte 0x3a,psp+1 
      008F83 72 C7 00 4A      [ 4]    2     ld [psp],a 
      008F87 20 11            [ 2]  398 	jra 9$ 
      008F89 A1 24            [ 1]  399 3$: cp a,#STEP_IDX 
      008F8B 26 0D            [ 1]  400 	jrne 9$ 
      00029B                        401 	_pop_op 
      008F8D 72 C6 00 4A      [ 4]    1     ld a,[psp]
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 53.
Hexadecimal [24-Bits]



      00029F                          2     _incz psp+1 
      008F91 3C 4B                    1     .byte 0x3c, psp+1 
      008F93 A1 27            [ 1]  402 	cp a,#TO_IDX 
      008F95 27 03            [ 1]  403 	jreq 9$ 
      008F97 CC 96 73         [ 2]  404 	jp syntax_error 
      008F9A                        405 9$:	
      008F9A 81               [ 4]  406 	ret 
      008F9B                        407 push_it:
      0002A9                        408 	_push_op 
      0002A9                          1     _decz psp+1
      008F9B 3A 4B                    1     .byte 0x3a,psp+1 
      008F9D 72 C7 00 4A      [ 4]    2     ld [psp],a 
      008FA1 81               [ 4]  409 	ret 
                                    410 
                                    411 ;---------------------------
                                    412 ;  token begin with a letter,
                                    413 ;  is keyword or variable. 	
                                    414 ; input:
                                    415 ;   X 		point to pad 
                                    416 ;   Y 		point to text
                                    417 ;   A 	    first letter  
                                    418 ; output:
                                    419 ;   Y		point in pad after token  
                                    420 ;   A 		token identifier
                                    421 ;   pad 	keyword|var_name  
                                    422 ;--------------------------  
                           000001   423 	TOK_POS=1
                           000003   424 	NLEN=TOK_POS+2
                           000003   425 	VSIZE=NLEN 
      008FA2                        426 parse_keyword:
      0002B0                        427 	_vars VSIZE 
      008FA2 52 03            [ 2]    1     sub sp,#VSIZE 
      008FA4 0F 03            [ 1]  428 	clr (NLEN,sp)
      008FA6 1F 01            [ 2]  429 	ldw (TOK_POS,sp),x  ; where TOK_IDX should be put 
      008FA8 CD 8F 17         [ 4]  430 	call parse_symbol
      008FAB 6B 03            [ 1]  431 	ld (NLEN,sp),a 
      008FAD A1 01            [ 1]  432 	cp a,#1
      008FAF 27 30            [ 1]  433 	jreq 3$  
                                    434  ; check in dictionary, if not found must be variable name.
      0002BF                        435 	_ldx_dict kword_dict ; dictionary entry point
      008FB1 AE AB 88         [ 2]    1         ldw x,#kword_dict+2
      008FB4 16 01            [ 2]  436 	ldw y,(TOK_POS,sp) ; name to search for
      008FB6 72 A9 00 01      [ 2]  437 	addw y,#1 ; name first character 
      008FBA CD 98 A1         [ 4]  438 	call search_dict
      008FBD A1 FF            [ 1]  439 	cp a,#NONE_IDX 
      008FBF 26 2C            [ 1]  440 	jrne 6$
                                    441 ; not in dictionary
                                    442 ; either LETTER+'$' || LETTER+DIGIT 
      008FC1 A6 02            [ 1]  443 	ld a,#2 
      008FC3 11 03            [ 1]  444 	cp a,(NLEN,sp)
      008FC5 27 03            [ 1]  445 	jreq 1$ 
      008FC7 CC 96 73         [ 2]  446     jp syntax_error 	
      008FCA                        447 1$: ; 2 letters variables 
      008FCA 16 01            [ 2]  448 	ldw y,(TOK_POS,sp)
      008FCC 93               [ 1]  449 	ldw x,y 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 54.
Hexadecimal [24-Bits]



      008FCD 1C 00 02         [ 2]  450 	addw x,#2 
      008FD0 F6               [ 1]  451 	ld a,(x)
      008FD1 A1 24            [ 1]  452 	cp a,#'$ 
      008FD3 26 04            [ 1]  453 	jrne 2$ 
      008FD5 A6 0A            [ 1]  454 	ld a,#STR_VAR_IDX
      008FD7 20 0C            [ 2]  455 	jra 5$
      008FD9 CD 89 1E         [ 4]  456 2$:	call is_digit 
      008FDC 25 05            [ 1]  457 	jrc 4$ ; LETTER+DIGIT 
      008FDE CC 96 73         [ 2]  458 	jp syntax_error 
      008FE1                        459 3$:
                                    460 ; one letter symbol is integer variable name 
                                    461 ; tokenize as: VAR_IDX,LETTER,NUL  
      008FE1 16 01            [ 2]  462 	ldw y,(TOK_POS,sp)
      008FE3                        463 4$:	
      008FE3 A6 09            [ 1]  464 	ld a,#VAR_IDX 
      008FE5                        465 5$:
      008FE5 90 F7            [ 1]  466 	ld (y),a
      008FE7 72 A9 00 03      [ 2]  467 	addw y,#3
      008FEB 20 09            [ 2]  468 	jra 9$
      008FED                        469 6$:	; word in dictionary 
      008FED 16 01            [ 2]  470 	ldw y,(TOK_POS,sp)
      008FEF 90 F7            [ 1]  471 	ld (y),a ; compile token 
      008FF1 90 5C            [ 1]  472 	incw y
      008FF3 CD 8F 44         [ 4]  473 	call check_syntax  
      000304                        474 9$:	_drop VSIZE 
      008FF6 5B 03            [ 2]    1     addw sp,#VSIZE 
      008FF8 81               [ 4]  475 	ret  	
                                    476 
                                    477 ;------------------------------------
                                    478 ; skip character c in text starting from 'in'
                                    479 ; input:
                                    480 ;	 y 		point to text buffer
                                    481 ;    a 		character to skip
                                    482 ; output:  
                                    483 ;	'in' ajusted to new position
                                    484 ;------------------------------------
                           000001   485 	C = 1 ; local var
      008FF9                        486 skip:
      008FF9 88               [ 1]  487 	push a
      008FFA 91 D6 30         [ 4]  488 1$:	ld a,([in.w],y)
      008FFD 27 08            [ 1]  489 	jreq 2$
      008FFF 11 01            [ 1]  490 	cp a,(C,sp)
      009001 26 04            [ 1]  491 	jrne 2$
      000311                        492 	_incz in
      009003 3C 31                    1     .byte 0x3c, in 
      009005 20 F3            [ 2]  493 	jra 1$
      000315                        494 2$: _drop 1 
      009007 5B 01            [ 2]    1     addw sp,#1 
      009009 81               [ 4]  495 	ret
                                    496 	
                                    497 
                                    498 ;------------------------------------
                                    499 ; scan text for next lexeme
                                    500 ; compile its TOKEN_IDX and value
                                    501 ; in output buffer.  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 55.
Hexadecimal [24-Bits]



                                    502 ; update input and output pointers 
                                    503 ; input: 
                                    504 ;	X 		pointer to buffer where 
                                    505 ;	        token idx and value are compiled 
                                    506 ; use:
                                    507 ;	Y       pointer to text in tib 
                                    508 ;   in.w    offset in tib, i.e. tib[in.w]
                                    509 ; output:
                                    510 ;   A       token index  
                                    511 ;   Y       updated position in output buffer   
                                    512 ;------------------------------------
                                    513 	; use to check special character 
                                    514 	.macro _case c t  
                                    515 	ld a,#c 
                                    516 	cp a,(TCHAR,sp) 
                                    517 	jrne t
                                    518 	.endm 
                                    519 	
                                    520 ; local variables 
                           000001   521 	TCHAR=1 ; parsed character 
                           000002   522 	ATTRIB=2 ; token value  
                           000002   523 	VSIZE=2
      00900A                        524 parse_lexeme:
      000318                        525 	_vars VSIZE
      00900A 52 02            [ 2]    1     sub sp,#VSIZE 
      00900C 90 AE 16 80      [ 2]  526 	ldw y,#tib    	
      009010 A6 20            [ 1]  527 	ld a,#SPACE
      009012 CD 8F F9         [ 4]  528 	call skip
      009015 91 D6 30         [ 4]  529 	ld a,([in.w],y)
      009018 26 05            [ 1]  530 	jrne 1$
      00901A 90 93            [ 1]  531 	ldw y,x 
      00901C CC 91 9F         [ 2]  532 	jp token_exit ; end of line 
      00032D                        533 1$:	_incz in 
      00901F 3C 31                    1     .byte 0x3c, in 
      009021 6B 01            [ 1]  534 	ld (TCHAR,sp),a ; first char of lexeme 
                                    535 ; check for quoted string
      009023                        536 str_tst:  	
      000331                        537 	_case '"' nbr_tst
      009023 A6 22            [ 1]    1 	ld a,#'"' 
      009025 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      009027 26 0C            [ 1]    3 	jrne nbr_tst
      009029 A6 06            [ 1]  538 	ld a,#QUOTE_IDX
      00902B 88               [ 1]  539 	push a 
      00902C F7               [ 1]  540 	ld (x),a ; compile TOKEN INDEX 
      00902D 5C               [ 1]  541 	incw x 
      00902E CD 8E 96         [ 4]  542 	call parse_quote ; compile quoted string 
      009031 84               [ 1]  543 	pop a 
      009032 CC 91 9F         [ 2]  544 	jp token_exit
      009035                        545 nbr_tst:
                                    546 ; check for hexadecimal number 
      000343                        547 	_case '$' digit_test 
      009035 A6 24            [ 1]    1 	ld a,#'$' 
      009037 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      009039 26 02            [ 1]    3 	jrne digit_test
      00903B 20 07            [ 2]  548 	jra integer 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 56.
Hexadecimal [24-Bits]



                                    549 ; check for decimal number 	
      00903D                        550 digit_test: 
      00903D 7B 01            [ 1]  551 	ld a,(TCHAR,sp)
      00903F CD 89 1E         [ 4]  552 	call is_digit
      009042 24 09            [ 1]  553 	jrnc other_tests
      009044                        554 integer: 
      009044 CD 8E F5         [ 4]  555 	call parse_integer 
      009047 CD 8F 0A         [ 4]  556 	call compile_integer
      00904A CC 91 9F         [ 2]  557 	jp token_exit 
      00904D                        558 other_tests: 
      00035B                        559 	_case '(' bkslsh_tst 
      00904D A6 28            [ 1]    1 	ld a,#'(' 
      00904F 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      009051 26 0B            [ 1]    3 	jrne bkslsh_tst
      009053 A6 04            [ 1]  560 	ld a,#LPAREN_IDX 
      000363                        561 	_push_op 
      000363                          1     _decz psp+1
      009055 3A 4B                    1     .byte 0x3a,psp+1 
      009057 72 C7 00 4A      [ 4]    2     ld [psp],a 
      00905B CC 91 9B         [ 2]  562 	jp token_char   	
      00905E                        563 bkslsh_tst: ; character token 
      00036C                        564 	_case '\',rparnt_tst
      00905E A6 5C            [ 1]    1 	ld a,#'\' 
      009060 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      009062 26 12            [ 1]    3 	jrne rparnt_tst
      009064 A6 07            [ 1]  565 	ld a,#LITC_IDX 
      009066 F7               [ 1]  566 	ld (x),a 
      009067 88               [ 1]  567 	push a 
      009068 5C               [ 1]  568 	incw x 
      009069 91 D6 30         [ 4]  569 	ld a,([in.w],y)
      00037A                        570 	_incz in  
      00906C 3C 31                    1     .byte 0x3c, in 
      00906E F7               [ 1]  571 	ld (x),a 
      00906F 5C               [ 1]  572 	incw x
      009070 90 93            [ 1]  573 	ldw y,x 
      009072 84               [ 1]  574 	pop a 	 
      009073 CC 91 9F         [ 2]  575 	jp token_exit
      009076                        576 rparnt_tst:		
      000384                        577 	_case ')' colon_tst 
      009076 A6 29            [ 1]    1 	ld a,#')' 
      009078 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      00907A 26 0A            [ 1]    3 	jrne colon_tst
      00907C A6 05            [ 1]  578 	ld a,#RPAREN_IDX  
      00907E CD 8F 44         [ 4]  579 	call check_syntax 
      009081 A6 05            [ 1]  580 	ld a,#RPAREN_IDX
      009083 CC 91 9B         [ 2]  581 	jp token_char
      009086                        582 colon_tst:
      000394                        583 	_case ':' comma_tst 
      009086 A6 3A            [ 1]    1 	ld a,#':' 
      009088 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      00908A 26 05            [ 1]    3 	jrne comma_tst
      00908C A6 01            [ 1]  584 	ld a,#COLON_IDX  
      00908E CC 91 9B         [ 2]  585 	jp token_char  
      009091                        586 comma_tst:
      00039F                        587 	_case COMMA semic_tst 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 57.
Hexadecimal [24-Bits]



      009091 A6 2C            [ 1]    1 	ld a,#COMMA 
      009093 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      009095 26 05            [ 1]    3 	jrne semic_tst
      009097 A6 02            [ 1]  588 	ld a,#COMMA_IDX 
      009099 CC 91 9B         [ 2]  589 	jp token_char
      00909C                        590 semic_tst:
      0003AA                        591 	_case SEMIC dash_tst
      00909C A6 3B            [ 1]    1 	ld a,#SEMIC 
      00909E 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      0090A0 26 05            [ 1]    3 	jrne dash_tst
      0090A2 A6 03            [ 1]  592 	ld a,#SCOL_IDX  
      0090A4 CC 91 9B         [ 2]  593 	jp token_char 	
      0090A7                        594 dash_tst: 	
      0003B5                        595 	_case '-' sharp_tst 
      0090A7 A6 2D            [ 1]    1 	ld a,#'-' 
      0090A9 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      0090AB 26 05            [ 1]    3 	jrne sharp_tst
      0090AD A6 0C            [ 1]  596 	ld a,#SUB_IDX  
      0090AF CC 91 9B         [ 2]  597 	jp token_char 
      0090B2                        598 sharp_tst:
      0003C0                        599 	_case '#' qmark_tst 
      0090B2 A6 23            [ 1]    1 	ld a,#'#' 
      0090B4 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      0090B6 26 05            [ 1]    3 	jrne qmark_tst
      0090B8 A6 15            [ 1]  600 	ld a,#REL_NE_IDX  
      0090BA CC 91 9B         [ 2]  601 	jp token_char
      0090BD                        602 qmark_tst:
      0003CB                        603 	_case '?' tick_tst 
      0090BD A6 3F            [ 1]    1 	ld a,#'?' 
      0090BF 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      0090C1 26 09            [ 1]    3 	jrne tick_tst
      0090C3 A6 3F            [ 1]  604 	ld a,#PRINT_IDX   
      0090C5 F7               [ 1]  605 	ld (x),a 
      0090C6 5C               [ 1]  606 	incw x 
      0090C7 90 93            [ 1]  607 	ldw y,x 
      0090C9 CC 91 9F         [ 2]  608 	jp token_exit
      0090CC                        609 tick_tst: ; comment 
      0003DA                        610 	_case TICK plus_tst 
      0090CC A6 27            [ 1]    1 	ld a,#TICK 
      0090CE 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      0090D0 26 2F            [ 1]    3 	jrne plus_tst
      0090D2 A6 23            [ 1]  611 	ld a,#REM_IDX 
      0090D4 F7               [ 1]  612 	ld (x),a 
      0090D5 5C               [ 1]  613 	incw x
      0090D6                        614 copy_comment:
      0090D6 90 AE 16 80      [ 2]  615 	ldw y,#tib 
      0090DA 72 B9 00 30      [ 2]  616 	addw y,in.w
      0090DE 90 89            [ 2]  617 	pushw y 
      0090E0 CD 88 AE         [ 4]  618 	call strcpy
      0090E3 72 F2 01         [ 2]  619 	subw y,(1,sp)
      0090E6 90 5C            [ 1]  620 	incw y ; strlen+1
      0090E8 90 89            [ 2]  621 	pushw y  
      0090EA 72 FB 01         [ 2]  622 	addw x,(1,sp) 
      0090ED 90 93            [ 1]  623 	ldw y,x 
      0090EF 85               [ 2]  624 	popw x 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 58.
Hexadecimal [24-Bits]



      0090F0 72 FB 01         [ 2]  625 	addw x,(1,sp)
      0090F3 5A               [ 2]  626 	decw x 
      0090F4 1D 16 80         [ 2]  627 	subw x,#tib 
      0090F7 CF 00 30         [ 2]  628 	ldw in.w,x 
      000408                        629 	_drop 2 
      0090FA 5B 02            [ 2]    1     addw sp,#2 
      0090FC A6 23            [ 1]  630 	ld a,#REM_IDX
      0090FE CC 91 9F         [ 2]  631 	jp token_exit 
      009101                        632 plus_tst:
      00040F                        633 	_case '+' star_tst 
      009101 A6 2B            [ 1]    1 	ld a,#'+' 
      009103 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      009105 26 05            [ 1]    3 	jrne star_tst
      009107 A6 0B            [ 1]  634 	ld a,#ADD_IDX  
      009109 CC 91 9B         [ 2]  635 	jp token_char 
      00910C                        636 star_tst:
      00041A                        637 	_case '*' slash_tst 
      00910C A6 2A            [ 1]    1 	ld a,#'*' 
      00910E 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      009110 26 05            [ 1]    3 	jrne slash_tst
      009112 A6 0F            [ 1]  638 	ld a,#MULT_IDX  
      009114 CC 91 9B         [ 2]  639 	jp token_char 
      009117                        640 slash_tst: 
      000425                        641 	_case '/' prcnt_tst 
      009117 A6 2F            [ 1]    1 	ld a,#'/' 
      009119 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      00911B 26 05            [ 1]    3 	jrne prcnt_tst
      00911D A6 0D            [ 1]  642 	ld a,#DIV_IDX  
      00911F CC 91 9B         [ 2]  643 	jp token_char 
      009122                        644 prcnt_tst:
      000430                        645 	_case '%' eql_tst 
      009122 A6 25            [ 1]    1 	ld a,#'%' 
      009124 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      009126 26 05            [ 1]    3 	jrne eql_tst
      009128 A6 0E            [ 1]  646 	ld a,#MOD_IDX 
      00912A CC 91 9B         [ 2]  647 	jp token_char  
                                    648 ; 1 or 2 character tokens 	
      00912D                        649 eql_tst:
      00043B                        650 	_case '=' gt_tst 		
      00912D A6 3D            [ 1]    1 	ld a,#'=' 
      00912F 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      009131 26 05            [ 1]    3 	jrne gt_tst
      009133 A6 11            [ 1]  651 	ld a,#REL_EQU_IDX 
      009135 CC 91 9B         [ 2]  652 	jp token_char 
      009138                        653 gt_tst:
      000446                        654 	_case '>' lt_tst 
      009138 A6 3E            [ 1]    1 	ld a,#'>' 
      00913A 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      00913C 26 21            [ 1]    3 	jrne lt_tst
      00913E A6 14            [ 1]  655 	ld a,#REL_GT_IDX 
      009140 6B 02            [ 1]  656 	ld (ATTRIB,sp),a 
      009142 91 D6 30         [ 4]  657 	ld a,([in.w],y)
      000453                        658 	_incz in 
      009145 3C 31                    1     .byte 0x3c, in 
      009147 A1 3D            [ 1]  659 	cp a,#'=
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 59.
Hexadecimal [24-Bits]



      009149 26 04            [ 1]  660 	jrne 1$
      00914B A6 12            [ 1]  661 	ld a,#REL_GE_IDX  
      00914D 20 4C            [ 2]  662 	jra token_char  
      00914F A1 3C            [ 1]  663 1$: cp a,#'<
      009151 26 04            [ 1]  664 	jrne 2$
      009153 A6 15            [ 1]  665 	ld a,#REL_NE_IDX  
      009155 20 44            [ 2]  666 	jra token_char 
      009157 72 5A 00 31      [ 1]  667 2$: dec in
      00915B 7B 02            [ 1]  668 	ld a,(ATTRIB,sp)
      00915D 20 3C            [ 2]  669 	jra token_char 	 
      00915F                        670 lt_tst:
      00046D                        671 	_case '<' other
      00915F A6 3C            [ 1]    1 	ld a,#'<' 
      009161 11 01            [ 1]    2 	cp a,(TCHAR,sp) 
      009163 26 21            [ 1]    3 	jrne other
      009165 A6 13            [ 1]  672 	ld a,#REL_LT_IDX  
      009167 6B 02            [ 1]  673 	ld (ATTRIB,sp),a 
      009169 91 D6 30         [ 4]  674 	ld a,([in.w],y)
      00047A                        675 	_incz in 
      00916C 3C 31                    1     .byte 0x3c, in 
      00916E A1 3D            [ 1]  676 	cp a,#'=
      009170 26 04            [ 1]  677 	jrne 1$
      009172 A6 10            [ 1]  678 	ld a,#REL_LE_IDX 
      009174 20 25            [ 2]  679 	jra token_char 
      009176 A1 3E            [ 1]  680 1$: cp a,#'>
      009178 26 04            [ 1]  681 	jrne 2$
      00917A A6 15            [ 1]  682 	ld a,#REL_NE_IDX  
      00917C 20 1D            [ 2]  683 	jra token_char 
      00917E 72 5A 00 31      [ 1]  684 2$: dec in 
      009182 7B 02            [ 1]  685 	ld a,(ATTRIB,sp)
      009184 20 15            [ 2]  686 	jra token_char 	
      009186                        687 other: ; not a special character 	 
      009186 7B 01            [ 1]  688 	ld a,(TCHAR,sp)
      009188 CD 89 0D         [ 4]  689 	call is_alpha 
      00918B 25 03            [ 1]  690 	jrc 30$ 
      00918D CC 96 73         [ 2]  691 	jp syntax_error 
      009190                        692 30$: 
      009190 CD 8F A2         [ 4]  693 	call parse_keyword
      009193 A1 23            [ 1]  694 	cp a,#REM_IDX  
      009195 26 08            [ 1]  695 	jrne token_exit   
      009197 93               [ 1]  696 	ldw x,y 
      009198 CC 90 D6         [ 2]  697 	jp copy_comment
      00919B                        698 token_char:
      00919B F7               [ 1]  699 	ld (x),a 
      00919C 5C               [ 1]  700 	incw x
      00919D 90 93            [ 1]  701 	ldw y,x 
      00919F                        702 token_exit:
      0004AD                        703 	_drop VSIZE 
      00919F 5B 02            [ 2]    1     addw sp,#VSIZE 
      0091A1 81               [ 4]  704 	ret
                                    705 
                                    706 
                                    707 ;-----------------------------------
                                    708 ; create token list fromm text line 
                                    709 ; save this list in pad buffer 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 60.
Hexadecimal [24-Bits]



                                    710 ;  compiled line format: 
                                    711 ;    line_no  2 bytes {0...32767}
                                    712 ;    line length    1 byte  
                                    713 ;    tokens list  variable length 
                                    714 ;   
                                    715 ; input:
                                    716 ;   none
                                    717 ; used variables:
                                    718 ;   in.w  		 3|count, i.e. index in buffer
                                    719 ;   count        length of line | 0  
                                    720 ;   basicptr    
                                    721 ;   pad buffer   compiled BASIC line  
                                    722 ;
                                    723 ; If there is a line number copy pad 
                                    724 ; in program space. 
                                    725 ;-----------------------------------
                           000001   726 	XSAVE=1
                           000002   727 	VSIZE=2
      0091A2                        728 compile::
      0004B0                        729 	_vars VSIZE 
      0091A2 52 02            [ 2]    1     sub sp,#VSIZE 
      0091A4 55 00 37 00 35   [ 1]  730 	mov basicptr,lomem
      0091A9 72 1A 00 43      [ 1]  731 	bset flags,#FCOMP 
      0004BB                        732 	_rst_pending
      0091AD AE 00 5C         [ 2]    1     ldw x,#pending_stack+PENDING_STACK_SIZE
      0004BE                          2     _strxz psp 
      0091B0 BF 4A                    1     .byte 0xbf,psp 
      0091B2 4F               [ 1]  733 	clr a 
      0091B3 5F               [ 1]  734 	clrw x
      0091B4 CF 17 00         [ 2]  735 	ldw pad,x ; line# in destination buffer 
      0091B7 C7 17 02         [ 1]  736 	ld pad+2,a ; line length  
      0004C8                        737 	_clrz in.w 
      0091BA 3F 30                    1     .byte 0x3f, in.w 
      0004CA                        738 	_clrz in  ; offset in input text buffer 
      0091BC 3F 31                    1     .byte 0x3f, in 
      0091BE C6 16 80         [ 1]  739 	ld a,tib 
      0091C1 CD 89 1E         [ 4]  740 	call is_digit
      0091C4 24 1B            [ 1]  741 	jrnc 1$ 
      0004D4                        742 	_incz in 
      0091C6 3C 31                    1     .byte 0x3c, in 
      0091C8 AE 17 03         [ 2]  743 	ldw x,#pad+3
      0091CB 90 AE 16 80      [ 2]  744 	ldw y,#tib   
      0091CF CD 8E F5         [ 4]  745 	call parse_integer 
      0091D2 A3 00 01         [ 2]  746 	cpw x,#1
      0091D5 2F 05            [ 1]  747 	jrslt 0$
      0091D7 CF 17 00         [ 2]  748 	ldw pad,x 
      0091DA 20 05            [ 2]  749 	jra 1$ 
      0091DC A6 01            [ 1]  750 0$:	ld a,#ERR_SYNTAX 
      0091DE CC 96 75         [ 2]  751 	jp tb_error
      0091E1                        752 1$:	 
      0091E1 90 AE 17 03      [ 2]  753 	ldw y,#pad+3 
      0091E5 90 A3 17 80      [ 2]  754 2$:	cpw y,#stack_full 
      0091E9 25 05            [ 1]  755 	jrult 3$
      0091EB A6 0A            [ 1]  756 	ld a,#ERR_MEM_FULL 
      0091ED CC 96 75         [ 2]  757 	jp tb_error 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 61.
Hexadecimal [24-Bits]



      0091F0                        758 3$:	
      0091F0 93               [ 1]  759 	ldw x,y 
      0091F1 CD 90 0A         [ 4]  760 	call parse_lexeme 
      0091F4 4D               [ 1]  761 	tnz a 
      0091F5 26 EE            [ 1]  762 	jrne 2$ 
                                    763 ; compilation completed  
      000505                        764 	_pending_empty 
      000505                          1     _ldaz psp+1 
      0091F7 B6 4B                    1     .byte 0xb6,psp+1 
      0091F9 A0 5C            [ 1]    2     sub a,#pending_stack+PENDING_STACK_SIZE
      0091FB 27 0D            [ 1]  765 	jreq 4$
      00050B                        766 	_pop_op 
      0091FD 72 C6 00 4A      [ 4]    1     ld a,[psp]
      00050F                          2     _incz psp+1 
      009201 3C 4B                    1     .byte 0x3c, psp+1 
      009203 A1 27            [ 1]  767 	cp a,#TO_IDX 
      009205 27 03            [ 1]  768 	jreq 4$ 
      009207 CC 96 73         [ 2]  769 	jp syntax_error 
      00920A                        770 4$:
      00920A 90 7F            [ 1]  771 	clr (y)
      00920C 90 5C            [ 1]  772 	incw y 
      00920E 72 A2 17 00      [ 2]  773 	subw y,#pad ; compiled line length 
      009212 90 9F            [ 1]  774     ld a,yl
      009214 AE 17 00         [ 2]  775 	ldw x,#pad 
      000525                        776 	_strxz ptr16 
      009217 BF 0F                    1     .byte 0xbf,ptr16 
      009219 E7 02            [ 1]  777 	ld (2,x),a 
      00921B FE               [ 2]  778 	ldw x,(x)  ; line# 
      00921C 27 08            [ 1]  779 	jreq 10$
      00921E CD 8E 2E         [ 4]  780 	call insert_line ; in program space 
      00052F                        781 	_clrz  count
      009221 3F 32                    1     .byte 0x3f, count 
      009223 4F               [ 1]  782 	clr  a ; not immediate command  
      009224 20 0F            [ 2]  783 	jra  11$ 
      009226                        784 10$: ; line# is zero 
                                    785 ; for immediate execution from pad buffer.
      000534                        786 	_ldxz ptr16  
      009226 BE 0F                    1     .byte 0xbe,ptr16 
      009228 E6 02            [ 1]  787 	ld a,(2,x)
      000538                        788 	_straz count
      00922A B7 32                    1     .byte 0xb7,count 
      00053A                        789 	_strxz line.addr
      00922C BF 33                    1     .byte 0xbf,line.addr 
      00922E 1C 00 03         [ 2]  790 	addw x,#LINE_HEADER_SIZE
      00053F                        791 	_strxz basicptr
      009231 BF 35                    1     .byte 0xbf,basicptr 
      009233 90 93            [ 1]  792 	ldw y,x
      009235                        793 11$:
      000543                        794 	_drop VSIZE 
      009235 5B 02            [ 2]    1     addw sp,#VSIZE 
      009237 72 1B 00 43      [ 1]  795 	bres flags,#FCOMP 
      00923B 81               [ 4]  796 	ret 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 62.
Hexadecimal [24-Bits]



                                      1 ;;
                                      2 ; Copyright Jacques Deschênes 2023,2024  
                                      3 ; This file is part of pomme-I 
                                      4 ;
                                      5 ;     pomme-I is free software: you can redistribute it and/or modify
                                      6 ;     it under the terms of the GNU General Public License as published by
                                      7 ;     the Free Software Foundation, either version 3 of the License, or
                                      8 ;     (at your option) any later version.
                                      9 ;
                                     10 ;     pomme-I is distributed in the hope that it will be useful,
                                     11 ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                     12 ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                     13 ;     GNU General Public License for more details.
                                     14 ;
                                     15 ;     You should have received a copy of the GNU General Public License
                                     16 ;     along with pomme-I.  If not, see <http://www.gnu.org/licenses/>.
                                     17 ;;
                                     18 
                                     19 ;---------------------------------------
                                     20 ;  decompiler
                                     21 ;  decompile bytecode to text source
                                     22 ;  used by command LIST
                                     23 ;---------------------------------------
                                     24 
                                     25     .module DECOMPILER 
                                     26 
                                     27     .area CODE 
                                     28 
                                     29 ;--------------------------
                                     30 ;  align text in buffer 
                                     31 ;  by  padding left  
                                     32 ;  with  SPACE 
                                     33 ; input:
                                     34 ;   X      str*
                                     35 ;   A      width  
                                     36 ; output:
                                     37 ;   A      strlen
                                     38 ;   X      ajusted
                                     39 ;--------------------------
                           000001    40 	WIDTH=1 ; column width 
                           000002    41 	SLEN=2  ; string length 
                           000002    42 	VSIZE=2 
      00923C                         43 right_align::
      00054A                         44 	_vars VSIZE 
      00923C 52 02            [ 2]    1     sub sp,#VSIZE 
      00923E 6B 01            [ 1]   45 	ld (WIDTH,sp),a 
      009240 CD 88 94         [ 4]   46 	call strlen 
      009243 6B 02            [ 1]   47 0$:	ld (SLEN,sp),a  
      009245 11 01            [ 1]   48 	cp a,(WIDTH,sp) 
      009247 2A 09            [ 1]   49 	jrpl 1$
      009249 5A               [ 2]   50 	decw x
      00924A A6 20            [ 1]   51 	ld a,#SPACE 
      00924C F7               [ 1]   52 	ld (x),a  
      00924D 7B 02            [ 1]   53 	ld a,(SLEN,sp)
      00924F 4C               [ 1]   54 	inc a 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 63.
Hexadecimal [24-Bits]



      009250 20 F1            [ 2]   55 	jra 0$ 
      009252 7B 02            [ 1]   56 1$: ld a,(SLEN,sp)	
      000562                         57 	_drop VSIZE 
      009254 5B 02            [ 2]    1     addw sp,#VSIZE 
      009256 81               [ 4]   58 	ret 
                                     59 
                                     60 ;--------------------------
                                     61 ; print quoted string 
                                     62 ; converting control character
                                     63 ; to backslash sequence
                                     64 ; input:
                                     65 ;   X        char *
                                     66 ;-----------------------------
      009257                         67 prt_quote:
      009257 A6 22            [ 1]   68 	ld a,#'"
      009259 CD 85 81         [ 4]   69 	call putc 
      00925C 90 89            [ 2]   70 	pushw y 
      00925E CD 98 23         [ 4]   71 	call skip_string 
      009261 85               [ 2]   72 	popw x  
      009262 F6               [ 1]   73 1$:	ld a,(x)
      009263 5C               [ 1]   74 	incw x 
      009264 72 5A 00 32      [ 1]   75 	dec count 
      009268 4D               [ 1]   76 	tnz a 
      009269 27 2E            [ 1]   77 	jreq 9$ 
      00926B A1 20            [ 1]   78 	cp a,#SPACE 
      00926D 25 0C            [ 1]   79 	jrult 3$
      00926F CD 85 81         [ 4]   80 	call putc 
      009272 A1 5C            [ 1]   81 	cp a,#'\ 
      009274 26 EC            [ 1]   82 	jrne 1$ 
      009276                         83 2$:
      009276 CD 85 81         [ 4]   84 	call putc 
      009279 20 E7            [ 2]   85 	jra 1$
      00927B 88               [ 1]   86 3$: push a 
      00927C A6 5C            [ 1]   87 	ld a,#'\
      00927E CD 85 81         [ 4]   88 	call putc  
      009281 84               [ 1]   89 	pop a 
      009282 A0 07            [ 1]   90 	sub a,#7
      000592                         91 	_straz acc8 
      009284 B7 16                    1     .byte 0xb7,acc8 
      009286 72 5F 00 15      [ 1]   92 	clr acc16
      00928A 89               [ 2]   93 	pushw x
      00928B AE 8E ED         [ 2]   94 	ldw x,#escaped 
      00928E 72 BB 00 15      [ 2]   95 	addw x,acc16 
      009292 F6               [ 1]   96 	ld a,(x)
      009293 CD 85 81         [ 4]   97 	call putc 
      009296 85               [ 2]   98 	popw x
      009297 20 C9            [ 2]   99 	jra 1$
      009299                        100 9$:
      009299 A6 22            [ 1]  101 	ld a,#'"
      00929B CD 85 81         [ 4]  102 	call putc  
      00929E 81               [ 4]  103 	ret
                                    104 
                                    105 ;--------------------------
                                    106 ; print variable name  
                                    107 ; input:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 64.
Hexadecimal [24-Bits]



                                    108 ;   X    variable name
                                    109 ; output:
                                    110 ;   none 
                                    111 ;--------------------------
      00929F                        112 prt_var_name:
      00929F 9E               [ 1]  113 	ld a,xh 
      0092A0 A4 7F            [ 1]  114 	and a,#0x7f 
      0092A2 CD 85 81         [ 4]  115 	call putc 
      0092A5 9F               [ 1]  116 	ld a,xl 
      0092A6 CD 85 81         [ 4]  117 	call putc 
      0092A9 81               [ 4]  118 	ret 
                                    119 
                                    120 ;----------------------------------
                                    121 ; search name in dictionary
                                    122 ; from its token index  
                                    123 ; input:
                                    124 ;   a       	token index   
                                    125 ; output:
                                    126 ;   A           token index | 0 
                                    127 ;   X 			*name  | 0 
                                    128 ;--------------------------------
                           000001   129 	TOKEN=1  ; TOK_IDX 
                           000002   130 	NFIELD=TOKEN+1 ; NAME FIELD 
                           000004   131 	SKIP=NFIELD+2 
                           000005   132 	VSIZE=SKIP+1 
      0092AA                        133 tok_to_name:
      0005B8                        134 	_vars VSIZE 
      0092AA 52 05            [ 2]    1     sub sp,#VSIZE 
      0092AC 0F 04            [ 1]  135 	clr (SKIP,sp) 
      0092AE 6B 01            [ 1]  136 	ld (TOKEN,sp),a 
      0092B0 AE AC 05         [ 2]  137 	ldw x, #all_words+2 ; name field 	
      0092B3 1F 02            [ 2]  138 1$:	ldw (NFIELD,sp),x
      0092B5 F6               [ 1]  139 	ld a,(x)
      0092B6 AB 02            [ 1]  140 	add a,#2 
      0092B8 6B 05            [ 1]  141 	ld (SKIP+1,sp),a 
      0092BA 72 FB 04         [ 2]  142 	addw x,(SKIP,sp)
      0092BD F6               [ 1]  143 	ld a,(x) ; TOK_IDX     
      0092BE 11 01            [ 1]  144 	cp a,(TOKEN,sp)
      0092C0 27 0B            [ 1]  145 	jreq 2$
      0092C2 1E 02            [ 2]  146 	ldw x,(NFIELD,sp) ; name field 
      0092C4 1D 00 02         [ 2]  147 	subw x,#2 ; link field 
      0092C7 FE               [ 2]  148 	ldw x,(x) 
      0092C8 26 E9            [ 1]  149 	jrne 1$
      0092CA 4F               [ 1]  150 	clr a 
      0092CB 20 03            [ 2]  151 	jra 9$
      0092CD 1E 02            [ 2]  152 2$: ldw x,(NFIELD,sp)
      0092CF 5C               [ 1]  153 	incw x 
      0005DE                        154 9$:	_drop VSIZE
      0092D0 5B 05            [ 2]    1     addw sp,#VSIZE 
      0092D2 81               [ 4]  155 	ret
                                    156 
                                    157 ;------------------------------------
                                    158 ; check if token need space 
                                    159 ; before or after it 
                                    160 ; input:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 65.
Hexadecimal [24-Bits]



                                    161 ;   A     token index 
                                    162 ; output:
                                    163 ;   C     set need space 
                                    164 ;------------------------------------
      0092D3                        165 need_space:
      0092D3 A1 07            [ 1]  166 	cp a,#DELIM_LAST+1 
      0092D5 2B 0A            [ 1]  167 	jrmi 9$ 
      0092D7 A1 0B            [ 1]  168 	cp a,#SYMB_LAST+1 
      0092D9 2B 04            [ 1]  169 	jrmi 8$ 
      0092DB A1 16            [ 1]  170 	cp a,#OP_REL_LAST+1 
      0092DD 2B 02            [ 1]  171 	jrmi 9$ 
      0092DF 99               [ 1]  172 8$: scf
      0092E0 81               [ 4]  173 	ret 
      0092E1 98               [ 1]  174 9$:	rcf 
      0092E2 81               [ 4]  175 	ret 
                                    176 
                                    177 ;-------------------------------------
                                    178 ; decompile tokens list 
                                    179 ; to original text line 
                                    180 ; input:
                                    181 ;   A      0 don't align line number 
                                    182 ;          !0 align it. 
                                    183 ;   line.addr start of line 
                                    184 ;   Y,basicptr  at first token 
                                    185 ;   count     stop position.
                                    186 ;------------------------------------
                           000001   187 	PSTR=1     ;  1 word 
                           000003   188 	ALIGN=3
                           000004   189 	LAST_BC=4
                           000005   190 	PREV_BC=5
                           000005   191 	VSIZE=5
      0092E3                        192 decompile::
      0092E3 3B 00 0C         [ 1]  193 	push base 
      0092E6 35 0A 00 0C      [ 1]  194 	mov base,#10
      0005F8                        195 	_vars VSIZE
      0092EA 52 05            [ 2]    1     sub sp,#VSIZE 
      0092EC 0F 04            [ 1]  196 	clr (LAST_BC,sp)
      0092EE 6B 03            [ 1]  197 	ld (ALIGN,sp),a 
      0005FE                        198 	_ldxz line.addr
      0092F0 BE 33                    1     .byte 0xbe,line.addr 
      0092F2 FE               [ 2]  199 	ldw x,(x)
      0092F3 4F               [ 1]  200 	clr a ; unsigned conversion  
      0092F4 CD 88 47         [ 4]  201 	call itoa
      0092F7 0D 03            [ 1]  202 	tnz (ALIGN,sp)
      0092F9 27 05            [ 1]  203 	jreq 1$  
      0092FB A6 05            [ 1]  204 	ld a,#5 
      0092FD CD 92 3C         [ 4]  205 	call right_align 
      009300 CD 85 CD         [ 4]  206 1$:	call puts 
      009303 CD 85 FB         [ 4]  207 	call space
      000614                        208 	_ldyz basicptr 
      009306 90 BE 35                 1     .byte 0x90,0xbe,basicptr 
      009309                        209 decomp_loop:
      009309 7B 04            [ 1]  210 	ld a,(LAST_BC,sp)
      00930B 6B 05            [ 1]  211 	ld (PREV_BC,sp),a 
      00061B                        212 	_ldaz count 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 66.
Hexadecimal [24-Bits]



      00930D B6 32                    1     .byte 0xb6,count 
      00930F 26 03            [ 1]  213 	jrne 0$
      009311 CC 93 C2         [ 2]  214 	jp decomp_exit 
      009314                        215 0$:	
      009314 72 5A 00 32      [ 1]  216 	dec count 
      000626                        217 	_next_token
      000626                          1         _get_char 
      009318 90 F6            [ 1]    1         ld a,(y)    ; 1 cy 
      00931A 90 5C            [ 1]    2         incw y      ; 1 cy 
      00931C 4D               [ 1]  218 	tnz a 
      00931D 26 03            [ 1]  219 	jrne 1$
      00931F CC 93 C2         [ 2]  220 	jp decomp_exit   
      009322                        221 1$:	
      009322 6B 04            [ 1]  222 	ld (LAST_BC,sp),a 
      009324 A1 06            [ 1]  223 	cp a,#QUOTE_IDX 
      009326 26 03            [ 1]  224 	jrne 2$
      009328 CC 93 BC         [ 2]  225 	jp quoted_string 
      00932B A1 09            [ 1]  226 2$:	cp a,#VAR_IDX 
      00932D 26 03            [ 1]  227 	jrne 3$
      00932F CC 93 7D         [ 2]  228 	jp variable 
      009332 A1 23            [ 1]  229 3$:	cp a,#REM_IDX 
      009334 26 03            [ 1]  230 	jrne 4$
      009336 CC 93 B0         [ 2]  231 	jp comment 
      009339                        232 4$:	
      009339 A1 0A            [ 1]  233 	cp a,#STR_VAR_IDX 
      00933B 26 03            [ 1]  234 	jrne 5$
      00933D CC 93 7D         [ 2]  235 	jp variable 
      009340 A1 07            [ 1]  236 5$:	cp a,#LITC_IDX 
      009342 26 10            [ 1]  237 	jrne 6$ 
      009344 A6 5C            [ 1]  238 	ld a,#'\ 
      009346 CD 85 81         [ 4]  239 	call putc 
      000657                        240 	_get_char 
      009349 90 F6            [ 1]    1         ld a,(y)    ; 1 cy 
      00934B 90 5C            [ 1]    2         incw y      ; 1 cy 
      00065B                        241 	_decz count 
      00934D 3A 32                    1     .byte 0x3a,count 
      00934F CD 85 81         [ 4]  242 	call putc 
      009352 20 1C            [ 2]  243 	jra prt_space 
      009354 A1 08            [ 1]  244 6$:	cp a,#LITW_IDX 
      009356 26 02            [ 1]  245 	jrne 7$
      009358 20 3E            [ 2]  246 	jra lit_word
      00935A                        247 7$:	
                                    248 ; print command,function or operator 	 
      00935A CD 92 AA         [ 4]  249 	call tok_to_name 
      00935D 4D               [ 1]  250 	tnz a 
      00935E 26 03            [ 1]  251 	jrne 9$
      009360 CC 93 C2         [ 2]  252 	jp decomp_exit
      009363                        253 9$:	
      009363 CD 85 CD         [ 4]  254 	call puts
      009366 7B 04            [ 1]  255 	ld a,(LAST_BC,sp)
      009368 CD 92 D3         [ 4]  256 	call need_space 
      00936B 25 03            [ 1]  257 	jrc prt_space
      00936D CC 93 09         [ 2]  258     jp decomp_loop 
      009370                        259 prt_space:	
      009370 90 F6            [ 1]  260 	ld a,(y)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 67.
Hexadecimal [24-Bits]



      009372 CD 92 D3         [ 4]  261 	call need_space 
      009375 24 03            [ 1]  262 	jrnc 1$ 
      009377 CD 85 FB         [ 4]  263 	call space 
      00937A CC 93 09         [ 2]  264 1$:	jp decomp_loop
                                    265 ; print variable name 	
      00937D                        266 variable: ; VAR_IDX 
      00937D 90 F6            [ 1]  267 	ld a,(y)
      00937F A4 7F            [ 1]  268 	and a,#127 
      009381 CD 85 81         [ 4]  269 	call putc 
      009384 90 E6 01         [ 1]  270 	ld a,(1,y) 
      009387 CD 85 81         [ 4]  271 	call putc 
      00938A 72 5A 00 32      [ 1]  272 	dec count 
      00938E 72 5A 00 32      [ 1]  273 	dec count   
      009392 72 A9 00 02      [ 2]  274 	addw y,#2
      009396 20 D8            [ 2]  275 	jra prt_space
                                    276 ; print literal integer  
      009398                        277 lit_word: ; LITW_IDX 
      0006A6                        278 	_get_word
      0006A6                          1         _get_addr
      009398 93               [ 1]    1         ldw x,y     ; 1 cy 
      009399 FE               [ 2]    2         ldw x,(x)   ; 2 cy 
      00939A 72 A9 00 02      [ 2]    3         addw y,#2   ; 2 cy 
      00939E CD 88 3C         [ 4]  279 	call print_int
      0093A1 90 F6            [ 1]  280 	ld a,(y)
      0093A3 CD 92 D3         [ 4]  281 	call need_space
      0093A6 25 05            [ 1]  282 	jrc 1$ 
      0093A8 A6 08            [ 1]  283 	ld a,#BS 
      0093AA CD 85 81         [ 4]  284 	call putc 
      0093AD CC 93 09         [ 2]  285 1$:	jp decomp_loop  	
                                    286 ; print comment	
      0093B0                        287 comment: ; REM_IDX 
      0093B0 A6 27            [ 1]  288 	ld a,#''
      0093B2 CD 85 81         [ 4]  289 	call putc
      0093B5 93               [ 1]  290 	ldw x,y
      0093B6 CD 85 CD         [ 4]  291 	call puts 
      0093B9 CC 93 C2         [ 2]  292 	jp decomp_exit 
                                    293 ; print quoted string 	
      0093BC                        294 quoted_string:	
      0093BC CD 92 57         [ 4]  295 	call prt_quote  
      0093BF CC 93 09         [ 2]  296 	jp decomp_loop 
                                    297 ; print \letter 	
                           000000   298 .if 0
                                    299 letter: 
                                    300 	ld a,#'\ 
                                    301 	call putc 
                                    302 	_get_char 
                                    303 	dec count   
                                    304 	call putc  
                                    305 	jp prt_space 
                                    306 .endif 
      0093C2                        307 decomp_exit: 
      0093C2 CD 85 EA         [ 4]  308 	call new_line 
      0006D3                        309 	_drop VSIZE 
      0093C5 5B 05            [ 2]    1     addw sp,#VSIZE 
      0093C7 32 00 0C         [ 1]  310 	pop base 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 68.
Hexadecimal [24-Bits]



      0093CA 81               [ 4]  311 	ret 
                                    312 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 69.
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
                                     33     .module FILES
                                     34 
                                     35 	.area CODE 
                                     36 
                                     37 
                                     38 ;---------------------------------
                                     39 ;  files.asm macros 
                                     40 ;---------------------------------
                                     41 
                                     42 
                           005042    43 SIGNATURE="PB" 
                           005858    44 ERASED="XX" ; erased file, replace signature. 
                           000000    45 FILE_SIGN_FIELD = 0 ; signature offset 2 bytes 
                           000002    46 FILE_SIZE_FIELD = 2 ; size offset 2 bytes 
                           000004    47 FILE_NAME_FIELD = 4 ; file name 12 byte 
                           000010    48 FILE_HEADER_SIZE = 16 ; bytes 
                           000010    49 FILE_DATA= FILE_HEADER_SIZE ; data offset 
                           000100    50 FSECTOR_SIZE=256 ; file sector size  
                           00000C    51 FNAME_MAX_LEN=12 
                                     52 
                                     53 
                                     54 ;-------------------------------
                                     55 ; search a BASIC file in spi eeprom  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 70.
Hexadecimal [24-Bits]



                                     56 ; 
                                     57 ; The file name is identified 
                                     58 ; input:
                                     59 ;    x      *fname 
                                     60 ;    farptr   start address in file system 
                                     61 ; output: 
                                     62 ;    A        0 not found | 1 found
                                     63 ;    farptr   file address in eeprom   
                                     64 ;-------------------------------
                           000001    65 	FNAME=1 
                           000003    66 	YSAVE=FNAME+2 
                           000004    67 	VSIZE=YSAVE+1 
      0093CB                         68 search_file:
      0006D9                         69 	_vars VSIZE
      0093CB 52 04            [ 2]    1     sub sp,#VSIZE 
      0093CD 17 03            [ 2]   70 	ldw (YSAVE,sp),y  
      0093CF 1F 01            [ 2]   71 	ldw (FNAME,sp),x
      0093D1 CD 95 28         [ 4]   72 	call first_file  
      0093D4 27 1B            [ 1]   73 1$: jreq 7$  
      0093D6 AE 00 60         [ 2]   74     ldw x,#file_header+FILE_NAME_FIELD
      0093D9 16 01            [ 2]   75 	ldw y,(FNAME,sp)
      0093DB CD 88 9F         [ 4]   76 	call strcmp 
      0093DE 27 0D            [ 1]   77 	jreq 4$ 
      0093E0 AE 00 5C         [ 2]   78 	ldw x,#file_header 
      0093E3 CD 95 6F         [ 4]   79 	call skip_to_next
      0093E6 CD 95 2D         [ 4]   80 	call next_file 
      0093E9 27 06            [ 1]   81 	jreq 7$
      0093EB 20 E7            [ 2]   82 	jra 1$   
      0093ED                         83 4$: ; file found  
      0093ED A6 01            [ 1]   84 	ld a,#1 
      0093EF 20 01            [ 2]   85 	jra 8$  
      0093F1                         86 7$: ; not found 
      0093F1 4F               [ 1]   87 	clr a 
      0093F2                         88 8$:	
      0093F2 16 03            [ 2]   89 	ldw y,(YSAVE,sp)
      000702                         90 	_drop VSIZE 
      0093F4 5B 04            [ 2]    1     addw sp,#VSIZE 
      0093F6 81               [ 4]   91 	ret 
                                     92 
                                     93 ;-----------------------------------
                                     94 ; erase program file
                                     95 ; replace signature by "XX. 
                                     96 ; input:
                                     97 ;   farptr    file address in eeprom  
                                     98 ;-----------------------------------
      0093F7                         99 erase_file:
      0093F7 A6 58            [ 1]  100 	ld a,#'X 
      0093F9 AE 00 5C         [ 2]  101 	ldw x,#file_header
      0093FC F7               [ 1]  102 	ld (x),a 
      0093FD E7 01            [ 1]  103 	ld (1,x),a
      0093FF A6 02            [ 1]  104 	ld a,#2 
      009401 CD 8A FD         [ 4]  105 	call eeprom_write 
      009404 81               [ 4]  106 	ret 
                                    107 
                                    108 ;--------------------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 71.
Hexadecimal [24-Bits]



                                    109 ; reclaim erased file space that 
                                    110 ; fit size 
                                    111 ; input:
                                    112 ;    X     minimum size to reclaim 
                                    113 ; output:
                                    114 ;    A     0 no fit | 1 fit found 
                                    115 ;    farptr   fit address 
                                    116 ;--------------------------------------
                           000001   117 	NEED=1
                           000003   118 	SMALL_FIT=NEED+2
                           000005   119 	YSAVE=SMALL_FIT+2 
                           000006   120 	VSIZE=YSAVE+1
      009405                        121 reclaim_space:
      000713                        122 	_vars VSIZE 
      009405 52 06            [ 2]    1     sub sp,#VSIZE 
      009407 17 05            [ 2]  123 	ldw (YSAVE,sp),y 
      009409 1F 01            [ 2]  124 	ldw (NEED,sp),x 
      00940B AE FF FF         [ 2]  125 	ldw x,#-1 
      00940E 1F 03            [ 2]  126 	ldw (SMALL_FIT,sp),x 
      00071E                        127 	_clrz farptr  
      009410 3F 0E                    1     .byte 0x3f, farptr 
      009412 5F               [ 1]  128 	clrw x
      000721                        129 	_strxz ptr16 
      009413 BF 0F                    1     .byte 0xbf,ptr16 
      009415                        130 1$:	
      009415 CD 8B BE         [ 4]  131 	call addr_to_page
      009418 A3 02 00         [ 2]  132 	cpw x,#512 
      00941B 2A 29            [ 1]  133 	jrpl 7$ ; to end  
      00941D AE 00 10         [ 2]  134 	ldw x,#FILE_HEADER_SIZE
      009420 90 AE 00 5C      [ 2]  135 	ldw y,#file_header
      009424 CD 8B 29         [ 4]  136 	call eeprom_read 
      009427 AE 00 5C         [ 2]  137 	ldw x,#file_header  
      00942A FE               [ 2]  138 	ldw x,(x)
      00942B A3 58 58         [ 2]  139 	cpw x,#ERASED 
      00942E 27 05            [ 1]  140 	jreq 4$ 
      009430 CD 95 6F         [ 4]  141 3$:	call skip_to_next
      009433 20 E0            [ 2]  142 	jra 1$ 
      009435                        143 4$: ; check size 
      009435 AE 00 5C         [ 2]  144 	ldw x,#file_header  
      009438 EE 02            [ 2]  145 	ldw x,(FILE_SIZE_FIELD,x)
      00943A 13 01            [ 2]  146 	cpw x,(NEED,sp)
      00943C 25 F2            [ 1]  147 	jrult 3$ 
      00943E 13 03            [ 2]  148 	cpw x,(SMALL_FIT,sp)
      009440 22 EE            [ 1]  149 	jrugt 3$ 
      009442 1F 03            [ 2]  150 	ldw (SMALL_FIT,sp),x  
      009444 20 EA            [ 2]  151 	jra 3$ 
      009446                        152 7$: ; to end of file system 
      009446 4F               [ 1]  153 	clr a 
      009447 1E 03            [ 2]  154 	ldw x,(SMALL_FIT,sp)
      009449 A3 FF FF         [ 2]  155 	cpw x,#-1
      00944C 27 02            [ 1]  156 	jreq 9$ 
      00944E A6 01            [ 1]  157 	ld a,#1
      009450                        158 9$:	
      009450 16 05            [ 2]  159 	ldw y,(YSAVE,sp)
      000760                        160 	_drop VSIZE  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 72.
Hexadecimal [24-Bits]



      009452 5B 06            [ 2]    1     addw sp,#VSIZE 
      009454 81               [ 4]  161 	ret 
                                    162 
                                    163 ;--------------------------
                                    164 ; load file in RAM 
                                    165 ; input:
                                    166 ;   farptr   file address 
                                    167 ;   file_header   file header data 
                                    168 ;--------------------------
                           000001   169 	FSIZE=1
                           000003   170 	YSAVE=FSIZE+2
                           000004   171 	VSIZE=YSAVE+1
      009455                        172 load_file:
      000763                        173 	_vars VSIZE 
      009455 52 04            [ 2]    1     sub sp,#VSIZE 
      009457 17 03            [ 2]  174 	ldw (YSAVE,sp),y
      009459 AE 00 10         [ 2]  175 	ldw x,#FILE_HEADER_SIZE 
      00945C CD 95 79         [ 4]  176 	call incr_farptr 	
      00945F AE 00 5C         [ 2]  177 	ldw x,#file_header  
      009462 EE 02            [ 2]  178 	ldw x,(FILE_SIZE_FIELD,x)
      009464 1F 01            [ 2]  179 	ldw (FSIZE,sp),x 
      009466 90 CE 00 37      [ 2]  180 	ldw y,lomem 
      00946A CD 8B 29         [ 4]  181 	call eeprom_read 
      00946D CE 00 37         [ 2]  182 	ldw x,lomem 
      009470 72 FB 01         [ 2]  183 	addw x,(FSIZE,sp)
      000781                        184 	_strxz progend 
      009473 BF 3B                    1     .byte 0xbf,progend 
      000783                        185 	_strxz dvar_bgn
      009475 BF 3D                    1     .byte 0xbf,dvar_bgn 
      000785                        186 	_strxz dvar_end 
      009477 BF 3F                    1     .byte 0xbf,dvar_end 
      009479                        187 9$:
      009479 16 03            [ 2]  188 	ldw y,(YSAVE,sp)
      000789                        189 	_drop VSIZE 
      00947B 5B 04            [ 2]    1     addw sp,#VSIZE 
      00947D 81               [ 4]  190 	ret 
                                    191 
                                    192 ;--------------------------------------
                                    193 ; save program file 
                                    194 ; input:
                                    195 ;    farptr     address in eeprom 
                                    196 ;    X          file name 
                                    197 ;--------------------------------------
                           000001   198 	TO_WRITE=1
                           000003   199 	DONE=TO_WRITE+2
                           000005   200 	FNAME=DONE+2 
                           000005   201 	XSAVE=FNAME
                           000007   202 	YSAVE=XSAVE+2 
                           000008   203 	VSIZE=YSAVE+1
      00947E                        204 save_file:
      00078C                        205 	_vars VSIZE 
      00947E 52 08            [ 2]    1     sub sp,#VSIZE 
      009480 17 07            [ 2]  206 	ldw (YSAVE,sp),y 
      009482 1F 05            [ 2]  207 	ldw (FNAME,sp),x 
      009484 AE 00 5C         [ 2]  208 	ldw x,#file_header
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 73.
Hexadecimal [24-Bits]



      009487 A6 50            [ 1]  209 	ld a,#'P 
      009489 F7               [ 1]  210 	ld (x),a 
      00948A A6 42            [ 1]  211 	ld a,#'B 
      00948C E7 01            [ 1]  212 	ld (1,x),a
      00948E 90 CE 00 3B      [ 2]  213 	ldw y,progend 
      009492 72 B2 00 37      [ 2]  214 	subw y,lomem
      009496 EF 02            [ 2]  215 	ldw (FILE_SIZE_FIELD,X),y
      009498 17 01            [ 2]  216 	ldw (TO_WRITE,sp),y 
      00949A 1C 00 04         [ 2]  217 	addw x,#FILE_NAME_FIELD 
      00949D 16 05            [ 2]  218 	ldw y,(FNAME,sp)
      00949F CD 88 AE         [ 4]  219 	call strcpy 
      0094A2 A6 10            [ 1]  220 	ld a,#FILE_HEADER_SIZE
      0094A4 AE 00 5C         [ 2]  221 	ldw x,#file_header
      0094A7 6F 0F            [ 1]  222 	clr (FILE_HEADER_SIZE-1,x) ; in case name is longer that FNAME_MAX_LEN
      0094A9 CD 8A FD         [ 4]  223 	call eeprom_write 
      0094AC AE 00 10         [ 2]  224 	ldw x,#FILE_HEADER_SIZE 
      0094AF CD 95 79         [ 4]  225 	call incr_farptr
      0094B2 CE 00 37         [ 2]  226 	ldw x,lomem 
      0094B5 1F 05            [ 2]  227 	ldw (XSAVE,sp),x 
      0094B7 AE 00 F0         [ 2]  228 	ldw x,#FSECTOR_SIZE-FILE_HEADER_SIZE 
      0094BA                        229 1$: 
      0094BA 13 01            [ 2]  230 	cpw x,(TO_WRITE,sp)
      0094BC 23 02            [ 2]  231 	jrule 2$ 
      0094BE 1E 01            [ 2]  232 	ldw x,(TO_WRITE,sp)
      0094C0 1F 03            [ 2]  233 2$: ldw (DONE,sp),x
      0094C2 9F               [ 1]  234 	ld a,xl 
      0094C3 1E 05            [ 2]  235 	ldw x,(XSAVE,sp)
      0094C5 CD 8A FD         [ 4]  236 	call eeprom_write 
      0094C8 1E 03            [ 2]  237 	ldw x,(DONE,sp)
      0094CA CD 95 79         [ 4]  238 	call incr_farptr
      0094CD 1E 01            [ 2]  239 	ldw x,(TO_WRITE,sp)
      0094CF 72 F0 03         [ 2]  240 	subw x,(DONE,sp)
      0094D2 1F 01            [ 2]  241 	ldw (TO_WRITE,sp),x 
      0094D4 27 0C            [ 1]  242 	jreq 9$ 
      0094D6 1E 05            [ 2]  243 	ldw x,(XSAVE,sp)
      0094D8 72 FB 03         [ 2]  244 	addw x,(DONE,sp)
      0094DB 1F 05            [ 2]  245 	ldw (XSAVE,sp),x 
      0094DD AE 01 00         [ 2]  246 	ldw x,#FSECTOR_SIZE
      0094E0 20 D8            [ 2]  247 	jra 1$ 
      0094E2                        248 9$:
      0094E2 16 07            [ 2]  249 	ldw y,(YSAVE,sp)
      0007F2                        250 	_drop VSIZE 
      0094E4 5B 08            [ 2]    1     addw sp,#VSIZE 
      0094E6 81               [ 4]  251 	ret 
                                    252 
                                    253 ;---------------------------
                                    254 ; search free page in eeprom 
                                    255 ; output:
                                    256 ;    A     0 no free | 1 free 
                                    257 ;    farptr  address free 
                                    258 ;---------------------------
      0094E7                        259 search_free:
      0007F5                        260 	_clrz farptr 
      0094E7 3F 0E                    1     .byte 0x3f, farptr 
      0094E9 5F               [ 1]  261 	clrw x 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 74.
Hexadecimal [24-Bits]



      0007F8                        262 	_strxz ptr16 
      0094EA BF 0F                    1     .byte 0xbf,ptr16 
      0094EC 90 AE 00 5C      [ 2]  263 1$:	ldw y,#file_header 
      0094F0 AE 00 10         [ 2]  264 	ldw x,#FILE_HEADER_SIZE 
      0094F3 CD 8B 29         [ 4]  265 	call eeprom_read 
      0094F6 AE 00 5C         [ 2]  266 	ldw x,#file_header
      0094F9 FE               [ 2]  267 	ldw x,(x)
      000808                        268 	_strxz acc16
      0094FA BF 15                    1     .byte 0xbf,acc16 
      0094FC AE FF FF         [ 2]  269 	ldw x,#-1 
      0094FF C3 00 15         [ 2]  270 	cpw x,acc16 
      009502 27 21            [ 1]  271 	jreq 6$   ; erased page, take it 
      009504 AE 50 42         [ 2]  272 	ldw x,#SIGNATURE
      009507 C3 00 15         [ 2]  273 	cpw x,acc16 
      00950A 27 08            [ 1]  274 	jreq 4$ 
      00950C AE 58 58         [ 2]  275 	ldw x,#ERASED
      00950F C3 00 15         [ 2]  276 	cpw x,acc16  
      009512 26 11            [ 1]  277 	jrne 6$ ; no "PB" or "XX" take it 
      009514                        278 4$: ; try next 
      009514 AE 00 5C         [ 2]  279 	ldw x,#file_header 
      009517 CD 95 6F         [ 4]  280 	call skip_to_next 
      00951A CD 8B BE         [ 4]  281 	call addr_to_page 
      00951D A3 02 00         [ 2]  282 	cpw x,#512 
      009520 2B CA            [ 1]  283 	jrmi 1$
      009522 4F               [ 1]  284 	clr a  
      009523 20 02            [ 2]  285 	jra 9$ 
      009525                        286 6$: ; found free 
      009525 A6 01            [ 1]  287 	ld a,#1
      009527                        288 9$:	
      009527 81               [ 4]  289 	ret 
                                    290 
                                    291 
                                    292 ;---------------------------------------
                                    293 ;  search first file 
                                    294 ;  input: 
                                    295 ;    none 
                                    296 ;  output:
                                    297 ;     A     0 none | 1 found 
                                    298 ;  farptr   file address 
                                    299 ;   pad     file header 
                                    300 ;-----------------------------------------
      009528                        301 first_file:
      000836                        302 	_clrz farptr 
      009528 3F 0E                    1     .byte 0x3f, farptr 
      00952A 5F               [ 1]  303 	clrw x 
      000839                        304 	_strxz ptr16 
      00952B BF 0F                    1     .byte 0xbf,ptr16 
                                    305 ; search next file 
      00952D                        306 next_file: 
      00952D 90 89            [ 2]  307 	pushw y 
      00952F                        308 1$:	
      00952F CD 8B BE         [ 4]  309 	call addr_to_page
      009532 A3 02 00         [ 2]  310 	cpw x,#512
      009535 2A 30            [ 1]  311 	jrpl 4$ 
      009537 AE 00 10         [ 2]  312 	ldw x,#FILE_HEADER_SIZE 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 75.
Hexadecimal [24-Bits]



      00953A 90 AE 00 5C      [ 2]  313 	ldw y,#file_header  
      00953E CD 8B 29         [ 4]  314 	call eeprom_read 
      009541 AE 00 5C         [ 2]  315 	ldw x,#file_header
      009544 FE               [ 2]  316 	ldw x,(x) ; signature 
      000853                        317 	_strxz acc16 
      009545 BF 15                    1     .byte 0xbf,acc16 
      009547 AE 50 42         [ 2]  318 	ldw x,#SIGNATURE  
      00954A C3 00 15         [ 2]  319 	cpw x,acc16 
      00954D 27 1B            [ 1]  320 	jreq 8$  
      00954F AE FF FF         [ 2]  321 	ldw x,#-1 
      009552 C3 00 15         [ 2]  322 	cpw x,acc16 
      009555 27 10            [ 1]  323 	jreq 4$ ; end of files 	
      009557 AE 58 58         [ 2]  324 	ldw x,#ERASED 
      00955A C3 00 15         [ 2]  325 	cpw x,acc16 
      00955D 26 08            [ 1]  326 	jrne 4$ 
      00955F                        327 2$:
      00955F AE 00 5C         [ 2]  328 	ldw x,#file_header 
      009562 CD 95 6F         [ 4]  329 	call skip_to_next 
      009565 20 C8            [ 2]  330 	jra 1$ 
      009567                        331 4$: ; no more file 
      009567 4F               [ 1]  332 	clr a
      009568 20 02            [ 2]  333 	jra 9$  
      00956A A6 01            [ 1]  334 8$: ld a,#1 
      00956C                        335 9$: 	
      00956C 90 85            [ 2]  336 	popw y 
      00956E 81               [ 4]  337 	ret 
                                    338 
                                    339 ;----------------------------
                                    340 ;  skip to next program
                                    341 ;  in file system  
                                    342 ; input:
                                    343 ;     X       address of buffer containing file HEADER data 
                                    344 ;    farptr   actual program address in eeprom 
                                    345 ; output:
                                    346 ;    farptr   updated to next sector after program   
                                    347 ;----------------------------
      00956F                        348 skip_to_next:
      00956F EE 02            [ 2]  349 	ldw x,(FILE_SIZE_FIELD,x)
      009571 1C 00 10         [ 2]  350 	addw x,#FILE_HEADER_SIZE 
      009574 1C 00 FF         [ 2]  351 	addw x,#FSECTOR_SIZE-1 
      009577 4F               [ 1]  352 	clr a 
      009578 97               [ 1]  353 	ld xl,a 
                                    354 
                                    355 ;----------------------
                                    356 ; input: 
                                    357 ;    X     increment 
                                    358 ; output:
                                    359 ;   farptr += X 
                                    360 ;---------------------
      009579                        361 incr_farptr:
      009579 72 BB 00 0F      [ 2]  362 	addw x,ptr16 
      00088B                        363 	_strxz ptr16  
      00957D BF 0F                    1     .byte 0xbf,ptr16 
      00957F 4F               [ 1]  364 	clr a 
      009580 C9 00 0E         [ 1]  365 	adc a,farptr 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 76.
Hexadecimal [24-Bits]



      000891                        366 	_straz farptr 
      009583 B7 0E                    1     .byte 0xb7,farptr 
      009585 81               [ 4]  367 	ret 
                                    368 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 77.
Hexadecimal [24-Bits]



                                      1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                      2 ;;   pomme BASIC error messages 
                                      3 ;;   addresses indexed table 
                                      4 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                      5 
                                      6 
                                      7 	; macro to create err_msg table 
                                      8 	.macro _err_entry msg_addr, error_code 
                                      9 	.word msg_addr  
                                     10 	error_code==ERR_IDX 
                                     11 	ERR_IDX=ERR_IDX+1
                                     12 	.endm 
                                     13 
                           000000    14 	ERR_IDX=0
                                     15 
                                     16 ; array of pointers to 
                                     17 ; error_messages strings table.	
      009586                         18 err_msg_idx:  
                                     19 
      000894                         20 	_err_entry 0,ERR_NONE 
      009586 00 00                    1 	.word 0  
                           000000     2 	ERR_NONE==ERR_IDX 
                           000001     3 	ERR_IDX=ERR_IDX+1
      000896                         21 	_err_entry err_syntax,ERR_SYNTAX 
      009588 95 AC                    1 	.word err_syntax  
                           000001     2 	ERR_SYNTAX==ERR_IDX 
                           000002     3 	ERR_IDX=ERR_IDX+1
      000898                         22 	_err_entry err_gt32767,ERR_GT32767 
      00958A 95 B3                    1 	.word err_gt32767  
                           000002     2 	ERR_GT32767==ERR_IDX 
                           000003     3 	ERR_IDX=ERR_IDX+1
      00089A                         23 	_err_entry err_gt255,ERR_GT255 
      00958C 95 BA                    1 	.word err_gt255  
                           000003     2 	ERR_GT255==ERR_IDX 
                           000004     3 	ERR_IDX=ERR_IDX+1
      00089C                         24 	_err_entry err_bad_branch,ERR_BAD_BRANCH 
      00958E 95 BF                    1 	.word err_bad_branch  
                           000004     2 	ERR_BAD_BRANCH==ERR_IDX 
                           000005     3 	ERR_IDX=ERR_IDX+1
      00089E                         25 	_err_entry err_bad_return,ERR_BAD_RETURN 
      009590 95 CA                    1 	.word err_bad_return  
                           000005     2 	ERR_BAD_RETURN==ERR_IDX 
                           000006     3 	ERR_IDX=ERR_IDX+1
      0008A0                         26 	_err_entry err_bad_next,ERR_BAD_NEXT 
      009592 95 D5                    1 	.word err_bad_next  
                           000006     2 	ERR_BAD_NEXT==ERR_IDX 
                           000007     3 	ERR_IDX=ERR_IDX+1
      0008A2                         27 	_err_entry err_gt8_gosub,ERR_GOSUBS 
      009594 95 DE                    1 	.word err_gt8_gosub  
                           000007     2 	ERR_GOSUBS==ERR_IDX 
                           000008     3 	ERR_IDX=ERR_IDX+1
      0008A4                         28 	_err_entry err_gt8_fors, ERR_FORS 
      009596 95 E8                    1 	.word err_gt8_fors  
                           000008     2 	ERR_FORS==ERR_IDX 
                           000009     3 	ERR_IDX=ERR_IDX+1
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 78.
Hexadecimal [24-Bits]



      0008A6                         29 	_err_entry err_end, ERR_END 
      009598 95 F0                    1 	.word err_end  
                           000009     2 	ERR_END==ERR_IDX 
                           00000A     3 	ERR_IDX=ERR_IDX+1
      0008A8                         30 	_err_entry err_mem_full, ERR_MEM_FULL
      00959A 95 F4                    1 	.word err_mem_full  
                           00000A     2 	ERR_MEM_FULL==ERR_IDX 
                           00000B     3 	ERR_IDX=ERR_IDX+1
      0008AA                         31 	_err_entry err_too_long, ERR_TOO_LONG 
      00959C 95 FD                    1 	.word err_too_long  
                           00000B     2 	ERR_TOO_LONG==ERR_IDX 
                           00000C     3 	ERR_IDX=ERR_IDX+1
      0008AC                         32 	_err_entry err_dim, ERR_DIM 
      00959E 96 06                    1 	.word err_dim  
                           00000C     2 	ERR_DIM==ERR_IDX 
                           00000D     3 	ERR_IDX=ERR_IDX+1
      0008AE                         33 	_err_entry err_range, ERR_RANGE 
      0095A0 96 0A                    1 	.word err_range  
                           00000D     2 	ERR_RANGE==ERR_IDX 
                           00000E     3 	ERR_IDX=ERR_IDX+1
      0008B0                         34 	_err_entry err_str_ovfl, ERR_STR_OVFL 
      0095A2 96 10                    1 	.word err_str_ovfl  
                           00000E     2 	ERR_STR_OVFL==ERR_IDX 
                           00000F     3 	ERR_IDX=ERR_IDX+1
      0008B2                         35 	_err_entry err_string, ERR_STRING 
      0095A4 96 19                    1 	.word err_string  
                           00000F     2 	ERR_STRING==ERR_IDX 
                           000010     3 	ERR_IDX=ERR_IDX+1
      0008B4                         36 	_err_entry err_retype, ERR_RETYPE 
      0095A6 96 20                    1 	.word err_retype  
                           000010     2 	ERR_RETYPE==ERR_IDX 
                           000011     3 	ERR_IDX=ERR_IDX+1
      0008B6                         37 	_err_entry err_prog_only, ERR_PROG_ONLY  
      0095A8 96 2C                    1 	.word err_prog_only  
                           000011     2 	ERR_PROG_ONLY==ERR_IDX 
                           000012     3 	ERR_IDX=ERR_IDX+1
      0008B8                         38 	_err_entry err_div0, ERR_DIV0 
      0095AA 96 39                    1 	.word err_div0  
                           000012     2 	ERR_DIV0==ERR_IDX 
                           000013     3 	ERR_IDX=ERR_IDX+1
                                     39 
                                     40 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     41 ; error messages strings table 
                                     42 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      0095AC                         43 error_messages: 
                                     44 
      0095AC 53 59 4E 54 41 58 00    45 err_syntax: .asciz "SYNTAX"
      0095B3 3E 33 32 37 36 37 00    46 err_gt32767: .asciz ">32767" 
      0095BA 3E 32 35 35 00          47 err_gt255: .asciz ">255" 
      0095BF 42 41 44 20 42 52 41    48 err_bad_branch: .asciz "BAD BRANCH" 
             4E 43 48 00
      0095CA 42 41 44 20 52 45 54    49 err_bad_return: .asciz "BAD RETURN" 
             55 52 4E 00
      0095D5 42 41 44 20 4E 45 58    50 err_bad_next: .asciz "BAD NEXT" 
             54 00
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 79.
Hexadecimal [24-Bits]



      0095DE 3E 38 20 47 4F 53 55    51 err_gt8_gosub: .asciz ">8 GOSUBS"  
             42 53 00
      0095E8 3E 38 20 46 4F 52 53    52 err_gt8_fors: .asciz ">8 FORS" 
             00
      0095F0 45 4E 44 00             53 err_end: .asciz "END" 
      0095F4 4D 45 4D 20 46 55 4C    54 err_mem_full: .asciz "MEM FULL" 
             4C 00
      0095FD 54 4F 4F 20 4C 4F 4E    55 err_too_long: .asciz "TOO LONG" 
             47 00
      009606 44 49 4D 00             56 err_dim: .asciz "DIM" 
      00960A 52 41 4E 47 45 00       57 err_range: .asciz "RANGE"
      009610 53 54 52 20 4F 56 46    58 err_str_ovfl: .asciz "STR OVFL" 
             4C 00
      009619 53 54 52 49 4E 47 00    59 err_string: .asciz "STRING" 
      009620 52 45 54 59 50 45 20    60 err_retype: .asciz "RETYPE LINE" 
             4C 49 4E 45 00
      00962C 50 52 4F 47 52 41 4D    61 err_prog_only: .asciz "PROGRAM ONLY" 
             20 4F 4E 4C 59 00
      009639 44 49 56 20 42 59 20    62 err_div0: .asciz "DIV BY 0" 
             30 00
                                     63 
                                     64 ;-------------------------------------
      009642 0A 72 75 6E 20 74 69    65 rt_msg: .asciz "\nrun time error, "
             6D 65 20 65 72 72 6F
             72 2C 20 00
      009654 0A 63 6F 6D 70 69 6C    66 comp_msg: .asciz "\ncompile error, "
             65 20 65 72 72 6F 72
             2C 20 00
      009665 2A 2A 2A 20 00          67 err_stars: .asciz "*** " 
      00966A 20 45 52 52 4F 52 20    68 err_err: .asciz " ERROR \n" 
             0A 00
                                     69 
      009673                         70 syntax_error::
      009673 A6 01            [ 1]   71 	ld a,#ERR_SYNTAX 
      009675                         72 tb_error::
      009675 72 0A 00 43 19   [ 2]   73 	btjt flags,#FCOMP,1$
      00967A 88               [ 1]   74 	push a 
      00967B AE 96 42         [ 2]   75 	ldw x, #rt_msg 
      00967E CD 85 CD         [ 4]   76 	call puts
      009681 84               [ 1]   77 0$:	pop a 
      009682 AD 35            [ 4]   78 	callr print_err_msg
      009684 72 B2 00 33      [ 2]   79 	subw y, line.addr 
      009688 90 9F            [ 1]   80 	ld a,yl 
      00968A A0 03            [ 1]   81 	sub a,#LINE_HEADER_SIZE 
      00099A                         82 	_ldxz line.addr 
      00968C BE 33                    1     .byte 0xbe,line.addr 
      00968E CD 9E FF         [ 4]   83 	call prt_basic_line
      009691 20 1F            [ 2]   84 	jra 6$
      009693                         85 1$:	
      009693 88               [ 1]   86 	push a 
      009694 AE 96 54         [ 2]   87 	ldw x,#comp_msg
      009697 CD 85 CD         [ 4]   88 	call puts 
      00969A 84               [ 1]   89 	pop a 
      00969B AD 1C            [ 4]   90 	callr print_err_msg
      00969D AE 16 80         [ 2]   91 	ldw x,#tib
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 80.
Hexadecimal [24-Bits]



      0096A0 CD 85 CD         [ 4]   92 	call puts 
      0096A3 A6 0D            [ 1]   93 	ld a,#CR 
      0096A5 CD 85 81         [ 4]   94 	call putc
      0009B6                         95 	_ldxz in.w
      0096A8 BE 30                    1     .byte 0xbe,in.w 
      0096AA CD 86 01         [ 4]   96 	call spaces
      0096AD A6 5E            [ 1]   97 	ld a,#'^
      0096AF CD 85 81         [ 4]   98 	call putc 
      0096B2                         99 6$:
      0096B2 AE 17 FF         [ 2]  100 	ldw x,#STACK_EMPTY 
      0096B5 94               [ 1]  101     ldw sp,x
      0096B6 CC 97 A4         [ 2]  102 	jp warm_start 
                                    103 	
                                    104 ;------------------------
                                    105 ; print error message 
                                    106 ; input:
                                    107 ;    A   error code 
                                    108 ; output:
                                    109 ;	 none 
                                    110 ;------------------------
      0096B9                        111 print_err_msg:
      0096B9 88               [ 1]  112 	push a 
      0096BA AE 96 65         [ 2]  113 	ldw x,#err_stars 
      0096BD CD 85 CD         [ 4]  114 	call puts
      0096C0 84               [ 1]  115 	pop a 
      0096C1 5F               [ 1]  116 	clrw x 
      0096C2 97               [ 1]  117 	ld xl,a 
      0096C3 58               [ 2]  118 	sllw x 
      0096C4 1C 95 86         [ 2]  119 	addw x,#err_msg_idx 
      0096C7 FE               [ 2]  120 	ldw x,(x)
      0096C8 CD 85 CD         [ 4]  121 	call puts 
      0096CB AE 96 6A         [ 2]  122 	ldw x,#err_err 
      0096CE CD 85 CD         [ 4]  123 	call puts 
      0096D1 81               [ 4]  124 	ret 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 81.
Hexadecimal [24-Bits]



                                      1 ;;
                                      2 ; Copyright Jacques Deschênes 2019,2022,2023  
                                      3 ; This file is part of p1Basic 
                                      4 ;
                                      5 ;     p1Basic is free software: you can redistribute it and/or modify
                                      6 ;     it under the terms of the GNU General Public License as published by
                                      7 ;     the Free Software Foundation, either version 3 of the License, or
                                      8 ;     (at your option) any later version.
                                      9 ;
                                     10 ;     p1Basic is distributed in the hope that it will be useful,
                                     11 ;     but WITHOUT ANY WARRANTY; without even the implied warranty of
                                     12 ;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                                     13 ;     GNU General Public License for more details.
                                     14 ;
                                     15 ;     You should have received a copy of the GNU General Public License
                                     16 ;     along with p1Basic.  If not, see <http://www.gnu.org/licenses/>.
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
                                     44 
                                     45     .module P1_BASIC 
                                     46 
                                     47 	.area CODE 
                                     48 
                                     49 
                                     50 
                                     51 ;---------------------------------------
                                     52 ;   BASIC configuration parameters
                                     53 ;---------------------------------------
                           001500    54 MAX_CODE_SIZE=5376 ; 42*BLOCK_SIZE multiple of BLOCK_SIZE=128 bytes  
                           000080    55 MIN_VAR_SIZE=BLOCK_SIZE ; FREE_RAM-MAX_CODE_SIZE 128 bytes 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 82.
Hexadecimal [24-Bits]



                           000010    56 PENDING_STACK_SIZE= 16 ; pending operation stack 
                                     57 
                                     58 ;--------------------------------------
                                     59     .area APP_DATA (ABS)
      000030                         60 	.org APP_DATA_ORG 
                                     61 ;--------------------------------------	
                                     62 
                                     63 ; keep the following 3 variables in this order 
      000030                         64 in.w::  .blkb 1 ; used by compiler 
      000031                         65 in::    .blkb 1 ; low byte of in.w 
      000032                         66 count:: .blkb 1 ; current BASIC line length and tib text length  
      000033                         67 line.addr:: .blkw 1 ; BASIC line start at this address. 
      000035                         68 basicptr::  .blkw 1  ; BASIC interperter program pointer.
                                     69 ;data_line:: .blkw 1  ; data line address 
                                     70 ;data_ptr:  .blkw 1  ; point to DATA in line 
      000037                         71 lomem:: .blkw 1 ; tokenized BASIC area beginning address 
      000039                         72 himem:: .blkw 1 ; tokenized BASIC area end before this address 
      00003B                         73 progend:: .blkw 1 ; address end of BASIC program 
      00003D                         74 dvar_bgn:: .blkw 1 ; DIM variables start address 
      00003F                         75 dvar_end:: .blkw 1 ; DIM variables end address 
      000041                         76 heap_free:: .blkw 1 ; free RAM growing down from tib 
      000043                         77 flags:: .blkb 1 ; various boolean flags
      000044                         78 auto_line: .blkw 1 ; automatic line number  
      000046                         79 auto_step: .blkw 1 ; automatic lein number increment 
                                     80 ; chain_level: .blkb 1 ; increment for each CHAIN command 
      000048                         81 for_nest: .blkb 1 ; nesting level of FOR...NEXT , maximum 8 
      000049                         82 gosub_nest: .blkb 1 ; nesting level of GOSUB, maximum 8 
                                     83 ; pending stack is used by compiler to check syntax, like matching pair 
      00004A                         84 psp: .blkw 1 ; pending_stack pointer 
      00004C                         85 pending_stack: .blkb PENDING_STACK_SIZE ; pending operations stack 
      00005C                         86 file_header: .blkb FILE_HEADER_SIZE ; buffer to hold file header structure 
                                     87 
                                     88 ;------------------------------
                                     89 	.area APP_DATA
      000100                         90 	.org 0x100 
                                     91 ;-------------------------------
                                     92 ; BASIC programs compiled here
      000100                         93 free_ram: 
                                     94 
                                     95 
                                     96 	.area CODE 
                                     97 
                                     98 ;-----------------------
                                     99 ;  display POMME BASIC  
                                    100 ;  information 
                                    101 ;-----------------------
                           000001   102 	PB_MAJOR=1
                           000000   103 	PB_MINOR=0
                           00000F   104 	PB_REV=15
                                    105 		
      0096D2 70 6F 6D 6D 65 20 42   106 app_name: .asciz "pomme BASIC\n"
             41 53 49 43 0A 00
      0096DF 43 6F 70 79 72 69 67   107 pb_copyright: .asciz "Copyright, Jacques Deschenes 2023\n"
             68 74 2C 20 4A 61 63
             71 75 65 73 20 44 65
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 83.
Hexadecimal  73-Bits]



             73 63 68 65 6E 65 73
             20 32 30 32 33 0A 00
                                    108 
      000A10                        109 print_app_info:
      0096F5 63 68 65         [ 1]  110 	push base 
      0096F8 6E 65 73 20      [ 1]  111 	mov base, #10 
                                    112 ; push app_info()
                                    113 ; parameters on stack 
      0096FC 32 30            [ 1]  114 	push #PB_REV 
      0096FE 32 33            [ 1]  115 	push #PB_MINOR 
      009700 0A 00            [ 1]  116 	push #PB_MAJOR  
      009702 AE 09 E0         [ 2]  117 	ldw x,#app_name  
      009702 3B 00 0C 35      [ 2]  118 	ldw y,#pb_copyright 
      009706 0A 00 0C         [ 4]  119 	call app_info
      000A27                        120 	_drop 3
      009709 4B 0F            [ 2]    1     addw sp,#3 
      00970B 4B 00 4B         [ 1]  121 	pop base 
      00970E 01               [ 4]  122 	ret
                                    123 
                                    124 ;------------------------------
                                    125 ;  les variables ne sont pas 
                                    126 ;  réinitialisées.
                                    127 ;-----------------------------
      000A2D                        128 warm_init:
      00970F AE 96 D2         [ 2]  129 	ldw x,#uart_putc 
      009712 90 AE 96         [ 2]  130 	ldw out,x ; standard output   
      000A33                        131 	_clrz flags 
      009715 DF CD                    1     .byte 0x3f, flags 
      009717 89 47 5B 03      [ 1]  132 	mov base,#10 
      000A39                        133 	_rst_pending 
      00971B 32 00 0C         [ 2]    1     ldw x,#pending_stack+PENDING_STACK_SIZE
      000A3C                          2     _strxz psp 
      00971E 81 4A                    1     .byte 0xbf,psp 
      00971F 81               [ 4]  134 	ret 
                                    135 
                                    136 ;---------------------------
                                    137 ; reset BASIC system variables 
                                    138 ; and clear BASIC program 
                                    139 ; variables  
                                    140 ;---------------------------
      000A3F                        141 reset_basic:
      00971F AE               [ 2]  142 	pushw x 
      009720 85 98 CF         [ 2]  143 	ldw x,#free_ram 
      000A43                        144 	_strxz lomem
      009723 00 17                    1     .byte 0xbf,lomem 
      000A45                        145 	_strxz progend  
      009725 3F 43                    1     .byte 0xbf,progend 
      000A47                        146 	_strxz dvar_bgn 
      009727 35 0A                    1     .byte 0xbf,dvar_bgn 
      000A49                        147 	_strxz dvar_end
      009729 00 0C                    1     .byte 0xbf,dvar_end 
      00972B AE 00 5C         [ 2]  148 	ldw x,#tib 
      000A4E                        149 	_strxz himem 
      00972E BF 4A                    1     .byte 0xbf,himem 
      000A50                        150 	_strxz heap_free 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 84.
Hexadecimal [24-Bits]



      009730 81 41                    1     .byte 0xbf,heap_free 
      009731                        151 	_clrz flags
      009731 89 AE                    1     .byte 0x3f, flags 
      009733 01               [ 1]  152 	clrw x 
      000A55                        153 	_strxz for_nest 
      009734 00 BF                    1     .byte 0xbf,for_nest 
      000A57                        154 	_strxz psp 
      009736 37 BF                    1     .byte 0xbf,psp 
      009738 3B BF            [ 1]  155 	ld a,#10 
      000A5B                        156 	_straz auto_line 
      00973A 3D BF                    1     .byte 0xb7,auto_line 
      000A5D                        157 	_straz auto_step  
      00973C 3F AE                    1     .byte 0xb7,auto_step 
      00973E 16               [ 2]  158 	popw x
      00973F 80               [ 4]  159 	ret 
                                    160 
      000A61                        161 P1BASIC:: 
                                    162 ; enable SPI for file system 
      009740 BF 39 BF         [ 4]  163 	call spi_enable 
                                    164 ; reset hardware stack 
      009743 41 3F 43         [ 2]  165     ldw x,#STACK_EMPTY 
      009746 5F               [ 1]  166     ldw sp,x 
      009747 BF 48 BF         [ 4]  167 	call reset_basic
                                    168 ; initialize operation pending stack 	
      000A6B                        169 	_rst_pending 
      00974A 4A A6 0A         [ 2]    1     ldw x,#pending_stack+PENDING_STACK_SIZE
      000A6E                          2     _strxz psp 
      00974D B7 44                    1     .byte 0xbf,psp 
      00974F B7 46 85         [ 4]  170 	call print_app_info ; display BASIC information
      009752 81 1A EC         [ 4]  171 	call free 
                                    172 ; set ctrl_c_vector
      009753 AE 0A 98         [ 2]  173 	ldw x,#ctrl_c_stop 
      000A79                        174 	_strxz ctrl_c_vector 
      009753 CD 89                    1     .byte 0xbf,ctrl_c_vector 
                                    175 ; RND function seed 
                                    176 ; must be initialized 
                                    177 ; to value other than 0.
                                    178 ; take values from ROM space 
      009755 77 AE 17         [ 2]  179 	ldw x,0x6000
      009758 FF               [ 2]  180 	ldw x,(x)
      009759 94 CD 97         [ 2]  181 	ldw seedy,x  
      00975C 31 AE 00         [ 2]  182 	ldw x,0x6006 
      00975F 5C               [ 2]  183 	ldw x,(x)
      009760 BF 4A CD         [ 2]  184 	ldw seedx,x  
      009763 97 02            [ 2]  185 	jra warm_start 
                                    186 
      009765 CD A7 DE AE 97 8A BF   187 ctrl_c_msg: .asciz "\nSTOPPED AT " 	
             19 CE 60 00 FE CF
                                    188 ;-------------------------------
                                    189 ; while a program is running 
                                    190 ; CTRL+C end program
                                    191 ;--------------------------- 
      000A98                        192 ctrl_c_stop: 
      009772 00 0A CE         [ 2]  193 	ldw x,#ctrl_c_msg 
      009775 60 06 FE         [ 4]  194 	call puts 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 85.
Hexadecimal [24-Bits]



      009778 CF 00 08         [ 2]  195 	ldw x,line.addr 
      00977B 20               [ 2]  196 	ldw x,(x)
      00977C 27 0A 53         [ 4]  197 	call print_int
      00977F 54 4F 50         [ 4]  198 	call new_line 
      009782 50 45 44         [ 2]  199 	ldw x,#STACK_EMPTY 
      009785 20               [ 1]  200 	ldw sp,x
      009786 41 54 20 00      [ 1]  201 	bres flags,#FRUN
      00978A 20 03            [ 2]  202 	jra cmd_line 
      000AB2                        203 warm_start:
      00978A AE 97 7D         [ 4]  204 	call warm_init
                                    205 ;----------------------------
                                    206 ;   BASIC interpreter
                                    207 ;----------------------------
      000AB5                        208 cmd_line: ; user interface 
      00978D CD 85            [ 1]  209 	ld a,#CR 
      00978F CD CE 00         [ 4]  210 	call putc 
      009792 33 FE            [ 1]  211 	ld a,#'> 
      009794 CD 88 3C         [ 4]  212 	call putc
      009797 CD 85            [ 1]  213 	push #0 
      009799 EA AE 17 FF 94   [ 2]  214 	btjf flags,#FAUTO,1$ 
      000AC6                        215 	_ldxz auto_line 
      00979E 72 11                    1     .byte 0xbe,auto_line 
      0097A0 00 43 20         [ 4]  216 	call itoa
      0097A3 03 01            [ 1]  217 	ld (1,sp),a  
      0097A4 90 93            [ 1]  218 	ldw y,x 
      0097A4 CD 97 1F         [ 2]  219 	ldw x,#tib 
      0097A7 CD 00 00         [ 4]  220 	call strcpy 
      000AD5                        221 	_ldxz auto_line 
      0097A7 A6 0D                    1     .byte 0xbe,auto_line 
      0097A9 CD 85 81 A6      [ 2]  222 	addw x,auto_step 
      000ADB                        223 	_strxz auto_line
      0097AD 3E CD                    1     .byte 0xbf,auto_line 
      0097AF 85               [ 1]  224 1$: pop a 
      0097B0 81 4B 00         [ 4]  225 	call readln
      0097B3 72               [ 1]  226 	tnz a 
      0097B4 0D 00            [ 1]  227 	jreq cmd_line
      0097B6 43 17 BE         [ 4]  228 	call compile
      0097B9 44               [ 1]  229 	tnz a 
      0097BA CD 88            [ 1]  230 	jreq cmd_line ; not direct command
                                    231 
                                    232 ;; direct command 
                                    233 ;; interpret 
                                    234 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    235 ;; This is the interpreter loop
                                    236 ;; for each BASIC code line.
                                    237 ;; 10 cycles  
                                    238 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
      000AEA                        239 do_nothing: 
      000AEA                        240 interp_loop:   
      000AEA                        241     _next_cmd ; command bytecode, 2 cy  
      000AEA                          1         _get_char       ; 2 cy 
      0097BC 47 6B            [ 1]    1         ld a,(y)    ; 1 cy 
      0097BE 01 90            [ 1]    2         incw y      ; 1 cy 
      000AEE                        242 	_jp_code ; 8 cy + 2 cy for jump back to interp_loop  
      000AEE                          1         _code_addr 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 86.
Hexadecimal [24-Bits]



      0097C0 93               [ 1]    1         clrw x   ; 1 cy 
      0097C1 AE               [ 1]    2         ld xl,a  ; 1 cy 
      0097C2 16               [ 2]    3         sllw x   ; 2 cy 
      0097C3 80 CD 88         [ 2]    4         ldw x,(code_addr,x) ; 2 cy 
      0097C6 AE               [ 2]    2         jp (x)
                                    243 
                                    244 ;---------------------
                                    245 ; BASIC: REM | ' 
                                    246 ; skip comment to end of line 
                                    247 ;---------------------- 
      000AF5                        248 kword_remark::
      0097C7 BE 44 72 BB      [ 2]  249 	ldw y,line.addr 
      0097CB 00 46 BF         [ 1]  250 	ld a,(2,y) ; line length 
      000AFC                        251 	_straz in  
      0097CE 44 84                    1     .byte 0xb7,in 
      0097D0 CD 86 0D 4D      [ 2]  252 	addw y,in.w   
                                    253 
                                    254 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    255 ; move basicptr to first token 
                                    256 ; of next line 
                                    257 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      000B02                        258 next_line:
      0097D4 27 D1 CD 91 A2   [ 2]  259 	btjf flags,#FRUN,cmd_line
      0097D9 4D 27 CB 3B      [ 2]  260 	cpw y,progend
      0097DC 2B 05            [ 1]  261 	jrmi 1$
      0097DC                        262 0$:
      0097DC 90 F6            [ 1]  263 	ld a,#ERR_END 
      0097DE 90 5C 5F         [ 2]  264 	jp tb_error 
                                    265 ;	jp kword_end 
      000B12                        266 1$:	
      000B12                        267 	_stryz line.addr 
      0097E1 97 58 DE                 1     .byte 0x90,0xbf,line.addr 
      0097E4 8C F2 FC 03      [ 2]  268 	addw y,#LINE_HEADER_SIZE
      0097E7 72 0F 00 43 03   [ 2]  269 	btjf flags,#FTRACE,2$
      0097E7 90 CE 00         [ 4]  270 	call prt_line_no 
      000B21                        271 2$:	
      000B21                        272   _next 
      0097EA 33 90 E6         [ 2]    1         jp interp_loop 
                                    273 
                                    274 
                                    275 
                                    276 ;------------------------
                                    277 ; when TRACE is active 
                                    278 ; print line number to 
                                    279 ; be executed by VM
                                    280 ;------------------------
      000B24                        281 prt_line_no:
      0097ED 02 B7 31 72      [ 5]  282 	ldw x,[line.addr] 
      0097F1 B9 00 30         [ 4]  283 	call print_int 
      0097F4 A6 0D            [ 1]  284 	ld a,#CR 
      0097F4 72 01 00         [ 4]  285 	call putc 
      0097F7 43               [ 4]  286 	ret 
                                    287 
                                    288 
                                    289 ;-------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 87.
Hexadecimal [24-Bits]



                                    290 ;  skip .asciz in BASIC line 
                                    291 ;  name 
                                    292 ;  input:
                                    293 ;     x		* string 
                                    294 ;  output:
                                    295 ;     none 
                                    296 ;-------------------------
      000B31                        297 skip_string:
      0097F8 AE 90            [ 1]  298 	ld a,(y)
      0097FA C3 00            [ 1]  299 	jreq 8$
      0097FC 3B 2B            [ 1]  300 1$:	incw y
      0097FE 05 F6            [ 1]  301 	ld a,(y)
      0097FF 26 FA            [ 1]  302 	jrne 1$  
      0097FF A6 09            [ 1]  303 8$: incw y
      009801 CC               [ 4]  304 	ret 
                                    305 
                                    306 ;-------------------------------
                                    307 ; called when an intger token 
                                    308 ; is expected. can be LIT_IDX 
                                    309 ; or LITW_IDX 
                                    310 ; program fail if not integer 
                                    311 ;------------------------------
      000B3E                        312 expect_integer:
      000B3E                        313 	_next_token 
      000B3E                          1         _get_char 
      009802 96 75            [ 1]    1         ld a,(y)    ; 1 cy 
      009804 90 5C            [ 1]    2         incw y      ; 1 cy 
      009804 90 BF            [ 1]  314 	cp a,#LITW_IDX 
      009806 33 72            [ 1]  315 	jreq 0$
      009808 A9 00 03         [ 2]  316 	jp syntax_error
      000B49                        317 0$:	_get_word 
      000B49                          1         _get_addr
      00980B 72               [ 1]    1         ldw x,y     ; 1 cy 
      00980C 0F               [ 2]    2         ldw x,(x)   ; 2 cy 
      00980D 00 43 03 CD      [ 2]    3         addw y,#2   ; 2 cy 
      009811 98               [ 4]  318 	ret 
                                    319 
                                    320 
                                    321 ;--------------------------
                                    322 ; input:
                                    323 ;   A      character 
                                    324 ; output:
                                    325 ;   A      digit 
                                    326 ;   Cflag   1 ok, 0 failed 
                                    327 ; use:
                                    328 ;   base
                                    329 ;------------------------------   
      000B50                        330 char_to_digit:
      009812 16 30            [ 1]  331 	sub a,#'0
      009813 2B 11            [ 1]  332 	jrmi 9$ 
      009813 CC 97            [ 1]  333 	cp a,#10
      009815 DC 0B            [ 1]  334 	jrmi 5$
      009816 A1 11            [ 1]  335 	cp a,#17 
      009816 72 CE            [ 1]  336 	jrmi 9$   
      009818 00 33            [ 1]  337 	sub a,#7 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 88.
Hexadecimal [24-Bits]



      00981A CD 88 3C         [ 1]  338 	cp a,base 
      00981D A6 0D            [ 1]  339 	jrpl 9$	 
      00981F CD               [ 1]  340 5$: scf ; ok 
      009820 85               [ 4]  341 	ret 
      009821 81               [ 1]  342 9$: rcf ; failed 
      009822 81               [ 4]  343 	ret 
                                    344 
                                    345 ;------------------------------------
                                    346 ; convert pad content in integer
                                    347 ; input:
                                    348 ;    Y		* .asciz to convert
                                    349 ; output:
                                    350 ;    X        int16_t
                                    351 ;    Y        * .asciz after integer  
                                    352 ;    acc16    int16_t 
                                    353 ; use:
                                    354 ;   base 
                                    355 ;------------------------------------
                                    356 	; local variables
                           000001   357 	N=1 ; INT_SIZE  
                           000003   358 	DIGIT=N+INT_SIZE 
                           000005   359 	SIGN=DIGIT+INT_SIZE ; 1 byte, 
                           000005   360 	VSIZE=SIGN   
      009823                        361 atoi16::
      000B67                        362 	_vars VSIZE
      009823 90 F6            [ 2]    1     sub sp,#VSIZE 
                                    363 ; conversion made on stack 
      009825 27 06 90 5C      [ 1]  364 	mov base, #10 ; defaul conversion base 
      009829 90 F6            [ 1]  365 	clr (DIGIT,sp)
      00982B 26               [ 1]  366 	clrw x 
      000B70                        367 	_i16_store N   
      00982C FA 90            [ 2]    1     ldw (N,sp),x 
      00982E 5C 81            [ 1]  368 	clr (SIGN,sp)
      009830 90 F6            [ 1]  369 	ld a,(y)
      009830 90 F6            [ 1]  370 	jreq 9$  ; completed if 0
      009832 90 5C            [ 1]  371 	cp a,#'-
      009834 A1 08            [ 1]  372 	jrne 1$ 
      009836 27 03            [ 1]  373 	cpl (SIGN,sp)
      009838 CC 96            [ 2]  374 	jra 2$
      000B80                        375 1$:  
      00983A 73 93            [ 1]  376 	cp a,#'$ 
      00983C FE 72            [ 1]  377 	jrne 3$ 
      00983E A9 00 02 81      [ 1]  378 	mov base,#16 ; hexadecimal base 
      009842 90 5C            [ 1]  379 2$:	incw y
      009842 A0 30            [ 1]  380 	ld a,(y)
      009844 2B 11            [ 1]  381 	jreq 9$ 
      000B8E                        382 3$:	; char to digit 
      009846 A1 0A 2B         [ 4]  383 	call char_to_digit
      009849 0B A1            [ 1]  384 	jrnc 9$
      00984B 11 2B            [ 1]  385 	ld (DIGIT+1,sp),a 
      000B95                        386 	_i16_fetch N  ; X=N 
      00984D 09 A0            [ 2]    1     ldw x,(N,sp)
      000B97                        387 	_ldaz base   
      00984F 07 C1                    1     .byte 0xb6,base 
      009851 00 0C 2A         [ 4]  388 	call umul16_8      
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 89.
Hexadecimal [24-Bits]



      009854 02 99 81         [ 2]  389 	addw x,(DIGIT,sp)
      000B9F                        390 	_i16_store N  
      009857 98 81            [ 2]    1     ldw (N,sp),x 
      009859 20 E5            [ 2]  391 	jra 2$
      000BA3                        392 9$:	_i16_fetch N
      009859 52 05            [ 2]    1     ldw x,(N,sp)
      00985B 35 0A            [ 1]  393 	tnz (SIGN,sp)
      00985D 00 0C            [ 1]  394     jreq 10$
      00985F 0F               [ 2]  395     negw x
      000BAA                        396 10$:
      000BAA                        397 	_strxz acc16  
      009860 03 5F                    1     .byte 0xbf,acc16 
      000BAC                        398 	_drop VSIZE
      009862 1F 01            [ 2]    1     addw sp,#VSIZE 
      009864 0F               [ 4]  399 	ret
                                    400 
                                    401 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    402 ;;   pomme BASIC  operators,
                                    403 ;;   commands and functions 
                                    404 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    405 
                                    406 ;---------------------------------
                                    407 ; dictionary search 
                                    408 ; input:
                                    409 ;	X 		dictionary entry point, name field  
                                    410 ;   y		.asciz name to search 
                                    411 ; output:
                                    412 ;  A		TOKEN_IDX  
                                    413 ;---------------------------------
                           000001   414 	NLEN=1 ; cmd length 
                           000003   415 	XSAVE=NLEN+2
                           000005   416 	YSAVE=XSAVE+2
                           000006   417 	VSIZE=YSAVE+1
      000BAF                        418 search_dict::
      000BAF                        419 	_vars VSIZE 
      009865 05 90            [ 2]    1     sub sp,#VSIZE 
      009867 F6 27            [ 1]  420 	clr (NLEN,sp)
      009869 2B A1            [ 2]  421 	ldw (YSAVE,sp),y 
      000BB5                        422 search_next:
      00986B 2D 26            [ 2]  423 	ldw (XSAVE,sp),x 
                                    424 ; get name length in dictionary	
      00986D 04               [ 1]  425 	ld a,(x)
      00986E 03 05            [ 1]  426 	ld (NLEN+1,sp),a  
      009870 20 08            [ 2]  427 	ldw y,(YSAVE,sp) ; name pointer 
      009872 5C               [ 1]  428 	incw x 
      009872 A1 24 26         [ 4]  429 	call strcmp 
      009875 0A 35            [ 1]  430 	jreq str_match 
      000BC2                        431 no_match:
      009877 10 00            [ 2]  432 	ldw x,(XSAVE,sp) 
      009879 0C 90 5C         [ 2]  433 	subw x,#2 ; move X to link field
      00987C 90 F6            [ 1]  434 	ld a,#NONE_IDX   
      00987E 27               [ 2]  435 	ldw x,(x) ; next word link 
      00987F 15 0B            [ 1]  436 	jreq search_exit  ; not found  
                                    437 ;try next 
      009880 20 E7            [ 2]  438 	jra search_next
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 90.
Hexadecimal [24-Bits]



      000BCE                        439 str_match:
      009880 CD 98            [ 2]  440 	ldw x,(XSAVE,sp)
      009882 42 24 10         [ 2]  441 	addw x,(NLEN,sp)
                                    442 ; move x to token field 	
      009885 6B 04 1E         [ 2]  443 	addw x,#2 ; to skip length byte and 0 at end  
      009888 01               [ 1]  444 	ld a,(x) ; token index
      000BD7                        445 search_exit: 
      000BD7                        446 	_drop VSIZE 
      009889 B6 0C            [ 2]    1     addw sp,#VSIZE 
      00988B CD               [ 4]  447 	ret 
                                    448 
                                    449 
                                    450 ;---------------------
                                    451 ; check if next token
                                    452 ;  is of expected type 
                                    453 ; input:
                                    454 ;   A 		 expected token attribute
                                    455 ;  ouput:
                                    456 ;   none     if fail call syntax_error 
                                    457 ;--------------------
      000BDA                        458 expect:
      00988C 83               [ 1]  459 	push a 
      000BDB                        460 	_next_token 
      000BDB                          1         _get_char 
      00988D B5 72            [ 1]    1         ld a,(y)    ; 1 cy 
      00988F FB 03            [ 1]    2         incw y      ; 1 cy 
      009891 1F 01            [ 1]  461 	cp a,(1,sp)
      009893 20 E5            [ 1]  462 	jreq 1$
      009895 1E 01 0D         [ 2]  463 	jp syntax_error
      009898 05               [ 1]  464 1$: pop a 
      009899 27               [ 4]  465 	ret 
                                    466 
                                    467 ;;;;;;;;;;;;;;;;;;;;;;;;;;
                                    468 ; parse arguments list 
                                    469 ; between ()
                                    470 ;;;;;;;;;;;;;;;;;;;;;;;;;;
      000BE8                        471 func_args:
      000BE8                        472 	_next_token 
      000BE8                          1         _get_char 
      00989A 01 50            [ 1]    1         ld a,(y)    ; 1 cy 
      00989C 90 5C            [ 1]    2         incw y      ; 1 cy 
      00989C BF 15            [ 1]  473 	cp a,#LPAREN_IDX 
      00989E 5B 05            [ 1]  474 	jreq arg_list 
      0098A0 81 09 81         [ 2]  475 	jp syntax_error 
                                    476 
                                    477 ; expected to continue in arg_list 
                                    478 ; caller must check for RPAREN_IDX 
                                    479 
                                    480 ;-------------------------------
                                    481 ; parse embedded BASIC routines 
                                    482 ; arguments list.
                                    483 ; arg_list::=  expr[','expr]*
                                    484 ; all arguments are of int24_t type
                                    485 ; and pushed on stack 
                                    486 ; input:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 91.
Hexadecimal [24-Bits]



                                    487 ;   none
                                    488 ; output:
                                    489 ;   stack{n}   arguments pushed on stack
                                    490 ;   A  	number of arguments pushed on stack  
                                    491 ;--------------------------------
                           000004   492 	ARGN=4 
                           000002   493 	ARG_SIZE=INT_SIZE 
      0098A1                        494 arg_list:
      0098A1 52 06            [ 1]  495 	push #0 ; arguments counter
      0098A3 0F 01            [ 1]  496 	tnz (y)
      0098A5 17 05            [ 1]  497 	jreq 7$ 
      0098A7                        498 1$:	 
      0098A7 1F               [ 1]  499 	pop a 
      0098A8 03               [ 2]  500 	popw x 
      0098A9 F6 6B            [ 2]  501 	sub sp, #ARG_SIZE
      0098AB 02               [ 2]  502 	pushw x 
      0098AC 16               [ 1]  503 	inc a 
      0098AD 05               [ 1]  504 	push a
      0098AE 5C CD 88         [ 4]  505 	call expression 
      000C03                        506 	_i16_store ARGN   
      0098B1 9F 27            [ 2]    1     ldw (ARGN,sp),x 
      000C05                        507 	_next_token 
      000C05                          1         _get_char 
      0098B3 0C F6            [ 1]    1         ld a,(y)    ; 1 cy 
      0098B4 90 5C            [ 1]    2         incw y      ; 1 cy 
      0098B4 1E 03            [ 1]  508 	cp a,#COMMA_IDX 
      0098B6 1D 00            [ 1]  509 	jreq 1$ 
      0098B8 02 A6            [ 1]  510 	cp a,#RPAREN_IDX 
      0098BA FF FE            [ 1]  511 	jreq 7$ 
      000C11                        512 	_unget_token 
      0098BC 27 0B            [ 2]    1         decw y
      000C13                        513 7$:	
      0098BE 20               [ 1]  514 	pop a
      0098BF E7               [ 4]  515 	ret  
                                    516 
                                    517 ;--------------------------------
                                    518 ;   BASIC commnands 
                                    519 ;--------------------------------
                                    520 
                                    521 ;----------------------------------
                                    522 ; BASIC: MULDIV(expr1,expr2,expr3)
                                    523 ; return expr1*expr2/expr3 
                                    524 ; product result is int32_t and 
                                    525 ; divisiont is int32_t/int16_t
                                    526 ;----------------------------------
                           000001   527 	ARG3=1
                           000003   528 	ARG2=ARG3+2
                           000005   529 	ARG1=ARG2+2
                           000007   530 	YSAVE=ARG1+2
                           000008   531 	VSIZE=YSAVE+1  
      0098C0                        532 func_muldiv:
      0098C0 1E 03            [ 2]  533 	pushw y 
      0098C2 72 FB 01         [ 4]  534 	call func_args 
      0098C5 1C 00            [ 2]  535 	ldw (YSAVE,sp),y 
      0098C7 02 F6            [ 1]  536 	cp a,#3 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 92.
Hexadecimal [24-Bits]



      0098C9 27 03            [ 1]  537 	jreq 1$
      0098C9 5B 06 81         [ 2]  538 	jp syntax_error
      0098CC                        539 1$: 
      0098CC 88 90            [ 2]  540 	ldw x,(ARG1,sp) ; expr1
      0098CE F6 90            [ 2]  541 	ldw y,(ARG2,sp) ; expr2
      0098D0 5C 11 01         [ 4]  542 	call multiply 
      0098D3 27 03            [ 2]  543 	ldw (ARG2,sp),x  ;int32_t 15..0
      0098D5 CC 96            [ 2]  544 	ldw x,(ARG3,sp)  ; divisor 
      0098D7 73 84            [ 2]  545 	ldw (ARG3,sp),y  ;int32_t 31..16
      0098D9 81 00 00         [ 4]  546 	call div32_16 ; int32_t/expr3 
      0098DA 16 07            [ 2]  547 	ldw y,(YSAVE,sp)
      000C35                        548 	_drop VSIZE
      0098DA 90 F6            [ 2]    1     addw sp,#VSIZE 
      0098DC 90               [ 4]  549 	ret 
                                    550 
                                    551 ;--------------------------------
                                    552 ;  arithmetic and relational 
                                    553 ;  routines
                                    554 ;  operators precedence
                                    555 ;  highest to lowest
                                    556 ;  operators on same row have 
                                    557 ;  same precedence and are executed
                                    558 ;  from left to right.
                                    559 ;	'*','/','%'
                                    560 ;   '-','+'
                                    561 ;   '=','>','<','>=','<=','<>','><'
                                    562 ;   '<>' and '><' are equivalent for not equal.
                                    563 ;--------------------------------
                                    564 
                                    565 
                                    566 
                                    567 ;***********************************
                                    568 ;   expression parse,execute 
                                    569 ;***********************************
                                    570 
                                    571 ;-----------------------------------
                                    572 ; factor ::= ['+'|'-'|e]  var | @ |
                                    573 ;			 integer | function |
                                    574 ;			 '('expression')' 
                                    575 ; output:
                                    576 ;     X     factor value 
                                    577 ; ---------------------------------
                           000001   578 	NEG=1
                           000001   579 	VSIZE=1
      000C38                        580 factor:
      000C38                        581 	_vars VSIZE 
      0098DD 5C A1            [ 2]    1     sub sp,#VSIZE 
      0098DF 04 27            [ 1]  582 	clr (NEG,sp)
      000C3C                        583 	_next_token
      000C3C                          1         _get_char 
      0098E1 03 CC            [ 1]    1         ld a,(y)    ; 1 cy 
      0098E3 96 73            [ 1]    2         incw y      ; 1 cy 
      0098E5 A1 01            [ 1]  584 	cp a,#CMD_END
      0098E5 4B 00            [ 1]  585 	jrugt 1$ 
      0098E7 90 7D 27         [ 2]  586 	jp syntax_error
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 93.
Hexadecimal [24-Bits]



      000C47                        587 1$:
      0098EA 1A 0B            [ 1]  588 	cp a,#ADD_IDX 
      0098EB 27 06            [ 1]  589 	jreq 2$
      0098EB 84 85            [ 1]  590 	cp a,#SUB_IDX 
      0098ED 52 02            [ 1]  591 	jrne 4$ 
      0098EF 89 4C            [ 1]  592 	cpl (NEG,sp)
      000C51                        593 2$:	
      000C51                        594 	_next_token
      000C51                          1         _get_char 
      0098F1 88 CD            [ 1]    1         ld a,(y)    ; 1 cy 
      0098F3 99 D4            [ 1]    2         incw y      ; 1 cy 
      000C55                        595 4$:
      0098F5 1F 04            [ 1]  596 	cp a,#LITW_IDX 
      0098F7 90 F6            [ 1]  597 	jrne 5$
      000C59                        598 	_get_word 
      000C59                          1         _get_addr
      0098F9 90               [ 1]    1         ldw x,y     ; 1 cy 
      0098FA 5C               [ 2]    2         ldw x,(x)   ; 2 cy 
      0098FB A1 02 27 EC      [ 2]    3         addw y,#2   ; 2 cy 
      0098FF A1 05            [ 2]  599 	jra 18$
      000C61                        600 5$: 
      009901 27 02            [ 1]  601 	cp a,#LITC_IDX 
      009903 90 5A            [ 1]  602 	jrne 6$
      009905                        603 	_get_char 
      009905 84 81            [ 1]    1         ld a,(y)    ; 1 cy 
      009907 90 5C            [ 1]    2         incw y      ; 1 cy 
      009907 90               [ 1]  604 	clrw x 
      009908 89               [ 1]  605 	ld xl,a
      009909 CD 98            [ 2]  606 	jra 18$  	
      000C6D                        607 6$:
      00990B DA 17            [ 1]  608 	cp a,#VAR_IDX 
      00990D 07 A1            [ 1]  609 	jrne 8$
      00990F 03 27 03         [ 4]  610 	call get_var_adr 
      009912 CC 96 73         [ 4]  611 	call get_array_adr 
      009915 FE               [ 2]  612 	ldw x,(x)
      009915 1E 05            [ 2]  613 	jra 18$ 	
      000C7A                        614 8$:
      009917 16 03            [ 1]  615 	cp a,#LPAREN_IDX
      009919 CD 84            [ 1]  616 	jrne 10$
      00991B 04 1F 03         [ 4]  617 	call expression
      000C81                        618 	_i16_push
      00991E 1E               [ 2]    1     pushw X
      00991F 01 17            [ 1]  619 	ld a,#RPAREN_IDX 
      009921 01 CD 84         [ 4]  620 	call expect
      000C87                        621 	_i16_pop 
      009924 70               [ 2]    1     popw x 
      009925 16 07            [ 2]  622 	jra 18$ 
      000C8A                        623 10$: ; must be a function 
      000C8A                        624 	_call_code
      000C8A                          1         _code_addr  ; 6 cy  
      009927 5B               [ 1]    1         clrw x   ; 1 cy 
      009928 08               [ 1]    2         ld xl,a  ; 1 cy 
      009929 81               [ 2]    3         sllw x   ; 2 cy 
      00992A DE 00 00         [ 2]    4         ldw x,(code_addr,x) ; 2 cy 
      00992A 52               [ 4]    2         call (x)    ; 4 cy 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 94.
Hexadecimal [24-Bits]



      000C91                        625 18$: 
      00992B 01 0F            [ 1]  626 	tnz (NEG,sp)
      00992D 01 90            [ 1]  627 	jreq 20$
      00992F F6               [ 2]  628 	negw x   
      000C96                        629 20$:
      000C96                        630 	_drop VSIZE
      009930 90 5C            [ 2]    1     addw sp,#VSIZE 
      009932 A1               [ 4]  631 	ret
                                    632 
                                    633 
                                    634 ;-----------------------------------
                                    635 ; term ::= factor ['*'|'/'|'%' factor]* 
                                    636 ; output:
                                    637 ;   X    	term  value 
                                    638 ;-----------------------------------
                           000001   639 	N1=1 ; left operand   
                           000003   640 	YSAVE=N1+INT_SIZE   
                           000005   641 	MULOP=YSAVE+ADR_SIZE
                           000005   642 	VSIZE=INT_SIZE+ADR_SIZE+1    
      000C99                        643 term:
      000C99                        644 	_vars VSIZE
      009933 01 22            [ 2]    1     sub sp,#VSIZE 
                                    645 ; first factor 	
      009935 03 CC 96         [ 4]  646 	call factor
      000C9E                        647 	_i16_store N1 ; left operand 
      009938 73 01            [ 2]    1     ldw (N1,sp),x 
      009939                        648 term01:	 ; check for  operator '*'|'/'|'%' 
      000CA0                        649 	_next_token
      000CA0                          1         _get_char 
      009939 A1 0B            [ 1]    1         ld a,(y)    ; 1 cy 
      00993B 27 06            [ 1]    2         incw y      ; 1 cy 
      00993D A1 0C            [ 1]  650 	ld (MULOP,sp),a
      00993F 26 06            [ 1]  651 	cp a,#DIV_IDX 
      009941 03 01            [ 1]  652 	jrmi 0$ 
      009943 A1 0F            [ 1]  653 	cp a,#MULT_IDX
      009943 90 F6            [ 2]  654 	jrule 1$ 
      000CAE                        655 0$:	_unget_token
      009945 90 5C            [ 2]    1         decw y
      009947 20 2B            [ 2]  656 	jra term_exit 
      000CB2                        657 1$:	; got *|/|%
                                    658 ;second factor
      009947 A1 08 26         [ 4]  659 	call factor
      00994A 08 93            [ 2]  660 	ldw (YSAVE,sp),y ; save y 
      00994C FE 72            [ 2]  661 	ldw y,(N1,sp)
                                    662 ; select operation 	
      00994E A9 00            [ 1]  663 	ld a,(MULOP,sp) 
      009950 02 20            [ 1]  664 	cp a,#MULT_IDX 
      009952 30 09            [ 1]  665 	jrne 3$
                                    666 ; '*' operator
      009953 CD 00 00         [ 4]  667 	call multiply
      009953 A1               [ 1]  668 	tnz a  
      009954 07 26            [ 1]  669 	jreq 5$
      009956 08 90 F6         [ 2]  670 	jp tb_error 
      009959 90 5C            [ 1]  671 3$: cp a,#DIV_IDX 
      00995B 5F 97            [ 1]  672 	jrne 4$ 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 95.
Hexadecimal [24-Bits]



                                    673 ; '/' operator	
      00995D 20               [ 1]  674 	exgw x,y 
      00995E 24 00 00         [ 4]  675 	call divide 
      00995F 20 05            [ 2]  676 	jra 5$ 
      000CD2                        677 4$: ; '%' operator
      00995F A1               [ 1]  678 	exgw x,y 
      009960 09 26 09         [ 4]  679 	call divide  
      009963 CD               [ 1]  680 	exgw x,y 
      000CD7                        681 5$: 
      000CD7                        682 	_i16_store N1
      009964 9C 76            [ 2]    1     ldw (N1,sp),x 
      009966 CD 9C            [ 2]  683 	ldw y,(YSAVE,sp) 
      009968 D5 FE            [ 2]  684 	jra term01 
      000CDD                        685 term_exit:
      000CDD                        686 	_i16_fetch N1
      00996A 20 17            [ 2]    1     ldw x,(N1,sp)
      00996C                        687 	_drop VSIZE 
      00996C A1 04            [ 2]    1     addw sp,#VSIZE 
      00996E 26               [ 4]  688 	ret 
                                    689 
                                    690 ;-------------------------------
                                    691 ;  expr ::= term [['+'|'-'] term]*
                                    692 ;  result range {-16777215..16777215}
                                    693 ;  output:
                                    694 ;     X   expression value     
                                    695 ;-------------------------------
                           000001   696 	N1=1 ;left operand 
                           000003   697 	YSAVE=N1+INT_SIZE ;   
                           000005   698 	OP=YSAVE+ADR_SIZE ; 1
                           000005   699 	VSIZE=INT_SIZE+ADR_SIZE+1
      000CE2                        700 expression:
      000CE2                        701 	_vars VSIZE 
      00996F 0C CD            [ 2]    1     sub sp,#VSIZE 
                                    702 ; first term 	
      009971 99 D4 89         [ 4]  703 	call term
      000CE7                        704 	_i16_store N1 
      009974 A6 05            [ 2]    1     ldw (N1,sp),x 
      000CE9                        705 1$:	; operator '+'|'-'
      000CE9                        706 	_next_token
      000CE9                          1         _get_char 
      009976 CD 98            [ 1]    1         ld a,(y)    ; 1 cy 
      009978 CC 85            [ 1]    2         incw y      ; 1 cy 
      00997A 20 07            [ 1]  707 	ld (OP,sp),a 
      00997C A1 0B            [ 1]  708 	cp a,#ADD_IDX 
      00997C 5F 97            [ 1]  709 	jreq 2$
      00997E 58 DE            [ 1]  710 	cp a,#SUB_IDX 
      009980 8C F2            [ 1]  711 	jreq 2$ 
      000CF7                        712 	_unget_token 
      009982 FD 5A            [ 2]    1         decw y
      009983 20 1E            [ 2]  713 	jra 9$ 
      000CFB                        714 2$: ; second term 
      009983 0D 01 27         [ 4]  715 	call term
      009986 01 50            [ 2]  716 	ldw (YSAVE,sp),y 
      009988 51               [ 1]  717 	exgw x,y 
      000D01                        718 	_i16_fetch N1
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 96.
Hexadecimal [24-Bits]



      009988 5B 01            [ 2]    1     ldw x,(N1,sp)
      00998A 81 01            [ 2]  719 	ldw (N1,sp),y ; right operand   
      00998B 7B 05            [ 1]  720 	ld a,(OP,sp)
      00998B 52 05            [ 1]  721 	cp a,#ADD_IDX 
      00998D CD 99            [ 1]  722 	jrne 4$
                                    723 ; '+' operator
      00998F 2A 1F 01         [ 2]  724 	ADDW X,(N1,SP)
      009992 20 03            [ 2]  725 	jra 5$ 
      000D10                        726 4$:	; '-' operator 
      009992 90 F6 90         [ 2]  727 	SUBW X,(N1,SP)
      000D13                        728 5$:
      000D13                        729 	_i16_store N1
      009995 5C 6B            [ 2]    1     ldw (N1,sp),x 
      009997 05 A1            [ 2]  730 	ldw y,(YSAVE,sp)
      009999 0D 2B            [ 2]  731 	jra 1$
      000D19                        732 9$:
      000D19                        733 	_i16_fetch N1 
      00999B 04 A1            [ 2]    1     ldw x,(N1,sp)
      000D1B                        734 	_drop VSIZE 
      00999D 0F 23            [ 2]    1     addw sp,#VSIZE 
      00999F 04               [ 4]  735 	ret 
                                    736 
                                    737 ;---------------------------------------------
                                    738 ; rel ::= expr [rel_op expr]
                                    739 ; rel_op ::=  '=','<','>','>=','<=','<>','><'
                                    740 ;  relation return  integer , zero is false 
                                    741 ;  output:
                                    742 ;	 X		relation result   
                                    743 ;---------------------------------------------
                                    744   ; local variables
                           000001   745 	N1=1 ; left expression 
                           000003   746 	YSAVE=N1+INT_SIZE   
                           000005   747 	REL_OP=YSAVE+ADR_SIZE  ;  
                           000005   748 	VSIZE=INT_SIZE+ADR_SIZE+1 ; bytes  
      000D1E                        749 relation: 
      000D1E                        750 	_vars VSIZE
      0099A0 90 5A            [ 2]    1     sub sp,#VSIZE 
      0099A2 20 2B E2         [ 4]  751 	call expression
      0099A4                        752 	_i16_store N1 
      0099A4 CD 99            [ 2]    1     ldw (N1,sp),x 
                                    753 ; expect rel_op or leave 
      000D25                        754 	_next_token 
      000D25                          1         _get_char 
      0099A6 2A 17            [ 1]    1         ld a,(y)    ; 1 cy 
      0099A8 03 16            [ 1]    2         incw y      ; 1 cy 
      0099AA 01 7B            [ 1]  755 	ld (REL_OP,sp),a 
      0099AC 05 A1            [ 1]  756 	cp a,#REL_LE_IDX
      0099AE 0F 26            [ 1]  757 	jrmi 1$
      0099B0 09 CD            [ 1]  758 	cp a,#OP_REL_LAST 
      0099B2 84 04            [ 2]  759 	jrule 2$ 
      000D33                        760 1$:	_unget_token 
      0099B4 4D 27            [ 2]    1         decw y
      0099B6 12 CC            [ 2]  761 	jra 9$ 
      000D37                        762 2$:	; expect another expression
      0099B8 96 75 A1         [ 4]  763 	call expression
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 97.
Hexadecimal [24-Bits]



      0099BB 0D 26            [ 2]  764 	ldw (YSAVE,sp),y 
      0099BD 06               [ 1]  765 	exgw x,y 
      000D3D                        766 	_i16_fetch N1
      0099BE 51 CD            [ 2]    1     ldw x,(N1,sp)
      0099C0 84 AC            [ 2]  767 	ldw (N1,sp),y ; right expression  
      0099C2 20 05            [ 2]  768 	cpw x,(N1,sp)
      0099C4 2F 0A            [ 1]  769 	jrslt 4$
      0099C4 51 CD            [ 1]  770 	jrne 5$
                                    771 ; i1==i2 
      0099C6 84 AC            [ 1]  772 	ld a,(REL_OP,sp)
      0099C8 51 13            [ 1]  773 	cp a,#REL_LT_IDX 
      0099C9 2A 21            [ 1]  774 	jrpl 7$ ; relation false 
      0099C9 1F 01            [ 2]  775 	jra 6$  ; relation true 
      000D4F                        776 4$: ; i1<i2
      0099CB 16 03            [ 1]  777 	ld a,(REL_OP,sp)
      0099CD 20 C3            [ 1]  778 	cp a,#REL_LT_IDX 
      0099CF 27 14            [ 1]  779 	jreq 6$ ; relation true 
      0099CF 1E 01            [ 1]  780 	cp a,#REL_LE_IDX 
      0099D1 5B 05            [ 1]  781 	jreq 6$  ; relation true
      0099D3 81 0A            [ 2]  782 	jra 54$
      0099D4                        783 5$: ; i1>i2
      0099D4 52 05            [ 1]  784 	ld a,(REL_OP,sp)
      0099D6 CD 99            [ 1]  785 	cp a,#REL_GT_IDX 
      0099D8 8B 1F            [ 1]  786 	jreq 6$ ; relation true 
      0099DA 01 12            [ 1]  787 	cp a,#REL_GE_IDX 
      0099DB 27 04            [ 1]  788 	jreq 6$ ; relation true 
      000D65                        789 54$:
      0099DB 90 F6            [ 1]  790 	cp a,#REL_NE_IDX 
      0099DD 90 5C            [ 1]  791 	jrne 7$ ; relation false 
      000D69                        792 6$: ; TRUE  ; relation true 
      0099DF 6B 05 A1         [ 2]  793 	LDW X,#-1
      0099E2 0B 27            [ 2]  794 	jra 8$ 
      000D6E                        795 7$:	; FALSE 
      0099E4 08               [ 1]  796 	clrw x
      000D6F                        797 8$: 
      0099E5 A1 0C            [ 2]  798 	ldw y,(YSAVE,sp) 
      0099E7 27 04            [ 2]  799 	jra 10$ 
      000D73                        800 9$:	
      000D73                        801 	_i16_fetch N1
      0099E9 90 5A            [ 2]    1     ldw x,(N1,sp)
      000D75                        802 10$:
      000D75                        803 	_drop VSIZE
      0099EB 20 1E            [ 2]    1     addw sp,#VSIZE 
      0099ED 81               [ 4]  804 	ret 
                                    805 
                                    806 
                                    807 ;-------------------------------------------
                                    808 ;  AND factor:  [NOT] relation 
                                    809 ;  output:
                                    810 ;     X      boolean value 
                                    811 ;-------------------------------------------
                           000001   812 	NOT_OP=1
      000D78                        813 and_factor:
      0099ED CD 99            [ 1]  814 	push #0 
      000D7A                        815 0$:	_next_token  
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 98.
Hexadecimal [24-Bits]



      000D7A                          1         _get_char 
      0099EF 8B 17            [ 1]    1         ld a,(y)    ; 1 cy 
      0099F1 03 51            [ 1]    2         incw y      ; 1 cy 
      0099F3 1E 01            [ 1]  816 	cp a,#CMD_END 
      0099F5 17 01            [ 1]  817 	jrugt 1$
      0099F7 7B 05 A1         [ 2]  818 	jp syntax_error
      0099FA 0B 26            [ 1]  819 1$:	cp a,#NOT_IDX  
      0099FC 05 72            [ 1]  820 	jrne 2$ 
      0099FE FB 01            [ 1]  821 	cpl (NOT_OP,sp)
      009A00 20 03            [ 2]  822 	jra 4$
      009A02                        823 2$:
      000D8D                        824 	_unget_token 
      009A02 72 F0            [ 2]    1         decw y
      000D8F                        825 4$:
      009A04 01 0D 1E         [ 4]  826 	call relation
      009A05                        827 5$:	
      009A05 1F 01            [ 1]  828 	tnz (NOT_OP,sp)
      009A07 16 03            [ 1]  829 	jreq 8$
      009A09 20               [ 2]  830 	cplw x  
      000D97                        831 8$:
      000D97                        832 	_drop 1  
      009A0A D0 01            [ 2]    1     addw sp,#1 
      009A0B 81               [ 4]  833     ret 
                                    834 
                                    835 
                                    836 ;--------------------------------------------
                                    837 ;  AND operator as priority over OR||XOR 
                                    838 ;  format: and_factor [AND and_factor]*
                                    839 ;          
                                    840 ;  output:
                                    841 ;    X      boolean value  
                                    842 ;--------------------------------------------
                           000001   843 	B1=1 
                           000002   844 	VSIZE=INT_SIZE 
      000D9A                        845 and_cond:
      000D9A                        846 	_vars VSIZE 
      009A0B 1E 01            [ 2]    1     sub sp,#VSIZE 
      009A0D 5B 05 81         [ 4]  847 	call and_factor
      009A10                        848 	_i16_store B1 
      009A10 52 05            [ 2]    1     ldw (B1,sp),x 
      000DA1                        849 1$: _next_token 
      000DA1                          1         _get_char 
      009A12 CD 99            [ 1]    1         ld a,(y)    ; 1 cy 
      009A14 D4 1F            [ 1]    2         incw y      ; 1 cy 
      009A16 01 90            [ 1]  850 	cp a,#AND_IDX  
      009A18 F6 90            [ 1]  851 	jreq 3$  
      000DA9                        852 	_unget_token 
      009A1A 5C 6B            [ 2]    1         decw y
      009A1C 05 A1            [ 2]  853 	jra 9$ 
      009A1E 10 2B 04         [ 4]  854 3$:	call and_factor  
      009A21 A1               [ 1]  855 	rlwa x 
      009A22 15 23            [ 1]  856 	and a,(B1,sp)
      009A24 04               [ 1]  857 	rlwa x 
      009A25 90 5A            [ 1]  858 	and a, (B1+1,sp)
      009A27 20               [ 1]  859 	rlwa x 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 99.
Hexadecimal [24-Bits]



      000DB7                        860 	_i16_store B1 
      009A28 3C 01            [ 2]    1     ldw (B1,sp),x 
      009A29 20 E6            [ 2]  861 	jra 1$  
      000DBB                        862 9$:	
      000DBB                        863 	_i16_fetch B1 
      009A29 CD 99            [ 2]    1     ldw x,(B1,sp)
      000DBD                        864 	_drop VSIZE 
      009A2B D4 17            [ 2]    1     addw sp,#VSIZE 
      009A2D 03               [ 4]  865 	ret 	 
                                    866 
                                    867 ;--------------------------------------------
                                    868 ; condition for IF and UNTIL 
                                    869 ; operators: OR
                                    870 ; format:  and_cond [ OP and_cond ]* 
                                    871 ; output:
                                    872 ;    stack   value 
                                    873 ;--------------------------------------------
                           000001   874 	B1=1 ; left bool 
                           000003   875 	OP=B1+INT_SIZE ; 1 bytes 
                           000003   876 	VSIZE=INT_SIZE+1
      000DC0                        877 condition:
      000DC0                        878 	_vars VSIZE 
      009A2E 51 1E            [ 2]    1     sub sp,#VSIZE 
      009A30 01 17 01         [ 4]  879 	call and_cond
      000DC5                        880 	_i16_store B1
      009A33 13 01            [ 2]    1     ldw (B1,sp),x 
      000DC7                        881 1$:	_next_token 
      000DC7                          1         _get_char 
      009A35 2F 0A            [ 1]    1         ld a,(y)    ; 1 cy 
      009A37 26 14            [ 1]    2         incw y      ; 1 cy 
      009A39 7B 05            [ 1]  882 	cp a,#OR_IDX  
      009A3B A1 13            [ 1]  883 	jreq 2$
      000DCF                        884 	_unget_token 
      009A3D 2A 21            [ 2]    1         decw y
      009A3F 20 1A            [ 2]  885 	jra 9$ 
      009A41 6B 03            [ 1]  886 2$:	ld (OP,sp),a ; boolean operator  
      009A41 7B 05 A1         [ 4]  887 	call and_cond
      009A44 13 27            [ 1]  888 	ld a,(OP,sp)
      000DDA                        889 4$: ; B1 = B1 OR X   
      009A46 14               [ 1]  890 	rlwa x 
      009A47 A1 10            [ 1]  891 	or a,(B1,SP)
      009A49 27               [ 1]  892 	rlwa x 
      009A4A 10 20            [ 1]  893 	or a,(B1+1,SP) 
      009A4C 0A               [ 1]  894 	rlwa x 
      009A4D 20 07            [ 2]  895 	jra 6$  
      000DE3                        896 5$: ; B1 = B1 XOR X 
      009A4D 7B               [ 1]  897 	RLWA X 
      009A4E 05 A1            [ 1]  898 	XOR A,(B1,SP)
      009A50 14               [ 1]  899 	RLWA X 
      009A51 27 08            [ 1]  900 	XOR A,(B1+1,SP)
      009A53 A1               [ 1]  901 	RLWA X 
      000DEA                        902 6$: 
      000DEA                        903 	_i16_store B1 
      009A54 12 27            [ 2]    1     ldw (B1,sp),x 
      009A56 04 D9            [ 2]  904 	jra 1$ 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 100.
Hexadecimal [24-Bits]



      009A57                        905 9$:	 
      000DEE                        906 	_i16_fetch B1 ; result in X 
      009A57 A1 15            [ 2]    1     ldw x,(B1,sp)
      000DF0                        907 	_drop VSIZE
      009A59 26 05            [ 2]    1     addw sp,#VSIZE 
      009A5B 81               [ 4]  908 	ret 
                                    909 
                                    910 ;-----------------------------
                                    911 ; BASIC: LET var=expr 
                                    912 ; variable assignement 
                                    913 ; output:
                                    914 ;-----------------------------
                           000001   915 	VAR_ADR=1  ; 2 bytes 
                           000003   916 	VALUE=VAR_ADR+2 ;INT_SIZE 
                           000004   917 	VSIZE=2*INT_SIZE 
      000DF3                        918 kword_let::
      000DF3                        919 	_vars VSIZE 
      009A5B AE FF            [ 2]    1     sub sp,#VSIZE 
      000DF5                        920 	_next_token ; VAR_IDX || STR_VAR_IDX 
      000DF5                          1         _get_char 
      009A5D FF 20            [ 1]    1         ld a,(y)    ; 1 cy 
      009A5F 01 5C            [ 1]    2         incw y      ; 1 cy 
      009A60 A1 09            [ 1]  921 	cp a,#VAR_IDX
      009A60 5F 09            [ 1]  922 	jreq let_int_var
      009A61 A1 0A            [ 1]  923 	cp a,#STR_VAR_IDX 
      009A61 16 03            [ 1]  924 	jreq let_string
      009A63 20 02 81         [ 2]  925 	jp syntax_error
      009A65                        926 kword_let2: 	
      000E04                        927 	_vars VSIZE 
      009A65 1E 01            [ 2]    1     sub sp,#VSIZE 
      009A67                        928 let_int_var:
      009A67 5B 05 81         [ 4]  929 	call get_var_adr  
      009A6A CD 0F E3         [ 4]  930 	call get_array_adr
      009A6A 4B 00            [ 2]  931 	ldw (VAR_ADR,sp),x 
      009A6C 90 F6            [ 1]  932 	ld a,#REL_EQU_IDX 
      009A6E 90 5C A1         [ 4]  933 	call expect 
                                    934 ; var assignment 
      009A71 01 22 03         [ 4]  935 	call condition
      000E16                        936 	_i16_store VALUE
      009A74 CC 96            [ 2]    1     ldw (VALUE,sp),x 
      009A76 73 A1            [ 2]  937 	ldw x,(VAR_ADR,sp) 
      009A78 16 26            [ 1]  938 	ld a,(VALUE,sp)
      009A7A 04               [ 1]  939 	ld (x),a 
      009A7B 03 01            [ 1]  940 	ld a,(VALUE+1,sp)
      009A7D 20 02            [ 1]  941 	ld (1,x),a 
      009A7F                        942 9$: _drop VSIZE 	
      009A7F 90 5A            [ 2]    1     addw sp,#VSIZE 
      009A81                        943 	_next  
      009A81 CD 9A 10         [ 2]    1         jp interp_loop 
                                    944 
                                    945 
                                    946 ;-----------------------
                                    947 ; BASIC: LET l$="string" 
                                    948 ;        ||  l$="string"
                                    949 ;------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 101.
Hexadecimal [24-Bits]



                           000001   950 	TEMP=1 ; temporary storage 
                           000003   951 	DEST_SIZE=TEMP+2 
                           000005   952 	DEST_ADR=DEST_SIZE+2  
                           000007   953 	DEST_LEN=DEST_ADR+2 
                           000009   954 	SRC_ADR=DEST_LEN+2 
                           00000B   955 	SIZE=SRC_ADR+2 
                           00000C   956 	VSIZE2=SIZE+1
      009A84                        957 let_string:
      000E26                        958 	_drop VSIZE
      009A84 0D 01            [ 2]    1     addw sp,#VSIZE 
      000E28                        959 let_string2:	 
      000E28                        960 	_vars VSIZE2 
      009A86 27 01            [ 2]    1     sub sp,#VSIZE2 
      009A88 53 0B            [ 1]  961 	clr (SIZE,sp)
      009A89 0F 03            [ 1]  962 	clr (DEST_SIZE,sp)
      009A89 5B 01            [ 1]  963 	clr (DEST_LEN,sp)
      009A8B 81 0F 84         [ 4]  964 	call get_var_adr 
      009A8C 1F 01            [ 2]  965 	ldw (TEMP,sp),x 
      009A8C 52 02            [ 2]  966 	ldw x,(2,x)
      009A8E CD               [ 1]  967 	ld a,(x) ; DIM size 
      009A8F 9A               [ 1]  968 	incw x 
      009A90 6A 1F            [ 2]  969 	ldw (DEST_ADR,sp),x 
      009A92 01 90            [ 1]  970 	ld (DEST_SIZE+1,sp),a 
      009A94 F6 90 5C         [ 4]  971 	call strlen
      009A97 A1               [ 1]  972 	inc a  
      009A98 17 27            [ 1]  973 	ld (DEST_LEN+1,sp),a 
      009A9A 04 90            [ 1]  974 	ld a,(y)
      009A9C 5A 20            [ 1]  975 	cp a,#LPAREN_IDX 
      009A9E 0E CD            [ 1]  976 	jrne 3$ 
      009AA0 9A 6A 02         [ 4]  977 	call expression 
      009AA3 14 01            [ 2]  978 	cpw x,(DEST_LEN,sp)
      009AA5 02 14            [ 2]  979 	jrule 2$
      009AA7 02 02            [ 1]  980 	ld a,#ERR_STR_OVFL
      009AA9 1F 01 20         [ 2]  981 	jp tb_error 
      000E55                        982 2$:  
      009AAC E6               [ 2]  983 	decw x 
      009AAD 1F 01            [ 2]  984 	ldw (TEMP,sp),x 
      009AAD 1E 01 5B         [ 2]  985 	addw x,(DEST_ADR,sp)
      009AB0 02 81            [ 2]  986 	ldw (DEST_ADR,sp),x
      009AB2                        987 3$: ; space left in string space 
      009AB2 52 03            [ 2]  988 	ldw x,(DEST_SIZE,sp)
      009AB4 CD 9A 8C         [ 2]  989 	subw x,(TEMP,sp)
      009AB7 1F 01            [ 2]  990 	ldw (DEST_SIZE,sp),x 
                                    991 ; left side of '=' evaluated 
                                    992 ; expect '=' 
      009AB9 90 F6            [ 1]  993 	ld a,#REL_EQU_IDX 
      009ABB 90 5C A1         [ 4]  994 	call expect 
                                    995 ; evaluate right side 
                                    996 ; it may be:
                                    997 ;    string expression 
                                    998 ;    CHR$(expr) 
      000E69                        999 	_next_token 
      000E69                          1         _get_char 
      009ABE 18 27            [ 1]    1         ld a,(y)    ; 1 cy 
      009AC0 04 90            [ 1]    2         incw y      ; 1 cy 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 102.
Hexadecimal [24-Bits]



      009AC2 5A 20            [ 1] 1000 	cp a,#QUOTE_IDX
      009AC4 1B 6B            [ 1] 1001 	jrne 4$
      009AC6 03               [ 1] 1002 	ldw x,y
      009AC7 CD 9A            [ 2] 1003 	ldw (SRC_ADR,sp),x  
      009AC9 8C 7B 03         [ 4] 1004 	call strlen  ; copy count 
      009ACC 6B 0C            [ 1] 1005 	ld (SIZE+1,sp),a
      009ACC 02 1A 01         [ 2] 1006 	addw y,(SIZE,sp)
      009ACF 02 1A            [ 1] 1007 	incw y 
      009AD1 02 02            [ 2] 1008 	ldw x,(DEST_SIZE,sp)
      009AD3 20 07            [ 2] 1009 	cpw x,(SIZE,sp) 
      009AD5 24 05            [ 1] 1010 	jruge 1$ 
      009AD5 02 18            [ 1] 1011 0$:	ld a,#ERR_STR_OVFL 
      009AD7 01 02 18         [ 2] 1012 	jp tb_error 
      000E89                       1013 1$: 
      009ADA 02 02            [ 2] 1014 	ldw x,(SIZE,sp) 
      009ADC                       1015 	_strxz acc16 
      009ADC 1F 01                    1     .byte 0xbf,acc16 
      009ADE 20 D9            [ 2] 1016 	jra 5$ 
      009AE0                       1017 4$: 
                                   1018 	; VAR$ expression 
      009AE0 1E 01            [ 1] 1019 	cp a,#STR_VAR_IDX
      009AE2 5B 03            [ 1] 1020 	jrne 42$  
      009AE4 81 0F 84         [ 4] 1021 	call get_var_adr 
      009AE5 CD 0E D6         [ 4] 1022 	call get_string_slice
      009AE5 52 04            [ 2] 1023 	ldw (SRC_ADR,sp),x   
      000E9B                       1024 	_clrz acc16 
      009AE7 90 F6                    1     .byte 0x3f, acc16 
      000E9D                       1025 	_straz acc8 
      009AE9 90 5C                    1     .byte 0xb7,acc8 
      009AEB A1 09            [ 1] 1026 	ld (SIZE+1,sp),a 
      009AED 27 09            [ 1] 1027 	cp a,(DEST_SIZE+1,sp)
      009AEF A1 0A            [ 1] 1028 	jrugt 0$
      009AF1 27 25            [ 2] 1029 	jra 5$ 
      009AF3 CC 96            [ 1] 1030 42$: cp a,#CHAR_IDX 
      009AF5 73 03            [ 1] 1031 	jreq 44$ 
      009AF6 CC 09 81         [ 2] 1032 	jp syntax_error 
      000EAE                       1033 44$: _call_code 
      000EAE                          1         _code_addr  ; 6 cy  
      009AF6 52               [ 1]    1         clrw x   ; 1 cy 
      009AF7 04               [ 1]    2         ld xl,a  ; 1 cy 
      009AF8 58               [ 2]    3         sllw x   ; 2 cy 
      009AF8 CD 9C 76         [ 2]    4         ldw x,(code_addr,x) ; 2 cy 
      009AFB CD               [ 4]    2         call (x)    ; 4 cy 
      009AFC 9C               [ 1] 1034 	ld a,xl 
      009AFD D5 1F            [ 1] 1035 	and a,#127 
      009AFF 01 A6            [ 2] 1036 	ldw x,(DEST_ADR,sp)
      009B01 11               [ 1] 1037 	tnz (x)
      009B02 CD 98            [ 1] 1038 	jrne 46$ 
      009B04 CC CD            [ 1] 1039 	clr (1,x)
      000EBF                       1040 46$:	
      009B06 9A               [ 1] 1041 	ld (x),a 
      009B07 B2 1F            [ 2] 1042 	jra 9$  
      000EC2                       1043 5$:
      009B09 03 1E            [ 2] 1044 	ldw x,(DEST_ADR,sp) 
      009B0B 01 7B            [ 2] 1045 	ldw (TEMP,sp),y ; save basic pc   
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 103.
Hexadecimal [24-Bits]



      009B0D 03 F7            [ 2] 1046 	ldw y,(SRC_ADR,sp)
      009B0F 7B 04 E7         [ 4] 1047 	call move 
      009B12 01 5B 04         [ 2] 1048 	addw x,(SIZE,sp)
      009B15 CC               [ 1] 1049 	clr (x)
      000ECF                       1050 6$: 
      009B16 97 DC            [ 2] 1051 	ldw y,(TEMP,sp) ; restore basic pc 
      009B18                       1052 9$:	_drop VSIZE2 
      009B18 5B 04            [ 2]    1     addw sp,#VSIZE2 
      009B1A                       1053 	_next 
      009B1A 52 0C 0F         [ 2]    1         jp interp_loop 
                                   1054 
                                   1055 ;----------------------
                                   1056 ; extract a slice 
                                   1057 ; from string variable
                                   1058 ; str(val1[,val2]) 
                                   1059 ; or complete string 
                                   1060 ; if no indices 
                                   1061 ; input:
                                   1062 ;   X     var_adr
                                   1063 ;   Y     point to (expr,expr)
                                   1064 ;   ptr16 destination
                                   1065 ; ouput:
                                   1066 ;   A    slice length 
                                   1067 ;   X    slice address   
                                   1068 ;----------------------
                           000001  1069 	VAL2=1 
                           000003  1070 	VAL1=VAL2+INT_SIZE 
                           000005  1071 	CHAR_ARRAY=VAL1+INT_SIZE 
                           000007  1072 	RES_LEN=CHAR_ARRAY+INT_SIZE  
                           000009  1073 	YTEMP=RES_LEN+INT_SIZE 
                           000008  1074 	VSIZE=4*INT_SIZE 
      000ED6                       1075 get_string_slice:
      000ED6                       1076 	_vars VSIZE
      009B1D 0B 0F            [ 2]    1     sub sp,#VSIZE 
      009B1F 03 0F            [ 1] 1077 	clr (RES_LEN,sp)
      009B21 07 CD            [ 2] 1078 	ldw x,(2,x) ; char array 
      009B23 9C 76            [ 2] 1079 	ldw (CHAR_ARRAY,sp),x 
      009B25 1F               [ 1] 1080 	ld a,(x)
      009B26 01 EE            [ 1] 1081 	ld (RES_LEN+1,sp),a ; reserved space  
                                   1082 ; default slice to entire string 
      009B28 02 F6            [ 1] 1083 	clr (VAL1,sp)
      009B2A 5C 1F            [ 1] 1084 	ld a,#1 
      009B2C 05 6B            [ 1] 1085 	ld (VAL1+1,sp),a
      009B2E 04 CD            [ 1] 1086 	clr (VAL2,sp)
      009B30 88               [ 1] 1087 	incw x 
      009B31 94 4C 6B         [ 4] 1088 	call strlen
      009B34 08 90            [ 1] 1089 	ld (VAL2+1,sp),a 
      009B36 F6 A1            [ 1] 1090 	ld a,(y)
      009B38 04 26            [ 1] 1091 	cp a,#LPAREN_IDX 
      009B3A 14 CD            [ 1] 1092 	jreq 1$
      009B3C 99 D4            [ 2] 1093 	jra 4$  
      000EF7                       1094 1$:  
      009B3E 13 07            [ 1] 1095 	incw y 
      009B40 23 05 A6         [ 4] 1096 	call expression
      009B43 0E CC 96         [ 2] 1097 	cpw x,#1 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 104.
Hexadecimal [24-Bits]



      009B46 75 05            [ 1] 1098 	jrpl 2$ 
      009B47 A6 0E            [ 1] 1099 0$:	ld a,#ERR_STR_OVFL 
      009B47 5A 1F 01         [ 2] 1100 	jp tb_error 
      009B4A 72 FB            [ 2] 1101 2$:	cpw x,(VAL2,sp)
      009B4C 05 1F            [ 1] 1102 	jrugt 0$
      009B4E 05 03            [ 2] 1103 	ldw (VAL1,sp),x 
      009B4F 90 F6            [ 1] 1104 	ld a,(y)
      009B4F 1E 03            [ 1] 1105 	cp a,#RPAREN_IDX 
      009B51 72 F0            [ 1] 1106 	jrne 3$
      009B53 01 1F            [ 1] 1107 	incw y 
      009B55 03 A6            [ 2] 1108 	jra 4$
      000F16                       1109 3$: 
      009B57 11 CD            [ 1] 1110 	ld a,#COMMA_IDX 
      009B59 98 CC 90         [ 4] 1111 	call expect 
      009B5C F6 90 5C         [ 4] 1112 	call expression 
      009B5F A1 06            [ 2] 1113 	cpw x,(VAL2,sp)
      009B61 26 1E            [ 1] 1114 	jrugt 0$ 
      009B63 93 1F            [ 2] 1115 	ldw (VAL2,sp),x
      009B65 09 CD            [ 1] 1116 	ld a,#RPAREN_IDX 
      009B67 88 94 6B         [ 4] 1117 	call expect 
      000F29                       1118 4$: ; length and slice address 
      009B6A 0C 72            [ 2] 1119 	ldw x,(VAL2,sp)
      009B6C F9 0B 90         [ 2] 1120 	subw x,(VAL1,sp)
      009B6F 5C               [ 1] 1121 	incw x 
      009B70 1E               [ 1] 1122 	ld a,xl ; slice length 
      009B71 03 13            [ 2] 1123 	ldw x,(CHAR_ARRAY,sp)
      009B73 0B 24 05         [ 2] 1124 	addw x,(VAL1,sp)
      000F35                       1125 	_drop VSIZE 
      009B76 A6 0E            [ 2]    1     addw sp,#VSIZE 
      009B78 CC               [ 4] 1126 	ret 
                                   1127 
                                   1128 
                                   1129 ;-----------------------
                                   1130 ; allocate data space 
                                   1131 ; on heap 
                                   1132 ; reserve to more bytes 
                                   1133 ; than required 
                                   1134 ; input: 
                                   1135 ;    X     size 
                                   1136 ; output:
                                   1137 ;    X     addr 
                                   1138 ;------------------------
      000F38                       1139 heap_alloc:
      009B79 96 75 02         [ 2] 1140 	addw x,#2 
      009B7B 89               [ 2] 1141 	pushw x 
      009B7B 1E 0B BF         [ 2] 1142 	ldw x,heap_free 
      009B7E 15 20 33 3F      [ 2] 1143 	subw x,dvar_end 
      009B81 13 01            [ 2] 1144 	cpw x,(1,sp)
      009B81 A1 0A            [ 1] 1145 	jruge 1$
      009B83 26 14            [ 1] 1146 	ld a,#ERR_MEM_FULL 
      009B85 CD 9C 76         [ 2] 1147 	jp tb_error 
      009B88 CD 9B C8         [ 2] 1148 1$: ldw x,heap_free 
      009B8B 1F 09 3F         [ 2] 1149 	subw x,(1,sp)
      000F52                       1150 	_strxz heap_free 
      009B8E 15 B7                    1     .byte 0xbf,heap_free 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 105.
Hexadecimal [24-Bits]



      000F54                       1151 	_drop 2 
      009B90 16 6B            [ 2]    1     addw sp,#2 
      009B92 0C               [ 4] 1152 	ret 
                                   1153 
                                   1154 ;---------------------------
                                   1155 ; create scalar variable 
                                   1156 ; and initialize to 0.
                                   1157 ; abort program if mem full 
                                   1158 ; input:
                                   1159 ;   x    var_name 
                                   1160 ; output:
                                   1161 ;   x    var_addr 
                                   1162 ;-----------------------------
                           000001  1163 	VNAME=1 
                           000002  1164 	VSIZE=2 
      000F57                       1165 create_var:
      000F57                       1166 	_vars VSIZE 
      009B93 11 04            [ 2]    1     sub sp,#VSIZE 
      009B95 22 DF            [ 2] 1167 	ldw (VNAME,sp),x 
      009B97 20 1B A1         [ 2] 1168 	ldw x,heap_free 
      009B9A 2E 27 03 CC      [ 2] 1169 	subw x,dvar_end 
      009B9E 96 73 5F         [ 2] 1170 	cpw x,#4 
      009BA1 97 58            [ 1] 1171 	jruge 1$ 
      009BA3 DE 8C            [ 1] 1172 	ld a,#ERR_MEM_FULL
      009BA5 F2 FD 9F         [ 2] 1173 	jp tb_error 
      000F6C                       1174 1$: 
      009BA8 A4 7F 1E         [ 2] 1175 	ldw x,dvar_end 
      009BAB 05 7D            [ 1] 1176 	ld a,(VNAME,sp)
      009BAD 26               [ 1] 1177 	ld (x),a 
      009BAE 02 6F            [ 1] 1178 	ld a,(VNAME+1,sp)
      009BB0 01 01            [ 1] 1179 	ld (1,x),a 
      009BB1 6F 02            [ 1] 1180 	clr (2,x)
      009BB1 F7 20            [ 1] 1181 	clr (3,x)
      009BB3 0F               [ 2] 1182 	pushw x 
      009BB4 1C 00 04         [ 2] 1183 	addw x,#4 
      000F7E                       1184 	_strxz dvar_end 
      009BB4 1E 05                    1     .byte 0xbf,dvar_end 
      009BB6 17               [ 2] 1185 	popw x ; var address 
      000F81                       1186 	_drop VSIZE  
      009BB7 01 16            [ 2]    1     addw sp,#VSIZE 
      009BB9 09               [ 4] 1187 	ret 
                                   1188 
                                   1189 ;------------------------
                                   1190 ; last token was VAR_IDX 
                                   1191 ; next is VAR_NAME 
                                   1192 ; extract name
                                   1193 ; search var 
                                   1194 ; return data field address 
                                   1195 ; input:
                                   1196 ;   Y      *var_name 
                                   1197 ; output:
                                   1198 ;   y       Y+2 
                                   1199 ;   X       var address
                                   1200 ; ------------------------
                           000001  1201 	F_ARRAY=1
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 106.
Hexadecimal [24-Bits]



                           000002  1202 	VNAME=2 
                           000003  1203 	VSIZE=3 
      000F84                       1204 get_var_adr:
      000F84                       1205 	_vars VSIZE
      009BBA CD 88            [ 2]    1     sub sp,#VSIZE 
      009BBC BE 72            [ 1] 1206 	clr (F_ARRAY,sp)
      000F88                       1207 	_get_word 
      000F88                          1         _get_addr
      009BBE FB               [ 1]    1         ldw x,y     ; 1 cy 
      009BBF 0B               [ 2]    2         ldw x,(x)   ; 2 cy 
      009BC0 7F A9 00 02      [ 2]    3         addw y,#2   ; 2 cy 
      009BC1 1F 02            [ 2] 1208 	ldw (VNAME,sp),x 
      009BC1 16 01            [ 1] 1209 	ld a,(y) 
      009BC3 5B 0C            [ 1] 1210 	cp a,#LPAREN_IDX 
      009BC5 CC 97            [ 1] 1211 	jrne 1$ 
      009BC7 DC 01            [ 1] 1212 	cpl (F_ARRAY,sp)
      009BC8 9E               [ 1] 1213 	ld  a,xh 
      009BC8 52 08            [ 1] 1214 	or a,#128 
      009BCA 0F               [ 1] 1215 	ld xh,a 
      009BCB 07 EE            [ 1] 1216 	ld (VNAME,sp),a 
      000F9E                       1217 1$: 
      009BCD 02 1F 05         [ 4] 1218 	call search_var
      009BD0 F6               [ 2] 1219 	tnzw x 
      009BD1 6B 08            [ 1] 1220 	jrne 9$ ; found 
                                   1221 ; not found, if scalar create it 
      009BD3 0F 03            [ 1] 1222 	tnz (F_ARRAY,sp)
      009BD5 A6 01            [ 1] 1223 	jreq 2$ 
                                   1224 ; this array doesn't exist
                                   1225 ; check for var(1) form 
      009BD7 6B 04 0F         [ 4] 1226 	call check_for_idx_1
      000FAB                       1227 2$:	 	
      009BDA 01 5C            [ 1] 1228 	ld a,(VNAME+1,sp)
      009BDC CD 88            [ 1] 1229 	cp a,#'$ 
      009BDE 94 6B            [ 1] 1230 	jrne 8$
      009BE0 02 90            [ 1] 1231 	ld a,#ERR_DIM 
      009BE2 F6 A1 04         [ 2] 1232 	jp tb_error
      000FB6                       1233 8$:	
      009BE5 27 02            [ 2] 1234 	ldw x,(VNAME,sp)
                                   1235 ; it's not an array 
      009BE7 20               [ 1] 1236 	ld a,xh 
      009BE8 32 7F            [ 1] 1237 	and a,#127 
      009BE9 95               [ 1] 1238 	ld xh,a 
      009BE9 90 5C CD         [ 4] 1239 	call create_var	
      000FBF                       1240 9$:
      000FBF                       1241 	_drop VSIZE 
      009BEC 99 D4            [ 2]    1     addw sp,#VSIZE 
      009BEE A3               [ 4] 1242 	ret 
                                   1243 
                                   1244 ;-------------------------
                                   1245 ; a scalar variable can be 
                                   1246 ; addressed as var(1)
                                   1247 ; check for it 
                                   1248 ; fail if not that form 
                                   1249 ; input: 
                                   1250 ;   X     var address 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 107.
Hexadecimal [24-Bits]



                                   1251 ;   Y     *next token after varname
                                   1252 ;-------------------------
      000FC2                       1253 check_for_idx_1: 
      009BEF 00 01 2A         [ 2] 1254 	addw x,#2 ; 
      009BF2 05               [ 2] 1255 	pushw x ; save value  
      009BF3 A6 0E            [ 1] 1256 	ld a,(y)
      009BF5 CC 96            [ 1] 1257 	cp a,#LPAREN_IDX 
      009BF7 75 13            [ 1] 1258 	jrne 3$ 
      009BF9 01 22 F7         [ 4] 1259 	call func_args 
      009BFC 1F 03            [ 1] 1260 	cp a,#1 
      009BFE 90 F6            [ 1] 1261 	jreq 2$
      009C00 A1 05 26         [ 2] 1262 1$:	jp syntax_error  
      000FD6                       1263 2$:
      000FD6                       1264 	_i16_pop 
      009C03 04               [ 2]    1     popw x 
      009C04 90 5C 20         [ 2] 1265 	cpw x,#1 
      009C07 13 05            [ 1] 1266 	jreq 3$
      009C08 A6 0D            [ 1] 1267 	ld a,#ERR_RANGE  
      009C08 A6 02 CD         [ 4] 1268 	call tb_error  
      000FE1                       1269 3$:
      009C0B 98               [ 2] 1270 	popw x 
      009C0C CC               [ 4] 1271     ret 
                                   1272 
                                   1273 
                                   1274 ;--------------------------
                                   1275 ; get array element address
                                   1276 ; input:
                                   1277 ;   X     var addr  
                                   1278 ; output:
                                   1279 ;    X     element address 
                                   1280 ;---------------------------
                           000001  1281 	IDX=1 
                           000003  1282 	SIZE_FIELD=IDX+INT_SIZE 
                           000004  1283 	VSIZE=2*INT_SIZE 
      000FE3                       1284 get_array_adr:
      000FE3                       1285 	_vars VSIZE
      009C0D CD 99            [ 2]    1     sub sp,#VSIZE 
      009C0F D4               [ 1] 1286 	tnz (x)
      009C10 13 01            [ 1] 1287 	jrmi 10$ 
                                   1288 ; scalar data field follow name
                                   1289 ; check for 'var(1)' format 	
      009C12 22 DF 1F         [ 4] 1290 	call check_for_idx_1
      009C15 01 A6            [ 2] 1291 	jra 9$ 
      000FED                       1292 10$:	 
      009C17 05 CD            [ 2] 1293 	ldw x,(2,x) ; array data address 
      009C19 98 CC            [ 2] 1294 	ldw (SIZE_FIELD,sp),x ; array size field 
      009C1B 90 F6            [ 1] 1295 	ld a,(y)
      009C1B 1E 01            [ 1] 1296 	cp a,#LPAREN_IDX  
      009C1D 72 F0            [ 1] 1297 	jreq 0$ 
      009C1F 03 5C 9F         [ 2] 1298 	addw x,#2 
      009C22 1E 05            [ 2] 1299 	jra 9$ 
      000FFC                       1300 0$:
      009C24 72 FB 03         [ 4] 1301 	call func_args 
      009C27 5B 08            [ 1] 1302 	cp a,#1 
      009C29 81 03            [ 1] 1303 	jreq 1$ 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 108.
Hexadecimal [24-Bits]



      009C2A CC 09 81         [ 2] 1304 	jp syntax_error 
      001006                       1305 1$: _i16_pop 
      009C2A 1C               [ 2]    1     popw x 
      009C2B 00               [ 2] 1306 	tnzw x 
      009C2C 02 89            [ 1] 1307 	jreq 2$ 
      009C2E CE 00            [ 2] 1308 	ldw (IDX,sp),x 
      009C30 41 72            [ 2] 1309 	ldw x,(SIZE_FIELD,sp)
      009C32 B0               [ 2] 1310 	ldw x,(x) ; array size 
      009C33 00 3F            [ 2] 1311 	cpw x,(IDX,sp)
      009C35 13 01            [ 1] 1312 	jrpl 3$ 
      001013                       1313 2$: 
      009C37 24 05            [ 1] 1314 	ld a,#ERR_RANGE 
      009C39 A6 0A CC         [ 2] 1315 	jp tb_error 
      001018                       1316 3$: 
      009C3C 96 75            [ 2] 1317 	ldw x,(IDX,sp) 
      009C3E CE               [ 2] 1318 	sllw x ; 2*IDX  
      009C3F 00 41 72         [ 2] 1319 	addw x,(SIZE_FIELD,sp)
      00101E                       1320 9$:
      00101E                       1321 	_drop VSIZE 
      009C42 F0 01            [ 2]    1     addw sp,#VSIZE 
      009C44 BF               [ 4] 1322 	ret 
                                   1323 
                                   1324 ;-----------------------
                                   1325 ; get string reserved 
                                   1326 ; space 
                                   1327 ; input:
                                   1328 ;   X     string data pointer 
                                   1329 ; output:
                                   1330 ;   X      space 
                                   1331 ;-----------------------------
      001021                       1332 get_string_space:
      009C45 41               [ 2] 1333 	ldw x,(x) ; data address 
      009C46 5B               [ 1] 1334 	ld a,(x) ; space size 
      009C47 02               [ 1] 1335 	clrw x
      009C48 81               [ 1] 1336 	ld xl,a 
      009C49 81               [ 4] 1337 	ret 
                                   1338 
                                   1339 ;--------------------------
                                   1340 ; search dim var_name 
                                   1341 ; format of record 
                                   1342 ;  field | size 
                                   1343 ;------------------- 
                                   1344 ;  name | {2} byte, for array bit 15 of name is set
                                   1345 ;  data:  
                                   1346 ;  	integer | INT_SIZE 
                                   1347 ;  	str   | len(str)+1, counted string 
                                   1348 ;  	array | size=2 byte, data=size*INT_SIZE   
                                   1349 ;  
                                   1350 ; input:
                                   1351 ;    X     name
                                   1352 ; output:
                                   1353 ;    X     address|0
                                   1354 ; use:
                                   1355 ;   A,Y, acc16 
                                   1356 ;-------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 109.
Hexadecimal [24-Bits]



                           000001  1357 	VAR_NAME=1 ; target name pointer 
                                   1358 ;	WLKPTR=VAR_NAME+2   ; walking pointer in RAM 
                           000003  1359 	SKIP=VAR_NAME+2
                           000004  1360 	VSIZE=SKIP+1  
      001026                       1361 search_var:
      009C49 52 02            [ 2] 1362 	pushw y 
      001028                       1363 	_vars VSIZE
      009C4B 1F 01            [ 2]    1     sub sp,#VSIZE 
                                   1364 ; reset bit 7 
      009C4D CE               [ 1] 1365 	ld a,xh 
      009C4E 00 41            [ 1] 1366 	and a,#127
      009C50 72               [ 1] 1367     ld xh,a 
      009C51 B0 00            [ 2] 1368 	ldw (VAR_NAME,sp),x
      009C53 3F A3 00 04      [ 2] 1369 	ldw y,dvar_bgn
      001034                       1370 1$:	
      009C57 24 05 A6 0A      [ 2] 1371 	cpw y, dvar_end
      009C5B CC 96            [ 1] 1372 	jrpl 7$ ; no match found 
      009C5D 75               [ 1] 1373 	ldw x,y 
      009C5E FE               [ 2] 1374 	ldw x,(x)
                                   1375 ; reset bit 7 
      009C5E CE               [ 1] 1376 	ld a,xh 
      009C5F 00 3F            [ 1] 1377 	and a,#127
      009C61 7B               [ 1] 1378     ld xh,a 
      009C62 01 F7            [ 2] 1379 	cpw x,(VAR_NAME,sp)
      009C64 7B 02            [ 1] 1380 	jreq 8$ ; match  
                                   1381 ; skip this one 	
      009C66 E7 01 6F 02      [ 2] 1382 	addw y,#4 
      009C6A 6F 03            [ 2] 1383 	jra 1$ 
      009C6C 89 1C            [ 1] 1384 	ld a,(y)
      00104C                       1385 7$: ; no match found 
      009C6E 00 04            [ 1] 1386 	clrw y 
      00104E                       1387 8$: ; match found 
      009C70 BF               [ 1] 1388 	ldw x,y  ; variable address 
      00104F                       1389 9$:	_DROP VSIZE
      009C71 3F 85            [ 2]    1     addw sp,#VSIZE 
      009C73 5B 02            [ 2] 1390 	popw y 
      009C75 81               [ 4] 1391 	ret 
                                   1392 
                                   1393 ;---------------------------------
                                   1394 ; BASIC: DIM var_name(expr) [,var_name(expr)]* 
                                   1395 ; create named variables at end 
                                   1396 ; of BASIC program. 
                                   1397 ; value are not initialized 
                                   1398 ; bit 7 of first character of name 
                                   1399 ; is set for string and array variables 
                                   1400 ;---------------------------------
                           000001  1401 	HEAP_ADR=1 
                           000003  1402 	DIM_SIZE=HEAP_ADR+ADR_SIZE 
                           000005  1403 	VAR_NAME=DIM_SIZE+INT_SIZE
                           000007  1404 	VAR_ADR=VAR_NAME+NAME_SIZE  
                           000009  1405 	VAR_TYPE=VAR_ADR+ADR_SIZE 
                           000009  1406 	VSIZE=4*INT_SIZE+1 
      009C76                       1407 kword_dim:
      001054                       1408 	_vars VSIZE
      009C76 52 03            [ 2]    1     sub sp,#VSIZE 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 110.
Hexadecimal [24-Bits]



      001056                       1409 dim_next: 
      001056                       1410 	_next_token
      001056                          1         _get_char 
      009C78 0F 01            [ 1]    1         ld a,(y)    ; 1 cy 
      009C7A 93 FE            [ 1]    2         incw y      ; 1 cy 
      009C7C 72 A9            [ 1] 1411 	ld (VAR_TYPE,sp),a 
      009C7E 00               [ 1] 1412 	ldw x,y 
      009C7F 02 1F 02 90      [ 2] 1413 	addw y,#2 
      009C83 F6               [ 2] 1414 	ldw x,(x) ; var name 
                                   1415 ; set bit 7 for string or array 
      009C84 A1               [ 1] 1416 	ld a,xh 
      009C85 04 26            [ 1] 1417 	or a,#128 
      009C87 08               [ 1] 1418 	ld xh,a 
      009C88 03 01            [ 2] 1419 	ldw (VAR_NAME,sp),x 
      009C8A 9E AA 80         [ 4] 1420 	call search_var  
      009C8D 95               [ 2] 1421 	tnzw x 
      009C8E 6B 02            [ 1] 1422 	jreq 1$ ; doesn't exist 
                                   1423 ; if string or integer array 
                                   1424 ; abort with error 
      009C90 1F 07            [ 2] 1425 	ldw (VAR_ADR,sp),x
      009C90 CD               [ 1] 1426 	tnz (x)
      009C91 9D 18            [ 1] 1427 	jrpl 0$  ; it is a scalar will be transformed in array 
      009C93 5D 26            [ 1] 1428 	ld a,#ERR_DIM ; string or array already exist 
      009C95 1B 0D 01         [ 2] 1429 	jp tb_error
      009C98 27 03            [ 1] 1430 0$: or a,#128 ; make it array  
      009C9A CD               [ 1] 1431 	ld (x),a 
      009C9B 9C B4            [ 2] 1432 	jra 2$ 	
      009C9D                       1433 1$:
      009C9D 7B 03            [ 2] 1434 	ldw x,(VAR_NAME,sp)
      009C9F A1 24 26         [ 4] 1435 	call create_var
      009CA2 05 A6            [ 2] 1436 	ldw (VAR_ADR,sp),x  
      001084                       1437 2$: 
      009CA4 0C CC 96         [ 4] 1438 	call func_args 
      009CA7 75 01            [ 1] 1439 	cp a,#1
      009CA8 27 03            [ 1] 1440 	jreq 21$
      009CA8 1E 02 9E         [ 2] 1441 	jp syntax_error 
      00108E                       1442 21$: _i16_pop 
      009CAB A4               [ 2]    1     popw x 
      009CAC 7F 95            [ 2] 1443 	ldw (DIM_SIZE,sp),x 
      009CAE CD 9C 49         [ 2] 1444 	cpw x,#1 
      009CB1 2A 05            [ 1] 1445 	jrpl 4$ 
      001096                       1446 3$:
      009CB1 5B 03            [ 1] 1447 	ld a,#ERR_RANGE ; array or string must be 1 or more  
      009CB3 81 09 83         [ 2] 1448 	jp tb_error 
      009CB4 7B 09            [ 1] 1449 4$: ld a,(VAR_TYPE,sp)
      009CB4 1C 00            [ 1] 1450 	cp a,#VAR_IDX 
      009CB6 02 89            [ 1] 1451 	jreq 5$ 
      009CB8 90 F6 A1         [ 2] 1452 	cpw x,#256 
      009CBB 04 26            [ 1] 1453 	jrmi 42$ ; string too big
                                   1454 ; remove created var 
      0010A6                       1455 	_ldxz dvar_end 
      009CBD 15 CD                    1     .byte 0xbe,dvar_end 
      009CBF 98 DA A1         [ 2] 1456 	subw x,#4 
      0010AB                       1457 	_strxz dvar_end 
      009CC2 01 27                    1     .byte 0xbf,dvar_end 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 111.
Hexadecimal [24-Bits]



      009CC4 03 CC            [ 1] 1458 	ld a,#ERR_GT255
      009CC6 96 73 83         [ 2] 1459 	jp tb_error
      009CC8                       1460 42$:
      009CC8 85 A3 00         [ 4] 1461 	call heap_alloc 
      009CCB 01 27            [ 2] 1462 	ldw (HEAP_ADR,sp),x 
                                   1463 ; put size in high byte 
                                   1464 ; 0 in low byte  
      009CCD 05 A6            [ 1] 1465 	ld a,(DIM_SIZE+1,sp)
      009CCF 0D CD            [ 1] 1466 	ld (DIM_SIZE,sp),a  
      009CD1 96 75            [ 1] 1467 	clr (DIM_SIZE+1,sp)
      009CD3 20 06            [ 2] 1468 	jra 7$ 
      0010BF                       1469 5$: ; integer array 
      009CD3 85               [ 2] 1470 	sllw x  
      009CD4 81 0F 38         [ 4] 1471 	call heap_alloc 
      009CD5 1F 01            [ 2] 1472 	ldw (HEAP_ADR,sp),x 
      0010C5                       1473 7$: 	
                                   1474 ; initialize size field 
      009CD5 52 04            [ 1] 1475 	ld a,(DIM_SIZE,sp)
      009CD7 7D               [ 1] 1476 	ld (x),a
      009CD8 2B 05            [ 1] 1477 	ld a,(DIM_SIZE+1,sp) 
      009CDA CD 9C            [ 1] 1478 	ld (1,x),a 
      0010CC                       1479 8$: ; initialize pointer in variable 
      009CDC B4 20            [ 2] 1480 	ldw x,(VAR_ADR,sp)
      009CDE 31 01            [ 1] 1481 	ld a,(HEAP_ADR,sp)
      009CDF E7 02            [ 1] 1482 	ld (2,x),a 
      009CDF EE 02            [ 1] 1483 	ld a,(HEAP_ADR+1,sp)
      009CE1 1F 03            [ 1] 1484 	ld (3,x),a 
      0010D6                       1485 	_next_token 
      0010D6                          1         _get_char 
      009CE3 90 F6            [ 1]    1         ld a,(y)    ; 1 cy 
      009CE5 A1 04            [ 1]    2         incw y      ; 1 cy 
      009CE7 27 05            [ 1] 1486 	cp a,#COMMA_IDX 
      009CE9 1C 00            [ 1] 1487 	jrne 9$
      009CEB 02 20 22         [ 2] 1488 	jp dim_next 
      009CEE                       1489 9$: 
      0010E1                       1490 	_unget_token 	
      009CEE CD 98            [ 2]    1         decw y
      0010E3                       1491 	_drop VSIZE 
      009CF0 DA A1            [ 2]    1     addw sp,#VSIZE 
      0010E5                       1492 	_next 
      009CF2 01 27 03         [ 2]    1         jp interp_loop 
                                   1493 
                                   1494 
                                   1495 ;;;;;;;;;;;;;;;;;;;;;;;;;;
                                   1496 ; return program size 
                                   1497 ;;;;;;;;;;;;;;;;;;;;;;;;;;
      0010E8                       1498 prog_size:
      0010E8                       1499 	_ldxz progend
      009CF5 CC 96                    1     .byte 0xbe,progend 
      009CF7 73 85 5D 27      [ 2] 1500 	subw x,lomem 
      009CFB 09               [ 4] 1501 	ret 
                                   1502 
                                   1503 ;----------------------------
                                   1504 ; print program information 
                                   1505 ;---------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 112.
Hexadecimal [24-Bits]



      0010EF                       1506 program_info: 
      009CFC 1F 01 1E         [ 1] 1507 	push base 
      009CFF 03 FE 13         [ 2] 1508 	ldw x,#PROG_ADDR 
      009D02 01 2A 05         [ 4] 1509 	call puts 
      009D05                       1510 	_ldxz lomem 
      009D05 A6 0D                    1     .byte 0xbe,lomem 
      009D07 CC 96 75 00      [ 1] 1511 	mov base,#16 
      009D0A CD 00 00         [ 4] 1512 	call print_int
      009D0A 1E 01 58 72      [ 1] 1513 	mov base,#10  
      009D0E FB 03 44         [ 2] 1514 	ldw x,#PROG_SIZE
      009D10 CD 00 00         [ 4] 1515 	call puts 
      009D10 5B 04 81         [ 4] 1516 	call prog_size 
      009D13 CD 00 00         [ 4] 1517 	call print_int 
      009D13 FE F6 5F         [ 2] 1518 	ldw x,#STR_BYTES 
      009D16 97 81 00         [ 4] 1519 	call puts
      009D18                       1520 	_ldxz lomem
      009D18 90 89                    1     .byte 0xbe,lomem 
      009D1A 52 04 9E         [ 2] 1521 	cpw x,#app 
      009D1D A4 7F            [ 1] 1522 	jrult 2$
      009D1F 95 1F 01         [ 2] 1523 	ldw x,#FLASH_MEM 
      009D22 90 CE            [ 2] 1524 	jra 3$
      009D24 00 3D 6D         [ 2] 1525 2$: ldw x,#RAM_MEM 	 
      009D26 CD 00 00         [ 4] 1526 3$:	call puts 
      009D26 90 C3            [ 1] 1527 	ld a,#CR 
      009D28 00 3F 2A         [ 4] 1528 	call putc
      009D2B 12 93 FE         [ 1] 1529 	pop base 
      009D2E 9E               [ 4] 1530 	ret 
                                   1531 
      009D2F A4 7F 95 13 01 27 0A  1532 PROG_ADDR: .asciz "program address: "
             72 A9 00 04 20 EA 90
             F6 3A 20 00
      009D3E 2C 20 70 72 6F 67 72  1533 PROG_SIZE: .asciz ", program size: "
             61 6D 20 73 69 7A 65
             3A 20 00
      009D3E 90 5F 79 74 65 73 00  1534 STR_BYTES: .asciz " bytes" 
      009D40 20 69 6E 20 46 4C 41  1535 FLASH_MEM: .asciz " in FLASH memory" 
             53 48 20 6D 65 6D 6F
             72 79 00
      009D40 93 5B 04 90 85 81 4D  1536 RAM_MEM:   .asciz " in RAM memory" 
             20 6D 65 6D 6F 72 79
             00
                                   1537 
                                   1538 
                                   1539 ;----------------------------
                                   1540 ; BASIC: LIST [[start][-end]]
                                   1541 ; list program lines 
                                   1542 ; form start to end 
                                   1543 ; if empty argument list then 
                                   1544 ; list all.
                                   1545 ;----------------------------
                           000001  1546 	FIRST=1
                           000003  1547 	LAST=3 
                           000005  1548 	LN_PTR=5
                           000006  1549 	VSIZE=6
      009D46                       1550 cmd_list:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 113.
Hexadecimal [24-Bits]



      009D46 52 09 E8         [ 4] 1551 	call prog_size 
      009D48 22 03            [ 1] 1552 	jrugt 1$
      009D48 90 F6 90         [ 2] 1553 	jp cmd_line 
      001184                       1554 1$:
      001184                       1555 	 _vars VSIZE
      009D4B 5C 6B            [ 2]    1     sub sp,#VSIZE 
      001186                       1556 	_ldxz lomem 
      009D4D 09 93                    1     .byte 0xbe,lomem 
      009D4F 72 A9            [ 2] 1557 	ldw (LN_PTR,sp),x 
      009D51 00               [ 2] 1558 	ldw x,(x) 
      009D52 02 FE            [ 2] 1559 	ldw (FIRST,sp),x ; list from first line 
      009D54 9E AA 80         [ 2] 1560 	ldw x,#MAX_LINENO ; biggest line number 
      009D57 95 1F            [ 2] 1561 	ldw (LAST,sp),x 
      001192                       1562 	_next_token
      001192                          1         _get_char 
      009D59 05 CD            [ 1]    1         ld a,(y)    ; 1 cy 
      009D5B 9D 18            [ 1]    2         incw y      ; 1 cy 
      009D5D 5D               [ 1] 1563 	tnz a 
      009D5E 27 0F            [ 1] 1564 	jreq print_listing 
      009D60 1F 07            [ 1] 1565 	cp a,#SUB_IDX 
      009D62 7D 2A            [ 1] 1566 	jreq list_to
      009D64 05 A6            [ 2] 1567 	decw y    
      009D66 0C CC 96         [ 4] 1568 	call expect_integer 
      009D69 75 AA            [ 2] 1569 	ldw (FIRST,sp),x	
      0011A4                       1570 	_next_token
      0011A4                          1         _get_char 
      009D6B 80 F7            [ 1]    1         ld a,(y)    ; 1 cy 
      009D6D 20 07            [ 1]    2         incw y      ; 1 cy 
      009D6F 4D               [ 1] 1571 	tnz a 
      009D6F 1E 05            [ 1] 1572 	jrne 2$ 
      009D71 CD 9C            [ 2] 1573 	ldw (LAST,sp),x  
      009D73 49 1F            [ 2] 1574 	jra  print_listing 
      0011AF                       1575 2$: 
      009D75 07 0C            [ 1] 1576 	cp a,#SUB_IDX  
      009D76 27 03            [ 1] 1577 	jreq 3$ 
      009D76 CD 98 DA         [ 2] 1578 	jp syntax_error
      0011B6                       1579 3$: _next_token 
      0011B6                          1         _get_char 
      009D79 A1 01            [ 1]    1         ld a,(y)    ; 1 cy 
      009D7B 27 03            [ 1]    2         incw y      ; 1 cy 
      009D7D CC               [ 1] 1580 	tnz a 
      009D7E 96 73            [ 1] 1581 	jreq print_listing
      009D80 85 1F            [ 2] 1582 	decw y	 
      0011BF                       1583 list_to: ; listing will stop at this line
      009D82 03 A3 00         [ 4] 1584     call expect_integer 
      009D85 01 2A            [ 2] 1585 	ldw (LAST,sp),x
      0011C4                       1586 print_listing:
                                   1587 ; skip lines smaller than FIRST 
      009D87 05 05            [ 2] 1588 	ldw y,(LN_PTR,sp)
      009D88                       1589 	 _clrz acc16 
      009D88 A6 0D                    1     .byte 0x3f, acc16 
      009D8A CC               [ 1] 1590 1$:	ldw x,y 
      009D8B 96               [ 2] 1591 	ldw x,(x)
      009D8C 75 7B            [ 2] 1592 	cpw x,(FIRST,sp)
      009D8E 09 A1            [ 1] 1593 	jrpl 2$
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 114.
Hexadecimal [24-Bits]



      009D90 09 27 1E         [ 1] 1594 	ld a,(2,y)
      0011D1                       1595 	_straz acc8
      009D93 A3 01                    1     .byte 0xb7,acc8 
      009D95 00 2B 0C BE      [ 2] 1596 	addw y,acc16
      009D99 3F 1D 00 04      [ 2] 1597 	cpw y,progend 
      009D9D BF 3F            [ 1] 1598 	jrpl list_exit 
      009D9F A6 03            [ 2] 1599 	jra 1$
      009DA1 CC 96            [ 2] 1600 2$: ldw (LN_PTR,sp),y 	
      0011E1                       1601 list_loop:
      009DA3 75 05            [ 2] 1602 	ldw x,(LN_PTR,sp)
      009DA4 CF 00 33         [ 2] 1603 	ldw line.addr,x 
      009DA4 CD 9C            [ 1] 1604 	ld a,(2,x) 
      009DA6 2A 1F            [ 1] 1605 	sub a,#LINE_HEADER_SIZE
      009DA8 01 7B 04         [ 4] 1606 	call prt_basic_line
      009DAB 6B 03            [ 2] 1607 	ldw x,(LN_PTR,sp)
      009DAD 0F 04            [ 1] 1608 	ld a,(2,x)
      0011F1                       1609 	_straz acc8
      009DAF 20 06                    1     .byte 0xb7,acc8 
      009DB1                       1610 	_clrz acc16 
      009DB1 58 CD                    1     .byte 0x3f, acc16 
      009DB3 9C 2A 1F 01      [ 2] 1611 	addw x,acc16
      009DB7 C3 00 3B         [ 2] 1612 	cpw x,progend 
      009DB7 7B 03            [ 1] 1613 	jrpl list_exit
      009DB9 F7 7B            [ 2] 1614 	ldw (LN_PTR,sp),x
      009DBB 04               [ 2] 1615 	ldw x,(x)
      009DBC E7 01            [ 2] 1616 	cpw x,(LAST,sp)  
      009DBE 2D DC            [ 1] 1617 	jrsle list_loop
      001205                       1618 list_exit:
      001205                       1619 	_drop VSIZE 
      009DBE 1E 07            [ 2]    1     addw sp,#VSIZE 
      009DC0 7B 01 E7         [ 4] 1620 	call program_info
      009DC3 02 7B 02         [ 2] 1621 	jp cmd_line 
                                   1622 
                                   1623 ;---------------------------------
                                   1624 ; decompile line from token list
                                   1625 ; and print it. 
                                   1626 ; input:
                                   1627 ;   A       stop at this position 
                                   1628 ;   X 		pointer at line
                                   1629 ; output:
                                   1630 ;   none 
                                   1631 ;----------------------------------	
      00120D                       1632 prt_basic_line::
      00120D                       1633 	_straz count 
      009DC6 E7 03                    1     .byte 0xb7,count 
      009DC8 90 F6 90         [ 2] 1634 	addw x,#LINE_HEADER_SIZE  
      009DCB 5C A1 02         [ 2] 1635 	ldw basicptr,x
      009DCE 26 03            [ 1] 1636     ldw y,x 
      009DD0 CC 9D 48         [ 4] 1637 	call decompile
                                   1638 ;call new_line 
      009DD3 81               [ 4] 1639 	ret 
                                   1640 
                                   1641 ;---------------------------------
                                   1642 ; BASIC: PRINT|? arg_list 
                                   1643 ; print values from argument list
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 115.
Hexadecimal [24-Bits]



                                   1644 ;----------------------------------
                           000001  1645 	SEMICOL=1
                           000001  1646 	VSIZE=1
      00121B                       1647 cmd_print:
      00121B                       1648 	_vars VSIZE 
      009DD3 90 5A            [ 2]    1     sub sp,#VSIZE 
      00121D                       1649 reset_semicol:
      009DD5 5B 09            [ 1] 1650 	clr (SEMICOL,sp)
      00121F                       1651 prt_loop:
      00121F                       1652 	_next_token	
      00121F                          1         _get_char 
      009DD7 CC 97            [ 1]    1         ld a,(y)    ; 1 cy 
      009DD9 DC 5C            [ 1]    2         incw y      ; 1 cy 
      009DDA A1 01            [ 1] 1653 	cp a,#CMD_END 
      009DDA BE 3B            [ 1] 1654 	jrugt 0$
      001227                       1655 	_unget_token
      009DDC 72 B0            [ 2]    1         decw y
      009DDE 00 37            [ 2] 1656 	jra 8$
      00122B                       1657 0$:	
      009DE0 81 06            [ 1] 1658 	cp a,#QUOTE_IDX
      009DE1 27 12            [ 1] 1659 	jreq 1$
      009DE1 3B 00            [ 1] 1660 	cp a,#STR_VAR_IDX 
      009DE3 0C AE            [ 1] 1661 	jreq 2$ 
      009DE5 9E 24            [ 1] 1662 	cp a,#SCOL_IDX  
      009DE7 CD 85            [ 1] 1663 	jreq 4$
      009DE9 CD BE            [ 1] 1664 	cp a,#COMMA_IDX
      009DEB 37 35            [ 1] 1665 	jreq 5$	
      009DED 10 00            [ 1] 1666 	cp a,#CHAR_IDX 
      009DEF 0C CD            [ 1] 1667 	jreq 6$
      009DF1 88 3C            [ 2] 1668 	jra 7$ 
      001241                       1669 1$:	; print string 
      009DF3 35               [ 1] 1670 	ldw x,y 
      009DF4 0A 00 0C         [ 4] 1671 	call puts
      009DF7 AE 9E            [ 1] 1672 	ldw y,x  
      009DF9 36 CD            [ 2] 1673 	jra reset_semicol
      001249                       1674 2$:	; print string variable  
      009DFB 85 CD CD         [ 4] 1675 	call get_var_adr 
      009DFE 9D DA CD         [ 4] 1676 	call get_string_slice 
      009E01 88               [ 1] 1677 	tnz a 
      009E02 3C AE            [ 1] 1678 	jreq 22$   
      009E04 9E               [ 1] 1679 	push a
      001253                       1680 21$: 
      009E05 47               [ 1] 1681 	ld a,(x)
      009E06 CD               [ 1] 1682 	incw x 
      009E07 85 CD BE         [ 4] 1683 	call putc
      009E0A 37 A3            [ 1] 1684 	dec (1,sp)
      009E0C AC 72            [ 1] 1685 	jrne 21$ 
      009E0E 25               [ 1] 1686 	pop a  
      00125D                       1687 22$:
      009E0F 05 AE            [ 2] 1688 	jra reset_semicol 
      00125F                       1689 4$: ; set semi-colon  state 
      009E11 9E 4E            [ 1] 1690 	cpl (SEMICOL,sp)
      009E13 20 03            [ 2] 1691 	jra prt_loop 
      001263                       1692 5$: ; skip to next terminal tabulation
                                   1693      ; terminal TAB are 8 colons 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 116.
Hexadecimal [24-Bits]



      009E15 AE 9E            [ 1] 1694      ld a,#9 
      009E17 5F CD 85         [ 4] 1695 	 call putc 
      009E1A CD A6            [ 2] 1696 	 jra reset_semicol
      00126A                       1697 6$: ; appelle la foncton CHAR()
      00126A                       1698 	_call_code 
      00126A                          1         _code_addr  ; 6 cy  
      009E1C 0D               [ 1]    1         clrw x   ; 1 cy 
      009E1D CD               [ 1]    2         ld xl,a  ; 1 cy 
      009E1E 85               [ 2]    3         sllw x   ; 2 cy 
      009E1F 81 32 00         [ 2]    4         ldw x,(code_addr,x) ; 2 cy 
      009E22 0C               [ 4]    2         call (x)    ; 4 cy 
      009E23 81               [ 1] 1699 	rrwa x 
      009E24 70 72 6F         [ 4] 1700 	call putc 
      009E27 67 72            [ 2] 1701 	jra reset_semicol	 	    
      001277                       1702 7$:	
      001277                       1703 	_unget_token 
      009E29 61 6D            [ 2]    1         decw y
      009E2B 20 61 64         [ 4] 1704 	call condition
      009E2E 64 72 65         [ 4] 1705 	call print_int
      009E31 73 73 3A         [ 2] 1706 	jp reset_semicol 
      001282                       1707 8$:
      009E34 20 00            [ 1] 1708 	tnz (SEMICOL,sp)
      009E36 2C 20            [ 1] 1709 	jrne 9$
      009E38 70 72            [ 1] 1710 	ld a,#CR 
      009E3A 6F 67 72         [ 4] 1711     call putc 
      00128B                       1712 9$:	
      00128B                       1713 	_drop VSIZE 
      009E3D 61 6D            [ 2]    1     addw sp,#VSIZE 
      00128D                       1714 	_next
      009E3F 20 73 69         [ 2]    1         jp interp_loop 
                                   1715 
                                   1716 ;----------------------
                                   1717 ; 'save_context' and
                                   1718 ; 'rest_context' must be 
                                   1719 ; called at the same 
                                   1720 ; call stack depth 
                                   1721 ; i.e. SP must have the 
                                   1722 ; same value at  
                                   1723 ; entry point of both 
                                   1724 ; routine. 
                                   1725 ;---------------------
                           000004  1726 	CTXT_SIZE=4 ; size of saved data 
                                   1727 ;--------------------
                                   1728 ; save current BASIC
                                   1729 ; interpreter context 
                                   1730 ; on stack 
                                   1731 ;--------------------
      001290                       1732 	_argofs 0 
                           000002     1     ARG_OFS=2+0 
      001290                       1733 	_arg LNADR 1 
                           000003     1     LNADR=ARG_OFS+1 
      001290                       1734 	_arg BPTR 3
                           000005     1     BPTR=ARG_OFS+3 
      001290                       1735 save_context:
      009E42 7A 65            [ 2] 1736 	ldw (BPTR,sp),y 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 117.
Hexadecimal [24-Bits]



      001292                       1737 	_ldxz line.addr
      009E44 3A 20                    1     .byte 0xbe,line.addr 
      009E46 00 20            [ 2] 1738 	ldw (LNADR,sp),x 
      009E48 62               [ 4] 1739 	ret
                                   1740 
                                   1741 ;-----------------------
                                   1742 ; restore previously saved 
                                   1743 ; BASIC interpreter context 
                                   1744 ; from stack 
                                   1745 ;-------------------------
      001297                       1746 rest_context:
      009E49 79 74            [ 2] 1747 	ldw x,(LNADR,sp)
      009E4B 65 73 00         [ 2] 1748 	ldw line.addr,x 
      009E4E 20 69            [ 2] 1749 	ldw y,(BPTR,sp)
      009E50 6E               [ 4] 1750 	ret
                                   1751 
                                   1752 
                                   1753 ;-----------------------
                                   1754 ; ask user to retype 
                                   1755 ; input value 
                                   1756 ;----------------------
      00129F                       1757 retype:
      009E51 20 46 4C         [ 4] 1758 	call new_line
      009E54 41 53 48         [ 2] 1759 	ldw x,#err_retype 
      009E57 20 6D 65         [ 4] 1760 	call puts 
      009E5A 6D 6F 72         [ 4] 1761 	call new_line 
      009E5D 79               [ 4] 1762 	ret 
                                   1763 
                                   1764 ;--------------------------
                                   1765 ; readline from terminal 
                                   1766 ; and parse it in pad 
                                   1767 ;-------------------------
      0012AC                       1768 input_prompt:
      009E5E 00 20            [ 1] 1769 	ld a,#'? 
      009E60 69 6E 20         [ 4] 1770 	call putc 
      009E63 52               [ 4] 1771 	ret 
                                   1772 
                                   1773 ;-----------------------
                                   1774 ; print variable name 
                                   1775 ; input:
                                   1776 ;    X    var name 
                                   1777 ; use:
                                   1778 ;   A 
                                   1779 ;-----------------------
      0012B2                       1780 print_var_name:
      009E64 41               [ 1] 1781 	ld a,xh 
      009E65 4D 20            [ 1] 1782 	and a,#127 
      009E67 6D 65 6D         [ 4] 1783 	call uart_putc 
      009E6A 6F               [ 1] 1784 	ld a,xl 
      009E6B 72 79            [ 1] 1785 	and a,#127 
      009E6D 00 00 00         [ 4] 1786 	call uart_putc 
      009E6E 81               [ 4] 1787 	ret  
                                   1788 
                                   1789 ;--------------------------
                                   1790 ; input integer to variable 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 118.
Hexadecimal [24-Bits]



                                   1791 ; input:
                                   1792 ;   X     var name 
                                   1793 ; output:
                                   1794 ;   X      value 
                                   1795 ;----------------------------
                           000001  1796 	N=1
                           000003  1797 	DIGIT=N+INT_SIZE 
                           000005  1798 	SIGN=DIGIT+INT_SIZE
                           000006  1799 	COUNT=SIGN+1 
                           000006  1800  	VSIZE=COUNT  
      0012BF                       1801 input_integer:
      0012BF                       1802 	_vars VSIZE 
      009E6E CD 9D            [ 2]    1     sub sp,#VSIZE 
      009E70 DA 22            [ 1] 1803 	clr (DIGIT,sp)
      009E72 03 CC 97         [ 4] 1804 	call print_var_name 
      009E75 A7 12 AC         [ 4] 1805 	call input_prompt  
      009E76 5F               [ 1] 1806 	clrw x 
      009E76 52 06            [ 2] 1807 	ldw (N,sp),x 
      009E78 BE 37            [ 2] 1808 	ldw (SIGN,sp),x
      009E7A 1F 05 FE 1F      [ 1] 1809 	mov base,#10
      009E7E 01 AE 7F         [ 4] 1810 	call getc 
      009E81 FF 1F            [ 1] 1811 	cp a,#'- 
      009E83 03 90            [ 1] 1812 	jrne 1$ 
      009E85 F6 90            [ 1] 1813 	cpl (SIGN,sp)
      009E87 5C 4D            [ 2] 1814 	jra 2$ 
      009E89 27 2B            [ 1] 1815 1$: cp a,#'$ 
      009E8B A1 0C            [ 1] 1816 	jrne 3$ 
      009E8D 27 22 90 5A      [ 1] 1817 	mov base,#16  
      009E91 CD 98 30         [ 4] 1818 2$: call getc
      009E94 1F 01            [ 1] 1819 3$: cp a,#BS 
      009E96 90 F6            [ 1] 1820 	jrne 4$ 
      009E98 90 5C            [ 1] 1821 	tnz (COUNT,sp)
      009E9A 4D 26            [ 1] 1822 	jreq 2$ 
      009E9C 04 1F 03         [ 4] 1823 	call bksp 
      009E9F 20 15            [ 2] 1824 	ldw x,(N,sp)
      009EA1                       1825 	_ldaz base 
      009EA1 A1 0C                    1     .byte 0xb6,base 
      009EA3 27               [ 2] 1826 	div x,a 
      009EA4 03 CC            [ 2] 1827 	ldw (N,sp),x
      009EA6 96 73            [ 1] 1828 	dec (COUNT,sp)
      009EA8 90 F6            [ 2] 1829 	jra 2$  
      0012FE                       1830 4$:	
      009EAA 90 5C 4D         [ 4] 1831 	call uart_putc 
      009EAD 27 07            [ 1] 1832 	cp a,#CR 
      009EAF 90 5A            [ 1] 1833 	jreq 7$ 
      009EB1 CD 0B 50         [ 4] 1834 	call char_to_digit 
      009EB1 CD 98            [ 1] 1835 	jrnc 9$
      009EB3 30 1F            [ 1] 1836 	inc (COUNT,sp)
      009EB5 03 04            [ 1] 1837 	ld (DIGIT+1,sp),a 
      009EB6 1E 01            [ 2] 1838 	ldw x,(N,sp)
      001310                       1839 	_ldaz base 
      009EB6 16 05                    1     .byte 0xb6,base 
      009EB8 3F 15 93         [ 4] 1840 	call umul16_8
      009EBB FE 13 01         [ 2] 1841 	addw x,(DIGIT,sp)
      009EBE 2A 11            [ 2] 1842 	ldw (N,sp),x
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 119.
Hexadecimal [24-Bits]



      009EC0 90 E6            [ 2] 1843 	jra 2$  	
      009EC2 02 B7            [ 2] 1844 7$: ldw x,(N,sp)
      009EC4 16 72            [ 1] 1845 	tnz (SIGN,sp)
      009EC6 B9 00            [ 1] 1846 	jreq 8$ 
      009EC8 15               [ 2] 1847 	negw x 
      001323                       1848 8$: 
      009EC9 90               [ 1] 1849 	scf ; success 	
      001324                       1850 9$:	
      001324                       1851 	_drop VSIZE 
      009ECA C3 00            [ 2]    1     addw sp,#VSIZE 
      009ECC 3B               [ 4] 1852 	ret 
                                   1853 
                                   1854 ;---------------------------------------
                                   1855 ; input value for string variable 
                                   1856 ; accumulate all character up to CR 
                                   1857 ; input:
                                   1858 ;   X     var name  
                                   1859 ; output:
                                   1860 ;   X     *tib 
                                   1861 ;-------------------------------------- 
      001327                       1862 input_string:
      009ECD 2A 28 20         [ 4] 1863 	call print_var_name 
      009ED0 E9 17 05         [ 4] 1864 	call input_prompt 
      009ED3 4F               [ 1] 1865 	clr a 
      009ED3 1E 05 CF         [ 4] 1866 	call readln 
      009ED6 00 33 E6         [ 2] 1867 	ldw x,#tib 
      009ED9 02               [ 4] 1868 	ret 
                                   1869 
                                   1870 ;------------------------------------------
                                   1871 ; BASIC: INPUT [string],var[,var]
                                   1872 ; input value in variables 
                                   1873 ; [string] optionally can be used as prompt 
                                   1874 ;-----------------------------------------
                           000001  1875 	BPTR=1
                           000003  1876 	VAR_VALUE=BPTR+2
                           000005  1877 	VAR_ADR =VAR_VALUE+2
                           000006  1878 	VSIZE=3*INT_SIZE  
      001335                       1879 cmd_input:
      009EDA A0 03 CD 9E FF   [ 2] 1880 	btjt flags,#FRUN,1$ 
      009EDF 1E 05            [ 1] 1881 	ld a,#ERR_PROG_ONLY
      009EE1 E6 02 B7         [ 2] 1882 	jp tb_error 
      00133F                       1883 1$: 
      00133F                       1884 	_vars VSIZE 
      009EE4 16 3F            [ 2]    1     sub sp,#VSIZE 
      009EE6 15 72            [ 1] 1885 	ld a,(y) 
      009EE8 BB 00            [ 1] 1886 	cp a,#QUOTE_IDX 
      009EEA 15 C3            [ 1] 1887 	jrne 2$ 
      009EEC 00 3B            [ 1] 1888 	incw y 
      009EEE 2A               [ 1] 1889 	ldw x,y  
      009EEF 07 1F 05         [ 4] 1890 	call puts 
      009EF2 FE 13            [ 1] 1891 	ldw y,x 
      009EF4 03 2D DC         [ 4] 1892 	call new_line
      009EF7                       1893 	_next_token 
      001352                          1         _get_char 
      009EF7 5B 06            [ 1]    1         ld a,(y)    ; 1 cy 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 120.
Hexadecimal [24-Bits]



      009EF9 CD 9D            [ 1]    2         incw y      ; 1 cy 
      009EFB E1 CC            [ 1] 1894 	cp a,#COMMA_IDX 
      009EFD 97 A7            [ 1] 1895 	jreq 2$  
      009EFF CC 09 81         [ 2] 1896 	jp syntax_error 
      00135D                       1897 2$:
      00135D                       1898 	_next_token
      00135D                          1         _get_char 
      009EFF B7 32            [ 1]    1         ld a,(y)    ; 1 cy 
      009F01 1C 00            [ 1]    2         incw y      ; 1 cy 
      009F03 03 CF            [ 1] 1899 	cp a,#CMD_END+1  
      009F05 00 35            [ 1] 1900 	jrmi input_exit  
      009F07 90 93            [ 1] 1901     cp a,#VAR_IDX
      009F09 CD 92            [ 1] 1902 	jreq 4$
      009F0B E3 81            [ 1] 1903 	cp a,#STR_VAR_IDX 
      009F0D 27 2E            [ 1] 1904 	jreq 8$ 
      009F0D 52 01 81         [ 2] 1905 	jp syntax_error 
      009F0F                       1906 4$: 
      009F0F 0F               [ 1] 1907 	ldw x,y 
      009F10 01               [ 2] 1908 	ldw x,(x)
      009F11 1F 05            [ 2] 1909 	ldw (VAR_ADR,sp),x ; var name 
      009F11 90 F6            [ 2] 1910 5$:	ldw x,(VAR_ADR,sp) 
      009F13 90 5C A1         [ 4] 1911 	call input_integer 
      009F16 01 22            [ 1] 1912 	jrc 6$ 
      009F18 04 90 5A         [ 4] 1913 	call retype 
      009F1B 20 57            [ 2] 1914 	jra 5$ 	  
      009F1D                       1915 6$: 
      009F1D A1 06            [ 2] 1916 	ldw (VAR_VALUE,sp),x 
      009F1F 27 12 A1         [ 4] 1917 	call get_var_adr 
      009F22 0A 27 16         [ 4] 1918 	call get_array_adr 
      009F25 A1 03            [ 1] 1919 	ld a,(VAR_VALUE,sp)
      009F27 27               [ 1] 1920 	ld (x),a 
      009F28 28 A1            [ 1] 1921 	ld a,(VAR_VALUE+1,sp)
      009F2A 02 27            [ 1] 1922 	ld (1,x),a 
      00138F                       1923 7$: 
      00138F                       1924 	_next_token 
      00138F                          1         _get_char 
      009F2C 28 A1            [ 1]    1         ld a,(y)    ; 1 cy 
      009F2E 2E 27            [ 1]    2         incw y      ; 1 cy 
      009F30 2B 20            [ 1] 1925 	cp a,#COMMA_IDX 
      009F32 36 C6            [ 1] 1926 	jreq 2$
      009F33                       1927 	_unget_token   
      009F33 93 CD            [ 2]    1         decw y
      009F35 85 CD            [ 2] 1928 	jra input_exit ; all variables done
      00139B                       1929 8$: ;input string 
      009F37 90               [ 1] 1930 	ldw x,y
      009F38 93               [ 2] 1931 	ldw x,(x)
      009F39 20 D4            [ 2] 1932 	ldw (VAR_ADR,sp),x ; save var name 
      009F3B CD 13 27         [ 4] 1933 	call input_string  
      009F3B CD 9C 76         [ 4] 1934 	call get_var_adr 
      009F3E CD 9B            [ 2] 1935 	ldw (VAR_ADR,sp),x ; needed later 
      009F40 C8 4D 27         [ 4] 1936 	call get_string_slice 
      009F43 0B 88            [ 2] 1937 	ldw (BPTR,sp),y  
      009F45 90 AE 00 00      [ 2] 1938 	ldw y,#tib
      009F45 F6 5C CD         [ 4] 1939 	call strcpy 
      009F48 85 81 0A         [ 2] 1940 	ldw x,#tib 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 121.
Hexadecimal [24-Bits]



      009F4B 01 26 F7         [ 4] 1941 	call strlen 
      009F4E 84 05            [ 2] 1942 	ldw x,(VAR_ADR,sp)
      009F4F FE               [ 2] 1943 	ldw x,(x)
      009F4F 20               [ 1] 1944 	ld (x),a 
      009F50 BE 01            [ 2] 1945 	ldw y,(BPTR,sp)
      009F51 20 CE            [ 2] 1946 	jra 7$   	 
      0013C1                       1947 input_exit:
      0013C1                       1948 	_drop VSIZE 
      009F51 03 01            [ 2]    1     addw sp,#VSIZE 
      0013C3                       1949 	_next  
      009F53 20 BC EA         [ 2]    1         jp interp_loop 
                                   1950 
                                   1951 ;---------------------
                                   1952 ;BASIC: KEY
                                   1953 ; wait for a character 
                                   1954 ; received from STDIN 
                                   1955 ; input:
                                   1956 ;	none 
                                   1957 ; output:
                                   1958 ;	x  character 
                                   1959 ;---------------------
      009F55                       1960 func_key:
      009F55 A6               [ 1] 1961 	clrw x 
      009F56 09 CD 85         [ 4] 1962 	call qgetc 
      009F59 81 20            [ 1] 1963 	jreq 9$ 
      009F5B B3 00 00         [ 4] 1964 	call getc 
      009F5C 02               [ 1] 1965 	rlwa x  
      0013D0                       1966 9$:
      009F5C 5F               [ 4] 1967 	ret 
                                   1968 
                                   1969 ;--------------------
                                   1970 ; BASIC: POKE addr,byte
                                   1971 ; put a byte at addr 
                                   1972 ;--------------------
                           000001  1973 	VALUE=1
                           000003  1974 	POK_ADR=VALUE+INT_SIZE 
      0013D1                       1975 cmd_poke:
      009F5D 97 58 DE         [ 4] 1976 	call arg_list 
      009F60 8C F2            [ 1] 1977 	cp a,#2
      009F62 FD 01            [ 1] 1978 	jreq 1$
      009F64 CD 85 81         [ 2] 1979 	jp syntax_error
      0013DB                       1980 1$:	
      0013DB                       1981 	_i16_fetch POK_ADR ; address   
      009F67 20 A6            [ 2]    1     ldw x,(POK_ADR,sp)
      009F69 7B 02            [ 1] 1982 	ld a,(VALUE+1,sp) 
      009F69 90               [ 1] 1983 	ld (x),a 
      0013E0                       1984 	_drop 2*INT_SIZE 
      009F6A 5A CD            [ 2]    1     addw sp,#2*INT_SIZE 
      0013E2                       1985 	_next 
      009F6C 9A B2 CD         [ 2]    1         jp interp_loop 
                                   1986 
                                   1987 ;-----------------------
                                   1988 ; BASIC: PEEK(addr)
                                   1989 ; get the byte at addr 
                                   1990 ; input:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 122.
Hexadecimal [24-Bits]



                                   1991 ;	none 
                                   1992 ; output:
                                   1993 ;	X 		value 
                                   1994 ;-----------------------
      0013E5                       1995 func_peek:
      009F6F 88 3C CC         [ 4] 1996 	call func_args
      009F72 9F 0F            [ 1] 1997 	cp a,#1 
      009F74 27 03            [ 1] 1998 	jreq 1$
      009F74 0D 01 26         [ 2] 1999 	jp syntax_error
      0013EF                       2000 1$: _i16_pop ; address  
      009F77 05               [ 2]    1     popw x 
      009F78 A6               [ 1] 2001 	ld a,(x)
      009F79 0D               [ 1] 2002 	clrw x 
      009F7A CD               [ 1] 2003 	ld xl,a 
      009F7B 85               [ 4] 2004 	ret 
                                   2005 
                                   2006 ;---------------------------
                                   2007 ; BASIC IF expr : instructions
                                   2008 ; evaluate expr and if true 
                                   2009 ; execute instructions on same line. 
                                   2010 ;----------------------------
      0013F4                       2011 kword_if: 
      009F7C 81 F6            [ 1] 2012 	ld a,(y)
      009F7D A1 0A            [ 1] 2013 	cp a,#STR_VAR_IDX 
      009F7D 5B 01            [ 1] 2014 	jreq if_string 
      009F7F CC 97            [ 1] 2015 	cp a,#QUOTE_IDX
      009F81 DC 1A            [ 1] 2016 	jreq if_string 
      009F82 CD 0D C0         [ 4] 2017 	call condition
      009F82 17               [ 2] 2018 	tnzw x 
      009F83 05 BE            [ 1] 2019 	jrne 1$ 
      009F85 33 1F 03         [ 2] 2020 	jp kword_remark 
      009F88 81 21            [ 1] 2021 1$: ld a,#THEN_IDX 
      009F89 CD 0B DA         [ 4] 2022 	call expect 
      00140C                       2023 cond_accepted: 
      009F89 1E 03            [ 1] 2024 	ld a,(y)
      009F8B CF 00            [ 1] 2025 	cp a,#LITW_IDX 
      009F8D 33 16            [ 1] 2026 	jrne 2$ 
      009F8F 05 81 84         [ 2] 2027 	jp kword_goto
      009F91                       2028 2$:	_next  
      009F91 CD 85 EA         [ 2]    1         jp interp_loop 
                                   2029 ;-------------------------
                                   2030 ; if string condition 
                                   2031 ;--------------------------
                           000001  2032 	STR1=1 
                           000003  2033 	STR1_LEN=STR1+2
                           000005  2034 	STR2=STR1_LEN+2
                           000007  2035 	STR2_LEN=STR2+2 
                           000009  2036 	OP_REL=STR2_LEN+2 
                           00000A  2037 	YSAVE=OP_REL+1
                           00000B  2038 	VSIZE=YSAVE+1
      001418                       2039 if_string: 
      001418                       2040 	_vars VSIZE
      009F94 AE 96            [ 2]    1     sub sp,#VSIZE 
      009F96 20 CD            [ 1] 2041 	clr (STR1_LEN,sp)
      009F98 85 CD            [ 1] 2042 	clr (STR2_LEN,sp)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 123.
Hexadecimal [24-Bits]



      009F9A CD 85            [ 1] 2043 	incw y
      009F9C EA 81            [ 1] 2044 	cp a,#QUOTE_IDX
      009F9E 26 10            [ 1] 2045 	jrne 1$ 
      009F9E A6 3F            [ 2] 2046 	ldw (STR1,sp),y 
      009FA0 CD               [ 1] 2047 	ldw x,y 
      009FA1 85 81 81         [ 4] 2048 	call strlen 
      009FA4 6B 04            [ 1] 2049 	ld (STR1_LEN+1,sp),a
      009FA4 9E A4 7F         [ 2] 2050 	addw x,(STR1_LEN,sp)
      009FA7 CD               [ 1] 2051 	incw x 
      009FA8 85 98            [ 1] 2052 	ldw y,x  
      009FAA 9F A4            [ 2] 2053 	jra 2$ 
      001434                       2054 1$:	  
      009FAC 7F CD 85         [ 4] 2055 	call get_var_adr 
      009FAF 98 81 D6         [ 4] 2056 	call get_string_slice 	
      009FB1 1F 01            [ 2] 2057 	ldw (STR1,sp),x 
      009FB1 52 06            [ 1] 2058 	ld (STR1_LEN+1,sp),a 
      009FB3 0F 03            [ 1] 2059 2$: ld a,(y)
      009FB5 CD 9F            [ 1] 2060 	cp a,#REL_LE_IDX 
      009FB7 A4 CD            [ 1] 2061 	jrmi 3$ 
      009FB9 9F 9E            [ 1] 2062 	cp a,#OP_REL_LAST 
      009FBB 5F 1F            [ 2] 2063 	jrule 4$
      001448                       2064 3$:	
      009FBD 01 1F 05         [ 2] 2065 	jp syntax_error 
      00144B                       2066 4$: 
      009FC0 35 0A            [ 1] 2067 	ld (OP_REL,sp),a 
      009FC2 00 0C            [ 1] 2068 	incw y 
                                   2069 ;expect second string 	
      00144F                       2070 	_next_token 
      00144F                          1         _get_char 
      009FC4 CD 85            [ 1]    1         ld a,(y)    ; 1 cy 
      009FC6 AC A1            [ 1]    2         incw y      ; 1 cy 
      009FC8 2D 26            [ 1] 2071 	cp a,#QUOTE_IDX
      009FCA 04 03            [ 1] 2072 	jrne 5$ 
      009FCC 05 20            [ 2] 2073 	ldw (STR2,sp),y 
      009FCE 08               [ 1] 2074 	ldw x,y 
      009FCF A1 24 26         [ 4] 2075 	call strlen 
      009FD2 07 35            [ 1] 2076 	ld (STR2_LEN+1,sp),a 
      009FD4 10 00 0C         [ 2] 2077 	addw x,(STR2_LEN,sp)
      009FD7 CD               [ 1] 2078 	incw x 
      009FD8 85 AC            [ 1] 2079 	ldw y,x 
      009FDA A1 08            [ 2] 2080 	jra 54$
      009FDC 26 12            [ 1] 2081 5$: cp a,#STR_VAR_IDX
      009FDE 0D 06            [ 1] 2082 	jrne 3$
      009FE0 27 F5 CD         [ 4] 2083 	call get_var_adr 
      009FE3 85 D8 1E         [ 4] 2084 	call get_string_slice 
      009FE6 01 B6            [ 2] 2085 	ldw (STR2,sp),x 
      009FE8 0C 62            [ 1] 2086 	ld (STR2_LEN+1,sp),a
      001475                       2087 54$:
      009FEA 1F 01            [ 1] 2088 	ld a,#THEN_IDX 
      009FEC 0A 06 20         [ 4] 2089 	call expect
                                   2090 ; compare strings 
      009FEF E7 0A            [ 2] 2091 	ldw (YSAVE,sp),y 
      009FF0 1E 01            [ 2] 2092 	ldw x,(STR1,sp)
      009FF0 CD 85            [ 2] 2093 	ldw y,(STR2,sp)
      001480                       2094 6$:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 124.
Hexadecimal [24-Bits]



      009FF2 98 A1            [ 1] 2095 	tnz (STR1_LEN+1,sp) 
      009FF4 0D 27            [ 1] 2096 	jreq 7$ 
      009FF6 17 CD            [ 1] 2097 	tnz (STR2_LEN+1,sp)
      009FF8 98 42            [ 1] 2098 	jreq 7$ 
      009FFA 24               [ 1] 2099 	ld a,(x)
      009FFB 1A 0C            [ 1] 2100 	cp a,(y)
      009FFD 06 6B            [ 1] 2101 	jrne 8$ 
      009FFF 04               [ 1] 2102 	incw x 
      00A000 1E 01            [ 1] 2103 	incw y 
      00A002 B6 0C            [ 1] 2104 	dec (STR1_LEN+1,sp)
      00A004 CD 83            [ 1] 2105 	dec (STR2_LEN+1,sp)
      00A006 B5 72            [ 2] 2106 	jra 6$ 
      001496                       2107 7$: ; string end  
      00A008 FB 03            [ 1] 2108 	ld a,(STR1_LEN+1,sp)
      00A00A 1F 01            [ 1] 2109 	cp a,(STR2_LEN+1,sp)
      00149A                       2110 8$: ; no match  
      00A00C 20 C9            [ 1] 2111 	jrmi 9$ 
      00A00E 1E 01            [ 1] 2112 	jrne 10$ 
                                   2113 ; STR1 == STR2  
      00A010 0D 05            [ 1] 2114 	ld a,(OP_REL,sp)
      00A012 27 01            [ 1] 2115 	cp a,#REL_EQU_IDX 
      00A014 50 1A            [ 1] 2116 	jreq 11$ 
      00A015 2B 18            [ 1] 2117 	jrmi 11$ 
      00A015 99 26            [ 2] 2118 	jra 13$ 
      00A016                       2119 9$: ; STR1 < STR2 
      00A016 5B 06            [ 1] 2120 	ld a,(OP_REL,sp)
      00A018 81 13            [ 1] 2121 	cp a,#REL_LT_IDX 
      00A019 27 10            [ 1] 2122 	jreq 11$
      00A019 CD 9F            [ 1] 2123 	cp a,#REL_LE_IDX  
      00A01B A4 CD            [ 1] 2124 	jreq 11$
      00A01D 9F 9E            [ 2] 2125 	jra 13$  
      0014B4                       2126 10$: ; STR1 > STR2 
      00A01F 4F CD            [ 1] 2127 	ld a,(OP_REL,sp)
      00A021 86 0D            [ 1] 2128 	cp a,#REL_GT_IDX 
      00A023 AE 16            [ 1] 2129 	jreq 11$ 
      00A025 80 81            [ 1] 2130 	cp a,#REL_GE_IDX 
      00A027 26 10            [ 1] 2131 	jrne 13$ 
      0014BE                       2132 11$: ; accepted
      00A027 72 00            [ 2] 2133 	ldw y,(YSAVE,sp)
      0014C0                       2134 	_drop VSIZE 
      00A029 00 43            [ 2]    1     addw sp,#VSIZE 
      00A02B 05 A6            [ 1] 2135 	ld a,(y)
      00A02D 11 CC            [ 1] 2136 	cp a,#LITW_IDX 
      00A02F 96 75            [ 1] 2137 	jrne 12$
      00A031 CC 15 84         [ 2] 2138 	jp kword_goto 
      0014CB                       2139 12$: _next 
      00A031 52 06 90         [ 2]    1         jp interp_loop 
      0014CE                       2140 13$: ; rejected 
      00A034 F6 A1            [ 2] 2141 	ldw y,(YSAVE,sp)
      0014D0                       2142 	_drop VSIZE
      00A036 06 26            [ 2]    1     addw sp,#VSIZE 
      00A038 16 90 5C         [ 2] 2143 	jp kword_remark  
      0014D5                       2144 	_next 
      00A03B 93 CD 85         [ 2]    1         jp interp_loop 
                                   2145 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 125.
Hexadecimal [24-Bits]



                                   2146 
                                   2147 ;------------------------
                                   2148 ; BASIC: FOR var=expr 
                                   2149 ; set variable to expression 
                                   2150 ; leave variable address 
                                   2151 ; on stack and set
                                   2152 ; FLOOP bit in 'flags'
                                   2153 ;-----------------
                           000001  2154 	FSTEP=1  ; variable increment int16
                           000003  2155 	LIMIT=FSTEP+INT_SIZE ; loop limit, int16  
                           000005  2156 	CVAR=LIMIT+INT_SIZE   ; control variable data field 
                           000007  2157 	LN_ADDR=CVAR+2   ;  line.addr saved
                           000009  2158 	BPTR=LN_ADDR+2 ; basicptr saved
                           00000A  2159 	VSIZE=BPTR+1  
      0014D8                       2160 kword_for: ; { -- var_addr }
      0014D8                       2161 	_vars VSIZE
      00A03E CD 90            [ 2]    1     sub sp,#VSIZE 
      0014DA                       2162 	_ldaz for_nest 
      00A040 93 CD                    1     .byte 0xb6,for_nest 
      00A042 85 EA            [ 1] 2163 	cp a,#8 
      00A044 90 F6            [ 1] 2164 	jrmi 1$ 
      00A046 90 5C            [ 1] 2165 	ld a,#ERR_FORS
      00A048 A1 02 27         [ 2] 2166 	jp tb_error 
      00A04B 03               [ 1] 2167 1$: inc a 
      0014E6                       2168 	_straz for_nest 
      00A04C CC 96                    1     .byte 0xb7,for_nest 
      00A04E 73 00 01         [ 2] 2169 	ldw x,#1 
      00A04F 1F 01            [ 2] 2170 	ldw (FSTEP,sp),x  
      00A04F 90 F6            [ 1] 2171 	ld a,#VAR_IDX 
      00A051 90 5C A1         [ 4] 2172 	call expect 
      00A054 02 2B 5C         [ 4] 2173 	call get_var_adr
      00A057 A1 09 27         [ 2] 2174 	addw x,#2 
      00A05A 07 A1            [ 2] 2175 	ldw (CVAR,sp),x  ; control variable 
      0014FA                       2176 	_strxz ptr16 
      00A05C 0A 27                    1     .byte 0xbf,ptr16 
      00A05E 2E CC            [ 1] 2177 	ld a,#REL_EQU_IDX 
      00A060 96 73 DA         [ 4] 2178 	call expect 
      00A062 CD 0C E2         [ 4] 2179 	call expression
      00A062 93 FE 1F 05      [ 5] 2180 	ldw [ptr16],x
      00A066 1E 05            [ 1] 2181 	ld a,#TO_IDX 
      00A068 CD 9F B1         [ 4] 2182 	call expect 
                                   2183 ;-----------------------------------
                                   2184 ; BASIC: TO expr 
                                   2185 ; second part of FOR loop initilization
                                   2186 ; leave limit on stack and set 
                                   2187 ; FTO bit in 'flags'
                                   2188 ;-----------------------------------
      00150D                       2189 kword_to: ; { var_addr -- var_addr limit step }
      00A06B 25 05 CD         [ 4] 2190     call expression   
      001510                       2191 2$:
      00A06E 9F 91            [ 2] 2192 	ldw (LIMIT,sp),x
      001512                       2193 	_next_token 
      001512                          1         _get_char 
      00A070 20 F4            [ 1]    1         ld a,(y)    ; 1 cy 
      00A072 90 5C            [ 1]    2         incw y      ; 1 cy 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 126.
Hexadecimal [24-Bits]



      00A072 1F 03            [ 1] 2194 	cp a,#STEP_IDX 
      00A074 CD 9C            [ 1] 2195 	jreq kword_step
      00151A                       2196 	_unget_token
      00A076 76 CD            [ 2]    1         decw y
      00A078 9C D5            [ 2] 2197 	jra store_loop_addr 
                                   2198 
                                   2199 ;----------------------------------
                                   2200 ; BASIC: STEP expr 
                                   2201 ; optional third par of FOR loop
                                   2202 ; initialization. 	
                                   2203 ;------------------------------------
      00151E                       2204 kword_step: ; {var limit -- var limit step}
      00A07A 7B 03 F7         [ 4] 2205     call expression 
      001521                       2206 2$:	
      00A07D 7B 04            [ 2] 2207 	ldw (FSTEP,sp),x ; step
                                   2208 ; leave loop back entry point on stack 
      001523                       2209 store_loop_addr:
      00A07F E7 01            [ 2] 2210 	ldw (BPTR,sp),y 
      00A081                       2211 	_ldxz line.addr 
      00A081 90 F6                    1     .byte 0xbe,line.addr 
      00A083 90 5C            [ 2] 2212 	ldw (LN_ADDR,sp),x   
      001529                       2213 	_next 
      00A085 A1 02 27         [ 2]    1         jp interp_loop 
                                   2214 
                                   2215 ;--------------------------------
                                   2216 ; BASIC: NEXT var 
                                   2217 ; FOR loop control 
                                   2218 ; increment variable with step 
                                   2219 ; and compare with limit 
                                   2220 ; loop if threshold not crossed.
                                   2221 ; else stack. 
                                   2222 ;--------------------------------
                           000002  2223 	OFS=2 ; offset added by pushw y 
      00152C                       2224 kword_next: ; {var limit step retl1 -- [var limit step ] }
                                   2225 ; skip over variable name 
      00152C                       2226 	_tnz for_nest 
      00A088 C6 90                    1     .byte 0x3d,for_nest 
      00A08A 5A 20            [ 1] 2227 	jrne 1$ 
      00A08C 26 06            [ 1] 2228 	ld a,#ERR_BAD_NEXT 
      00A08D CC 09 83         [ 2] 2229 	jp tb_error
      001535                       2230 1$:
      00A08D 93 FE 1F 05      [ 2] 2231 	addw y,#3 ; ignore variable token 
      00A091 CD A0            [ 2] 2232 	ldw x,(CVAR,sp)
      00153B                       2233 	_strxz ptr16 
      00A093 19 CD                    1     .byte 0xbf,ptr16 
                                   2234 	; increment variable 
      00A095 9C               [ 2] 2235 	ldw x,(x)  ; get var value 
      00A096 76 1F 05         [ 2] 2236 	addw x,(FSTEP,sp) ; var+step 
      00A099 CD 9B C8 17      [ 5] 2237 	ldw [ptr16],x 
      00A09D 01 90 AE         [ 2] 2238 	subw x,(LIMIT,sp) 
      001548                       2239 	_strxz acc16 
      00A0A0 16 80                    1     .byte 0xbf,acc16 
      00A0A2 CD 88            [ 1] 2240 	jreq loop_back
      00154C                       2241 	_ldaz acc16 
      00A0A4 AE AE                    1     .byte 0xb6,acc16 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 127.
Hexadecimal [24-Bits]



      00A0A6 16 80            [ 1] 2242 	xor a,(FSTEP,sp)
      00A0A8 CD 88            [ 1] 2243 	jrpl loop_done 
      001552                       2244 loop_back:
      00A0AA 94 1E            [ 2] 2245 	ldw y,(BPTR,sp)
      00A0AC 05 FE            [ 2] 2246 	ldw x,(LN_ADDR,sp)
      00A0AE F7 16 01         [ 2] 2247 	ldw line.addr,x 
      001559                       2248 1$:	_next 
      00A0B1 20 CE EA         [ 2]    1         jp interp_loop 
      00A0B3                       2249 loop_done:
      00155C                       2250 	_decz for_nest 
      00A0B3 5B 06                    1     .byte 0x3a,for_nest 
                                   2251 	; remove loop data from stack  
      00155E                       2252 	_drop VSIZE 
      00A0B5 CC 97            [ 2]    1     addw sp,#VSIZE 
      001560                       2253 	_next 
      00A0B7 DC 0A EA         [ 2]    1         jp interp_loop 
                                   2254 
                                   2255 ;----------------------------
                                   2256 ; called by goto/gosub
                                   2257 ; to get target line number 
                                   2258 ; output:
                                   2259 ;    x    line address 
                                   2260 ;---------------------------
      00A0B8                       2261 get_target_line:
      00A0B8 5F CD 85         [ 4] 2262 	call expression 
      001566                       2263 target01: 
      00A0BB A6               [ 1] 2264 	clr a 
      00A0BC 27 04 CD 85 AC   [ 2] 2265 	btjf flags,#FRUN,2$ 
      00A0C1 02 C3 00 33      [ 4] 2266 0$:	cpw x,[line.addr] 
      00A0C2 25 06            [ 1] 2267 	jrult 2$ ; search from lomem 
      00A0C2 81 03            [ 1] 2268 	jrugt 1$
      00A0C3 CE 00 33         [ 2] 2269 	ldw x,line.addr
      00A0C3 CD               [ 1] 2270 1$:	cpl a  ; search from this line#
      001578                       2271 2$: 	
      00A0C4 98 E5 A1         [ 4] 2272 	call search_lineno 
      00A0C7 02               [ 1] 2273 	tnz a ; 0 if not found  
      00A0C8 27 03            [ 1] 2274 	jrne 3$ 
      00A0CA CC 96            [ 1] 2275 	ld a,#ERR_BAD_BRANCH  
      00A0CC 73 09 83         [ 2] 2276 	jp tb_error 
      00A0CD                       2277 3$:
      00A0CD 1E               [ 4] 2278 	ret 
                                   2279 
                                   2280 ;------------------------
                                   2281 ; BASIC: GOTO line# 
                                   2282 ; jump to line# 
                                   2283 ; here cstack is 2 call deep from interpreter 
                                   2284 ;------------------------
      001584                       2285 kword_goto:
      001584                       2286 kword_goto_1:
      00A0CE 03 7B 02         [ 4] 2287 	call get_target_line
      00A0D1 F7 5B 04 CC 97   [ 2] 2288 	btjt flags,#FRUN,1$
                                   2289 ; goto line# from command line 
      00A0D6 DC 10 00 43      [ 1] 2290 	bset flags,#FRUN 
      00A0D7                       2291 1$:
      001590                       2292 jp_to_target:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 128.
Hexadecimal [24-Bits]



      00A0D7 CD 98 DA         [ 2] 2293 	ldw line.addr,x 
      00A0DA A1 01 27         [ 2] 2294 	addw x,#LINE_HEADER_SIZE
      00A0DD 03 CC            [ 1] 2295 	ldw y,x   
      00A0DF 96 73 85 F6 5F   [ 2] 2296 	btjf flags,#FTRACE,9$ 
      00A0E4 97 81 24         [ 4] 2297 	call prt_line_no 
      00A0E6                       2298 9$:	_next
      00A0E6 90 F6 A1         [ 2]    1         jp interp_loop 
                                   2299 
                                   2300 
                                   2301 ;--------------------
                                   2302 ; BASIC: GOSUB line#
                                   2303 ; basic subroutine call
                                   2304 ; actual line# and basicptr 
                                   2305 ; are saved on stack
                                   2306 ;--------------------
                           000001  2307 	RET_BPTR=1 ; basicptr return point 
                           000003  2308 	RET_LN_ADDR=3  ; line.addr return point 
                           000004  2309 	VSIZE=4 
      0015A3                       2310 kword_gosub:
      0015A3                       2311 kword_gosub_1:
      0015A3                       2312 	_ldaz gosub_nest 
      00A0E9 0A 27                    1     .byte 0xb6,gosub_nest 
      00A0EB 1E A1            [ 1] 2313 	cp a,#8 
      00A0ED 06 27            [ 1] 2314 	jrmi 1$
      00A0EF 1A CD            [ 1] 2315 	ld a,#ERR_GOSUBS
      00A0F1 9A B2 5D         [ 2] 2316 	jp tb_error 
      00A0F4 26               [ 1] 2317 1$: inc a
      0015AF                       2318 	_straz gosub_nest 
      00A0F5 03 CC                    1     .byte 0xb7,gosub_nest 
      00A0F7 97 E7 A6         [ 4] 2319 	call get_target_line 
      00A0FA 21 CD 98         [ 2] 2320 	ldw ptr16,x ; target line address 
      0015B7                       2321 kword_gosub_2: 
      0015B7                       2322 	_vars VSIZE  
      00A0FD CC 04            [ 2]    1     sub sp,#VSIZE 
                                   2323 ; save BASIC subroutine return point.   
      00A0FE 17 01            [ 2] 2324 	ldw (RET_BPTR,sp),y 
      0015BB                       2325 	_ldxz line.addr 
      00A0FE 90 F6                    1     .byte 0xbe,line.addr 
      00A100 A1 08            [ 2] 2326 	ldw (RET_LN_ADDR,sp),x
      0015BF                       2327 	_ldxz ptr16  
      00A102 26 03                    1     .byte 0xbe,ptr16 
      00A104 CC A2            [ 2] 2328 	jra jp_to_target
                                   2329 
                                   2330 ;------------------------
                                   2331 ; BASIC: RETURN 
                                   2332 ; exit from BASIC subroutine 
                                   2333 ;------------------------
      0015C3                       2334 kword_return:
      00A106 76 CC 97 DC      [ 1] 2335 	tnz gosub_nest 
      00A10A 26 05            [ 1] 2336 	jrne 1$ 
      00A10A 52 0B            [ 1] 2337 	ld a,#ERR_BAD_RETURN 
      00A10C 0F 03 0F         [ 2] 2338 	jp tb_error 
      0015CE                       2339 1$:
      0015CE                       2340 	_decz gosub_nest
      00A10F 07 90                    1     .byte 0x3a,gosub_nest 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 129.
Hexadecimal [24-Bits]



      00A111 5C A1            [ 2] 2341 	ldw y,(RET_BPTR,sp) 
      00A113 06 26            [ 2] 2342 	ldw x,(RET_LN_ADDR,sp)
      00A115 10 17 01         [ 2] 2343 	ldw line.addr,x 
      0015D7                       2344 	_drop VSIZE 
      00A118 93 CD            [ 2]    1     addw sp,#VSIZE 
      0015D9                       2345 	_next 
      00A11A 88 94 6B         [ 2]    1         jp interp_loop 
                                   2346 
                                   2347 ;----------------------------------
                                   2348 ; BASIC: RUN [line#]
                                   2349 ; run BASIC program in RAM
                                   2350 ;----------------------------------- 
      0015DC                       2351 cmd_run: 
      00A11D 04 72 FB 03 5C   [ 2] 2352 	btjf flags,#FRUN,1$  
      0015E1                       2353 	_next ; already running 
      00A122 90 93 20         [ 2]    1         jp interp_loop 
      0015E4                       2354 1$: 
      00A125 0A F6            [ 1] 2355 	ld a,(y)
      00A126 A1 06            [ 1] 2356 	cp a,#QUOTE_IDX
      00A126 CD 9C            [ 1] 2357 	jreq 10$
      00A128 76 CD 9B         [ 2] 2358 	ldw x,progend 
      00A12B C8 1F 01         [ 2] 2359 	cpw x,lomem 
      00A12E 6B 04            [ 1] 2360 	jreq 9$
      00A130 90 F6 A1         [ 4] 2361 	call clear_state 
      00A133 10 2B 04         [ 2] 2362 	ldw x,#STACK_EMPTY
      00A136 A1               [ 1] 2363 	ldw sp,x 
      00A137 15 23 03         [ 4] 2364 	call arg_list 
      00A13A 4D               [ 1] 2365 	tnz  a 
      00A13A CC 96            [ 1] 2366 	jreq 2$
      0015FF                       2367 	_i16_pop
      00A13C 73               [ 2]    1     popw x 
      00A13D 4F               [ 1] 2368 	clr a  
      00A13D 6B 09 90         [ 4] 2369 	call search_lineno 
      00A140 5C               [ 1] 2370 	tnz a
      00A141 90 F6            [ 1] 2371 	jrne 3$ 
      00A143 90 5C            [ 1] 2372 	ld a,#ERR_RANGE 
      00A145 A1 06 26         [ 2] 2373 	jp tb_error 
      00160C                       2374 2$:
      00A148 10 17 05         [ 2] 2375 	ldw x,lomem 
      00160F                       2376 3$:
      00160F                       2377 	_strxz line.addr 
      00A14B 93 CD                    1     .byte 0xbf,line.addr 
      00A14D 88 94 6B         [ 2] 2378 	addw x,#LINE_HEADER_SIZE
      00A150 08 72            [ 1] 2379 	ldw y,x 
      00A152 FB 07 5C 90      [ 1] 2380 	bset flags,#FRUN 
      00161A                       2381 9$:
      00161A                       2382 	_next 
      00A156 93 20 0E         [ 2]    1         jp interp_loop 
                                   2383 ;------------------------
                                   2384 ; load and run file
                                   2385 ;------------------------
      00161D                       2386 10$:
      00A159 A1 0A            [ 1] 2387 	incw y 
      00A15B 26 DD CD         [ 4] 2388 	call basic_load_file
      00A15E 9C 76 CD         [ 2] 2389 	ldw x,progend 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 130.
Hexadecimal [24-Bits]



      00A161 9B C8 1F         [ 2] 2390 	cpw x,lomem 
      00A164 05 6B            [ 1] 2391 	jrugt 2$ 
      00162A                       2392 	_next 
      00A166 08 0A EA         [ 2]    1         jp interp_loop 
                                   2393 
                                   2394 ;----------------------
                                   2395 ; BASIC: END
                                   2396 ; end running program
                                   2397 ;---------------------- 
                           000001  2398 	CHAIN_LN=1 
                           000003  2399 	CHAIN_BP=3
                           000005  2400 	CHAIN_TXTBGN=5
                           000007  2401 	CHAIN_TXTEND=7
                           000008  2402 	CHAIN_CNTX_SIZE=8  
      00A167                       2403 kword_end: 
      00162D                       2404 8$: ; clean stack 
      00A167 A6 21 CD         [ 2] 2405 	ldw x,#STACK_EMPTY
      00A16A 98               [ 1] 2406 	ldw sp,x 
      001631                       2407 	_rst_pending 
      00A16B CC 17 0A         [ 2]    1     ldw x,#pending_stack+PENDING_STACK_SIZE
      001634                          2     _strxz psp 
      00A16E 1E 01                    1     .byte 0xbf,psp 
      00A170 16 05 B2         [ 2] 2408 	jp warm_start
                                   2409 
                                   2410 ;-----------------------
                                   2411 ; BASIC: TONE expr1,expr2
                                   2412 ; use TIMER2 channel 1
                                   2413 ; to produce a tone 
                                   2414 ; arguments:
                                   2415 ;    expr1   frequency 
                                   2416 ;    expr2   duration msec.
                                   2417 ;---------------------------
                           000001  2418 	DURATION=1 
                           000003  2419 	FREQ=DURATION+INT_SIZE
                           000005  2420 	YSAVE=FREQ+INT_SIZE 
                           000006  2421 	VSIZE=2*INT_SIZE+2    
      00A172                       2422 cmd_tone:
      00A172 0D 04            [ 2] 2423 	pushw y
      00A174 27 12 0D         [ 4] 2424 	call arg_list 
      00A177 08 27            [ 1] 2425 	cp a,#2 
      00A179 0E F6            [ 1] 2426 	jreq 0$ 
      00A17B 90 F1 26         [ 2] 2427 	jp syntax_error
      001645                       2428 0$:  
      00A17E 0D 5C            [ 2] 2429 	ldw (YSAVE,sp),y 
      001647                       2430 	_i16_fetch  FREQ 
      00A180 90 5C            [ 2]    1     ldw x,(FREQ,sp)
      00A182 0A 04            [ 1] 2431 	ldw y,x 
      00164B                       2432 	_i16_fetch  DURATION 
      00A184 0A 08            [ 2]    1     ldw x,(DURATION,sp)
      00A186 20 EA 00         [ 4] 2433 	call tone  
      00A188 16 05            [ 2] 2434 	ldw y,(YSAVE,sp)
      001652                       2435 	_drop VSIZE 
      00A188 7B 04            [ 2]    1     addw sp,#VSIZE 
      001654                       2436 	_next 
      00A18A 11 08 EA         [ 2]    1         jp interp_loop 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 131.
Hexadecimal [24-Bits]



                                   2437 
                                   2438 
                                   2439 ;-----------------------
                                   2440 ; BASIC: STOP
                                   2441 ; stop progam execution  
                                   2442 ; without resetting pointers 
                                   2443 ; the program is resumed
                                   2444 ; with RUN 
                                   2445 ;-------------------------
      00A18C                       2446 kword_stop:
      00A18C 2B 0C 26 16 7B   [ 2] 2447 	btjt flags,#FRUN,2$
      00165C                       2448 	_next 
      00A191 09 A1 11         [ 2]    1         jp interp_loop 
      00165F                       2449 2$:	 
                                   2450 ; create space on cstack to save context 
      00A194 27 1A 2B         [ 2] 2451 	ldw x,#stop_msg 
      00A197 18 20 26         [ 4] 2452 	call puts 
      00A19A                       2453 	_ldxz line.addr
      00A19A 7B 09                    1     .byte 0xbe,line.addr 
      00A19C A1               [ 2] 2454 	ldw x,(x)
      00A19D 13 27 10         [ 4] 2455 	call print_int 
      00A1A0 A1 10 27         [ 2] 2456 	ldw x,#con_msg 
      00A1A3 0C 20 1A         [ 4] 2457 	call puts 
      00A1A6                       2458 	_vars CTXT_SIZE ; context size 
      00A1A6 7B 09            [ 2]    1     sub sp,#CTXT_SIZE 
      00A1A8 A1 14 27         [ 4] 2459 	call save_context 
      00A1AB 04 A1 12 26      [ 1] 2460 	bres flags,#FRUN 
      00A1AF 10 18 00 43      [ 1] 2461 	bset flags,#FSTOP
      00A1B0 CC 0A B5         [ 2] 2462 	jp cmd_line  
                                   2463 
      00A1B0 16 0A 5B 0B 90 F6 A1  2464 stop_msg: .asciz "\nSTOP at line "
             08 26 03 CC A2 76 CC
             97
      00A1BF DC 20 43 4F 4E 20 74  2465 con_msg: .asciz ", CON to resume.\n"
             6F 20 72 65 73 75 6D
             65 2E 0A 00
                                   2466 
                                   2467 ;--------------------------------------
                                   2468 ; BASIC: CON 
                                   2469 ; continue execution after a STOP 
                                   2470 ;--------------------------------------
      00A1C0                       2471 kword_con:
      00A1C0 16 0A 5B 0B CC   [ 2] 2472 	btjt flags,#FSTOP,1$ 
      0016A7                       2473 	_next 
      00A1C5 97 E7 CC         [ 2]    1         jp interp_loop 
      0016AA                       2474 1$:
      00A1C8 97 DC 97         [ 4] 2475 	call rest_context 
      00A1CA                       2476 	_drop CTXT_SIZE
      00A1CA 52 0A            [ 2]    1     addw sp,#CTXT_SIZE 
      00A1CC B6 48 A1 08      [ 1] 2477 	bres flags,#FSTOP 
      00A1D0 2B 05 A6 08      [ 1] 2478 	bset flags,#FRUN 
      00A1D4 CC 96 75         [ 2] 2479 	jp interp_loop
                                   2480 
                                   2481 ;-----------------------
                                   2482 ; BASIC: SCR (NEW)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 132.
Hexadecimal [24-Bits]



                                   2483 ; from command line only 
                                   2484 ; free program memory
                                   2485 ; and clear variables 
                                   2486 ;------------------------
      0016BA                       2487 cmd_scr: 
      0016BA                       2488 cmd_new: 
      00A1D7 4C B7 48 AE 00   [ 2] 2489 0$:	btjt flags,#FRUN,9$
      00A1DC 01 1F 01         [ 4] 2490 	call reset_basic 
      0016C2                       2491 9$:	_next 
      00A1DF A6 09 CD         [ 2]    1         jp interp_loop 
                                   2492 
                                   2493 ;-----------------------------------
                                   2494 ; BASIC: ERASE "name" || \F  
                                   2495 ;  options:
                                   2496 ;   "name"    erase that program only  
                                   2497 ;     \F    erase all spi eeprom  
                                   2498 ;-----------------------------------
                           000001  2499 	LIMIT=1  ; 24 bits address 
                           000003  2500 	VSIZE = 3 
      0016C5                       2501 cmd_erase:
      00A1E2 98 CC CD 9C 76   [ 2] 2502 	btjf flags,#FRUN,0$
      0016CA                       2503 	_next 
      00A1E7 1C 00 02         [ 2]    1         jp interp_loop 
      0016CD                       2504 0$:
      0016CD                       2505 	_clrz farptr
      00A1EA 1F 05                    1     .byte 0x3f, farptr 
      00A1EC BF               [ 1] 2506 	clrw x 
      0016D0                       2507 	_strxz ptr16  
      00A1ED 0F A6                    1     .byte 0xbf,ptr16 
      0016D2                       2508 	_next_token
      0016D2                          1         _get_char 
      00A1EF 11 CD            [ 1]    1         ld a,(y)    ; 1 cy 
      00A1F1 98 CC            [ 1]    2         incw y      ; 1 cy 
      00A1F3 CD 99            [ 1] 2509 	cp a,#QUOTE_IDX 
      00A1F5 D4 72            [ 1] 2510 	jrne not_file
      0016DA                       2511 erase_program: 
      00A1F7 CF               [ 1] 2512 	ldw x,y
      00A1F8 00 0F A6         [ 4] 2513 	call skip_string  
      00A1FB 27 CD 98         [ 4] 2514 	call search_file
      00A1FE CC               [ 1] 2515 	tnz a 
      00A1FF 27 03            [ 1] 2516 	jreq 9$  ; not found 
      0016E4                       2517 8$:	
      00A1FF CD 99 D4         [ 4] 2518 	call erase_file  
      00A202                       2519 9$:	
      00A202 1F 03            [ 1] 2520 	clr (y)
      0016E9                       2521 	_next 
      00A204 90 F6 90         [ 2]    1         jp interp_loop 
      0016EC                       2522 not_file: 
      00A207 5C A1            [ 1] 2523 	cp a,#LITC_IDX 
      00A209 24 27            [ 1] 2524 	jreq 0$ 
      00A20B 04 90 5A         [ 2] 2525 	jp syntax_error	
      0016F3                       2526 0$: _get_char 
      00A20E 20 05            [ 1]    1         ld a,(y)    ; 1 cy 
      00A210 90 5C            [ 1]    2         incw y      ; 1 cy 
      00A210 CD 99            [ 1] 2527 	and a,#0XDF 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 133.
Hexadecimal [24-Bits]



      00A212 D4 46            [ 1] 2528 1$: cp a,#'F 
      00A213 27 03            [ 1] 2529 	jreq 2$
      00A213 1F 01 81         [ 2] 2530 	jp syntax_error 
      00A215                       2531 2$: 
      00A215 17 09 BE         [ 4] 2532 	call eeprom_erase_chip 
      001703                       2533 	_next 
      00A218 33 1F 07         [ 2]    1         jp interp_loop 
                                   2534 	
                                   2535 ;---------------------------------------
                                   2536 ; BASIC: SAVE "name" 
                                   2537 ; save program to spi eeprom 
                                   2538 ; if file already exist, replace it.
                                   2539 ;--------------------------------------
      001706                       2540 cmd_save:
      00A21B CC 97 DC 43 03   [ 2] 2541 	btjf flags,#FRUN,0$
      00A21E                       2542 	_next 
      00A21E 3D 48 26         [ 2]    1         jp interp_loop 
      00170E                       2543 0$:
      00A221 05 A6 06         [ 2] 2544 	ldw x,progend  
      00A224 CC 96 75 37      [ 2] 2545 	subw x,lomem 
      00A227 27 36            [ 1] 2546 	jreq 6$ 
      001717                       2547 	_next_token 
      001717                          1         _get_char 
      00A227 72 A9            [ 1]    1         ld a,(y)    ; 1 cy 
      00A229 00 03            [ 1]    2         incw y      ; 1 cy 
      00A22B 1E 05            [ 1] 2548 	cp a,#QUOTE_IDX
      00A22D BF 0F            [ 1] 2549 	jreq 1$ 
      00A22F FE 72 FB         [ 2] 2550 	jp syntax_error 
      00A232 01               [ 1] 2551 1$: ldw x,y 
      00A233 72 CF 00         [ 4] 2552 	call skip_string 
      00A236 0F               [ 2] 2553 	pushw x 
      00A237 72 F0 03         [ 4] 2554 	call search_file 
      00A23A BF               [ 1] 2555 	tnz a 
      00A23B 15 27            [ 1] 2556 	jreq 2$
      00A23D 06 B6 15         [ 2] 2557 	ldw x,#file_exist 
      00A240 18 01 2A         [ 4] 2558 	call puts 
      00A243 0A 27            [ 2] 2559 	jra 9$ 
      00A244                       2560 2$:
      00A244 16 09 1E         [ 4] 2561 	call search_free
      00A247 07               [ 1] 2562 	tnz a 
      00A248 CF 00            [ 1] 2563 	jrne 4$ 
      00A24A 33 CC 97         [ 2] 2564 	ldw x,progend 
      00A24D DC B0 00 37      [ 2] 2565 	subw x,lomem 
      00A24E CD 07 13         [ 4] 2566 	call reclaim_space 
      00A24E 3A 48            [ 1] 2567 	jreq 8$ 
      001747                       2568 4$: 
      00A250 5B               [ 2] 2569 	popw x 
      00A251 0A CC 97         [ 4] 2570 	call save_file
      00A254 DC 0F            [ 2] 2571 	jra 9$ 
      00A255                       2572 6$: 
      00A255 CD 99 D4         [ 2] 2573 	ldw x,#no_prog  
      00A258 CD 00 00         [ 4] 2574 	call puts 
      00A258 4F 72            [ 2] 2575 	jra 9$ 
      001755                       2576 8$: 
      00A25A 01               [ 2] 2577 	popw x 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 134.
Hexadecimal [24-Bits]



      00A25B 00 43 0C         [ 2] 2578 	ldw x,#no_space 
      00A25E 72 C3 00         [ 4] 2579 	call puts 
      00175C                       2580 9$:
      00A261 33 25            [ 1] 2581 	clr (y)
      00175E                       2582 	_next 
      00A263 06 22 03         [ 2]    1         jp interp_loop 
                                   2583 
      00A266 CE 00 33 43 69 63 61  2584 file_exist: .asciz "Duplicate name.\n"
             74 65 20 6E 61 6D 65
             2E 0A 00
      00A26A 4E 6F 20 70 72 6F 67  2585 no_prog: .asciz "No program in RAM.\n"
             72 61 6D 20 69 6E 20
             52 41 4D 2E 0A 00
      00A26A CD 8D 8E 4D 26 05 A6  2586 no_space: .asciz "File system full.\n" 
             04 CC 96 75 20 66 75
             6C 6C 2E 0A 00
                                   2587 
                                   2588 ;-----------------------
                                   2589 ;BASIC: LOAD "fname"
                                   2590 ; load file in RAM 
                                   2591 ;-----------------------
      00A275                       2592 cmd_load: 
      00A275 81 01 00 43 03   [ 2] 2593 	btjf flags,#FRUN,0$
      00A276                       2594 	_next 
      00A276 CC 0A EA         [ 2]    1         jp interp_loop 
      0017A1                       2595 0$:
      0017A1                       2596 	_next_token 
      0017A1                          1         _get_char 
      00A276 CD A2            [ 1]    1         ld a,(y)    ; 1 cy 
      00A278 55 72            [ 1]    2         incw y      ; 1 cy 
      00A27A 00 00            [ 1] 2597 	cp a,#QUOTE_IDX
      00A27C 43 04            [ 1] 2598 	jreq 1$ 
      00A27E 72 10 00         [ 2] 2599 	jp syntax_error
      0017AC                       2600 1$:
      00A281 43 17 C2         [ 4] 2601 	call basic_load_file 
      00A282                       2602 	_next  
      00A282 CC 0A EA         [ 2]    1         jp interp_loop 
                                   2603 
      00A282 CF 00 33 1C 00 03 90  2604 not_a_file: .asciz "file not found\n"
             93 72 0F 00 43 03 CD
             98 16
                                   2605 
                                   2606 ;--------------------------
                                   2607 ; common factor 
                                   2608 ; for LOAD and RUN "file"
                                   2609 ;-------------------------
      0017C2                       2610 basic_load_file:
      00A292 CC               [ 1] 2611 	ldw x,y 
      00A293 97 DC 31         [ 4] 2612 	call skip_string 
      00A295 CD 06 D9         [ 4] 2613 	call search_file
      00A295 4D               [ 1] 2614 	tnz a 
      00A295 B6 49            [ 1] 2615 	jrne 2$ ; file found   
      00A297 A1 08 2B         [ 2] 2616 	ldw x,#not_a_file 
      00A29A 05 A6 07         [ 4] 2617 	call puts 
      00A29D CC 96            [ 2] 2618 	jra 9$ 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 135.
Hexadecimal [24-Bits]



      0017D4                       2619 2$: 
      00A29F 75 4C B7         [ 4] 2620 	call reset_basic 
      00A2A2 49 CD A2         [ 4] 2621 	call load_file
      0017DA                       2622 9$: 
      00A2A5 55 CF            [ 1] 2623 	clr (y)
      00A2A7 00               [ 4] 2624 	ret 
                                   2625 
                                   2626 
                                   2627 
                                   2628 ;---------------------
                                   2629 ; BASIC: DIR 
                                   2630 ; list programs saved 
                                   2631 ; in flash 
                                   2632 ;--------------------
                           000001  2633 	FCNT=1
      0017DD                       2634 cmd_dir:
      00A2A8 0F 01 00 43 03   [ 2] 2635 	btjf flags,#FRUN,0$
      00A2A9                       2636 	_next 
      00A2A9 52 04 17         [ 2]    1         jp interp_loop 
      0017E5                       2637 0$:
      00A2AC 01 BE            [ 1] 2638 	push #0
      00A2AE 33 1F            [ 1] 2639 	push #0 
      00A2B0 03 BE 0F         [ 4] 2640 	call first_file 
      0017EC                       2641 1$:	 
      00A2B3 20               [ 1] 2642 	tnz a 
      00A2B4 CD 36            [ 1] 2643 	jreq 9$ 
      00A2B5 1E 01            [ 2] 2644 	ldw x,(FCNT,sp)
      00A2B5 72               [ 1] 2645 	incw x 
      00A2B6 5D 00            [ 2] 2646 	ldw (FCNT,sp),x
      00A2B8 49 26 05         [ 2] 2647 	ldw x,#file_header+FILE_NAME_FIELD
      00A2BB A6               [ 2] 2648 	pushw x 
      00A2BC 05 CC 96         [ 4] 2649 	call puts
      00A2BF 75               [ 2] 2650 	popw x 
      00A2C0 CD 00 00         [ 4] 2651 	call strlen
      00A2C0 3A               [ 1] 2652 	push a 
      00A2C1 49 16            [ 1] 2653 	push #0
      00A2C3 01 1E 03         [ 2] 2654 	ldw x,#FNAME_MAX_LEN 
      00A2C6 CF 00 33         [ 2] 2655 	subw x,(1,sp) 
      00A2C9 5B 04 CC         [ 4] 2656 	call spaces 
      00180B                       2657 	_drop 2  
      00A2CC 97 DC            [ 2]    1     addw sp,#2 
      00A2CE AE 00 5E         [ 2] 2658 	ldw x,#file_header+FILE_SIZE_FIELD
      00A2CE 72               [ 2] 2659 	ldw x,(x)
      00A2CF 01 00 43         [ 4] 2660 	call print_int
      00A2D2 03 CC 97         [ 2] 2661 	ldw x,#file_size 
      00A2D5 DC 00 00         [ 4] 2662 	call puts 
      00A2D6 AE 00 5C         [ 2] 2663 	ldw x,#file_header 
      00A2D6 90 F6 A1         [ 4] 2664 	call skip_to_next 
      00A2D9 06 27 33         [ 4] 2665 	call next_file 
      00A2DC CE 00            [ 2] 2666 	jra 1$  
      001825                       2667 9$:
      00A2DE 3B C3 00         [ 4] 2668 	call new_line
      00A2E1 37               [ 2] 2669 	popw x 	
      00A2E2 27 28 CD         [ 4] 2670 	call print_int
      00A2E5 A6 FC AE         [ 2] 2671 	ldw x,#files_count 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 136.
Hexadecimal [24-Bits]



      00A2E8 17 FF 94         [ 4] 2672 	call puts 
      00A2EB CD 98            [ 1] 2673 	clr (y)
      001834                       2674 	_next 
      00A2ED E5 4D 27         [ 2]    1         jp interp_loop 
                                   2675 
      00A2F0 0D 85 4F CD 8D 8E 4D  2676 file_size: .asciz "bytes\n"
      00A2F7 26 08 A6 0D CC 96     2677 files_count: .asciz "files"
                                   2678 
                                   2679 
                                   2680 
                                   2681 
                                   2682 ;------------------------------
                                   2683 ; BASIC: BYE 
                                   2684 ; exit BASIC and back to monitor  
                                   2685 ;------------------------------
      001844                       2686 cmd_bye:
      00A2FD 75 00 00 43 09   [ 2] 2687 	btjt flags,#FRUN,9$ 
      00A2FE 72 0D 52 40 FB   [ 2] 2688 	btjf UART_SR,#UART_SR_TC,.
      00184E                       2689 	_swreset
      00A2FE CE 00 37 D1      [ 1]    1     mov WWDG_CR,#0X80
      00A301                       2690 9$: _next 
      00A301 BF 33 1C         [ 2]    1         jp interp_loop 
                                   2691 
                                   2692 ;-------------------------------
                                   2693 ; BASIC: SLEEP expr 
                                   2694 ; suspend execution for n msec.
                                   2695 ; input:
                                   2696 ;	none
                                   2697 ; output:
                                   2698 ;	none 
                                   2699 ;------------------------------
      001855                       2700 cmd_sleep:
      00A304 00 03 90         [ 4] 2701 	call expression
      00A307 93 72 10 00      [ 1] 2702 	bres sys_flags,#FSYS_TIMER 
      00A30B 43 00 00         [ 2] 2703 	ldw timer,x
      00A30C 8F               [10] 2704 1$:	wfi 
      00A30C CC 97 DC         [ 2] 2705 	ldw x,timer 
      00A30F 26 FA            [ 1] 2706 	jrne 1$
      001865                       2707 	_next 
      00A30F 90 5C CD         [ 2]    1         jp interp_loop 
                                   2708 
                                   2709 ;------------------------------
                                   2710 ; BASIC: TICKS
                                   2711 ; return msec ticks counter value 
                                   2712 ; input:
                                   2713 ; 	none 
                                   2714 ; output:
                                   2715 ;	X 	msec since reset 
                                   2716 ;-------------------------------
      001868                       2717 func_ticks:
      001868                       2718 	_ldxz ticks 
      00A312 A4 B4                    1     .byte 0xbe,ticks 
      00A314 CE               [ 4] 2719 	ret
                                   2720 
                                   2721 ;---------------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 137.
Hexadecimal [24-Bits]



                                   2722 ; BASIC: CHR$(expr)
                                   2723 ; return ascci character 
                                   2724 ;---------------------------------
      00186B                       2725 func_char:
      00A315 00 3B            [ 1] 2726 	ld a,#LPAREN_IDX 
      00A317 C3 00 37         [ 4] 2727 	call expect 
      00A31A 22 E2 CC         [ 4] 2728 	call expression 
      00A31D 97               [ 1] 2729 	ld a,xl 
      00A31E DC               [ 1] 2730 	clrw x  
      00A31F 97               [ 1] 2731 	ld xl,a 
      00A31F A6 05            [ 1] 2732 	ld a,#RPAREN_IDX 
      00A31F AE 17 FF         [ 4] 2733 	call expect 
      00A322 94               [ 4] 2734 	ret 
                                   2735 
                                   2736 
                                   2737 ;------------------------------
                                   2738 ; BASIC: ABS(expr)
                                   2739 ; return absolute value of expr.
                                   2740 ; input:
                                   2741 ;   none
                                   2742 ; output:
                                   2743 ;   X   positive int16 
                                   2744 ;-------------------------------
      00187C                       2745 func_abs:
      00A323 AE 00 5C         [ 4] 2746 	call func_args 
      00A326 BF 4A            [ 1] 2747 	cp a,#1 
      00A328 CC 97            [ 1] 2748 	jreq 0$ 
      00A32A A4 09 81         [ 2] 2749 	jp syntax_error
      00A32B                       2750 0$: 
      001886                       2751 	_i16_pop
      00A32B 90               [ 2]    1     popw x 
      00A32C 89               [ 2] 2752 	tnzw x 
      00A32D CD 98            [ 1] 2753 	jrpl 1$  
      00A32F E5               [ 2] 2754 	negw x 
      00A330 A1               [ 4] 2755 1$:	ret 
                                   2756 
                                   2757 ;---------------------------------
                                   2758 ; BASIC: RND(n)
                                   2759 ; return integer [0..n-1] 
                                   2760 ; ref: https://en.wikipedia.org/wiki/Xorshift
                                   2761 ;
                                   2762 ; 	x ^= x << 13;
                                   2763 ;	x ^= x >> 17;
                                   2764 ;	x ^= x << 5;
                                   2765 ;
                                   2766 ;---------------------------------
      00188C                       2767 func_random:
      00A331 02 27 03         [ 4] 2768 	call func_args 
      00A334 CC 96            [ 1] 2769 	cp a,#1
      00A336 73 03            [ 1] 2770 	jreq 1$
      00A337 CC 09 81         [ 2] 2771 	jp syntax_error
      001896                       2772 1$:
      00A337 17 05 1E         [ 4] 2773 	call prng 
      00A33A 03 90            [ 2] 2774 	pushw y 
      00A33C 93 1E            [ 2] 2775 	ldw y,(3,sp)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 138.
Hexadecimal [24-Bits]



      00A33E 01               [ 2] 2776 	divw x,y 
      00A33F CD               [ 1] 2777 	exgw x,y 
      00A340 82 FA            [ 2] 2778 	popw y 
      0018A1                       2779 	_drop 2 
      00A342 16 05            [ 2]    1     addw sp,#2 
      00A344 5B               [ 4] 2780 	ret 
                                   2781 
                                   2782 ;---------------------------------
                                   2783 ; BASIC: RANDOMIZE expr 
                                   2784 ; intialize PRGN seed with expr 
                                   2785 ; or with ticks variable value 
                                   2786 ; if expr==0
                                   2787 ;---------------------------------
      0018A4                       2788 cmd_randomize:
      00A345 06 CC 97         [ 4] 2789 	call expression 
      00A348 DC 00 00         [ 4] 2790 	call set_seed 
      00A349                       2791 	_next 
      00A349 72 00 00         [ 2]    1         jp interp_loop 
                                   2792 
                                   2793 ;------------------------------
                                   2794 ; BASIC: SGN(expr)
                                   2795 ;    return -1 < 0 
                                   2796 ;    return 0 == 0
                                   2797 ;    return 1 > 0 
                                   2798 ;-------------------------------
      0018AD                       2799 func_sign:
      00A34C 43 03 CC         [ 4] 2800 	call func_args 
      00A34F 97 DC            [ 1] 2801 	cp a,#1 
      00A351 27 03            [ 1] 2802 	jreq 0$ 
      00A351 AE A3 73         [ 2] 2803 	jp syntax_error
      0018B7                       2804 0$:
      0018B7                       2805 	_i16_pop  
      00A354 CD               [ 2]    1     popw x 
      00A355 85               [ 2] 2806 	tnzw x 
      00A356 CD BE            [ 1] 2807 	jreq 9$
      00A358 33 FE            [ 1] 2808 	jrmi 4$
      00A35A CD 88 3C         [ 2] 2809 	ldw x,#1
      00A35D AE               [ 4] 2810 	ret
      00A35E A3 82 CD         [ 2] 2811 4$: ldw x,#-1    
      00A361 85               [ 4] 2812 9$:	ret 
                                   2813 
                                   2814 ;-----------------------------
                                   2815 ; BASIC: LEN(var$||quoted string)
                                   2816 ;  return length of string 
                                   2817 ;----------------------------
      0018C5                       2818 func_len:
      00A362 CD 52            [ 1] 2819 	ld a,#LPAREN_IDX 
      00A364 04 CD 9F         [ 4] 2820 	call expect 
      0018CA                       2821 	_next_token 
      0018CA                          1         _get_char 
      00A367 82 72            [ 1]    1         ld a,(y)    ; 1 cy 
      00A369 11 00            [ 1]    2         incw y      ; 1 cy 
      00A36B 43 72            [ 1] 2822 	cp a,#QUOTE_IDX
      00A36D 18 00            [ 1] 2823 	jrne 2$ 
      00A36F 43               [ 1] 2824 	ldw x,y 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 139.
Hexadecimal [24-Bits]



      00A370 CC 97 A7         [ 4] 2825 	call strlen
      00A373 0A               [ 1] 2826 	push a 
      00A374 53 54            [ 1] 2827 	push #0 
      00A376 4F 50 20         [ 2] 2828 	addw y,(1,sp)
      00A379 61 74            [ 1] 2829 	incw y 
      0018DE                       2830 	_drop 2 
      00A37B 20 6C            [ 2]    1     addw sp,#2 
      00A37D 69 6E            [ 2] 2831 	jra 9$ 
      0018E2                       2832 2$:
      00A37F 65 20            [ 1] 2833 	cp a,#STR_VAR_IDX 
      00A381 00 2C            [ 1] 2834 	jreq 3$ 
      00A383 20 43 4F         [ 2] 2835 	jp syntax_error
      0018E9                       2836 3$:
      00A386 4E 20 74         [ 4] 2837 	call get_var_adr  
      00A389 6F 20            [ 2] 2838 	ldw x,(2,x) 
      00A38B 72               [ 1] 2839 	incw x 
      00A38C 65 73 75         [ 4] 2840 	call strlen
      0018F2                       2841 9$:
      00A38F 6D               [ 1] 2842 	clrw x 
      00A390 65               [ 1] 2843 	ld xl,a 
      00A391 2E 0A            [ 1] 2844 	ld a,#RPAREN_IDX
      00A393 00 0B DA         [ 4] 2845 	call expect 
      00A394 81               [ 4] 2846 	ret 
                                   2847 
                           000001  2848 .if 1
                                   2849 ;---------------------------------
                                   2850 ; BASIC: WORDS [\C]
                                   2851 ; affiche la listes des mots 
                                   2852 ; réservés ainsi que le nombre
                                   2853 ; de mots.
                                   2854 ; si l'option \C est présente 
                                   2855 ; affiche la valeur tokenizé des 
                                   2856 ; mots réservés 
                                   2857 ;---------------------------------
                           000001  2858 	COL_CNT=1 ; column counter 
                           000002  2859 	WCNT=COL_CNT+1 ; count words printed 
                           000003  2860 	SHOW_CODE=WCNT+1 ; display token code
                           000004  2861 	YSAVE=SHOW_CODE+1
                           000006  2862 	XSAVE=YSAVE+2 
                           000007  2863 	VSIZE=XSAVE+1  	
      0018FA                       2864 cmd_words:
      0018FA                       2865 	_vars VSIZE 
      00A394 72 08            [ 2]    1     sub sp,#VSIZE 
      00A396 00 43            [ 1] 2866 	clr (COL_CNT,sp) 
      00A398 03 CC            [ 1] 2867 	clr (WCNT,sp)
      00A39A 97 DC            [ 1] 2868 	clr (SHOW_CODE,sp)
      00A39C                       2869 	_clrz acc16 
      00A39C CD 9F                    1     .byte 0x3f, acc16 
      00A39E 89 5B            [ 2] 2870 	ldw (YSAVE,sp),y 
      00A3A0 04 72            [ 1] 2871 	ld a,(y)
      00A3A2 19 00            [ 1] 2872 	cp a,#LITC_IDX 
      00A3A4 43 72            [ 1] 2873 	jrne 1$ 
      00A3A6 10 00            [ 1] 2874 	incw y 
      00190E                       2875 	_get_char 
      00A3A8 43 CC            [ 1]    1         ld a,(y)    ; 1 cy 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 140.
Hexadecimal [24-Bits]



      00A3AA 97 DC            [ 1]    2         incw y      ; 1 cy 
      00A3AC A1 43            [ 1] 2876 	cp a,#'C 
      00A3AC 27 03            [ 1] 2877 	jreq 0$ 
      00A3AC 72 00 00         [ 2] 2878 	jp syntax_error 
      001919                       2879 0$: 
      00A3AF 43 03            [ 2] 2880 	ldw (YSAVE,sp),y 
      00A3B1 CD 97            [ 1] 2881 	cpl (SHOW_CODE,sp)
      00A3B3 31 CC 97 DC      [ 2] 2882 	ldw y,#all_words+2 ; special char. bytecode 
      00A3B7 20 04            [ 2] 2883 	jra 2$
      001923                       2884 1$: 
      00A3B7 72 01 00 43      [ 2] 2885 	ldw y,#kword_dict+2 ; show only reserved words 
      001927                       2886 2$:
      00A3BB 03               [ 1] 2887 	ldw x,y
      00A3BC CC               [ 1] 2888 	ld a,(x) ; word length 
      00A3BD 97               [ 1] 2889 	incw x ; *word   	
      00A3BE DC 03            [ 1] 2890 	tnz (SHOW_CODE,sp)
      00A3BF 27 17            [ 1] 2891 	jreq 3$
      00A3BF 3F 0E            [ 2] 2892 	ldw (XSAVE,sp),x 
      00A3C1 5F               [ 1] 2893 	inc a 
      001931                       2894 	_straz acc8 	 	
      00A3C2 BF 0F                    1     .byte 0xb7,acc8 
      00A3C4 90 F6 90 5C      [ 2] 2895 	addw x,acc16 
      00A3C8 A1 06            [ 1] 2896 	ld a,#'$
      00A3CA 26 12 00         [ 4] 2897 	call uart_putc 
      00A3CC F6               [ 1] 2898 	ld a,(x)
      00A3CC 93 CD 98         [ 4] 2899 	call print_hex
      00A3CF 23 CD 93         [ 4] 2900 	call space
      00A3D2 CB 4D            [ 2] 2901 	ldw x,(XSAVE,sp)   
      001945                       2902 3$:
      00A3D4 27 03 00         [ 4] 2903 	call puts
      00A3D6 0C 02            [ 1] 2904 	inc (WCNT,sp)
      00A3D6 CD 93            [ 1] 2905 	inc (COL_CNT,sp)
      00A3D8 F7 01            [ 1] 2906 	ld a,(COL_CNT,sp)
      00A3D9 A1 04            [ 1] 2907 	cp a,#4 
      00A3D9 90 7F            [ 1] 2908 	jreq 5$ 
      00A3DB CC               [ 1] 2909 	swap a 
      00A3DC 97               [ 1] 2910 	inc a 
      00A3DD DC 00 00         [ 4] 2911 	call cursor_column
      00A3DE 20 05            [ 2] 2912 	jra  6$  
      001959                       2913 5$: 
      00A3DE A1 07 27         [ 4] 2914 	call new_line   
      00A3E1 03 CC            [ 1] 2915 	clr (COL_CNT,sp) 
      00195E                       2916 6$:	
      00A3E3 96 73 90 F6      [ 2] 2917 	subw y,#2 
      00A3E7 90 5C            [ 2] 2918 	ldw y,(y)
      00A3E9 A4 DF            [ 1] 2919 	jrne 2$ 
      00A3EB A1 46            [ 1] 2920 	ld a,#CR 
      00A3ED 27 03 CC         [ 4] 2921 	call uart_putc  
      00A3F0 96               [ 1] 2922 	clrw x 
      00A3F1 73 02            [ 1] 2923 	ld a,(WCNT,sp)
      00A3F2 97               [ 1] 2924 	ld xl,a 
      00A3F2 CD 8B A1         [ 4] 2925 	call print_int 
      00A3F5 CC 97 DC         [ 2] 2926 	ldw x,#words_count_msg
      00A3F8 CD 00 00         [ 4] 2927 	call puts 
      00A3F8 72 01            [ 2] 2928 	ldw y,(YSAVE,sp)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 141.
Hexadecimal [24-Bits]



      00197A                       2929 	_drop VSIZE 
      00A3FA 00 43            [ 2]    1     addw sp,#VSIZE 
      00197C                       2930 	_next 
      00A3FC 03 CC 97         [ 2]    1         jp interp_loop 
      00A3FF DC 77 6F 72 64 73 20  2931 words_count_msg: .asciz " words in dictionary\n"
             69 6E 20 64 69 63 74
             69 6F 6E 61 72 79 0A
             00
                                   2932 .endif 
                                   2933 
                                   2934 ;-----------------------------
                                   2935 ; BASIC: TIMER expr 
                                   2936 ; initialize count down timer 
                                   2937 ;-----------------------------
      00A400                       2938 cmd_set_timer:
      00A400 CE 00 3B         [ 4] 2939 	call arg_list
      00A403 72 B0            [ 1] 2940 	cp a,#1 
      00A405 00 37            [ 1] 2941 	jreq 1$
      00A407 27 36 90         [ 2] 2942 	jp syntax_error
      00199F                       2943 1$: 
      00199F                       2944 	_i16_pop  
      00A40A F6               [ 2]    1     popw x 
      00A40B 90 5C A1 06      [ 1] 2945 	bres sys_flags,#FSYS_TIMER  
      00A40F 27 03 CC         [ 2] 2946 	ldw timer,x
      0019A7                       2947 	_next 
      00A412 96 73 93         [ 2]    1         jp interp_loop 
                                   2948 
                                   2949 ;------------------------------
                                   2950 ; BASIC: TIMEOUT 
                                   2951 ; return state of timer 
                                   2952 ; output:
                                   2953 ;   A:X     0 not timeout 
                                   2954 ;   A:X     -1 timeout 
                                   2955 ;------------------------------
      0019AA                       2956 func_timeout:
      00A415 CD               [ 1] 2957 	clr a 
      00A416 98               [ 1] 2958 	clrw x 
      00A417 23 89 CD 93 CB   [ 2] 2959 	btjf sys_flags,#FSYS_TIMER,1$ 
      00A41C 4D               [ 1] 2960 	cpl a 
      00A41D 27               [ 2] 2961 	cplw x 
      00A41E 08               [ 4] 2962 1$:	ret 
                                   2963  	
                           000000  2964 .if 0
                                   2965 ;---------------------------
                                   2966 ; BASIC: DATA 
                                   2967 ; when the interpreter find 
                                   2968 ; a DATA line it skip over 
                                   2969 ;---------------------------
                                   2970 kword_data:
                                   2971 	jp kword_remark
                                   2972 
                                   2973 ;------------------------------
                                   2974 ; check if line is data line 
                                   2975 ; if so set data_pointers 
                                   2976 ; and return true 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 142.
Hexadecimal [24-Bits]



                                   2977 ; else move X to next line 
                                   2978 ; and return false 
                                   2979 ; input:
                                   2980 ;    X     line addr 
                                   2981 ; outpu:
                                   2982 ;    A     0 not data 
                                   2983 ;          1 data pointers set 
                                   2984 ;    X     updated to next line addr 
                                   2985 ;          if not data line 
                                   2986 ;--------------------------------
                                   2987 is_data_line:
                                   2988 	ld a,(LINE_HEADER_SIZE,x)
                                   2989 	cp a,#DATA_IDX 
                                   2990 	jrne 1$
                                   2991 	_strxz data_line 
                                   2992 	addw x,#FIRST_DATA_ITEM
                                   2993 	_strxz data_ptr  
                                   2994 	ld a,#1 
                                   2995 	ret 
                                   2996 1$: clr acc16 
                                   2997 	ld a,(2,x)
                                   2998 	ld acc8,a 
                                   2999 	addw x,acc16
                                   3000 	clr a 
                                   3001 	ret  
                                   3002 
                                   3003 ;---------------------------------
                                   3004 ; BASIC: RESTORE [line#]
                                   3005 ; set data_ptr to first data line
                                   3006 ; if no DATA found pointer set to
                                   3007 ; zero.
                                   3008 ; if a line# is given as argument 
                                   3009 ; a data line with that number 
                                   3010 ; is searched and the data pointer 
                                   3011 ; is set to it. If there is no 
                                   3012 ; data line with that number 
                                   3013 ; the program is interrupted. 
                                   3014 ;---------------------------------
                                   3015 cmd_restore:
                                   3016 	clrw x 
                                   3017 	ldw data_line,x 
                                   3018 	ldw data_ptr,x 
                                   3019 	_next_token 
                                   3020 	cp a,#CMD_END 
                                   3021 	jrugt 0$ 
                                   3022 	_unget_token 
                                   3023 	_ldxz lomem 
                                   3024 	jra 4$ 
                                   3025 0$:	cp a,#LITW_IDX
                                   3026 	jreq 2$
                                   3027 1$: jp syntax_error 	 
                                   3028 2$:	_get_word 
                                   3029 	call search_lineno  
                                   3030 	tnz a  
                                   3031 	jreq data_error 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 143.
Hexadecimal [24-Bits]



                                   3032 	call is_data_line
                                   3033 	tnz a 
                                   3034 	jrne 9$ 
                                   3035 	jreq data_error
                                   3036 4$:
                                   3037 ; search first DATA line 	
                                   3038 5$:	
                                   3039 	cpw x,himem
                                   3040 	jruge data_error 
                                   3041 	call is_data_line 
                                   3042 	tnz a 
                                   3043 	jreq 5$ 
                                   3044 9$:	_next  
                                   3045 
                                   3046 data_error:	
                                   3047     ld a,#ERR_NO_DATA 
                                   3048 	jp tb_error 
                                   3049 
                                   3050 
                                   3051 ;---------------------------------
                                   3052 ; BASIC: READ 
                                   3053 ; return next data item | data error
                                   3054 ; output:
                                   3055 ;    A:X int24  
                                   3056 ;---------------------------------
                                   3057 func_read_data:
                                   3058 read01:	
                                   3059 	ldw x,data_ptr
                                   3060 	ld a,(x)
                                   3061 	incw x 
                                   3062 	tnz a 
                                   3063 	jreq 4$ ; end of line
                                   3064 	cp a,#REM_IDX
                                   3065 	jreq 4$  
                                   3066 	cp a,#COMMA_IDX 
                                   3067 	jrne 1$ 
                                   3068 	ld a,(x)
                                   3069 	incw x 
                                   3070 1$:
                                   3071 .if 0
                                   3072 	cp a,#LIT_IDX 
                                   3073 	jreq 2$
                                   3074 .endif
                                   3075 	cp a,#LITW_IDX 
                                   3076 	jreq 14$
                                   3077 	jra data_error 
                                   3078 14$: ; word 
                                   3079 	clr a 
                                   3080 	_strxz data_ptr 	
                                   3081 	ldw x,(x)
                                   3082 .if 0	
                                   3083 	jra 24$
                                   3084 2$:	; int24  
                                   3085 	ld a,(x)
                                   3086 	incw x 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 144.
Hexadecimal [24-Bits]



                                   3087 	_strxz data_ptr 
                                   3088 	ldw x,(x)
                                   3089 24$:
                                   3090 .endif 
                                   3091 	pushw x 
                                   3092 	_ldxz data_ptr 
                                   3093 	addw x,#2 
                                   3094 	_strxz data_ptr
                                   3095 	popw x 
                                   3096 3$:
                                   3097 	ret 
                                   3098 4$: ; check if next line is DATA  
                                   3099 	_ldxz data_line
                                   3100 	ld a,(2,x)
                                   3101 	ld acc8,a
                                   3102 	clr acc16  
                                   3103 	addw x,acc16 
                                   3104 	call is_data_line 
                                   3105 	tnz a 
                                   3106 	jrne read01  
                                   3107 	jra data_error 
                                   3108 
                                   3109 ;-------------------------------
                                   3110 ; BASIC: CHAIN label
                                   3111 ; Execute another program like it 
                                   3112 ; is a sub-routine. When the 
                                   3113 ; called program terminate 
                                   3114 ; execution continue at caller 
                                   3115 ; after CHAIN command. 
                                   3116 ; if a line# is given, the 
                                   3117 ; chained program start execution 
                                   3118 ; at this line#.
                                   3119 ;---------------------------------
                                   3120 	CHAIN_ADDR=1 
                                   3121 	CHAIN_LNADR=3
                                   3122 	CHAIN_BP=5
                                   3123 	CHAIN_TXTBGN=7 
                                   3124 	CHAIN_TXTEND=9 
                                   3125 	VSIZE=10
                                   3126 	DISCARD=2
                                   3127 cmd_chain:
                                   3128 	_vars VSIZE 
                                   3129 	clr (CHAIN_LN,sp) 
                                   3130 	clr (CHAIN_LN+1,sp)  
                                   3131 	ld a,#LABEL_IDX 
                                   3132 	call expect 
                                   3133 	pushw y 
                                   3134 	call skip_label
                                   3135 	popw x 
                                   3136 	incw x
                                   3137 	call search_file 
                                   3138 	tnzw x  
                                   3139 	jrne 1$ 
                                   3140 0$:	ld a,#ERR_BAD_VALUE
                                   3141 	jp tb_error 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 145.
Hexadecimal [24-Bits]



                                   3142 1$: addw x,#FILE_HEADER_SIZE 
                                   3143 	ldw (CHAIN_ADDR,sp), x ; program addr 
                                   3144 ; save chain context 
                                   3145 	_ldxz line.addr 
                                   3146 	ldw (CHAIN_LNADR,sp),x 
                                   3147 	ldw (CHAIN_BP,sp),y
                                   3148 	_ldxz lomem 
                                   3149 	ldw (CHAIN_TXTBGN,sp),x
                                   3150 	_ldxz himem 
                                   3151 	ldw (CHAIN_TXTEND,sp),x  
                                   3152 ; set chained program context 	
                                   3153 	ldw x,(CHAIN_ADDR,sp)
                                   3154 	ldw line.addr,x 
                                   3155 	ldw lomem,x 
                                   3156 	subw x,#2
                                   3157 	ldw x,(x)
                                   3158 	addw x,(CHAIN_ADDR,sp)
                                   3159 	ldw himem,x  
                                   3160 	ldw y,(CHAIN_ADDR,sp)
                                   3161 	addw y,#LINE_HEADER_SIZE 
                                   3162     _incz chain_level
                                   3163 	_drop DISCARD
                                   3164 	_next 
                                   3165 
                                   3166 
                                   3167 ;-----------------------------
                                   3168 ; BASIC TRACE 0|1 
                                   3169 ; disable|enable line# trace 
                                   3170 ;-----------------------------
                                   3171 cmd_trace:
                                   3172 	_next_token
                                   3173 	cp a,#LITW_IDX
                                   3174 	jreq 1$ 
                                   3175 	jp syntax_error 
                                   3176 1$: _get_word 
                                   3177     tnzw x 
                                   3178 	jrne 2$ 
                                   3179 	bres flags,#FTRACE 
                                   3180 	_next 
                                   3181 2$: bset flags,#FTRACE 
                                   3182 	_next 
                                   3183 
                                   3184 .endif 
                                   3185 
                                   3186 ;-------------------------
                                   3187 ; BASIC: TAB expr 
                                   3188 ;  print spaces 
                                   3189 ;------------------------
      0019B4                       3190 cmd_tab:
      00A41F AE A4 53         [ 4] 3191 	call expression  
      00A422 CD               [ 1] 3192 	clr a 
      00A423 85               [ 1] 3193 	ld xh,a
      00A424 CD 20 27         [ 4] 3194 	call spaces 
      00A427                       3195 	_next 
      00A427 CD 94 E7         [ 2]    1         jp interp_loop 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 146.
Hexadecimal [24-Bits]



                                   3196 
                                   3197 ;---------------------
                                   3198 ; BASIC: CALL expr1 [,func_arg] 
                                   3199 ; execute a function written 
                                   3200 ; in binary code.
                                   3201 ; input:
                                   3202 ;   expr1	routine address
                                   3203 ;   expr2   optional argument passed in X  
                                   3204 ; output:
                                   3205 ;    none 
                                   3206 ;---------------------
                           000001  3207 	FN_ARG=1
                           000003  3208 	FN_ADR=3
      0019BF                       3209 cmd_call::
      00A42A 4D 26 0C         [ 4] 3210 	call arg_list 
      00A42D CE 00            [ 1] 3211 	cp a,#1
      00A42F 3B 72            [ 1] 3212 	jreq 1$
      00A431 B0 00            [ 1] 3213 	cp a,#2
      00A433 37 CD            [ 1] 3214 	jreq 0$ 
      00A435 94 05 27         [ 2] 3215 	jp syntax_error 
      0019CD                       3216 0$: 
      0019CD                       3217 	_i16_fetch FN_ADR  
      00A438 0E 03            [ 2]    1     ldw x,(FN_ADR,sp)
      00A439                       3218 	_strxz ptr16 
      00A439 85 CD                    1     .byte 0xbf,ptr16 
      0019D1                       3219 	_i16_pop 
      00A43B 94               [ 2]    1     popw x 
      0019D2                       3220 	_drop 2 
      00A43C 7E 20            [ 2]    1     addw sp,#2 
      00A43E 0F CD 00 00      [ 6] 3221 	call [ptr16]
      00A43F                       3222 	_next 
      00A43F AE A4 64         [ 2]    1         jp interp_loop 
      0019DB                       3223 1$: _i16_pop 	
      00A442 CD               [ 2]    1     popw x 
      00A443 85               [ 4] 3224 	call (x)
      0019DD                       3225 	_next 
      00A444 CD 20 07         [ 2]    1         jp interp_loop 
                                   3226 
                                   3227 ;------------------------
                                   3228 ; BASIC:AUTO expr1, expr2 
                                   3229 ; enable auto line numbering
                                   3230 ;  expr1   start line number 
                                   3231 ;  expr2   line# increment 
                                   3232 ;-----------------------------
      00A447                       3233 cmd_auto:
      00A447 85 AE A4 78 CD   [ 2] 3234 	btjt flags,#FRUN,9$ 
      00A44C 85 CD 0A         [ 2] 3235 	ldw x,#10 
      00A44E                       3236 	_strxz auto_step 
      00A44E 90 7F                    1     .byte 0xbf,auto_step 
      0019EA                       3237 	_strxz auto_line 
      00A450 CC 97                    1     .byte 0xbf,auto_line 
      00A452 DC 44 75         [ 4] 3238 	call arg_list 
      00A455 70               [ 1] 3239 	tnz a 
      00A456 6C 69            [ 1] 3240 	jreq 8$ 
      00A458 63 61            [ 1] 3241 	cp a,#1
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 147.
Hexadecimal [24-Bits]



      00A45A 74 65            [ 1] 3242 	jreq 1$
      00A45C 20 6E            [ 1] 3243 	cp a,#2
      00A45E 61 6D            [ 1] 3244 	jreq 0$ 
      00A460 65 2E 0A         [ 2] 3245 	jp syntax_error 
      0019FD                       3246 0$: 
      0019FD                       3247 	_i16_pop 
      00A463 00               [ 2]    1     popw x 
      0019FE                       3248 	_strxz auto_step 
      00A464 4E 6F                    1     .byte 0xbf,auto_step 
      001A00                       3249 1$:	
      001A00                       3250 	 _i16_pop 
      00A466 20               [ 2]    1     popw x 
      001A01                       3251 	_strxz auto_line
      00A467 70 72                    1     .byte 0xbf,auto_line 
      001A03                       3252 8$:
      00A469 6F 67 72 61      [ 1] 3253 	bset flags,#FAUTO
      001A07                       3254 9$: 
      001A07                       3255 	_next 
      00A46D 6D 20 69         [ 2]    1         jp interp_loop 
                                   3256 
                                   3257 
      001A0A                       3258 clear_state:
      001A0A                       3259 	_ldxz dvar_bgn
      00A470 6E 20                    1     .byte 0xbe,dvar_bgn 
      001A0C                       3260 	_strxz dvar_end 
      00A472 52 41                    1     .byte 0xbf,dvar_end 
      00A474 4D 2E 0A         [ 2] 3261 	ldw x,himem  
      001A11                       3262 	_strxz heap_free  
      00A477 00 46                    1     .byte 0xbf,heap_free 
      001A13                       3263 	_rst_pending 
      00A479 69 6C 65         [ 2]    1     ldw x,#pending_stack+PENDING_STACK_SIZE
      001A16                          2     _strxz psp 
      00A47C 20 73                    1     .byte 0xbf,psp 
      001A18                       3264 	_clrz gosub_nest 
      00A47E 79 73                    1     .byte 0x3f, gosub_nest 
      001A1A                       3265 	_clrz for_nest
      00A480 74 65                    1     .byte 0x3f, for_nest 
      00A482 6D               [ 4] 3266 	ret 
                                   3267 
                                   3268 ;---------------------------
                                   3269 ; BASIC: CLR 
                                   3270 ; reset stacks 
                                   3271 ; clear all variables
                                   3272 ;----------------------------
      001A1D                       3273 cmd_clear:
      00A483 20 66 75 6C 6C   [ 2] 3274 	btjt flags,#FRUN,9$
      00A488 2E 0A 00         [ 2] 3275 	ldw x,#STACK_EMPTY
      00A48B 94               [ 1] 3276 	ldw sp,x 
      00A48B 72 01 00         [ 4] 3277 	call clear_state  
      001A29                       3278 9$: 
      001A29                       3279 	_next 
      00A48E 43 03 CC         [ 2]    1         jp interp_loop 
                                   3280 
                                   3281 ;----------------------------
                                   3282 ; BASIC: DEL val1,val2 	
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 148.
Hexadecimal [24-Bits]



                                   3283 ;  delete all programs lines 
                                   3284 ;  from val1 to val2 
                                   3285 ;----------------------------
                           000001  3286 	START_ADR=1
                           000003  3287 	END_ADR=START_ADR+ADR_SIZE 
                           000005  3288 	DEL_SIZE=END_ADR+ADR_SIZE 
                           000007  3289 	YSAVE=DEL_SIZE+INT_SIZE 
                           000008  3290 	VSIZE=4*INT_SIZE  
      001A2C                       3291 cmd_del:
      00A491 97 DC 00 43 03   [ 2] 3292 	btjf flags,#FRUN,0$
      00A493                       3293 	_next 
      00A493 90 F6 90         [ 2]    1         jp interp_loop 
      001A34                       3294 0$:
      001A34                       3295 	_vars VSIZE
      00A496 5C A1            [ 2]    1     sub sp,#VSIZE 
      00A498 06               [ 1] 3296 	clrw x  
      00A499 27 03            [ 2] 3297 	ldw (END_ADR,sp),x  
      00A49B CC 96 73         [ 4] 3298 	call arg_list 
      00A49E A1 02            [ 1] 3299 	cp a,#2 
      00A49E CD A4            [ 1] 3300 	jreq 1$ 
      00A4A0 B4 CC            [ 1] 3301 	cp a,#1
      00A4A2 97 DC            [ 1] 3302 	jreq 2$ 
      00A4A4 66 69 6C         [ 2] 3303 	jp syntax_error 
      001A47                       3304 1$:	; range delete 
      001A47                       3305 	_i16_pop ; val2   
      00A4A7 65               [ 2]    1     popw x 
      00A4A8 20               [ 1] 3306 	clr a 
      00A4A9 6E 6F 74         [ 4] 3307 	call search_lineno 
      00A4AC 20               [ 1] 3308 	tnz a ; 0 not found 
      00A4AD 66 6F            [ 1] 3309 	jreq not_a_line 
                                   3310 ; this last line to be deleted 
                                   3311 ; skip at end of it 
      001A4F                       3312 	_strxz acc16 	
      00A4AF 75 6E                    1     .byte 0xbf,acc16 
      00A4B1 64 0A            [ 1] 3313 	ld a,(2,x) ; line length 
      00A4B3 00               [ 1] 3314 	clrw x 
      00A4B4 97               [ 1] 3315 	ld xl,a 
      00A4B4 93 CD 98 23      [ 2] 3316 	addw x,acc16 
      00A4B8 CD 93            [ 2] 3317 	ldw (END_ADR+INT_SIZE,sp),x
      001A5B                       3318 2$: 
      001A5B                       3319 	_i16_pop ; val1 
      00A4BA CB               [ 2]    1     popw x 
      00A4BB 4D               [ 1] 3320 	clr a 
      00A4BC 26 08 AE         [ 4] 3321 	call search_lineno 
      00A4BF A4               [ 1] 3322 	tnz a 
      00A4C0 A4 CD            [ 1] 3323 	jreq not_a_line 
      00A4C2 85 CD            [ 2] 3324 	ldw (START_ADR,sp),x 
      00A4C4 20 06            [ 2] 3325 	ldw x,(END_ADR,sp)
      00A4C6 26 0B            [ 1] 3326 	jrne 4$ 
                                   3327 ; END_ADR not set there was no val2 
                                   3328 ; skip end of this line for END_ADR 
      00A4C6 CD 97            [ 2] 3329 	ldw x,(START_ADR,sp)
      00A4C8 31 CD            [ 1] 3330 	ld a,(2,x)
      00A4CA 94               [ 1] 3331 	clrw x 
      00A4CB 55               [ 1] 3332 	ld xl,a 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 149.
Hexadecimal [24-Bits]



      00A4CC 72 FB 01         [ 2] 3333 	addw x,(START_ADR,sp)
      00A4CC 90 7F            [ 2] 3334 	ldw (END_ADR,sp),x 
      001A74                       3335 4$: 
      00A4CE 81 F0 01         [ 2] 3336 	subw x,(START_ADR,sp)
      00A4CF 1F 05            [ 2] 3337 	ldw (DEL_SIZE,sp),x 
      00A4CF 72 01 00         [ 2] 3338 	ldw x,progend 
      00A4D2 43 03 CC         [ 2] 3339 	subw x,(END_ADR,sp)
      001A7F                       3340 	_strxz acc16 
      00A4D5 97 DC                    1     .byte 0xbf,acc16 
      00A4D7 1E 01            [ 2] 3341 	ldw x,(START_ADR,sp)
      00A4D7 4B 00            [ 2] 3342 	ldw (YSAVE,sp),y 
      00A4D9 4B 00            [ 2] 3343 	ldw y,(END_ADR,sp)
      00A4DB CD 95 28         [ 4] 3344 	call move 
      00A4DE                       3345 	_ldxz progend 
      00A4DE 4D 27                    1     .byte 0xbe,progend 
      00A4E0 36 1E 01         [ 2] 3346 	subw x,(DEL_SIZE,sp)
      001A8F                       3347 	_strxz progend 
      00A4E3 5C 1F                    1     .byte 0xbf,progend 
      00A4E5 01 AE            [ 2] 3348 	ldw y,(YSAVE,sp)
      001A93                       3349 	_drop VSIZE
      00A4E7 00 60            [ 2]    1     addw sp,#VSIZE 
      001A95                       3350 	_next 
      00A4E9 89 CD 85         [ 2]    1         jp interp_loop 
      001A98                       3351 not_a_line:
      00A4EC CD 85            [ 1] 3352 	ld a,#ERR_RANGE 
      00A4EE CD 88 94         [ 2] 3353 	jp tb_error 
                                   3354 
                                   3355 
                                   3356 ;-----------------------------
                                   3357 ; BASIC: HIMEM = expr 
                                   3358 ; set end memory address of
                                   3359 ; BASIC program space.
                                   3360 ;------------------------------
      001A9D                       3361 cmd_himem:
      00A4F1 88 4B 00 AE 00   [ 2] 3362 	btjf flags,#FRUN,1$
      001AA2                       3363 	_next 
      00A4F6 0C 72 F0         [ 2]    1         jp interp_loop 
      00A4F9 01 CD            [ 1] 3364 1$: ld a,#REL_EQU_IDX 
      00A4FB 86 01 5B         [ 4] 3365 	call expect 
      00A4FE 02 AE 00         [ 4] 3366 	call expression 
      00A501 5E FE CD         [ 2] 3367 	cpw x,lomem  
      00A504 88 3C            [ 2] 3368 	jrule bad_value 
      00A506 AE A5 29         [ 2] 3369 	cpw x,#tib  
      00A509 CD 85            [ 1] 3370 	jruge bad_value  
      001AB7                       3371 	_strxz himem
      00A50B CD AE                    1     .byte 0xbf,himem 
      00A50D 00 5C            [ 2] 3372 	jra clear_prog_space  
      001ABB                       3373 	_next 
      00A50F CD 95 6F         [ 2]    1         jp interp_loop 
                                   3374 ;--------------------------------
                                   3375 ; BASIC: LOWMEM = expr 
                                   3376 ; set start memory address of 
                                   3377 ; BASIC program space. 	
                                   3378 ;---------------------------------
      001ABE                       3379 cmd_lomem:
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 150.
Hexadecimal [24-Bits]



      00A512 CD 95 2D 20 C7   [ 2] 3380 	btjf flags,#FRUN,1$
      00A517                       3381 	_next
      00A517 CD 85 EA         [ 2]    1         jp interp_loop 
      00A51A 85 CD            [ 1] 3382 1$: ld a,#REL_EQU_IDX 
      00A51C 88 3C AE         [ 4] 3383 	call expect 
      00A51F A5 30 CD         [ 4] 3384 	call expression 
      00A522 85 CD 90         [ 2] 3385 	cpw x,#free_ram 
      00A525 7F CC            [ 1] 3386 	jrult bad_value 
      00A527 97 DC 62         [ 2] 3387 	cpw x,himem  
      00A52A 79 74            [ 1] 3388 	jruge bad_value 
      001AD8                       3389 	_strxz lomem
      00A52C 65 73                    1     .byte 0xbf,lomem 
      001ADA                       3390 clear_prog_space: 
      00A52E 0A 00 66         [ 4] 3391 	call clear_state 
      001ADD                       3392 	_ldxz lomem 
      00A531 69 6C                    1     .byte 0xbe,lomem 
      001ADF                       3393 	_strxz progend 
      00A533 65 73                    1     .byte 0xbf,progend 
      00A535 00 1A EC         [ 4] 3394 	call free 
      00A536                       3395 	_next 
      00A536 72 00 00         [ 2]    1         jp interp_loop 
      001AE7                       3396 bad_value:
      00A539 43 09            [ 1] 3397 	ld a,#ERR_RANGE 
      00A53B 72 0D 52         [ 2] 3398 	jp tb_error 
                                   3399 
      001AEC                       3400 free: 
      00A53E 40 FB 35         [ 2] 3401 	ldw x,himem 
      00A541 80 50 D1 CC      [ 2] 3402 	subw x,lomem 
      00A545 97 DC 00         [ 4] 3403 	call print_int  
      00A547 AE 1A FD         [ 2] 3404 	ldw x,#bytes_free   
      00A547 CD 99 D4         [ 4] 3405 	call puts 
      00A54A 72               [ 4] 3406 	ret 
      00A54B 11 00 07 CF 00 03 8F  3407 bytes_free: .asciz "bytes free" 
             CE 00 03 26
                                   3408 
                                   3409 ;-----------------------------
                                   3410 ; BASIC: CLS 
                                   3411 ; send clear screen command 
                                   3412 ; to terminal 
                                   3413 ;-----------------------------
      001B08                       3414 cmd_cls:
      00A556 FA CC 97         [ 4] 3415 	call clr_screen
      00A559 DC 11 00 00      [ 1] 3416 	bres sys_flags,#FSYS_TIMER 
      00A55A AE 00 04         [ 2] 3417 	ldw x,#4 ; give time to terminal
      001B12                       3418 	_strxz timer  
      00A55A BE 01                    1     .byte 0xbf,timer 
      00A55C 81 01 00 00 FB   [ 2] 3419 	btjf sys_flags,#FSYS_TIMER,.
      00A55D                       3420 	_next 
      00A55D A6 04 CD         [ 2]    1         jp interp_loop 
                                   3421 
                                   3422 ;-----------------------------
                                   3423 ; BASIC: LOCATE line, column 
                                   3424 ; set terminal cursor position
                                   3425 ;------------------------------
                           000001  3426 	COL=1 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 151.
Hexadecimal [24-Bits]



                           000003  3427 	LN=COL+INT_SIZE 
      001B1C                       3428 cmd_locate:
      00A560 98 CC CD         [ 4] 3429 	call arg_list 
      00A563 99 D4            [ 1] 3430 	cp a,#2 
      00A565 9F 5F            [ 1] 3431 	jreq 1$ 
      00A567 97 A6 05         [ 2] 3432 	jp syntax_error 
      001B26                       3433 1$: 
      001B26                       3434 	_i16_fetch LN
      00A56A CD 98            [ 2]    1     ldw x,(LN,sp)
      00A56C CC               [ 1] 3435 	ld a,xl 
      001B29                       3436 	_i16_fetch COL 
      00A56D 81 01            [ 2]    1     ldw x,(COL,sp)
      00A56E 95               [ 1] 3437 	ld xh,a 
      00A56E CD 98 DA         [ 4] 3438 	call set_cursor_pos
      001B2F                       3439 	_drop 2*INT_SIZE 
      00A571 A1 01            [ 2]    1     addw sp,#2*INT_SIZE 
      001B31                       3440 	_next  
      00A573 27 03 CC         [ 2]    1         jp interp_loop 
                                   3441 
                                   3442 ;-----------------------------
                                   3443 ; BASIC CHAT(line,column) 
                                   3444 ; get CHaracter AT line,column 
                                   3445 ; from terminal 
                                   3446 ; output:
                                   3447 ;   X     character 
                                   3448 ;------------------------------
                           000001  3449 	COL=1 
                           000003  3450 	LN=COL+INT_SIZE 
      001B34                       3451 func_chat:
      00A576 96 73 E8         [ 4] 3452 	call func_args 
      00A578 A1 02            [ 1] 3453 	cp a,#2 
      00A578 85 5D            [ 1] 3454 	jreq 1$ 
      00A57A 2A 01 50         [ 2] 3455 	jp syntax_error 
      001B3E                       3456 1$:
      00A57D 81 00 00         [ 4] 3457 	call save_cursor_pos 
      00A57E                       3458 	_i16_fetch LN 
      00A57E CD 98            [ 2]    1     ldw x,(LN,sp)
      00A580 DA               [ 1] 3459 	ld a,xl 
      001B44                       3460 	_i16_fetch COL 
      00A581 A1 01            [ 2]    1     ldw x,(COL,sp)
      00A583 27               [ 1] 3461 	ld xh,a 
      00A584 03 CC 96         [ 4] 3462 	call set_cursor_pos 
      00A587 73 00 00         [ 4] 3463 	call get_char_at 
      00A588 5F               [ 1] 3464 	clrw x 
      00A588 CD               [ 1] 3465 	ld xl,a 
      001B4F                       3466 	_i16_store COL 
      00A589 83 6F            [ 2]    1     ldw (COL,sp),x 
      00A58B 90 89 16         [ 4] 3467 	call restore_cursor_pos
      001B54                       3468 	_i16_fetch COL 
      00A58E 03 65            [ 2]    1     ldw x,(COL,sp)
      001B56                       3469 	_drop 2*INT_SIZE 
      00A590 51 90            [ 2]    1     addw sp,#2*INT_SIZE 
      00A592 85               [ 4] 3470 	ret 
                                   3471 
                                   3472 ;----------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 152.
Hexadecimal [24-Bits]



                                   3473 ; BASIC: CPOS 
                                   3474 ; get terminal cursor position 
                                   3475 ;  line=CPOS/256 
                                   3476 ;  column=CPOS AND 255 
                                   3477 ;-----------------------------
      001B59                       3478 func_cpos:
      00A593 5B 02 81         [ 4] 3479 	call cursor_pos  
      00A596 81               [ 4] 3480 	ret 
                                   3481 
                                   3482 ;------------------------------
                                   3483 ; BASIC: RENUM [expr1, epxr2]  
                                   3484 ; renumber program lines 
                                   3485 ; starting at expr1 step expr2 
                                   3486 ;------------------------------
                           000001  3487 	STEP=1
                           000003  3488 	START=STEP+2 
                           000004  3489 	VSIZE=START+1
      001B5D                       3490 cmd_renum:
      00A596 CD 99 D4 CD 83   [ 2] 3491 	btjt flags,#FRUN,9$
      00A59B 91 CC 97         [ 4] 3492 	call arg_list 
      00A59E DC               [ 1] 3493 	tnz a 
      00A59F 26 07            [ 1] 3494 	jrne 1$
      00A59F CD 98 DA         [ 2] 3495 	ldw x,#10 
      00A5A2 A1               [ 2] 3496 	pushw x 
      00A5A3 01               [ 2] 3497 	pushw x 
      00A5A4 27 03            [ 2] 3498 	jra 4$
      00A5A6 CC 96            [ 1] 3499 1$: cp a,#1 
      00A5A8 73 06            [ 1] 3500 	jrne 2$ 
      00A5A9 AE 00 0A         [ 2] 3501 	ldw x,#10 
      00A5A9 85               [ 2] 3502 	pushw x 
      00A5AA 5D 27            [ 2] 3503 	jra 4$ 
      00A5AC 09 2B            [ 1] 3504 2$:	cp a,#2 
      00A5AE 04 AE            [ 1] 3505 	jreq 4$
      00A5B0 00 01 81         [ 2] 3506 	jp syntax_error 
      001B80                       3507 4$:
      00A5B3 AE FF FF         [ 4] 3508 	call line_to_addr
      00A5B6 81 85            [ 2] 3509 	popw y
      00A5B7 85               [ 2] 3510 	popw x 
      00A5B7 A6 04 CD         [ 4] 3511 	call renumber ; x=START,Y=STEP 
      00A5BA 98 CC 90         [ 4] 3512 	call addr_to_line  
      00A5BD F6 90            [ 1] 3513 9$:	clr (y)
      001B8E                       3514 	_next 
      00A5BF 5C A1 06         [ 2]    1         jp interp_loop 
                                   3515 
                                   3516 ;--------------------------
                                   3517 ; replace GOTO|GOSUB|THEN 
                                   3518 ; line#
                                   3519 ; by line address|0x8000
                                   3520 ;--------------------------
      001B91                       3521 line_to_addr:
      00A5C2 26 10 93 CD      [ 2] 3522 	ldw y,lomem 
      001B95                       3523 0$:	_stryz line.addr 
      00A5C6 88 94 88                 1     .byte 0x90,0xbf,line.addr 
      00A5C9 4B 00 72 F9      [ 2] 3524 	addw y,#LINE_HEADER_SIZE
      00A5CD 01 90 5C         [ 4] 3525 1$:	call scan_for_branch 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 153.
Hexadecimal [24-Bits]



      00A5D0 5B               [ 2] 3526 	tnzw x 
      00A5D1 02 20            [ 1] 3527 	jreq 4$ 
      00A5D3 10               [ 2] 3528 	ldw x,(x) ; line # 
      00A5D4 CD 1B B5         [ 4] 3529 	call line_by_addr
      00A5D4 A1 0A 27 03      [ 2] 3530 	addw y,#2 
      00A5D8 CC 96            [ 2] 3531 	jra 1$ 
      001BAC                       3532 4$: ; at end of line 
      00A5DA 73 5C            [ 1] 3533 	incw y 
      00A5DB 90 C3 00 3B      [ 2] 3534 	cpw y,progend 
      00A5DB CD 9C            [ 1] 3535 	jrmi 0$ 
      001BB4                       3536 9$:
      00A5DD 76               [ 4] 3537 	ret 
                                   3538 
                                   3539 ;-------------------------
                                   3540 ; replace line number 
                                   3541 ; by line address|0x8000
                                   3542 ; input:
                                   3543 ;   X    line number 
                                   3544 ;   Y    plug address 
                                   3545 ;--------------------------
      001BB5                       3546 line_by_addr:
      00A5DE EE               [ 1] 3547 	clr a 
      00A5DF 02 5C CD         [ 4] 3548 	call search_lineno
      00A5E2 88               [ 1] 3549 	tnz a 
      00A5E3 94 05            [ 1] 3550 	jrne 2$ 
      00A5E4 A6 04            [ 1] 3551 	ld a,#ERR_BAD_BRANCH
      00A5E4 5F 97 A6         [ 2] 3552 	jp tb_error 
      00A5E7 05               [ 1] 3553 2$: ld a,xh 
      00A5E8 CD 98            [ 1] 3554 	or a,#0x80 
      00A5EA CC               [ 1] 3555 	ld xh,a 
      00A5EB 81 FF            [ 2] 3556 	ldw (y),x 
      00A5EC 81               [ 4] 3557 	ret 
                                   3558 
                                   3559 
                                   3560 ;---------------------------
                                   3561 ; replace target line address 
                                   3562 ; by line number 
                                   3563 ;---------------------------
      001BC8                       3564 addr_to_line:
      00A5EC 52 07 0F 01      [ 2] 3565 	ldw y,lomem 
      001BCC                       3566 0$: _stryz line.addr 
      00A5F0 0F 02 0F                 1     .byte 0x90,0xbf,line.addr 
      00A5F3 03 3F 15 17      [ 2] 3567 	addw y,#LINE_HEADER_SIZE
      00A5F7 04 90 F6         [ 4] 3568 1$: call scan_for_branch
      00A5FA A1               [ 2] 3569 	tnzw x 
      00A5FB 07 26            [ 1] 3570 	jreq 4$ 
      00A5FD 17               [ 2] 3571 	ldw x,(x) ; ln_addr|0x8000
      00A5FE 90               [ 1] 3572 	ld a,xh 
      00A5FF 5C 90            [ 1] 3573 	and a,#0x7f 
      00A601 F6               [ 1] 3574 	ld xh,a ; x=line addr 
      00A602 90               [ 1] 3575 	ld a,(x)
      00A603 5C A1            [ 1] 3576 	ld (y),a 
      00A605 43 27            [ 1] 3577 	ld a,(1,x)
      00A607 03 CC 96         [ 1] 3578 	ld (1,y),a 
      00A60A 73 A9 00 02      [ 2] 3579 	addw y,#2 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 154.
Hexadecimal [24-Bits]



      00A60B 20 E7            [ 2] 3580 	jra 1$ 
      001BEC                       3581 4$: ; at end of line 
      00A60B 17 04            [ 1] 3582 	incw y 
      00A60D 03 03 90 AE      [ 2] 3583 	cpw y,progend 
      00A611 AC 05            [ 1] 3584 	jrmi 0$ 
      00A613 20               [ 4] 3585 9$:	ret 
                                   3586 
                                   3587 ;------------------------
                                   3588 ; renumber program lines 
                                   3589 ; input:
                                   3590 ;   x   start line 
                                   3591 ;   y   step 
                                   3592 ;-------------------------
                           000001  3593 	LN_LEN=1
                           000003  3594 	STEP=LN_LEN+2
                           000004  3595 	VSIZE=STEP+1  
      001BF5                       3596 renumber:
      001BF5                       3597 	_vars VSIZE 
      00A614 04 04            [ 2]    1     sub sp,#VSIZE 
      00A615 0F 01            [ 1] 3598 	clr (LN_LEN,sp)
      00A615 90 AE            [ 2] 3599 	ldw (STEP,sp),y
      00A617 AB 88 00 37      [ 2] 3600 	ldw y,lomem 
      00A619 90 FF            [ 2] 3601 1$:	ldw (y),x ; first line 
      00A619 93 F6 5C         [ 2] 3602 	addw x,(STEP,sp)
      00A61C 0D 03 27         [ 1] 3603 	ld a,(2,y)
      00A61F 17 1F            [ 1] 3604 	ld (LN_LEN+1,sp),a 
      00A621 06 4C B7         [ 2] 3605 	addw y,(LN_LEN,sp)
      00A624 16 72 BB 00      [ 2] 3606 	cpw y,progend 
      00A628 15 A6            [ 1] 3607 	jrmi 1$ 
      001C12                       3608 9$:	_drop VSIZE 
      00A62A 24 CD            [ 2]    1     addw sp,#VSIZE 
      00A62C 85               [ 4] 3609 	ret 
                                   3610 
                                   3611 ;-------------------------
                                   3612 ; scan line for 
                                   3613 ; GOTO|GOSUB|THEN ln# 
                                   3614 ; input:
                                   3615 ;    Y   basic pointer 
                                   3616 ; output:
                                   3617 ;    X   0 | addr GO...
                                   3618 ;-------------------------
      001C15                       3619 scan_for_branch:
      00A62D 98               [ 1] 3620 	clrw x 
      00A62E F6 CD            [ 1] 3621 0$:	ld a,(y)
      00A630 88 2A            [ 1] 3622 	cp a,#EOL_IDX 
      00A632 CD 85            [ 1] 3623 	jreq 9$ 
      00A634 FB 1E            [ 1] 3624 	cp a,#GOTO_IDX
      00A636 06 59            [ 1] 3625 	jreq 8$ 
      00A637 A1 1D            [ 1] 3626 	cp a,#GOSUB_IDX 
      00A637 CD 85            [ 1] 3627 	jreq 8$ 
      00A639 CD 0C            [ 1] 3628 	cp a,#THEN_IDX
      00A63B 02 0C            [ 1] 3629 	jrne 1$ 
      00A63D 01 7B 01         [ 1] 3630 	ld a,(1,y)
      00A640 A1 04            [ 1] 3631 	cp a,#LITW_IDX
      00A642 27 07            [ 1] 3632 	jreq 8$ 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 155.
Hexadecimal [24-Bits]



      00A644 4E 4C            [ 1] 3633 	incw y 
      00A646 CD 87            [ 2] 3634 	jra 0$ 
      00A648 50 20            [ 1] 3635 1$: cp a,#DELIM_LAST+1
      00A64A 05 04            [ 1] 3636 	jrpl 2$ 
      00A64B 90 5C            [ 1] 3637 	incw y 
      00A64B CD 85            [ 2] 3638 	jra 0$ 
      00A64D EA 0F            [ 1] 3639 2$: cp a,#LITC_IDX 
      00A64F 01 06            [ 1] 3640 	jrne 3$ 
      00A650 72 A9 00 02      [ 2] 3641 	addw y,#2 
      00A650 72 A2            [ 2] 3642 	jra 0$ 
      00A652 00 02            [ 1] 3643 3$: cp a,#SYMB_LAST+1
      00A654 90 FE            [ 1] 3644 	jrpl 4$ 
      00A656 26 C1 A6 0D      [ 2] 3645 	addw y,#3 
      00A65A CD 85            [ 2] 3646 	jra 0$ 
      00A65C 98 5F            [ 1] 3647 4$: cp a,#BOOL_OP_LAST+1 
      00A65E 7B 02            [ 1] 3648 	jrpl 5$ 
      00A660 97 CD            [ 1] 3649 	incw y 
      00A662 88 3C            [ 2] 3650 	jra 0$ 
      00A664 AE A6            [ 1] 3651 5$: cp a,#QUOTE_IDX 
      00A666 71 CD            [ 1] 3652 	jrne 6$
      00A668 85 CD 16         [ 4] 3653 	call skip_string 
      00A66B 04 5B            [ 2] 3654 	jra 0$ 
      00A66D 07 CC            [ 1] 3655 6$: cp a,#REM_IDX 
      00A66F 97 DC            [ 1] 3656 	jrne 7$ 
      00A671 20 77 6F         [ 2] 3657 	ldw x, line.addr  
      00A674 72 64            [ 1] 3658 	ld a,(2,x)
      00A676 73               [ 1] 3659 	clrw x 
      00A677 20               [ 1] 3660 	ld xl,a 
      00A678 69 6E 20 64      [ 2] 3661 	addw x,line.addr 
      00A67C 69               [ 2] 3662 	decw x 
      00A67D 63 74            [ 1] 3663 	ldw y,x 
      00A67F 69               [ 1] 3664 	clrw x 
      00A680 6F 6E            [ 2] 3665 	jra 9$ 
      00A682 61 72            [ 1] 3666 7$:	incw y 
      00A684 79 0A            [ 2] 3667 	jra 0$ 
      00A686 00 A9 00 02      [ 2] 3668 8$: addw y,#2 
      00A687 93               [ 1] 3669 	ldw x,y ; skip 2 op_codes 
      00A687 CD               [ 4] 3670 9$:	ret 
                                   3671 
                                   3672 ;----------------------------
                                   3673 ; BASIC: DO 
                                   3674 ; introtude DO...UNTIL condition 
                                   3675 ; loop 
                                   3676 ;------------------------------
                           000001  3677 	LN_ADR=1
                           000003  3678 	BPTR=LN_ADR+2 
      001C7F                       3679 kword_do:
      00A688 98 E5            [ 2] 3680 	pushw y 
      001C81                       3681 	_ldxz line.addr 
      00A68A A1 01                    1     .byte 0xbe,line.addr 
      00A68C 27               [ 2] 3682 	pushw x 
      001C84                       3683 	_next 
      00A68D 03 CC 96         [ 2]    1         jp interp_loop 
                                   3684 
                                   3685 ;----------------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 156.
Hexadecimal [24-Bits]



                                   3686 ; BASIC: UNTIL condition 
                                   3687 ; control loop of DO..UNTIL 
                                   3688 ;----------------------------------
      001C87                       3689 kword_until:
      00A690 73 0D C0         [ 4] 3690 	call condition 
      00A691 5D               [ 2] 3691 	tnzw x 
      00A691 85 72            [ 1] 3692 	jrne 8$ 
      00A693 11 00            [ 2] 3693 	ldw x,(LN_ADR,sp)
      001C8F                       3694 	_strxz line.addr 
      00A695 07 CF                    1     .byte 0xbf,line.addr 
      00A697 00 03            [ 2] 3695 	ldw y,(BPTR,sp)
      001C93                       3696 	_next 
      00A699 CC 97 DC         [ 2]    1         jp interp_loop 
      00A69C                       3697 8$:	_drop 4 
      00A69C 4F 5F            [ 2]    1     addw sp,#4 
      001C98                       3698 	_next 
      00A69E 72 01 00         [ 2]    1         jp interp_loop 
                                   3699 
                                   3700 ;------------------------------
                                   3701 ;      dictionary 
                                   3702 ; format:
                                   3703 ;   link:   2 bytes 
                                   3704 ;   name_length+flags:  1 byte, bits 0:3 lenght,4:8 kw type   
                                   3705 ;   cmd_name: 16 byte max 
                                   3706 ;   code_addr: 2 bytes 
                                   3707 ;------------------------------
                                   3708 	.macro _dict_entry len,name,token_id 
                                   3709 	.word LINK  ; point to next name field 
                                   3710 	LINK=.  ; name field 
                                   3711 	.byte len  ; name length 
                                   3712 	.asciz name  ; name 
                                   3713 	.byte token_id   ; TOK_IDX 
                                   3714 	.endm 
                                   3715 
                           000000  3716 	LINK=0
                                   3717 ; respect alphabetic order for BASIC names from Z-A
                                   3718 ; this sort order is for a cleaner WORDS cmd output. 	
      001C9B                       3719 dict_end:
      001C9B                       3720 	_dict_entry,5,"WORDS",WORDS_IDX 
      00A6A1 07 02                    1 	.word LINK  ; point to next name field 
                           001C9D     2 	LINK=.  ; name field 
      00A6A3 43                       3 	.byte 5  ; name length 
      00A6A4 53 81 52 44 53 00        4 	.asciz "WORDS"  ; name 
      00A6A6 41                       5 	.byte WORDS_IDX   ; TOK_IDX 
      001CA5                       3721 	_dict_entry,5,"UNTIL",UNTIL_IDX 
      00A6A6 CD 99                    1 	.word LINK  ; point to next name field 
                           001CA7     2 	LINK=.  ; name field 
      00A6A8 D4                       3 	.byte 5  ; name length 
      00A6A9 4F 95 CD 86 01 CC        4 	.asciz "UNTIL"  ; name 
      00A6AF 97                       5 	.byte UNTIL_IDX   ; TOK_IDX 
      001CAF                       3722 	_dict_entry,4,"TONE",TONE_IDX 
      00A6B0 DC A7                    1 	.word LINK  ; point to next name field 
                           001CB1     2 	LINK=.  ; name field 
      00A6B1 04                       3 	.byte 4  ; name length 
      00A6B1 CD 98 E5 A1 01           4 	.asciz "TONE"  ; name 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 157.
Hexadecimal [24-Bits]



      00A6B6 27                       5 	.byte TONE_IDX   ; TOK_IDX 
      001CB8                       3723 	_dict_entry,2,"TO",TO_IDX
      00A6B7 15 A1                    1 	.word LINK  ; point to next name field 
                           001CBA     2 	LINK=.  ; name field 
      00A6B9 02                       3 	.byte 2  ; name length 
      00A6BA 27 03 CC                 4 	.asciz "TO"  ; name 
      00A6BD 96                       5 	.byte TO_IDX   ; TOK_IDX 
      001CBF                       3724 	_dict_entry,5,"TICKS",TICKS_IDX 
      00A6BE 73 BA                    1 	.word LINK  ; point to next name field 
                           001CC1     2 	LINK=.  ; name field 
      00A6BF 05                       3 	.byte 5  ; name length 
      00A6BF 1E 03 BF 0F 85 5B        4 	.asciz "TICKS"  ; name 
      00A6C5 02                       5 	.byte TICKS_IDX   ; TOK_IDX 
      001CC9                       3725 	_dict_entry,4,"THEN",THEN_IDX 
      00A6C6 72 CD                    1 	.word LINK  ; point to next name field 
                           001CCB     2 	LINK=.  ; name field 
      00A6C8 00                       3 	.byte 4  ; name length 
      00A6C9 0F CC 97 DC 85           4 	.asciz "THEN"  ; name 
      00A6CE FD                       5 	.byte THEN_IDX   ; TOK_IDX 
      001CD2                       3726 	_dict_entry,3,"TAB",TAB_IDX 
      00A6CF CC 97                    1 	.word LINK  ; point to next name field 
                           001CD4     2 	LINK=.  ; name field 
      00A6D1 DC                       3 	.byte 3  ; name length 
      00A6D2 54 41 42 00              4 	.asciz "TAB"  ; name 
      00A6D2 72                       5 	.byte TAB_IDX   ; TOK_IDX 
      001CDA                       3727 	_dict_entry,4,"STOP",STOP_IDX
      00A6D3 00 00                    1 	.word LINK  ; point to next name field 
                           001CDC     2 	LINK=.  ; name field 
      00A6D5 43                       3 	.byte 4  ; name length 
      00A6D6 22 AE 00 0A BF           4 	.asciz "STOP"  ; name 
      00A6DB 46                       5 	.byte STOP_IDX   ; TOK_IDX 
      001CE3                       3728 	_dict_entry,4,"STEP",STEP_IDX
      00A6DC BF 44                    1 	.word LINK  ; point to next name field 
                           001CE5     2 	LINK=.  ; name field 
      00A6DE CD                       3 	.byte 4  ; name length 
      00A6DF 98 E5 4D 27 11           4 	.asciz "STEP"  ; name 
      00A6E4 A1                       5 	.byte STEP_IDX   ; TOK_IDX 
      001CEC                       3729 	_dict_entry,5,"SLEEP",SLEEP_IDX 
      00A6E5 01 27                    1 	.word LINK  ; point to next name field 
                           001CEE     2 	LINK=.  ; name field 
      00A6E7 0A                       3 	.byte 5  ; name length 
      00A6E8 A1 02 27 03 CC 96        4 	.asciz "SLEEP"  ; name 
      00A6EE 73                       5 	.byte SLEEP_IDX   ; TOK_IDX 
      00A6EF                       3730 	_dict_entry,3,"SGN",SGN_IDX
      00A6EF 85 BF                    1 	.word LINK  ; point to next name field 
                           001CF8     2 	LINK=.  ; name field 
      00A6F1 46                       3 	.byte 3  ; name length 
      00A6F2 53 47 4E 00              4 	.asciz "SGN"  ; name 
      00A6F2 85                       5 	.byte SGN_IDX   ; TOK_IDX 
      001CFE                       3731 	_dict_entry,3,"SCR",NEW_IDX
      00A6F3 BF 44                    1 	.word LINK  ; point to next name field 
                           001D00     2 	LINK=.  ; name field 
      00A6F5 03                       3 	.byte 3  ; name length 
      00A6F5 72 1C 00 43              4 	.asciz "SCR"  ; name 
      00A6F9 3C                       5 	.byte NEW_IDX   ; TOK_IDX 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 158.
Hexadecimal [24-Bits]



      001D06                       3732 	_dict_entry,4,"SAVE",SAVE_IDX 
      00A6F9 CC 97                    1 	.word LINK  ; point to next name field 
                           001D08     2 	LINK=.  ; name field 
      00A6FB DC                       3 	.byte 4  ; name length 
      00A6FC 53 41 56 45 00           4 	.asciz "SAVE"  ; name 
      00A6FC BE                       5 	.byte SAVE_IDX   ; TOK_IDX 
      001D0F                       3733 	_dict_entry 3,"RUN",RUN_IDX
      00A6FD 3D BF                    1 	.word LINK  ; point to next name field 
                           001D11     2 	LINK=.  ; name field 
      00A6FF 3F                       3 	.byte 3  ; name length 
      00A700 CE 00 39 BF              4 	.asciz "RUN"  ; name 
      00A704 41                       5 	.byte RUN_IDX   ; TOK_IDX 
      001D17                       3734 	_dict_entry,3,"RND",RND_IDX
      00A705 AE 00                    1 	.word LINK  ; point to next name field 
                           001D19     2 	LINK=.  ; name field 
      00A707 5C                       3 	.byte 3  ; name length 
      00A708 BF 4A 3F 49              4 	.asciz "RND"  ; name 
      00A70C 3F                       5 	.byte RND_IDX   ; TOK_IDX 
      001D1F                       3735 	_dict_entry,9,"RANDOMIZE",RNDMIZE_IDX 
      00A70D 48 81                    1 	.word LINK  ; point to next name field 
                           001D21     2 	LINK=.  ; name field 
      00A70F 09                       3 	.byte 9  ; name length 
      00A70F 72 00 00 43 07 AE 17     4 	.asciz "RANDOMIZE"  ; name 
             FF 94 CD
      00A719 A6                       5 	.byte RNDMIZE_IDX   ; TOK_IDX 
      001D2D                       3736 	_dict_entry,6,"RETURN",RET_IDX
      00A71A FC 21                    1 	.word LINK  ; point to next name field 
                           001D2F     2 	LINK=.  ; name field 
      00A71B 06                       3 	.byte 6  ; name length 
      00A71B CC 97 DC 55 52 4E 00     4 	.asciz "RETURN"  ; name 
      00A71E 1E                       5 	.byte RET_IDX   ; TOK_IDX 
      001D38                       3737 	_dict_entry,5,"RENUM",RENUM_IDX 
      00A71E 72 01                    1 	.word LINK  ; point to next name field 
                           001D3A     2 	LINK=.  ; name field 
      00A720 00                       3 	.byte 5  ; name length 
      00A721 43 03 CC 97 DC 00        4 	.asciz "RENUM"  ; name 
      00A726 4A                       5 	.byte RENUM_IDX   ; TOK_IDX 
      001D42                       3738 	_dict_entry 3,"REM",REM_IDX
      00A726 52 08                    1 	.word LINK  ; point to next name field 
                           001D44     2 	LINK=.  ; name field 
      00A728 5F                       3 	.byte 3  ; name length 
      00A729 1F 03 CD 98              4 	.asciz "REM"  ; name 
      00A72D E5                       5 	.byte REM_IDX   ; TOK_IDX 
      001D4A                       3739 	_dict_entry 5,"PRINT",PRINT_IDX 
      00A72E A1 02                    1 	.word LINK  ; point to next name field 
                           001D4C     2 	LINK=.  ; name field 
      00A730 27                       3 	.byte 5  ; name length 
      00A731 07 A1 01 27 17 CC        4 	.asciz "PRINT"  ; name 
      00A737 96                       5 	.byte PRINT_IDX   ; TOK_IDX 
      001D54                       3740 	_dict_entry,4,"POKE",POKE_IDX 
      00A738 73 4C                    1 	.word LINK  ; point to next name field 
                           001D56     2 	LINK=.  ; name field 
      00A739 04                       3 	.byte 4  ; name length 
      00A739 85 4F CD 8D 8E           4 	.asciz "POKE"  ; name 
      00A73E 4D                       5 	.byte POKE_IDX   ; TOK_IDX 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 159.
Hexadecimal [24-Bits]



      001D5D                       3741 	_dict_entry,4,"PEEK",PEEK_IDX 
      00A73F 27 49                    1 	.word LINK  ; point to next name field 
                           001D5F     2 	LINK=.  ; name field 
      00A741 BF                       3 	.byte 4  ; name length 
      00A742 15 E6 02 5F 97           4 	.asciz "PEEK"  ; name 
      00A747 72                       5 	.byte PEEK_IDX   ; TOK_IDX 
      001D66                       3742 	_dict_entry,2,"OR",OR_IDX  
      00A748 BB 00                    1 	.word LINK  ; point to next name field 
                           001D68     2 	LINK=.  ; name field 
      00A74A 15                       3 	.byte 2  ; name length 
      00A74B 1F 05 00                 4 	.asciz "OR"  ; name 
      00A74D 18                       5 	.byte OR_IDX   ; TOK_IDX 
      001D6D                       3743 	_dict_entry,3,"NOT",NOT_IDX
      00A74D 85 4F                    1 	.word LINK  ; point to next name field 
                           001D6F     2 	LINK=.  ; name field 
      00A74F CD                       3 	.byte 3  ; name length 
      00A750 8D 8E 4D 27              4 	.asciz "NOT"  ; name 
      00A754 35                       5 	.byte NOT_IDX   ; TOK_IDX 
      001D75                       3744 	_dict_entry,3,"NEW",NEW_IDX
      00A755 1F 01                    1 	.word LINK  ; point to next name field 
                           001D77     2 	LINK=.  ; name field 
      00A757 1E                       3 	.byte 3  ; name length 
      00A758 03 26 0B 1E              4 	.asciz "NEW"  ; name 
      00A75C 01                       5 	.byte NEW_IDX   ; TOK_IDX 
      001D7D                       3745 	_dict_entry,4,"NEXT",NEXT_IDX 
      00A75D E6 02                    1 	.word LINK  ; point to next name field 
                           001D7F     2 	LINK=.  ; name field 
      00A75F 5F                       3 	.byte 4  ; name length 
      00A760 97 72 FB 01 1F           4 	.asciz "NEXT"  ; name 
      00A765 03                       5 	.byte NEXT_IDX   ; TOK_IDX 
      00A766                       3746 	_dict_entry,6,"MULDIV",MULDIV_IDX 
      00A766 72 F0                    1 	.word LINK  ; point to next name field 
                           001D88     2 	LINK=.  ; name field 
      00A768 01                       3 	.byte 6  ; name length 
      00A769 1F 05 CE 00 3B 72 F0     4 	.asciz "MULDIV"  ; name 
      00A770 03                       5 	.byte MULDIV_IDX   ; TOK_IDX 
      001D91                       3747 	_dict_entry,3,"MOD",MOD_IDX 
      00A771 BF 15                    1 	.word LINK  ; point to next name field 
                           001D93     2 	LINK=.  ; name field 
      00A773 1E                       3 	.byte 3  ; name length 
      00A774 01 17 07 16              4 	.asciz "MOD"  ; name 
      00A778 03                       5 	.byte MOD_IDX   ; TOK_IDX 
      001D99                       3748 	_dict_entry,5,"LOMEM",LOMEM_IDX 
      00A779 CD 88                    1 	.word LINK  ; point to next name field 
                           001D9B     2 	LINK=.  ; name field 
      00A77B BE                       3 	.byte 5  ; name length 
      00A77C BE 3B 72 F0 05 BF        4 	.asciz "LOMEM"  ; name 
      00A782 3B                       5 	.byte LOMEM_IDX   ; TOK_IDX 
      001DA3                       3749 	_dict_entry,6,"LOCATE",LOCATE_IDX 
      00A783 16 07                    1 	.word LINK  ; point to next name field 
                           001DA5     2 	LINK=.  ; name field 
      00A785 5B                       3 	.byte 6  ; name length 
      00A786 08 CC 97 DC 54 45 00     4 	.asciz "LOCATE"  ; name 
      00A78A 49                       5 	.byte LOCATE_IDX   ; TOK_IDX 
      001DAE                       3750 	_dict_entry,4,"LOAD",LOAD_IDX 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 160.
Hexadecimal [24-Bits]



      00A78A A6 0D                    1 	.word LINK  ; point to next name field 
                           001DB0     2 	LINK=.  ; name field 
      00A78C CC                       3 	.byte 4  ; name length 
      00A78D 96 75 41 44 00           4 	.asciz "LOAD"  ; name 
      00A78F 44                       5 	.byte LOAD_IDX   ; TOK_IDX 
      001DB7                       3751 	_dict_entry 4,"LIST",LIST_IDX
      00A78F 72 01                    1 	.word LINK  ; point to next name field 
                           001DB9     2 	LINK=.  ; name field 
      00A791 00                       3 	.byte 4  ; name length 
      00A792 43 03 CC 97 DC           4 	.asciz "LIST"  ; name 
      00A797 A6                       5 	.byte LIST_IDX   ; TOK_IDX 
      001DC0                       3752 	_dict_entry 3,"LET",LET_IDX
      00A798 11 CD                    1 	.word LINK  ; point to next name field 
                           001DC2     2 	LINK=.  ; name field 
      00A79A 98                       3 	.byte 3  ; name length 
      00A79B CC CD 99 D4              4 	.asciz "LET"  ; name 
      00A79F C3                       5 	.byte LET_IDX   ; TOK_IDX 
      001DC8                       3753 	_dict_entry 3,"LEN",LEN_IDX  
      00A7A0 00 37                    1 	.word LINK  ; point to next name field 
                           001DCA     2 	LINK=.  ; name field 
      00A7A2 23                       3 	.byte 3  ; name length 
      00A7A3 35 A3 16 80              4 	.asciz "LEN"  ; name 
      00A7A7 24                       5 	.byte LEN_IDX   ; TOK_IDX 
      001DD0                       3754 	_dict_entry,3,"KEY",KEY_IDX 
      00A7A8 30 BF                    1 	.word LINK  ; point to next name field 
                           001DD2     2 	LINK=.  ; name field 
      00A7AA 39                       3 	.byte 3  ; name length 
      00A7AB 20 1F CC 97              4 	.asciz "KEY"  ; name 
      00A7AF DC                       5 	.byte KEY_IDX   ; TOK_IDX 
      00A7B0                       3755 	_dict_entry,5,"INPUT",INPUT_IDX 
      00A7B0 72 01                    1 	.word LINK  ; point to next name field 
                           001DDA     2 	LINK=.  ; name field 
      00A7B2 00                       3 	.byte 5  ; name length 
      00A7B3 43 03 CC 97 DC A6        4 	.asciz "INPUT"  ; name 
      00A7B9 11                       5 	.byte INPUT_IDX   ; TOK_IDX 
      001DE2                       3756 	_dict_entry,2,"IF",IF_IDX 
      00A7BA CD 98                    1 	.word LINK  ; point to next name field 
                           001DE4     2 	LINK=.  ; name field 
      00A7BC CC                       3 	.byte 2  ; name length 
      00A7BD CD 99 D4                 4 	.asciz "IF"  ; name 
      00A7C0 A3                       5 	.byte IF_IDX   ; TOK_IDX 
      001DE9                       3757 	_dict_entry,5,"HIMEM",HIMEM_IDX 
      00A7C1 01 00                    1 	.word LINK  ; point to next name field 
                           001DEB     2 	LINK=.  ; name field 
      00A7C3 25                       3 	.byte 5  ; name length 
      00A7C4 14 C3 00 39 24 0F        4 	.asciz "HIMEM"  ; name 
      00A7CA BF                       5 	.byte HIMEM_IDX   ; TOK_IDX 
      001DF3                       3758 	_dict_entry,4,"GOTO",GOTO_IDX  
      00A7CB 37 EB                    1 	.word LINK  ; point to next name field 
                           001DF5     2 	LINK=.  ; name field 
      00A7CC 04                       3 	.byte 4  ; name length 
      00A7CC CD A6 FC BE 37           4 	.asciz "GOTO"  ; name 
      00A7D1 BF                       5 	.byte GOTO_IDX   ; TOK_IDX 
      001DFC                       3759 	_dict_entry,5,"GOSUB",GOSUB_IDX 
      00A7D2 3B CD                    1 	.word LINK  ; point to next name field 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 161.
Hexadecimal [24-Bits]



                           001DFE     2 	LINK=.  ; name field 
      00A7D4 A7                       3 	.byte 5  ; name length 
      00A7D5 DE CC 97 DC 42 00        4 	.asciz "GOSUB"  ; name 
      00A7D9 1D                       5 	.byte GOSUB_IDX   ; TOK_IDX 
      001E06                       3760 	_dict_entry,5,"ERASE",ERASE_IDX 
      00A7D9 A6 0D                    1 	.word LINK  ; point to next name field 
                           001E08     2 	LINK=.  ; name field 
      00A7DB CC                       3 	.byte 5  ; name length 
      00A7DC 96 75 41 53 45 00        4 	.asciz "ERASE"  ; name 
      00A7DE 46                       5 	.byte ERASE_IDX   ; TOK_IDX 
      001E10                       3761 	_dict_entry,3,"FOR",FOR_IDX 
      00A7DE CE 00                    1 	.word LINK  ; point to next name field 
                           001E12     2 	LINK=.  ; name field 
      00A7E0 39                       3 	.byte 3  ; name length 
      00A7E1 72 B0 00 37              4 	.asciz "FOR"  ; name 
      00A7E5 CD                       5 	.byte FOR_IDX   ; TOK_IDX 
      001E18                       3762 	_dict_entry,3,"END",END_IDX
      00A7E6 88 3C                    1 	.word LINK  ; point to next name field 
                           001E1A     2 	LINK=.  ; name field 
      00A7E8 AE                       3 	.byte 3  ; name length 
      00A7E9 A7 EF CD 85              4 	.asciz "END"  ; name 
      00A7ED CD                       5 	.byte END_IDX   ; TOK_IDX 
      001E20                       3763 	_dict_entry,2,"DO",DO_IDX 
      00A7EE 81 62                    1 	.word LINK  ; point to next name field 
                           001E22     2 	LINK=.  ; name field 
      00A7F0 79                       3 	.byte 2  ; name length 
      00A7F1 74 65 73                 4 	.asciz "DO"  ; name 
      00A7F4 20                       5 	.byte DO_IDX   ; TOK_IDX 
      001E27                       3764 	_dict_entry,3,"DIR",DIR_IDX  
      00A7F5 66 72                    1 	.word LINK  ; point to next name field 
                           001E29     2 	LINK=.  ; name field 
      00A7F7 65                       3 	.byte 3  ; name length 
      00A7F8 65 00 52 00              4 	.asciz "DIR"  ; name 
      00A7FA 45                       5 	.byte DIR_IDX   ; TOK_IDX 
      001E2F                       3765 	_dict_entry,3,"DIM",DIM_IDX 
      00A7FA CD 85                    1 	.word LINK  ; point to next name field 
                           001E31     2 	LINK=.  ; name field 
      00A7FC F0                       3 	.byte 3  ; name length 
      00A7FD 72 11 00 07              4 	.asciz "DIM"  ; name 
      00A801 AE                       5 	.byte DIM_IDX   ; TOK_IDX 
      001E37                       3766 	_dict_entry,3,"DEL",DEL_IDX 
      00A802 00 04                    1 	.word LINK  ; point to next name field 
                           001E39     2 	LINK=.  ; name field 
      00A804 BF                       3 	.byte 3  ; name length 
      00A805 03 72 01 00              4 	.asciz "DEL"  ; name 
      00A809 07                       5 	.byte DEL_IDX   ; TOK_IDX 
      001E3F                       3767 	_dict_entry,4,"CPOS",CPOS_IDX 
      00A80A FB CC                    1 	.word LINK  ; point to next name field 
                           001E41     2 	LINK=.  ; name field 
      00A80C 97                       3 	.byte 4  ; name length 
      00A80D DC 50 4F 53 00           4 	.asciz "CPOS"  ; name 
      00A80E 31                       5 	.byte CPOS_IDX   ; TOK_IDX 
      001E48                       3768 	_dict_entry,3,"CON",CON_IDX 
      00A80E CD 98                    1 	.word LINK  ; point to next name field 
                           001E4A     2 	LINK=.  ; name field 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 162.
Hexadecimal [24-Bits]



      00A810 E5                       3 	.byte 3  ; name length 
      00A811 A1 02 27 03              4 	.asciz "CON"  ; name 
      00A815 CC                       5 	.byte CON_IDX   ; TOK_IDX 
      001E50                       3769 	_dict_entry,3,"CLS",CLS_IDX 
      00A816 96 73                    1 	.word LINK  ; point to next name field 
                           001E52     2 	LINK=.  ; name field 
      00A818 03                       3 	.byte 3  ; name length 
      00A818 1E 03 9F 1E              4 	.asciz "CLS"  ; name 
      00A81C 01                       5 	.byte CLS_IDX   ; TOK_IDX 
      001E58                       3770 	_dict_entry,3,"CLR",CLR_IDX 
      00A81D 95 CD                    1 	.word LINK  ; point to next name field 
                           001E5A     2 	LINK=.  ; name field 
      00A81F 87                       3 	.byte 3  ; name length 
      00A820 35 5B 04 CC              4 	.asciz "CLR"  ; name 
      00A824 97                       5 	.byte CLR_IDX   ; TOK_IDX 
      001E60                       3771 	_dict_entry,4,"CHR$",CHAR_IDX  
      00A825 DC 5A                    1 	.word LINK  ; point to next name field 
                           001E62     2 	LINK=.  ; name field 
      00A826 04                       3 	.byte 4  ; name length 
      00A826 CD 98 DA A1 02           4 	.asciz "CHR$"  ; name 
      00A82B 27                       5 	.byte CHAR_IDX   ; TOK_IDX 
      001E69                       3772 	_dict_entry,4,"CHAT",CHAT_IDX 
      00A82C 03 CC                    1 	.word LINK  ; point to next name field 
                           001E6B     2 	LINK=.  ; name field 
      00A82E 96                       3 	.byte 4  ; name length 
      00A82F 73 48 41 54 00           4 	.asciz "CHAT"  ; name 
      00A830 30                       5 	.byte CHAT_IDX   ; TOK_IDX 
      001E72                       3773 	_dict_entry,4,"CALL",CALL_IDX
      00A830 CD 87                    1 	.word LINK  ; point to next name field 
                           001E74     2 	LINK=.  ; name field 
      00A832 1F                       3 	.byte 4  ; name length 
      00A833 1E 03 9F 1E 01           4 	.asciz "CALL"  ; name 
      00A838 95                       5 	.byte CALL_IDX   ; TOK_IDX 
      001E7B                       3774 	_dict_entry,3,"BYE",BYE_IDX
      00A839 CD 87                    1 	.word LINK  ; point to next name field 
                           001E7D     2 	LINK=.  ; name field 
      00A83B 35                       3 	.byte 3  ; name length 
      00A83C CD 87 5C 5F              4 	.asciz "BYE"  ; name 
      00A840 97                       5 	.byte BYE_IDX   ; TOK_IDX 
      001E83                       3775 	_dict_entry,4,"AUTO",AUTO_IDX 
      00A841 1F 01                    1 	.word LINK  ; point to next name field 
                           001E85     2 	LINK=.  ; name field 
      00A843 CD                       3 	.byte 4  ; name length 
      00A844 87 2A 1E 01 5B           4 	.asciz "AUTO"  ; name 
      00A849 04                       5 	.byte AUTO_IDX   ; TOK_IDX 
      001E8C                       3776 	_dict_entry,3,"AND",AND_IDX  
      00A84A 81 85                    1 	.word LINK  ; point to next name field 
                           001E8E     2 	LINK=.  ; name field 
      00A84B 03                       3 	.byte 3  ; name length 
      00A84B CD 87 79 81              4 	.asciz "AND"  ; name 
      00A84F 17                       5 	.byte AND_IDX   ; TOK_IDX 
      001E94                       3777 kword_dict::
      001E94                       3778 	_dict_entry,3,"ABS",ABS_IDX 
      00A84F 72 00                    1 	.word LINK  ; point to next name field 
                           001E96     2 	LINK=.  ; name field 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 163.
Hexadecimal [24-Bits]



      00A851 00                       3 	.byte 3  ; name length 
      00A852 43 2A CD 98              4 	.asciz "ABS"  ; name 
      00A856 E5                       5 	.byte ABS_IDX   ; TOK_IDX 
                                   3779 ; the following are not searched
                                   3780 ; by compiler
      001E9C                       3781 	_dict_entry,1,"'",REM_IDX 
      00A857 4D 26                    1 	.word LINK  ; point to next name field 
                           001E9E     2 	LINK=.  ; name field 
      00A859 07                       3 	.byte 1  ; name length 
      00A85A AE 00                    4 	.asciz "'"  ; name 
      00A85C 0A                       5 	.byte REM_IDX   ; TOK_IDX 
      001EA2                       3782 	_dict_entry,1,"?",PRINT_IDX 
      00A85D 89 89                    1 	.word LINK  ; point to next name field 
                           001EA4     2 	LINK=.  ; name field 
      00A85F 20                       3 	.byte 1  ; name length 
      00A860 11 A1                    4 	.asciz "?"  ; name 
      00A862 01                       5 	.byte PRINT_IDX   ; TOK_IDX 
      001EA8                       3783 	_dict_entry,1,"#",REL_NE_IDX 
      00A863 26 06                    1 	.word LINK  ; point to next name field 
                           001EAA     2 	LINK=.  ; name field 
      00A865 AE                       3 	.byte 1  ; name length 
      00A866 00 0A                    4 	.asciz "#"  ; name 
      00A868 89                       5 	.byte REL_NE_IDX   ; TOK_IDX 
      001EAE                       3784 	_dict_entry,2,"<>",REL_NE_IDX
      00A869 20 07                    1 	.word LINK  ; point to next name field 
                           001EB0     2 	LINK=.  ; name field 
      00A86B A1                       3 	.byte 2  ; name length 
      00A86C 02 27 03                 4 	.asciz "<>"  ; name 
      00A86F CC                       5 	.byte REL_NE_IDX   ; TOK_IDX 
      001EB5                       3785 	_dict_entry,1,">",REL_GT_IDX
      00A870 96 73                    1 	.word LINK  ; point to next name field 
                           001EB7     2 	LINK=.  ; name field 
      00A872 01                       3 	.byte 1  ; name length 
      00A872 CD A8                    4 	.asciz ">"  ; name 
      00A874 83                       5 	.byte REL_GT_IDX   ; TOK_IDX 
      001EBB                       3786 	_dict_entry,1,"<",REL_LT_IDX
      00A875 90 85                    1 	.word LINK  ; point to next name field 
                           001EBD     2 	LINK=.  ; name field 
      00A877 85                       3 	.byte 1  ; name length 
      00A878 CD A8                    4 	.asciz "<"  ; name 
      00A87A E7                       5 	.byte REL_LT_IDX   ; TOK_IDX 
      001EC1                       3787 	_dict_entry,2,">=",REL_GE_IDX
      00A87B CD A8                    1 	.word LINK  ; point to next name field 
                           001EC3     2 	LINK=.  ; name field 
      00A87D BA                       3 	.byte 2  ; name length 
      00A87E 90 7F CC                 4 	.asciz ">="  ; name 
      00A881 97                       5 	.byte REL_GE_IDX   ; TOK_IDX 
      001EC8                       3788 	_dict_entry,1,"=",REL_EQU_IDX 
      00A882 DC C3                    1 	.word LINK  ; point to next name field 
                           001ECA     2 	LINK=.  ; name field 
      00A883 01                       3 	.byte 1  ; name length 
      00A883 90 CE                    4 	.asciz "="  ; name 
      00A885 00                       5 	.byte REL_EQU_IDX   ; TOK_IDX 
      001ECE                       3789 	_dict_entry,2,"<=",REL_LE_IDX 
      00A886 37 90                    1 	.word LINK  ; point to next name field 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 164.
Hexadecimal [24-Bits]



                           001ED0     2 	LINK=.  ; name field 
      00A888 BF                       3 	.byte 2  ; name length 
      00A889 33 72 A9                 4 	.asciz "<="  ; name 
      00A88C 00                       5 	.byte REL_LE_IDX   ; TOK_IDX 
      001ED5                       3790 	_dict_entry,1,"*",MULT_IDX 
      00A88D 03 CD                    1 	.word LINK  ; point to next name field 
                           001ED7     2 	LINK=.  ; name field 
      00A88F A9                       3 	.byte 1  ; name length 
      00A890 07 5D                    4 	.asciz "*"  ; name 
      00A892 27                       5 	.byte MULT_IDX   ; TOK_IDX 
      001EDB                       3791 	_dict_entry,1,"%",MOD_IDX 
      00A893 0A FE                    1 	.word LINK  ; point to next name field 
                           001EDD     2 	LINK=.  ; name field 
      00A895 CD                       3 	.byte 1  ; name length 
      00A896 A8 A7                    4 	.asciz "%"  ; name 
      00A898 72                       5 	.byte MOD_IDX   ; TOK_IDX 
      001EE1                       3792 	_dict_entry,1,"/",DIV_IDX 
      00A899 A9 00                    1 	.word LINK  ; point to next name field 
                           001EE3     2 	LINK=.  ; name field 
      00A89B 02                       3 	.byte 1  ; name length 
      00A89C 20 F0                    4 	.asciz "/"  ; name 
      00A89E 0D                       5 	.byte DIV_IDX   ; TOK_IDX 
      001EE7                       3793 	_dict_entry,1,"-",SUB_IDX 
      00A89E 90 5C                    1 	.word LINK  ; point to next name field 
                           001EE9     2 	LINK=.  ; name field 
      00A8A0 90                       3 	.byte 1  ; name length 
      00A8A1 C3 00                    4 	.asciz "-"  ; name 
      00A8A3 3B                       5 	.byte SUB_IDX   ; TOK_IDX 
      001EED                       3794 	_dict_entry,1,"+",ADD_IDX
      00A8A4 2B E1                    1 	.word LINK  ; point to next name field 
                           001EEF     2 	LINK=.  ; name field 
      00A8A6 01                       3 	.byte 1  ; name length 
      00A8A6 81 00                    4 	.asciz "+"  ; name 
      00A8A7 0B                       5 	.byte ADD_IDX   ; TOK_IDX 
      001EF3                       3795 	_dict_entry,1,'"',QUOTE_IDX
      00A8A7 4F CD                    1 	.word LINK  ; point to next name field 
                           001EF5     2 	LINK=.  ; name field 
      00A8A9 8D                       3 	.byte 1  ; name length 
      00A8AA 8E 4D                    4 	.asciz '"'  ; name 
      00A8AC 26                       5 	.byte QUOTE_IDX   ; TOK_IDX 
      001EF9                       3796 	_dict_entry,1,")",RPAREN_IDX 
      00A8AD 05 A6                    1 	.word LINK  ; point to next name field 
                           001EFB     2 	LINK=.  ; name field 
      00A8AF 04                       3 	.byte 1  ; name length 
      00A8B0 CC 96                    4 	.asciz ")"  ; name 
      00A8B2 75                       5 	.byte RPAREN_IDX   ; TOK_IDX 
      001EFF                       3797 	_dict_entry,1,"(",LPAREN_IDX 
      00A8B3 9E AA                    1 	.word LINK  ; point to next name field 
                           001F01     2 	LINK=.  ; name field 
      00A8B5 80                       3 	.byte 1  ; name length 
      00A8B6 95 90                    4 	.asciz "("  ; name 
      00A8B8 FF                       5 	.byte LPAREN_IDX   ; TOK_IDX 
      001F05                       3798 	_dict_entry,1,^/";"/,SCOL_IDX
      00A8B9 81 01                    1 	.word LINK  ; point to next name field 
                           001F07     2 	LINK=.  ; name field 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 165.
Hexadecimal [24-Bits]



      00A8BA 01                       3 	.byte 1  ; name length 
      00A8BA 90 CE                    4 	.asciz ";"  ; name 
      00A8BC 00                       5 	.byte SCOL_IDX   ; TOK_IDX 
      001F0B                       3799 	_dict_entry,1,^/","/,COMMA_IDX 
      00A8BD 37 90                    1 	.word LINK  ; point to next name field 
                           001F0D     2 	LINK=.  ; name field 
      00A8BF BF                       3 	.byte 1  ; name length 
      00A8C0 33 72                    4 	.asciz ","  ; name 
      00A8C2 A9                       5 	.byte COMMA_IDX   ; TOK_IDX 
      001F11                       3800 all_words:
      001F11                       3801 	_dict_entry,1,":",COLON_IDX 
      00A8C3 00 03                    1 	.word LINK  ; point to next name field 
                           001F13     2 	LINK=.  ; name field 
      00A8C5 CD                       3 	.byte 1  ; name length 
      00A8C6 A9 07                    4 	.asciz ":"  ; name 
      00A8C8 5D                       5 	.byte COLON_IDX   ; TOK_IDX 
                                   3802 
      001F80                       3803 	.bndry 128 
      001F80                       3804 app: 
      001F80                       3805 app_space:
                           000000  3806 .if 0
                                   3807 ; program to test CALL command 
                                   3808 blink:
                                   3809 	_led_toggle 
                                   3810 	ldw x,#250 
                                   3811 	_strxz timer 
                                   3812 	bres sys_flags,#FSYS_TIMER 
                                   3813 1$:	
                                   3814 	wfi 
                                   3815 	btjf sys_flags,#FSYS_TIMER,1$
                                   3816 	call qgetc 
                                   3817 	jreq blink 
                                   3818 	call getc 
                                   3819 	ret 
                                   3820 .endif 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 166.
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
    ALIGN   =  000003     |     AND_IDX =  000017     |     APP_DATA=  000030 
    ARG1    =  000005     |     ARG2    =  000003     |     ARG3    =  000001 
    ARGN    =  000004     |     ARG_OFS =  000002     |     ARG_SIZE=  000002 
    ATTRIB  =  000002     |     AUTO_IDX=  000035     |     AWU_APR =  0050F1 
    AWU_CSR =  0050F0     |     AWU_CSR_=  000004     |     AWU_TBR =  0050F2 
    B0_MASK =  000001     |     B1      =  000001     |     B115200 =  000006 
    B19200  =  000003     |     B1_MASK =  000002     |     B230400 =  000007 
    B2400   =  000000     |     B2_MASK =  000004     |     B38400  =  000004 
    B3_MASK =  000008     |     B460800 =  000008     |     B4800   =  000001 
    B4_MASK =  000010     |     B57600  =  000005     |     B5_MASK =  000020 
    B6_MASK =  000040     |     B7_MASK =  000080     |     B921600 =  000009 
    B9600   =  000002     |     BEEP_BIT=  000004     |     BEEP_CSR=  0050F3 
    BEEP_MAS=  000010     |     BEEP_POR=  00000F     |     BELL    =  000007 
    BIT0    =  000000     |     BIT1    =  000001     |     BIT2    =  000002 
    BIT3    =  000003     |     BIT4    =  000004     |     BIT5    =  000005 
    BIT6    =  000006     |     BIT7    =  000007     |     BLOCK_SI=  000080 
    BOOL_OP_=  000018     |     BOOT_ROM=  006000     |     BOOT_ROM=  007FFF 
    BPTR    =  000003     |     BS      =  000008     |     BUFOUT  =  000003 
    BYE_IDX =  000042     |     C       =  000001     |     CALL_IDX=  00003D 
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
    CHAIN_BP=  000003     |     CHAIN_CN=  000008     |     CHAIN_LN=  000001 
    CHAIN_TX=  000005     |     CHAIN_TX=  000007     |     CHAR_ARR=  000005 
    CHAR_IDX=  00002E     |     CHAT_IDX=  000030     |     CLKOPT  =  004807 
    CLKOPT_C=  000002     |     CLKOPT_E=  000003     |     CLKOPT_P=  000000 
    CLKOPT_P=  000001     |     CLK_CCOR=  0050C9     |     CLK_CKDI=  0050C6 
    CLK_CKDI=  000000     |     CLK_CKDI=  000001     |     CLK_CKDI=  000002 
    CLK_CKDI=  000003     |     CLK_CKDI=  000004     |     CLK_CMSR=  0050C3 
    CLK_CSSR=  0050C8     |     CLK_ECKR=  0050C1     |     CLK_ECKR=  000000 
    CLK_ECKR=  000001     |     CLK_HSIT=  0050CC     |     CLK_ICKR=  0050C0 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 167.
Hexadecimal [24-Bits]

Symbol Table

    CLK_ICKR=  000002     |     CLK_ICKR=  000000     |     CLK_ICKR=  000001 
    CLK_ICKR=  000003     |     CLK_ICKR=  000004     |     CLK_ICKR=  000005 
    CLK_PCKE=  0050C7     |     CLK_PCKE=  000000     |     CLK_PCKE=  000001 
    CLK_PCKE=  000007     |     CLK_PCKE=  000005     |     CLK_PCKE=  000006 
    CLK_PCKE=  000004     |     CLK_PCKE=  000002     |     CLK_PCKE=  000003 
    CLK_PCKE=  0050CA     |     CLK_PCKE=  000003     |     CLK_PCKE=  000002 
    CLK_PCKE=  000007     |     CLK_SWCR=  0050C5     |     CLK_SWCR=  000000 
    CLK_SWCR=  000001     |     CLK_SWCR=  000002     |     CLK_SWCR=  000003 
    CLK_SWIM=  0050CD     |     CLK_SWR =  0050C4     |     CLK_SWR_=  0000B4 
    CLK_SWR_=  0000E1     |     CLK_SWR_=  0000D2     |     CLR_IDX =  000039 
    CLS_IDX =  000048     |     CMD_END =  000001     |     CMD_LAST=  00004D 
    COL     =  000001     |     COLON   =  00003A     |     COLON_ID=  000001 
    COL_CNT =  000001     |     COMMA   =  00002C     |     COMMA_ID=  000002 
    CON_IDX =  000026     |     COUNT   =  000006     |     CPOS_IDX=  000031 
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
    CTRL_Y  =  000019     |     CTRL_Z  =  00001A     |     CTXT_SIZ=  000004 
    CURR    =  000002     |     CVAR    =  000005     |     DC1     =  000011 
    DC2     =  000012     |     DC3     =  000013     |     DC4     =  000014 
    DEBUG   =  000000     |     DEBUG_BA=  007F00     |     DEBUG_EN=  007FFF 
    DELIM_LA=  000006     |     DEL_IDX =  000038     |     DEL_SIZE=  000005 
    DEST    =  000001     |     DEST_ADR=  000005     |     DEST_LEN=  000007 
    DEST_SIZ=  000003     |     DEVID_BA=  0048CD     |     DEVID_EN=  0048D8 
    DEVID_LO=  0048D2     |     DEVID_LO=  0048D3     |     DEVID_LO=  0048D4 
    DEVID_LO=  0048D5     |     DEVID_LO=  0048D6     |     DEVID_LO=  0048D7 
    DEVID_LO=  0048D8     |     DEVID_WA=  0048D1     |     DEVID_XH=  0048CE 
    DEVID_XL=  0048CD     |     DEVID_YH=  0048D0     |     DEVID_YL=  0048CF 
    DIGIT   =  000003     |     DIM_IDX =  000019     |     DIM_SIZE=  000003 
    DIR_IDX =  000045     |     DIV_IDX =  00000D     |     DLE     =  000010 
    DM_BK1RE=  007F90     |     DM_BK1RH=  007F91     |     DM_BK1RL=  007F92 
    DM_BK2RE=  007F93     |     DM_BK2RH=  007F94     |     DM_BK2RL=  007F95 
    DM_CR1  =  007F96     |     DM_CR2  =  007F97     |     DM_CSR1 =  007F98 
    DM_CSR2 =  007F99     |     DM_ENFCT=  007F9A     |     DONE    =  000003 
    DO_IDX  =  00004B     |     DURATION=  000001     |     EEPROM_B=  004000 
    EEPROM_E=  0043FF     |     EEPROM_S=  000400     |     EM      =  000019 
    END_ADR =  000003     |     END_IDX =  00001A     |     ENQ     =  000005 
    EOF     =  0000FF     |     EOL_IDX =  000000     |     EOT     =  000004 
    ERASED  =  005858     |     ERASE_ID=  000046     |     ERR_BAD_=  000004 G
    ERR_BAD_=  000006 G   |     ERR_BAD_=  000005 G   |     ERR_DIM =  00000C G
    ERR_DIV0=  000012 G   |     ERR_END =  000009 G   |     ERR_FORS=  000008 G
    ERR_GOSU=  000007 G   |     ERR_GT25=  000003 G   |     ERR_GT32=  000002 G
    ERR_IDX =  000013     |     ERR_MEM_=  00000A G   |     ERR_NONE=  000000 G
    ERR_PROG=  000011 G   |     ERR_RANG=  00000D G   |     ERR_RETY=  000010 G
    ERR_STRI=  00000F G   |     ERR_STR_=  00000E G   |     ERR_SYNT=  000001 G
    ERR_TOO_=  00000B G   |     ESC     =  00001B     |     ETB     =  000017 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 168.
Hexadecimal [24-Bits]

Symbol Table

    ETX     =  000003     |     EXTI_CR1=  0050A0     |     EXTI_CR2=  0050A1 
    FAUTO   =  000006     |     FCNT    =  000001     |     FCOMP   =  000005 
    FF      =  00000C     |     FHSE    =  7A1200     |     FHSI    =  F42400 
    FILE_DAT=  000010     |     FILE_HEA=  000010     |     FILE_NAM=  000004 
    FILE_SIG=  000000     |     FILE_SIZ=  000002     |     FIRST   =  000001 
    FIRST_CH=  000001     |     FIRST_DA=  000004     |     FLASH_BA=  008000 
    FLASH_CR=  00505A     |     FLASH_CR=  000002     |     FLASH_CR=  000000 
    FLASH_CR=  000003     |     FLASH_CR=  000001     |     FLASH_CR=  00505B 
    FLASH_CR=  000005     |     FLASH_CR=  000004     |     FLASH_CR=  000007 
    FLASH_CR=  000000     |     FLASH_CR=  000006     |     FLASH_DU=  005064 
    FLASH_DU=  0000AE     |     FLASH_DU=  000056     |     FLASH_EN=  017FFF 
    FLASH_FP=  00505D     |     FLASH_FP=  000000     |     FLASH_FP=  000001 
    FLASH_FP=  000002     |     FLASH_FP=  000003     |     FLASH_FP=  000004 
    FLASH_FP=  000005     |     FLASH_IA=  00505F     |     FLASH_IA=  000003 
    FLASH_IA=  000002     |     FLASH_IA=  000006     |     FLASH_IA=  000001 
    FLASH_IA=  000000     |   1 FLASH_ME   00115C R   |     FLASH_NC=  00505C 
    FLASH_NF=  00505E     |     FLASH_NF=  000000     |     FLASH_NF=  000001 
    FLASH_NF=  000002     |     FLASH_NF=  000003     |     FLASH_NF=  000004 
    FLASH_NF=  000005     |     FLASH_PU=  005062     |     FLASH_PU=  000056 
    FLASH_PU=  0000AE     |     FLASH_SI=  010000     |     FLASH_WS=  00480D 
    FLSI    =  01F400     |     FMSTR   =  000010     |     FNAME   =  000005 
    FNAME_MA=  00000C     |     FN_ADR  =  000003     |     FN_ARG  =  000001 
    FOPT    =  000001     |     FOR_IDX =  00001B     |     FREE_RAM=  001580 G
    FREQ    =  000003     |     FRUN    =  000000     |     FS      =  00001C 
    FSECTOR_=  000100     |     FSIZE   =  000001     |     FSLEEP  =  000003 
    FSTEP   =  000001     |     FSTOP   =  000004     |     FSYS_TIM   ****** GX
    FS_BASE =  00C000 G   |     FS_SIZE =  00C000 G   |     FTRACE  =  000007 
    FUNC_LAS=  000031     |     F_ARRAY =  000001     |     GOSUB_ID=  00001D 
    GOTO_IDX=  00001F     |     GPIO_BAS=  005000     |     GPIO_CR1=  000003 
    GPIO_CR2=  000004     |     GPIO_DDR=  000002     |     GPIO_IDR=  000001 
    GPIO_ODR=  000000     |     GPIO_SIZ=  000005     |     GS      =  00001D 
    HEAP_ADR=  000001     |     HIMEM_ID=  000036     |     HSE     =  000000 
    HSECNT  =  004809     |     HSI     =  000001     |     I2C_BASE=  005210 
    I2C_CCRH=  00521C     |     I2C_CCRH=  000080     |     I2C_CCRH=  0000C0 
    I2C_CCRH=  000080     |     I2C_CCRH=  000000     |     I2C_CCRH=  000001 
    I2C_CCRH=  000000     |     I2C_CCRH=  000006     |     I2C_CCRH=  000007 
    I2C_CCRL=  00521B     |     I2C_CCRL=  00001A     |     I2C_CCRL=  000002 
    I2C_CCRL=  00000D     |     I2C_CCRL=  000050     |     I2C_CCRL=  000090 
    I2C_CCRL=  0000A0     |     I2C_CR1 =  005210     |     I2C_CR1_=  000006 
    I2C_CR1_=  000007     |     I2C_CR1_=  000000     |     I2C_CR2 =  005211 
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 169.
Hexadecimal [24-Bits]

Symbol Table

    I2C_TRIS=  000005     |     I2C_TRIS=  000011     |     I2C_TRIS=  000011 
    I2C_TRIS=  000011     |     I2C_WRIT=  000000     |     IDX     =  000001 
    IF_IDX  =  000020     |     INPUT_DI=  000000     |     INPUT_EI=  000001 
    INPUT_FL=  000000     |     INPUT_ID=  00003A     |     INPUT_PU=  000001 
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
    ITC_SPR8=  007F77     |     ITC_SPR_=  000001     |     ITC_SPR_=  000000 
    ITC_SPR_=  000003     |     IWDG_KEY=  000055     |     IWDG_KEY=  0000CC 
    IWDG_KEY=  0000AA     |     IWDG_KR =  0050E0     |     IWDG_PR =  0050E1 
    IWDG_RLR=  0050E2     |     KEY_IDX =  00002F     |     KWORD_LA=  000027 
    LAST    =  000003     |     LAST_BC =  000004     |     LB      =  000002 
    LED_BIT =  000005     |     LED_MASK=  000020     |     LED_PORT=  00500A 
    LEN     =  000005     |     LEN_IDX =  00002C     |     LET_IDX =  000022 
    LF      =  00000A     |     LIMIT   =  000001     |     LINENO  =  000005 
    LINE_HEA=  000003     |   1 LINK    =  001F13 R   |     LIST_IDX=  00003B 
    LITC_IDX=  000007     |     LITW_IDX=  000008     |     LIT_LAST=  000008 
    LL      =  000001     |     LLEN    =  000007     |     LN      =  000003 
    LNADR   =  000003     |     LN_ADDR =  000007     |     LN_ADR  =  000001 
    LN_LEN  =  000001     |     LN_PTR  =  000005     |     LOAD_IDX=  000044 
    LOCATE_I=  000049     |     LOMEM_ID=  000037     |     LPAREN_I=  000004 
    MAX_CODE=  001500     |     MAX_LINE=  007FFF     |     MIN_VAR_=  000080 
    MOD_IDX =  00000E     |     MULDIV_I=  00004D     |     MULOP   =  000005 
    MULT_IDX=  00000F     |     N       =  000001     |     N1      =  000001 
    NAFR    =  004804     |     NAK     =  000015     |     NAME_SIZ=  000002 
    NCLKOPT =  004808     |     NEED    =  000001     |     NEG     =  000001 
    NEW_IDX =  00003C     |     NEXT_IDX=  00001C     |     NFIELD  =  000002 
    NFLASH_W=  00480E     |     NHSECNT =  00480A     |     NLEN    =  000001 
    NLEN_MAS=  00000F     |     NONE_IDX=  0000FF     |     NOPT1   =  004802 
    NOPT2   =  004804     |     NOPT3   =  004806     |     NOPT4   =  004808 
    NOPT5   =  00480A     |     NOPT6   =  00480C     |     NOPT7   =  00480E 
    NOPTBL  =  00487F     |     NOT_IDX =  000016     |     NOT_OP  =  000001 
    NUBC    =  004802     |     NUCLEO_8=  000001     |     NUCLEO_8=  000000 
    NWDGOPT =  004806     |     NWDGOPT_=  FFFFFFFD     |     NWDGOPT_=  FFFFFFFC 
    NWDGOPT_=  FFFFFFFF     |     NWDGOPT_=  FFFFFFFE     |     OFS     =  000002 
    OFS_UART=  000002     |     OFS_UART=  000003     |     OFS_UART=  000004 
    OFS_UART=  000005     |     OFS_UART=  000006     |     OFS_UART=  000007 
    OFS_UART=  000008     |     OFS_UART=  000009     |     OFS_UART=  000001 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 170.
Hexadecimal [24-Bits]

Symbol Table

    OFS_UART=  000009     |     OFS_UART=  00000A     |     OFS_UART=  000000 
    OP      =  000003     |     OPT0    =  004800     |     OPT1    =  004801 
    OPT2    =  004803     |     OPT3    =  004805     |     OPT4    =  004807 
    OPT5    =  004809     |     OPT6    =  00480B     |     OPT7    =  00480D 
    OPTBL   =  00487E     |     OPTION_B=  004800     |     OPTION_E=  00487F 
    OPTION_S=  000080     |     OP_ARITH=  00000F     |     OP_REL  =  000009 
    OP_REL_L=  000015     |     OR_IDX  =  000018     |     OUTPUT_F=  000001 
    OUTPUT_O=  000000     |     OUTPUT_P=  000001     |     OUTPUT_S=  000000 
  1 P1BASIC    000A61 GR  |     PA      =  000000     |     PAD_SIZE=  000080 G
    PAGE0_SI=  000100 G   |     PA_BASE =  005000     |     PA_CR1  =  005003 
    PA_CR2  =  005004     |     PA_DDR  =  005002     |     PA_IDR  =  005001 
    PA_ODR  =  005000     |     PB      =  000005     |     PB_BASE =  005005 
    PB_CR1  =  005008     |     PB_CR2  =  005009     |     PB_DDR  =  005007 
    PB_IDR  =  005006     |     PB_MAJOR=  000001     |     PB_MINOR=  000000 
    PB_ODR  =  005005     |     PB_REV  =  00000F     |     PC      =  00000A 
    PC_BASE =  00500A     |     PC_CR1  =  00500D     |     PC_CR2  =  00500E 
    PC_DDR  =  00500C     |     PC_IDR  =  00500B     |     PC_ODR  =  00500A 
    PD      =  00000F     |     PD_BASE =  00500F     |     PD_CR1  =  005012 
    PD_CR2  =  005013     |     PD_DDR  =  005011     |     PD_IDR  =  005010 
    PD_ODR  =  00500F     |     PE      =  000014     |     PEEK_IDX=  000029 
    PENDING_=  000010     |     PE_BASE =  005014     |     PE_CR1  =  005017 
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
    PI_IDR  =  005029     |     PI_ODR  =  005028     |     POKE_IDX=  00003E 
    POK_ADR =  000003     |     PREV    =  000001     |     PREV_BC =  000005 
    PRINT_ID=  00003F     |   1 PROG_ADD   001132 R   |   1 PROG_SIZ   001144 R
    PSTR    =  000001     |     QUOTE_ID=  000006     |     RAM_BASE=  000000 
    RAM_END =  0017FF     |   1 RAM_MEM    00116D R   |     RAM_SIZE=  001800 
    REL_EQU_=  000011     |     REL_GE_I=  000012     |     REL_GT_I=  000014 
    REL_LE_I=  000010     |     REL_LT_I=  000013     |     REL_NE_I=  000015 
    REL_OP  =  000005     |     REM_IDX =  000023     |     RENUM_ID=  00004A 
    RES_LEN =  000007     |     RET_BPTR=  000001     |     RET_IDX =  00001E 
    RET_LN_A=  000003     |     RNDMIZE_=  000047     |     RND_IDX =  00002A 
    ROP     =  004800     |     RPAREN_I=  000005     |     RS      =  00001E 
    RST_SR  =  0050B3     |     RUN_IDX =  000040     |     RX_QUEUE=  000008 
    SAVE_IDX=  000043     |     SCOL_IDX=  000003     |     SEMIC   =  00003B 
    SEMICOL =  000001     |     SFR_BASE=  005000     |     SFR_END =  0057FF 
    SGN_IDX =  00002B     |     SHARP   =  000023     |     SHOW_COD=  000003 
    SI      =  00000F     |     SIGN    =  000005     |     SIGNATUR=  005042 
    SIZE    =  00000B     |     SIZE_FIE=  000003     |     SKIP    =  000003 
    SLEEP_ID=  000032     |     SLEN    =  000002     |     SMALL_FI=  000003 
    SO      =  00000E     |     SOH     =  000001     |     SPACE   =  000020 
    SPI_CR1 =  005200     |     SPI_CR1_=  000003     |     SPI_CR1_=  000000 
    SPI_CR1_=  000001     |     SPI_CR1_=  000007     |     SPI_CR1_=  000002 
    SPI_CR1_=  000006     |     SPI_CR2 =  005201     |     SPI_CR2_=  000007 
    SPI_CR2_=  000006     |     SPI_CR2_=  000005     |     SPI_CR2_=  000004 
    SPI_CR2_=  000002     |     SPI_CR2_=  000000     |     SPI_CR2_=  000001 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 171.
Hexadecimal [24-Bits]

Symbol Table

    SPI_CRCP=  005205     |     SPI_DR  =  005204     |     SPI_ICR =  005202 
    SPI_RXCR=  005206     |     SPI_SR  =  005203     |     SPI_SR_B=  000007 
    SPI_SR_C=  000004     |     SPI_SR_M=  000005     |     SPI_SR_O=  000006 
    SPI_SR_R=  000000     |     SPI_SR_T=  000001     |     SPI_SR_W=  000003 
    SPI_TXCR=  005207     |     SRC     =  000003     |     SRC_ADR =  000009 
    STACK_EM=  0017FF     |     STACK_SI=  000080 G   |     START   =  000003 
    START_AD=  000001     |     STDOUT  =  000001     |     STEP    =  000003 
    STEP_IDX=  000024     |     STOP_IDX=  000025     |     STR1    =  000001 
    STR1_LEN=  000003     |     STR2    =  000005     |     STR2_LEN=  000007 
  1 STR_BYTE   001155 R   |     STR_VAR_=  00000A     |     STX     =  000002 
    SUB     =  00001A     |     SUB_IDX =  00000C     |     SWIM_CSR=  007F80 
    SYMB_LAS=  00000A     |     SYN     =  000016     |     SYS_SIZE=  004000 
    TAB     =  000009     |     TAB_IDX =  000034     |     TAB_WIDT=  000004 
    TCHAR   =  000001     |     TEMP    =  000001     |     THEN_IDX=  000021 
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 172.
Hexadecimal [24-Bits]

Symbol Table

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
    TOKEN   =  000001     |     TOK_IDX =  00004E     |     TOK_POS =  000001 
    TONE_IDX=  000033     |     TOS     =  000001     |     TO_IDX  =  000027 
    TO_WRITE=  000001     |     TYPE_CON=  000020     |     TYPE_DVA=  000010 
    TYPE_MAS=  0000F0     |     UART    =  000002     |     UART1   =  000000 
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 173.
Hexadecimal [24-Bits]

Symbol Table

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
    UBC     =  004801     |     UNTIL_ID=  00004C     |     US      =  00001F 
    VAL1    =  000003     |     VAL2    =  000001     |     VALUE   =  000001 
    VAR_ADR =  000005     |     VAR_IDX =  000009     |     VAR_NAME=  000005 
    VAR_TYPE=  000009     |     VAR_VALU=  000003     |     VNAME   =  000002 
    VSIZE   =  000004     |     VSIZE2  =  00000C     |     VT      =  00000B 
    WCNT    =  000002     |     WDGOPT  =  004805     |     WDGOPT_I=  000002 
    WDGOPT_L=  000003     |     WDGOPT_W=  000000     |     WDGOPT_W=  000001 
    WIDTH   =  000001     |     WORDS_ID=  000041     |     WWDG_CR =  0050D1 
    WWDG_WR =  0050D2     |     XOFF    =  000013     |     XON     =  000011 
    XSAVE   =  000006     |     YSAVE   =  000007     |     YTEMP   =  000009 
    acc16      ****** GX  |     acc8       ****** GX  |   1 addr_to_   001BC8 R
    addr_to_   ****** GX  |   1 all_word   001F11 R   |   1 and_cond   000D9A R
  1 and_fact   000D78 R   |   1 app        001F80 R   |     app_info   ****** GX
  1 app_name   0009E0 R   |   1 app_spac   001F80 R   |   1 arg_list   000BF3 R
  1 atoi16     000B67 GR  |   3 auto_lin   000044 R   |   3 auto_ste   000046 R
  1 bad_valu   001AE7 R   |     base       ****** GX  |   1 basic_lo   0017C2 R
  3 basicptr   000035 GR  |   1 bkslsh_t   00036C R   |     bksp       ****** GX
  1 bytes_fr   001AFD R   |   1 char_to_   000B50 R   |   1 check_fo   000FC2 R
  1 check_sy   000252 R   |   1 clear_pr   001ADA R   |   1 clear_st   001A0A R
    clr_scre   ****** GX  |   1 cmd_auto   0019E0 R   |   1 cmd_bye    001844 R
  1 cmd_call   0019BF GR  |   1 cmd_clea   001A1D R   |   1 cmd_cls    001B08 R
  1 cmd_del    001A2C R   |   1 cmd_dir    0017DD R   |   1 cmd_eras   0016C5 R
  1 cmd_hime   001A9D R   |   1 cmd_inpu   001335 R   |   1 cmd_line   000AB5 R
  1 cmd_list   00117C R   |   1 cmd_load   001799 R   |   1 cmd_loca   001B1C R
  1 cmd_lome   001ABE R   |   1 cmd_new    0016BA R   |   1 cmd_poke   0013D1 R
  1 cmd_prin   00121B R   |   1 cmd_rand   0018A4 R   |   1 cmd_renu   001B5D R
  1 cmd_run    0015DC R   |   1 cmd_save   001706 R   |   1 cmd_scr    0016BA R
  1 cmd_set_   001995 R   |   1 cmd_slee   001855 R   |   1 cmd_tab    0019B4 R
  1 cmd_tone   001639 R   |   1 cmd_word   0018FA R   |   1 code_add   000000 R
  1 colon_ts   000394 R   |   1 comma_ts   00039F R   |   1 comment    0006BE R
  1 comp_msg   000962 R   |   1 compile    0004B0 GR  |   1 compile_   000218 R
  1 con_msg    001690 R   |   1 cond_acc   00140C R   |   1 conditio   000DC0 R
  1 convert_   0001E6 R   |   1 copy_com   0003E4 R   |   3 count      000032 GR
  1 create_v   000F57 R   |   1 ctrl_c_m   000A8B R   |   1 ctrl_c_s   000A98 R
    ctrl_c_v   ****** GX  |     cursor_c   ****** GX  |     cursor_p   ****** GX
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 174.
Hexadecimal [24-Bits]

Symbol Table

  1 dash_tst   0003B5 R   |   1 decomp_e   0006D0 R   |   1 decomp_l   000617 R
  1 decompil   0005F1 GR  |   1 del_line   0000CE R   |   1 dict_end   001C9B R
  1 digit_te   00034B R   |   1 dim_next   001056 R   |     div32_16   ****** GX
    divide     ****** GX  |   1 do_nothi   000AEA R   |   3 dvar_bgn   00003D GR
  3 dvar_end   00003F GR  |     eeprom_e   ****** GX  |     eeprom_r   ****** GX
    eeprom_w   ****** GX  |   1 eql_tst    00043B R   |   1 erase_fi   000705 R
  1 erase_pr   0016DA R   |   1 err_bad_   0008CD R   |   1 err_bad_   0008E3 R
  1 err_bad_   0008D8 R   |   1 err_dim    000914 R   |   1 err_div0   000947 R
  1 err_end    0008FE R   |   1 err_err    000978 R   |   1 err_gt25   0008C8 R
  1 err_gt32   0008C1 R   |   1 err_gt8_   0008F6 R   |   1 err_gt8_   0008EC R
  1 err_mem_   000902 R   |   1 err_msg_   000894 R   |   1 err_prog   00093A R
  1 err_rang   000918 R   |   1 err_rety   00092E R   |   1 err_star   000973 R
  1 err_str_   00091E R   |   1 err_stri   000927 R   |   1 err_synt   0008BA R
  1 err_too_   00090B R   |   1 error_me   0008BA R   |   1 escaped    0001FB GR
  1 expect     000BDA R   |   1 expect_i   000B3E R   |   1 expressi   000CE2 R
  1 factor     000C38 R   |     farptr     ****** GX  |   1 file_exi   001761 R
  3 file_hea   00005C R   |   1 file_siz   001837 R   |   1 files_co   00183E R
  1 first_fi   000836 R   |   3 flags      000043 GR  |   3 for_nest   000048 R
  1 free       001AEC R   |   4 free_ram   000100 R   |   1 func_abs   00187C R
  1 func_arg   000BE8 R   |   1 func_cha   00186B R   |   1 func_cha   001B34 R
  1 func_cpo   001B59 R   |   1 func_key   0013C6 R   |   1 func_len   0018C5 R
  1 func_mul   000C15 R   |   1 func_pee   0013E5 R   |   1 func_ran   00188C R
  1 func_sig   0018AD R   |   1 func_tic   001868 R   |   1 func_tim   0019AA R
  1 get_arra   000FE3 R   |     get_char   ****** GX  |   1 get_stri   000ED6 R
  1 get_stri   001021 R   |   1 get_targ   001563 R   |   1 get_var_   000F84 R
    getc       ****** GX  |   3 gosub_ne   000049 R   |   1 gt_tst     000446 R
  1 heap_all   000F38 R   |   3 heap_fre   000041 GR  |   3 himem      000039 GR
  1 if_strin   001418 R   |   3 in         000031 GR  |   3 in.w       000030 GR
  1 incr_far   000887 R   |   1 input_ex   0013C1 R   |   1 input_in   0012BF R
  1 input_pr   0012AC R   |   1 input_st   001327 R   |   1 insert_l   00013C R
  1 integer    000352 R   |   1 interp_l   000AEA R   |     is_alpha   ****** GX
    is_digit   ****** GX  |     itoa       ****** GX  |   1 jp_to_ta   001590 R
  1 kword_co   0016A2 R   |   1 kword_di   001E94 GR  |   1 kword_di   001054 R
  1 kword_do   001C7F R   |   1 kword_en   00162D R   |   1 kword_fo   0014D8 R
  1 kword_go   0015A3 R   |   1 kword_go   0015A3 R   |   1 kword_go   0015B7 R
  1 kword_go   001584 R   |   1 kword_go   001584 R   |   1 kword_if   0013F4 R
  1 kword_le   000DF3 GR  |   1 kword_le   000E04 R   |   1 kword_ne   00152C R
  1 kword_re   000AF5 GR  |   1 kword_re   0015C3 R   |   1 kword_st   00151E R
  1 kword_st   001657 R   |   1 kword_to   00150D R   |   1 kword_un   001C87 R
  1 let_int_   000E06 R   |   1 let_stri   000E26 R   |   1 let_stri   000E28 R
  3 line.add   000033 GR  |   1 line_by_   001BB5 R   |   1 line_to_   001B91 R
  1 list_exi   001205 R   |   1 list_loo   0011E1 R   |   1 list_to    0011BF R
  1 lit_word   0006A6 R   |   1 load_fil   000763 R   |   3 lomem      000037 GR
  1 loop_bac   001552 R   |   1 loop_don   00155C R   |   1 lt_tst     00046D R
    move       ****** GX  |     multiply   ****** GX  |   1 nbr_tst    000343 R
  1 need_spa   0005E1 R   |     new_line   ****** GX  |   1 next_fil   00083B R
  1 next_lin   000B02 R   |   1 no_match   000BC2 R   |   1 no_prog    001772 R
  1 no_space   001786 R   |   1 not_a_fi   0017B2 R   |   1 not_a_li   001A98 R
  1 not_file   0016EC R   |   1 open_gap   000107 R   |   1 other      000494 R
  1 other_te   00035B R   |     out        ****** GX  |     pad        ****** GX
  1 parse_in   000203 R   |   1 parse_ke   0002B0 R   |   1 parse_le   000318 R
  1 parse_qu   0001A4 R   |   1 parse_sy   000225 R   |   1 pb_copyr   0009ED R
  3 pending_   00004C R   |   1 plus_tst   00040F R   |   1 prcnt_ts   000430 R
  1 print_ap   000A10 R   |   1 print_er   0009C7 R   |     print_he   ****** GX
    print_in   ****** GX  |   1 print_li   0011C4 R   |   1 print_va   0012B2 R
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 175.
Hexadecimal [24-Bits]

Symbol Table

    prng       ****** GX  |   1 prog_siz   0010E8 R   |   3 progend    00003B GR
  1 program_   0010EF R   |   1 prt_basi   00120D GR  |   1 prt_line   000B24 R
  1 prt_loop   00121F R   |   1 prt_quot   000565 R   |   1 prt_spac   00067E R
  1 prt_var_   0005AD R   |   3 psp        00004A R   |     ptr16      ****** GX
  1 push_it    0002A9 R   |     putc       ****** GX  |     puts       ****** GX
    qgetc      ****** GX  |   1 qmark_ts   0003CB R   |   1 quoted_s   0006CA R
    readln     ****** GX  |   1 reclaim_   000713 R   |   1 relation   000D1E R
  1 renumber   001BF5 R   |   1 reset_ba   000A3F R   |   1 reset_se   00121D R
  1 rest_con   001297 R   |     restore_   ****** GX  |   1 retype     00129F R
  1 right_al   00054A GR  |   1 rparnt_t   000384 R   |   1 rt_msg     000950 R
  1 save_con   001290 R   |     save_cur   ****** GX  |   1 save_fil   00078C R
  1 scan_for   001C15 R   |   1 search_d   000BAF GR  |   1 search_e   000BD7 R
  1 search_f   0006D9 R   |   1 search_f   0007F5 R   |   1 search_l   00009C GR
  1 search_n   000BB5 R   |   1 search_v   001026 R   |     seedx      ****** GX
    seedy      ****** GX  |   1 semic_ts   0003AA R   |     set_curs   ****** GX
    set_seed   ****** GX  |   1 sharp_ts   0003C0 R   |   1 skip       000307 R
  1 skip_str   000B31 R   |   1 skip_to_   00087D R   |   1 slash_ts   000425 R
    space      ****** GX  |     spaces     ****** GX  |     spi_enab   ****** GX
    stack_fu   ****** GX  |   1 star_tst   00041A R   |   1 stop_msg   001681 R
  1 store_lo   001523 R   |   1 str_matc   000BCE R   |   1 str_tst    000331 R
    strcmp     ****** GX  |     strcpy     ****** GX  |     strlen     ****** GX
  1 symb_loo   00022C R   |   1 syntax_e   000981 GR  |     sys_flag   ****** GX
  1 target01   001566 R   |   1 tb_error   000983 GR  |   1 term       000C99 R
  1 term01     000CA0 R   |   1 term_exi   000CDD R   |     tib        ****** GX
  1 tick_tst   0003DA R   |     ticks      ****** GX  |     timer      ****** GX
    to_upper   ****** GX  |   1 tok_to_n   0005B8 R   |   1 token_ch   0004A9 R
  1 token_ex   0004AD R   |     tone       ****** GX  |     uart_put   ****** GX
    umul16_8   ****** GX  |   1 variable   00068B R   |   1 warm_ini   000A2D R
  1 warm_sta   000AB2 R   |   1 words_co   00197F R

ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 176.
Hexadecimal [24-Bits]

Area Table

   0 _CODE      size      0   flags    0
   1 CODE       size   1F80   flags    0
   2 APP_DATA   size      0   flags    8
   3 APP_DATA   size     3C   flags    8
   4 APP_DATA   size      0   flags    8

