ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 1.
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
                                     19 ;-----------------------------
                                     20 ;  pomme-1 project main 
                                     21 ;  assembly file. 
                                     22 ;  interrupt vector table 
                                     23 ;  and hardware initialisation 
                                     24 ;-----------------------------
                                     25 
                                     26     .module POMME1
                                     27 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 2.
Hexadecimal [24-Bits]



                                     28     .include "config.inc" 
                                      1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                      2 ;;  configuration parameters 
                                      3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                      4 
                           000000     5 DEBUG=0 ; set to 1 to include debugging code 
                                      6 
                           000001     7 HSI=1 ; set this to 1 if using internal high speed oscillator  
                           000001     8 .if HSI 
                           000000     9 HSE=0
                           000000    10 .else
                                     11 HSE=1  
                                     12 .endif 
                                     13 
                           000010    14 FMSTR=16 ; master clock frequency in Mhz 
                                     15 
                                     16 ; boards list
                                     17 ; set selected board to 1  
                           000001    18 NUCLEO_8S208RB=1
                                     19 ; use this to ensure 
                                     20 ; only one is selected 
                           000001    21 .if NUCLEO_8S208RB 
                           000000    22 NUCLEO_8S207K8=0
                           000000    23 SB5_SHORT=0
                           000000    24 .else 
                                     25 NUCLEO_8S207K8=1
                                     26 .endif 
                                     27 
                                     28 ; NUCLEO-8S208RB config.
                           000001    29 .if NUCLEO_8S208RB 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 3.
Hexadecimal [24-Bits]



                                     30     .include "inc/stm8s208.inc" 
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
                                     18 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     19 ; 2019/10/18
                                     20 ; STM8S208RB µC registers map
                                     21 ; sdas source file
                                     22 ; author: Jacques Deschênes, copyright 2018,2019
                                     23 ; licence: GPLv3
                                     24 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                     25 	.module stm8s208rb
                                     26 
                                     27 ;;;;;;;;;;;;
                                     28 ; bits
                                     29 ;;;;;;;;;;;;
                           000000    30  BIT0 = 0
                           000001    31  BIT1 = 1
                           000002    32  BIT2 = 2
                           000003    33  BIT3 = 3
                           000004    34  BIT4 = 4
                           000005    35  BIT5 = 5
                           000006    36  BIT6 = 6
                           000007    37  BIT7 = 7
                                     38  	
                                     39 ;;;;;;;;;;;;
                                     40 ; bits masks
                                     41 ;;;;;;;;;;;;
                           000001    42  B0_MASK = (1<<0)
                           000002    43  B1_MASK = (1<<1)
                           000004    44  B2_MASK = (1<<2)
                           000008    45  B3_MASK = (1<<3)
                           000010    46  B4_MASK = (1<<4)
                           000020    47  B5_MASK = (1<<5)
                           000040    48  B6_MASK = (1<<6)
                           000080    49  B7_MASK = (1<<7)
                                     50 
                                     51 ; HSI oscillator frequency 16Mhz
                           F42400    52  FHSI = 16000000
                                     53 ; LSI oscillator frequency 128Khz
                           01F400    54  FLSI = 128000 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 4.
Hexadecimal [24-Bits]



                                     55 
                                     56 ; controller memory regions
                           001800    57  RAM_SIZE = (0x1800) ; 6KB 
                           000800    58  EEPROM_SIZE = (0x800) ; 2KB
                                     59 ; STM8S208RB have 128K flash
                           020000    60  FLASH_SIZE = (0x20000)
                                     61 ; erase block size 
                           000080    62 BLOCK_SIZE=128 
                                     63 
                           000000    64  RAM_BASE = (0)
                           0017FF    65  RAM_END = (RAM_BASE+RAM_SIZE-1)
                           004000    66  EEPROM_BASE = (0x4000)
                           0047FF    67  EEPROM_END = (EEPROM_BASE+EEPROM_SIZE-1)
                           005000    68  SFR_BASE = (0x5000)
                           0057FF    69  SFR_END = (0x57FF)
                           006000    70  BOOT_ROM_BASE = (0x6000)
                           007FFF    71  BOOT_ROM_END = (0x7fff)
                           008000    72  FLASH_BASE = (0x8000)
                           027FFF    73  FLASH_END = (FLASH_BASE+FLASH_SIZE-1)
                           004800    74  OPTION_BASE = (0x4800)
                           000080    75  OPTION_SIZE = (0x80)
                           00487F    76  OPTION_END = (OPTION_BASE+OPTION_SIZE-1)
                           0048CD    77  DEVID_BASE = (0x48CD)
                           0048D8    78  DEVID_END = (0x48D8)
                           007F00    79  DEBUG_BASE = (0X7F00)
                           007FFF    80  DEBUG_END = (0X7FFF)
                                     81 
                                     82 ; options bytes
                                     83 ; this one can be programmed only from SWIM  (ICP)
                           004800    84  OPT0  = (0x4800)
                                     85 ; these can be programmed at runtime (IAP)
                           004801    86  OPT1  = (0x4801)
                           004802    87  NOPT1  = (0x4802)
                           004803    88  OPT2  = (0x4803)
                           004804    89  NOPT2  = (0x4804)
                           004805    90  OPT3  = (0x4805)
                           004806    91  NOPT3  = (0x4806)
                           004807    92  OPT4  = (0x4807)
                           004808    93  NOPT4  = (0x4808)
                           004809    94  OPT5  = (0x4809)
                           00480A    95  NOPT5  = (0x480A)
                           00480B    96  OPT6  = (0x480B)
                           00480C    97  NOPT6 = (0x480C)
                           00480D    98  OPT7 = (0x480D)
                           00480E    99  NOPT7 = (0x480E)
                           00487E   100  OPTBL  = (0x487E)
                           00487F   101  NOPTBL  = (0x487F)
                                    102 ; option registers usage
                                    103 ; read out protection, value 0xAA enable ROP
                           004800   104  ROP = OPT0  
                                    105 ; user boot code, {0..0x3e} 512 bytes row
                           004801   106  UBC = OPT1
                           004802   107  NUBC = NOPT1
                                    108 ; alternate function register
                           004803   109  AFR = OPT2
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 5.
Hexadecimal [24-Bits]



                           004804   110  NAFR = NOPT2
                                    111 ; miscelinous options
                           004805   112  WDGOPT = OPT3
                           004806   113  NWDGOPT = NOPT3
                                    114 ; clock options
                           004807   115  CLKOPT = OPT4
                           004808   116  NCLKOPT = NOPT4
                                    117 ; HSE clock startup delay
                           004809   118  HSECNT = OPT5
                           00480A   119  NHSECNT = NOPT5
                                    120 ; flash wait state
                           00480D   121 FLASH_WS = OPT7
                           00480E   122 NFLASH_WS = NOPT7
                                    123 
                                    124 ; watchdog options bits
                           000003   125   WDGOPT_LSIEN   =  BIT3
                           000002   126   WDGOPT_IWDG_HW =  BIT2
                           000001   127   WDGOPT_WWDG_HW =  BIT1
                           000000   128   WDGOPT_WWDG_HALT = BIT0
                                    129 ; NWDGOPT bits
                           FFFFFFFC   130   NWDGOPT_LSIEN    = ~BIT3
                           FFFFFFFD   131   NWDGOPT_IWDG_HW  = ~BIT2
                           FFFFFFFE   132   NWDGOPT_WWDG_HW  = ~BIT1
                           FFFFFFFF   133   NWDGOPT_WWDG_HALT = ~BIT0
                                    134 
                                    135 ; CLKOPT bits
                           000003   136  CLKOPT_EXT_CLK  = BIT3
                           000002   137  CLKOPT_CKAWUSEL = BIT2
                           000001   138  CLKOPT_PRS_C1   = BIT1
                           000000   139  CLKOPT_PRS_C0   = BIT0
                                    140 
                                    141 ; AFR option, remapable functions
                           000007   142  AFR7_BEEP    = BIT7
                           000006   143  AFR6_I2C     = BIT6
                           000005   144  AFR5_TIM1    = BIT5
                           000004   145  AFR4_TIM1    = BIT4
                           000003   146  AFR3_TIM1    = BIT3
                           000002   147  AFR2_CCO     = BIT2
                           000001   148  AFR1_TIM2    = BIT1
                           000000   149  AFR0_ADC     = BIT0
                                    150 
                                    151 ; device ID = (read only)
                           0048CD   152  DEVID_XL  = (0x48CD)
                           0048CE   153  DEVID_XH  = (0x48CE)
                           0048CF   154  DEVID_YL  = (0x48CF)
                           0048D0   155  DEVID_YH  = (0x48D0)
                           0048D1   156  DEVID_WAF  = (0x48D1)
                           0048D2   157  DEVID_LOT0  = (0x48D2)
                           0048D3   158  DEVID_LOT1  = (0x48D3)
                           0048D4   159  DEVID_LOT2  = (0x48D4)
                           0048D5   160  DEVID_LOT3  = (0x48D5)
                           0048D6   161  DEVID_LOT4  = (0x48D6)
                           0048D7   162  DEVID_LOT5  = (0x48D7)
                           0048D8   163  DEVID_LOT6  = (0x48D8)
                                    164 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 6.
Hexadecimal [24-Bits]



                                    165 
                           005000   166 GPIO_BASE = (0x5000)
                           000005   167 GPIO_SIZE = (5)
                                    168 ; PORTS SFR OFFSET
                           000000   169 PA = 0
                           000005   170 PB = 5
                           00000A   171 PC = 10
                           00000F   172 PD = 15
                           000014   173 PE = 20
                           000019   174 PF = 25
                           00001E   175 PG = 30
                           000023   176 PH = 35 
                           000028   177 PI = 40 
                                    178 
                                    179 ; GPIO
                                    180 ; gpio register offset to base
                           000000   181  GPIO_ODR = 0
                           000001   182  GPIO_IDR = 1
                           000002   183  GPIO_DDR = 2
                           000003   184  GPIO_CR1 = 3
                           000004   185  GPIO_CR2 = 4
                           005000   186  GPIO_BASE=(0X5000)
                                    187  
                                    188 ; port A
                           005000   189  PA_BASE = (0X5000)
                           005000   190  PA_ODR  = (0x5000)
                           005001   191  PA_IDR  = (0x5001)
                           005002   192  PA_DDR  = (0x5002)
                           005003   193  PA_CR1  = (0x5003)
                           005004   194  PA_CR2  = (0x5004)
                                    195 ; port B
                           005005   196  PB_BASE = (0X5005)
                           005005   197  PB_ODR  = (0x5005)
                           005006   198  PB_IDR  = (0x5006)
                           005007   199  PB_DDR  = (0x5007)
                           005008   200  PB_CR1  = (0x5008)
                           005009   201  PB_CR2  = (0x5009)
                                    202 ; port C
                           00500A   203  PC_BASE = (0X500A)
                           00500A   204  PC_ODR  = (0x500A)
                           00500B   205  PC_IDR  = (0x500B)
                           00500C   206  PC_DDR  = (0x500C)
                           00500D   207  PC_CR1  = (0x500D)
                           00500E   208  PC_CR2  = (0x500E)
                                    209 ; port D
                           00500F   210  PD_BASE = (0X500F)
                           00500F   211  PD_ODR  = (0x500F)
                           005010   212  PD_IDR  = (0x5010)
                           005011   213  PD_DDR  = (0x5011)
                           005012   214  PD_CR1  = (0x5012)
                           005013   215  PD_CR2  = (0x5013)
                                    216 ; port E
                           005014   217  PE_BASE = (0X5014)
                           005014   218  PE_ODR  = (0x5014)
                           005015   219  PE_IDR  = (0x5015)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 7.
Hexadecimal [24-Bits]



                           005016   220  PE_DDR  = (0x5016)
                           005017   221  PE_CR1  = (0x5017)
                           005018   222  PE_CR2  = (0x5018)
                                    223 ; port F
                           005019   224  PF_BASE = (0X5019)
                           005019   225  PF_ODR  = (0x5019)
                           00501A   226  PF_IDR  = (0x501A)
                           00501B   227  PF_DDR  = (0x501B)
                           00501C   228  PF_CR1  = (0x501C)
                           00501D   229  PF_CR2  = (0x501D)
                                    230 ; port G
                           00501E   231  PG_BASE = (0X501E)
                           00501E   232  PG_ODR  = (0x501E)
                           00501F   233  PG_IDR  = (0x501F)
                           005020   234  PG_DDR  = (0x5020)
                           005021   235  PG_CR1  = (0x5021)
                           005022   236  PG_CR2  = (0x5022)
                                    237 ; port H not present on LQFP48/LQFP64 package
                           005023   238  PH_BASE = (0X5023)
                           005023   239  PH_ODR  = (0x5023)
                           005024   240  PH_IDR  = (0x5024)
                           005025   241  PH_DDR  = (0x5025)
                           005026   242  PH_CR1  = (0x5026)
                           005027   243  PH_CR2  = (0x5027)
                                    244 ; port I ; only bit 0 on LQFP64 package, not present on LQFP48
                           005028   245  PI_BASE = (0X5028)
                           005028   246  PI_ODR  = (0x5028)
                           005029   247  PI_IDR  = (0x5029)
                           00502A   248  PI_DDR  = (0x502a)
                           00502B   249  PI_CR1  = (0x502b)
                           00502C   250  PI_CR2  = (0x502c)
                                    251 
                                    252 ; input modes CR1
                           000000   253  INPUT_FLOAT = (0) ; no pullup resistor
                           000001   254  INPUT_PULLUP = (1)
                                    255 ; output mode CR1
                           000000   256  OUTPUT_OD = (0) ; open drain
                           000001   257  OUTPUT_PP = (1) ; push pull
                                    258 ; input modes CR2
                           000000   259  INPUT_DI = (0)
                           000001   260  INPUT_EI = (1)
                                    261 ; output speed CR2
                           000000   262  OUTPUT_SLOW = (0)
                           000001   263  OUTPUT_FAST = (1)
                                    264 
                                    265 
                                    266 ; Flash memory
                           000080   267  BLOCK_SIZE=128 
                           00505A   268  FLASH_CR1  = (0x505A)
                           00505B   269  FLASH_CR2  = (0x505B)
                           00505C   270  FLASH_NCR2  = (0x505C)
                           00505D   271  FLASH_FPR  = (0x505D)
                           00505E   272  FLASH_NFPR  = (0x505E)
                           00505F   273  FLASH_IAPSR  = (0x505F)
                           005062   274  FLASH_PUKR  = (0x5062)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 8.
Hexadecimal [24-Bits]



                           005064   275  FLASH_DUKR  = (0x5064)
                                    276 ; data memory unlock keys
                           0000AE   277  FLASH_DUKR_KEY1 = (0xae)
                           000056   278  FLASH_DUKR_KEY2 = (0x56)
                                    279 ; flash memory unlock keys
                           000056   280  FLASH_PUKR_KEY1 = (0x56)
                           0000AE   281  FLASH_PUKR_KEY2 = (0xae)
                                    282 ; FLASH_CR1 bits
                           000003   283  FLASH_CR1_HALT = BIT3
                           000002   284  FLASH_CR1_AHALT = BIT2
                           000001   285  FLASH_CR1_IE = BIT1
                           000000   286  FLASH_CR1_FIX = BIT0
                                    287 ; FLASH_CR2 bits
                           000007   288  FLASH_CR2_OPT = BIT7
                           000006   289  FLASH_CR2_WPRG = BIT6
                           000005   290  FLASH_CR2_ERASE = BIT5
                           000004   291  FLASH_CR2_FPRG = BIT4
                           000000   292  FLASH_CR2_PRG = BIT0
                                    293 ; FLASH_FPR bits
                           000005   294  FLASH_FPR_WPB5 = BIT5
                           000004   295  FLASH_FPR_WPB4 = BIT4
                           000003   296  FLASH_FPR_WPB3 = BIT3
                           000002   297  FLASH_FPR_WPB2 = BIT2
                           000001   298  FLASH_FPR_WPB1 = BIT1
                           000000   299  FLASH_FPR_WPB0 = BIT0
                                    300 ; FLASH_NFPR bits
                           000005   301  FLASH_NFPR_NWPB5 = BIT5
                           000004   302  FLASH_NFPR_NWPB4 = BIT4
                           000003   303  FLASH_NFPR_NWPB3 = BIT3
                           000002   304  FLASH_NFPR_NWPB2 = BIT2
                           000001   305  FLASH_NFPR_NWPB1 = BIT1
                           000000   306  FLASH_NFPR_NWPB0 = BIT0
                                    307 ; FLASH_IAPSR bits
                           000006   308  FLASH_IAPSR_HVOFF = BIT6
                           000003   309  FLASH_IAPSR_DUL = BIT3
                           000002   310  FLASH_IAPSR_EOP = BIT2
                           000001   311  FLASH_IAPSR_PUL = BIT1
                           000000   312  FLASH_IAPSR_WR_PG_DIS = BIT0
                                    313 
                                    314 ; Interrupt control
                           0050A0   315  EXTI_CR1  = (0x50A0)
                           0050A1   316  EXTI_CR2  = (0x50A1)
                                    317 
                                    318 ; Reset Status
                           0050B3   319  RST_SR  = (0x50B3)
                                    320 
                                    321 ; Clock Registers
                           0050C0   322  CLK_ICKR  = (0x50c0)
                           0050C1   323  CLK_ECKR  = (0x50c1)
                           0050C3   324  CLK_CMSR  = (0x50C3)
                           0050C4   325  CLK_SWR  = (0x50C4)
                           0050C5   326  CLK_SWCR  = (0x50C5)
                           0050C6   327  CLK_CKDIVR  = (0x50C6)
                           0050C7   328  CLK_PCKENR1  = (0x50C7)
                           0050C8   329  CLK_CSSR  = (0x50C8)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 9.
Hexadecimal [24-Bits]



                           0050C9   330  CLK_CCOR  = (0x50C9)
                           0050CA   331  CLK_PCKENR2  = (0x50CA)
                           0050CC   332  CLK_HSITRIMR  = (0x50CC)
                           0050CD   333  CLK_SWIMCCR  = (0x50CD)
                                    334 
                                    335 ; Peripherals clock gating
                                    336 ; CLK_PCKENR1 
                           000007   337  CLK_PCKENR1_TIM1 = (7)
                           000006   338  CLK_PCKENR1_TIM3 = (6)
                           000005   339  CLK_PCKENR1_TIM2 = (5)
                           000004   340  CLK_PCKENR1_TIM4 = (4)
                           000003   341  CLK_PCKENR1_UART3 = (3)
                           000002   342  CLK_PCKENR1_UART1 = (2)
                           000001   343  CLK_PCKENR1_SPI = (1)
                           000000   344  CLK_PCKENR1_I2C = (0)
                                    345 ; CLK_PCKENR2
                           000007   346  CLK_PCKENR2_CAN = (7)
                           000003   347  CLK_PCKENR2_ADC = (3)
                           000002   348  CLK_PCKENR2_AWU = (2)
                                    349 
                                    350 ; Clock bits
                           000005   351  CLK_ICKR_REGAH = (5)
                           000004   352  CLK_ICKR_LSIRDY = (4)
                           000003   353  CLK_ICKR_LSIEN = (3)
                           000002   354  CLK_ICKR_FHW = (2)
                           000001   355  CLK_ICKR_HSIRDY = (1)
                           000000   356  CLK_ICKR_HSIEN = (0)
                                    357 
                           000001   358  CLK_ECKR_HSERDY = (1)
                           000000   359  CLK_ECKR_HSEEN = (0)
                                    360 ; clock source
                           0000E1   361  CLK_SWR_HSI = 0xE1
                           0000D2   362  CLK_SWR_LSI = 0xD2
                           0000B4   363  CLK_SWR_HSE = 0xB4
                                    364 
                           000003   365  CLK_SWCR_SWIF = (3)
                           000002   366  CLK_SWCR_SWIEN = (2)
                           000001   367  CLK_SWCR_SWEN = (1)
                           000000   368  CLK_SWCR_SWBSY = (0)
                                    369 
                           000004   370  CLK_CKDIVR_HSIDIV1 = (4)
                           000003   371  CLK_CKDIVR_HSIDIV0 = (3)
                           000002   372  CLK_CKDIVR_CPUDIV2 = (2)
                           000001   373  CLK_CKDIVR_CPUDIV1 = (1)
                           000000   374  CLK_CKDIVR_CPUDIV0 = (0)
                                    375 
                                    376 ; Watchdog
                           0050D1   377  WWDG_CR  = (0x50D1)
                           0050D2   378  WWDG_WR  = (0x50D2)
                           0050E0   379  IWDG_KR  = (0x50E0)
                           0050E1   380  IWDG_PR  = (0x50E1)
                           0050E2   381  IWDG_RLR  = (0x50E2)
                           0000CC   382  IWDG_KEY_ENABLE = 0xCC  ; enable IWDG key 
                           0000AA   383  IWDG_KEY_REFRESH = 0xAA ; refresh counter key 
                           000055   384  IWDG_KEY_ACCESS = 0x55 ; write register key 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 10.
Hexadecimal [24-Bits]



                                    385  
                           0050F0   386  AWU_CSR  = (0x50F0)
                           0050F1   387  AWU_APR  = (0x50F1)
                           0050F2   388  AWU_TBR  = (0x50F2)
                           000004   389  AWU_CSR_AWUEN = 4
                                    390 
                                    391 
                                    392 
                                    393 ; Beeper
                                    394 ; beeper output is alternate function AFR7 on PD4
                                    395 ; connected to CN9-6
                           0050F3   396  BEEP_CSR  = (0x50F3)
                           00000F   397  BEEP_PORT = PD
                           000004   398  BEEP_BIT = 4
                           000010   399  BEEP_MASK = B4_MASK
                                    400 
                                    401 ; SPI
                           005200   402  SPI_CR1  = (0x5200)
                           005201   403  SPI_CR2  = (0x5201)
                           005202   404  SPI_ICR  = (0x5202)
                           005203   405  SPI_SR  = (0x5203)
                           005204   406  SPI_DR  = (0x5204)
                           005205   407  SPI_CRCPR  = (0x5205)
                           005206   408  SPI_RXCRCR  = (0x5206)
                           005207   409  SPI_TXCRCR  = (0x5207)
                                    410 
                                    411 ; SPI_CR1 bit fields 
                           000000   412   SPI_CR1_CPHA=0
                           000001   413   SPI_CR1_CPOL=1
                           000002   414   SPI_CR1_MSTR=2
                           000003   415   SPI_CR1_BR=3
                           000006   416   SPI_CR1_SPE=6
                           000007   417   SPI_CR1_LSBFIRST=7
                                    418   
                                    419 ; SPI_CR2 bit fields 
                           000000   420   SPI_CR2_SSI=0
                           000001   421   SPI_CR2_SSM=1
                           000002   422   SPI_CR2_RXONLY=2
                           000004   423   SPI_CR2_CRCNEXT=4
                           000005   424   SPI_CR2_CRCEN=5
                           000006   425   SPI_CR2_BDOE=6
                           000007   426   SPI_CR2_BDM=7  
                                    427 
                                    428 ; SPI_SR bit fields 
                           000000   429   SPI_SR_RXNE=0
                           000001   430   SPI_SR_TXE=1
                           000003   431   SPI_SR_WKUP=3
                           000004   432   SPI_SR_CRCERR=4
                           000005   433   SPI_SR_MODF=5
                           000006   434   SPI_SR_OVR=6
                           000007   435   SPI_SR_BSY=7
                                    436 
                                    437 ; I2C
                           005210   438  I2C_BASE_ADDR = 0x5210 
                           005210   439  I2C_CR1  = (0x5210)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 11.
Hexadecimal [24-Bits]



                           005211   440  I2C_CR2  = (0x5211)
                           005212   441  I2C_FREQR  = (0x5212)
                           005213   442  I2C_OARL  = (0x5213)
                           005214   443  I2C_OARH  = (0x5214)
                           005216   444  I2C_DR  = (0x5216)
                           005217   445  I2C_SR1  = (0x5217)
                           005218   446  I2C_SR2  = (0x5218)
                           005219   447  I2C_SR3  = (0x5219)
                           00521A   448  I2C_ITR  = (0x521A)
                           00521B   449  I2C_CCRL  = (0x521B)
                           00521C   450  I2C_CCRH  = (0x521C)
                           00521D   451  I2C_TRISER  = (0x521D)
                           00521E   452  I2C_PECR  = (0x521E)
                                    453 
                           000007   454  I2C_CR1_NOSTRETCH = (7)
                           000006   455  I2C_CR1_ENGC = (6)
                           000000   456  I2C_CR1_PE = (0)
                                    457 
                           000007   458  I2C_CR2_SWRST = (7)
                           000003   459  I2C_CR2_POS = (3)
                           000002   460  I2C_CR2_ACK = (2)
                           000001   461  I2C_CR2_STOP = (1)
                           000000   462  I2C_CR2_START = (0)
                                    463 
                           000000   464  I2C_OARL_ADD0 = (0)
                                    465 
                           000009   466  I2C_OAR_ADDR_7BIT = ((I2C_OARL & 0xFE) >> 1)
                           000813   467  I2C_OAR_ADDR_10BIT = (((I2C_OARH & 0x06) << 9) | (I2C_OARL & 0xFF))
                                    468 
                           000007   469  I2C_OARH_ADDMODE = (7)
                           000006   470  I2C_OARH_ADDCONF = (6)
                           000002   471  I2C_OARH_ADD9 = (2)
                           000001   472  I2C_OARH_ADD8 = (1)
                                    473 
                           000007   474  I2C_SR1_TXE = (7)
                           000006   475  I2C_SR1_RXNE = (6)
                           000004   476  I2C_SR1_STOPF = (4)
                           000003   477  I2C_SR1_ADD10 = (3)
                           000002   478  I2C_SR1_BTF = (2)
                           000001   479  I2C_SR1_ADDR = (1)
                           000000   480  I2C_SR1_SB = (0)
                                    481 
                           000005   482  I2C_SR2_WUFH = (5)
                           000003   483  I2C_SR2_OVR = (3)
                           000002   484  I2C_SR2_AF = (2)
                           000001   485  I2C_SR2_ARLO = (1)
                           000000   486  I2C_SR2_BERR = (0)
                                    487 
                           000007   488  I2C_SR3_DUALF = (7)
                           000004   489  I2C_SR3_GENCALL = (4)
                           000002   490  I2C_SR3_TRA = (2)
                           000001   491  I2C_SR3_BUSY = (1)
                           000000   492  I2C_SR3_MSL = (0)
                                    493 
                           000002   494  I2C_ITR_ITBUFEN = (2)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 12.
Hexadecimal [24-Bits]



                           000001   495  I2C_ITR_ITEVTEN = (1)
                           000000   496  I2C_ITR_ITERREN = (0)
                                    497 
                           000007   498  I2C_CCRH_FAST = 7 
                           000006   499  I2C_CCRH_DUTY = 6 
                                    500  
                                    501 ; Precalculated values, all in KHz
                           000080   502  I2C_CCRH_16MHZ_FAST_400 = 0x80
                           00000D   503  I2C_CCRL_16MHZ_FAST_400 = 0x0D
                                    504 ;
                                    505 ; Fast I2C mode max rise time = 300ns
                                    506 ; I2C_FREQR = 16 = (MHz) => tMASTER = 1/16 = 62.5 ns
                                    507 ; TRISER = = (300/62.5) + 1 = floor(4.8) + 1 = 5.
                                    508 
                           000005   509  I2C_TRISER_16MHZ_FAST_400 = 0x05
                                    510 
                           0000C0   511  I2C_CCRH_16MHZ_FAST_320 = 0xC0
                           000002   512  I2C_CCRL_16MHZ_FAST_320 = 0x02
                           000005   513  I2C_TRISER_16MHZ_FAST_320 = 0x05
                                    514 
                           000080   515  I2C_CCRH_16MHZ_FAST_200 = 0x80
                           00001A   516  I2C_CCRL_16MHZ_FAST_200 = 0x1A
                           000005   517  I2C_TRISER_16MHZ_FAST_200 = 0x05
                                    518 
                           000000   519  I2C_CCRH_16MHZ_STD_100 = 0x00
                           000050   520  I2C_CCRL_16MHZ_STD_100 = 0x50
                                    521 ;
                                    522 ; Standard I2C mode max rise time = 1000ns
                                    523 ; I2C_FREQR = 16 = (MHz) => tMASTER = 1/16 = 62.5 ns
                                    524 ; TRISER = = (1000/62.5) + 1 = floor(16) + 1 = 17.
                                    525 
                           000011   526  I2C_TRISER_16MHZ_STD_100 = 0x11
                                    527 
                           000000   528  I2C_CCRH_16MHZ_STD_50 = 0x00
                           0000A0   529  I2C_CCRL_16MHZ_STD_50 = 0xA0
                           000011   530  I2C_TRISER_16MHZ_STD_50 = 0x11
                                    531 
                           000001   532  I2C_CCRH_16MHZ_STD_20 = 0x01
                           000090   533  I2C_CCRL_16MHZ_STD_20 = 0x90
                           000011   534  I2C_TRISER_16MHZ_STD_20 = 0x11;
                                    535 
                           000001   536  I2C_READ = 1
                           000000   537  I2C_WRITE = 0
                                    538 
                                    539 ; baudrate constant for brr_value table access
                                    540 ; to be used by uart_init 
                           000000   541 B2400=0
                           000001   542 B4800=1
                           000002   543 B9600=2
                           000003   544 B19200=3
                           000004   545 B38400=4
                           000005   546 B57600=5
                           000006   547 B115200=6
                           000007   548 B230400=7
                           000008   549 B460800=8
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 13.
Hexadecimal [24-Bits]



                           000009   550 B921600=9
                                    551 
                                    552 ; UART registers offset from
                                    553 ; base address 
                           000000   554 OFS_UART_SR=0
                           000001   555 OFS_UART_DR=1
                           000002   556 OFS_UART_BRR1=2
                           000003   557 OFS_UART_BRR2=3
                           000004   558 OFS_UART_CR1=4
                           000005   559 OFS_UART_CR2=5
                           000006   560 OFS_UART_CR3=6
                           000007   561 OFS_UART_CR4=7
                           000008   562 OFS_UART_CR5=8
                           000009   563 OFS_UART_CR6=9
                           000009   564 OFS_UART_GTR=9
                           00000A   565 OFS_UART_PSCR=10
                                    566 
                                    567 ; uart identifier
                           000000   568  UART1 = 0 
                           000001   569  UART2 = 1
                           000002   570  UART3 = 2
                                    571 
                                    572 ; pins used by uart 
                           000005   573 UART1_TX_PIN=BIT5
                           000004   574 UART1_RX_PIN=BIT4
                           000005   575 UART3_TX_PIN=BIT5
                           000006   576 UART3_RX_PIN=BIT6
                                    577 ; uart port base address 
                           000000   578 UART1_PORT=PA 
                           00000F   579 UART3_PORT=PD
                                    580 
                                    581 ; UART1 
                           005230   582  UART1_BASE  = (0x5230)
                           005230   583  UART1_SR    = (0x5230)
                           005231   584  UART1_DR    = (0x5231)
                           005232   585  UART1_BRR1  = (0x5232)
                           005233   586  UART1_BRR2  = (0x5233)
                           005234   587  UART1_CR1   = (0x5234)
                           005235   588  UART1_CR2   = (0x5235)
                           005236   589  UART1_CR3   = (0x5236)
                           005237   590  UART1_CR4   = (0x5237)
                           005238   591  UART1_CR5   = (0x5238)
                           005239   592  UART1_GTR   = (0x5239)
                           00523A   593  UART1_PSCR  = (0x523A)
                                    594 
                                    595 ; UART3
                           005240   596  UART3_BASE  = (0x5240)
                           005240   597  UART3_SR    = (0x5240)
                           005241   598  UART3_DR    = (0x5241)
                           005242   599  UART3_BRR1  = (0x5242)
                           005243   600  UART3_BRR2  = (0x5243)
                           005244   601  UART3_CR1   = (0x5244)
                           005245   602  UART3_CR2   = (0x5245)
                           005246   603  UART3_CR3   = (0x5246)
                           005247   604  UART3_CR4   = (0x5247)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 14.
Hexadecimal [24-Bits]



                           004249   605  UART3_CR6   = (0x4249)
                                    606 
                                    607 ; UART Status Register bits
                           000007   608  UART_SR_TXE = (7)
                           000006   609  UART_SR_TC = (6)
                           000005   610  UART_SR_RXNE = (5)
                           000004   611  UART_SR_IDLE = (4)
                           000003   612  UART_SR_OR = (3)
                           000002   613  UART_SR_NF = (2)
                           000001   614  UART_SR_FE = (1)
                           000000   615  UART_SR_PE = (0)
                                    616 
                                    617 ; Uart Control Register bits
                           000007   618  UART_CR1_R8 = (7)
                           000006   619  UART_CR1_T8 = (6)
                           000005   620  UART_CR1_UARTD = (5)
                           000004   621  UART_CR1_M = (4)
                           000003   622  UART_CR1_WAKE = (3)
                           000002   623  UART_CR1_PCEN = (2)
                           000001   624  UART_CR1_PS = (1)
                           000000   625  UART_CR1_PIEN = (0)
                                    626 
                           000007   627  UART_CR2_TIEN = (7)
                           000006   628  UART_CR2_TCIEN = (6)
                           000005   629  UART_CR2_RIEN = (5)
                           000004   630  UART_CR2_ILIEN = (4)
                           000003   631  UART_CR2_TEN = (3)
                           000002   632  UART_CR2_REN = (2)
                           000001   633  UART_CR2_RWU = (1)
                           000000   634  UART_CR2_SBK = (0)
                                    635 
                           000006   636  UART_CR3_LINEN = (6)
                           000005   637  UART_CR3_STOP1 = (5)
                           000004   638  UART_CR3_STOP0 = (4)
                           000003   639  UART_CR3_CLKEN = (3)
                           000002   640  UART_CR3_CPOL = (2)
                           000001   641  UART_CR3_CPHA = (1)
                           000000   642  UART_CR3_LBCL = (0)
                                    643 
                           000006   644  UART_CR4_LBDIEN = (6)
                           000005   645  UART_CR4_LBDL = (5)
                           000004   646  UART_CR4_LBDF = (4)
                           000003   647  UART_CR4_ADD3 = (3)
                           000002   648  UART_CR4_ADD2 = (2)
                           000001   649  UART_CR4_ADD1 = (1)
                           000000   650  UART_CR4_ADD0 = (0)
                                    651 
                           000005   652  UART_CR5_SCEN = (5)
                           000004   653  UART_CR5_NACK = (4)
                           000003   654  UART_CR5_HDSEL = (3)
                           000002   655  UART_CR5_IRLP = (2)
                           000001   656  UART_CR5_IREN = (1)
                                    657 ; LIN mode config register
                           000007   658  UART_CR6_LDUM = (7)
                           000005   659  UART_CR6_LSLV = (5)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 15.
Hexadecimal [24-Bits]



                           000004   660  UART_CR6_LASE = (4)
                           000002   661  UART_CR6_LHDIEN = (2) 
                           000001   662  UART_CR6_LHDF = (1)
                           000000   663  UART_CR6_LSF = (0)
                                    664 
                                    665 ; TIMERS
                                    666 ; Timer 1 - 16-bit timer with complementary PWM outputs
                           005250   667  TIM1_CR1  = (0x5250)
                           005251   668  TIM1_CR2  = (0x5251)
                           005252   669  TIM1_SMCR  = (0x5252)
                           005253   670  TIM1_ETR  = (0x5253)
                           005254   671  TIM1_IER  = (0x5254)
                           005255   672  TIM1_SR1  = (0x5255)
                           005256   673  TIM1_SR2  = (0x5256)
                           005257   674  TIM1_EGR  = (0x5257)
                           005258   675  TIM1_CCMR1  = (0x5258)
                           005259   676  TIM1_CCMR2  = (0x5259)
                           00525A   677  TIM1_CCMR3  = (0x525A)
                           00525B   678  TIM1_CCMR4  = (0x525B)
                           00525C   679  TIM1_CCER1  = (0x525C)
                           00525D   680  TIM1_CCER2  = (0x525D)
                           00525E   681  TIM1_CNTRH  = (0x525E)
                           00525F   682  TIM1_CNTRL  = (0x525F)
                           005260   683  TIM1_PSCRH  = (0x5260)
                           005261   684  TIM1_PSCRL  = (0x5261)
                           005262   685  TIM1_ARRH  = (0x5262)
                           005263   686  TIM1_ARRL  = (0x5263)
                           005264   687  TIM1_RCR  = (0x5264)
                           005265   688  TIM1_CCR1H  = (0x5265)
                           005266   689  TIM1_CCR1L  = (0x5266)
                           005267   690  TIM1_CCR2H  = (0x5267)
                           005268   691  TIM1_CCR2L  = (0x5268)
                           005269   692  TIM1_CCR3H  = (0x5269)
                           00526A   693  TIM1_CCR3L  = (0x526A)
                           00526B   694  TIM1_CCR4H  = (0x526B)
                           00526C   695  TIM1_CCR4L  = (0x526C)
                           00526D   696  TIM1_BKR  = (0x526D)
                           00526E   697  TIM1_DTR  = (0x526E)
                           00526F   698  TIM1_OISR  = (0x526F)
                                    699 
                                    700 ; Timer Control Register bits
                           000007   701  TIM_CR1_ARPE = (7)
                           000006   702  TIM_CR1_CMSH = (6)
                           000005   703  TIM_CR1_CMSL = (5)
                           000004   704  TIM_CR1_DIR = (4)
                           000003   705  TIM_CR1_OPM = (3)
                           000002   706  TIM_CR1_URS = (2)
                           000001   707  TIM_CR1_UDIS = (1)
                           000000   708  TIM_CR1_CEN = (0)
                                    709 
                           000006   710  TIM1_CR2_MMS2 = (6)
                           000005   711  TIM1_CR2_MMS1 = (5)
                           000004   712  TIM1_CR2_MMS0 = (4)
                           000002   713  TIM1_CR2_COMS = (2)
                           000000   714  TIM1_CR2_CCPC = (0)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 16.
Hexadecimal [24-Bits]



                                    715 
                                    716 ; Timer Slave Mode Control bits
                           000007   717  TIM1_SMCR_MSM = (7)
                           000006   718  TIM1_SMCR_TS2 = (6)
                           000005   719  TIM1_SMCR_TS1 = (5)
                           000004   720  TIM1_SMCR_TS0 = (4)
                           000002   721  TIM1_SMCR_SMS2 = (2)
                           000001   722  TIM1_SMCR_SMS1 = (1)
                           000000   723  TIM1_SMCR_SMS0 = (0)
                                    724 
                                    725 ; Timer External Trigger Enable bits
                           000007   726  TIM1_ETR_ETP = (7)
                           000006   727  TIM1_ETR_ECE = (6)
                           000005   728  TIM1_ETR_ETPS1 = (5)
                           000004   729  TIM1_ETR_ETPS0 = (4)
                           000003   730  TIM1_ETR_ETF3 = (3)
                           000002   731  TIM1_ETR_ETF2 = (2)
                           000001   732  TIM1_ETR_ETF1 = (1)
                           000000   733  TIM1_ETR_ETF0 = (0)
                                    734 
                                    735 ; Timer Interrupt Enable bits
                           000007   736  TIM1_IER_BIE = (7)
                           000006   737  TIM1_IER_TIE = (6)
                           000005   738  TIM1_IER_COMIE = (5)
                           000004   739  TIM1_IER_CC4IE = (4)
                           000003   740  TIM1_IER_CC3IE = (3)
                           000002   741  TIM1_IER_CC2IE = (2)
                           000001   742  TIM1_IER_CC1IE = (1)
                           000000   743  TIM1_IER_UIE = (0)
                                    744 
                                    745 ; Timer Status Register bits
                           000007   746  TIM1_SR1_BIF = (7)
                           000006   747  TIM1_SR1_TIF = (6)
                           000005   748  TIM1_SR1_COMIF = (5)
                           000004   749  TIM1_SR1_CC4IF = (4)
                           000003   750  TIM1_SR1_CC3IF = (3)
                           000002   751  TIM1_SR1_CC2IF = (2)
                           000001   752  TIM1_SR1_CC1IF = (1)
                           000000   753  TIM1_SR1_UIF = (0)
                                    754 
                           000004   755  TIM1_SR2_CC4OF = (4)
                           000003   756  TIM1_SR2_CC3OF = (3)
                           000002   757  TIM1_SR2_CC2OF = (2)
                           000001   758  TIM1_SR2_CC1OF = (1)
                                    759 
                                    760 ; Timer Event Generation Register bits
                           000007   761  TIM1_EGR_BG = (7)
                           000006   762  TIM1_EGR_TG = (6)
                           000005   763  TIM1_EGR_COMG = (5)
                           000004   764  TIM1_EGR_CC4G = (4)
                           000003   765  TIM1_EGR_CC3G = (3)
                           000002   766  TIM1_EGR_CC2G = (2)
                           000001   767  TIM1_EGR_CC1G = (1)
                           000000   768  TIM1_EGR_UG = (0)
                                    769 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 17.
Hexadecimal [24-Bits]



                                    770 ; Capture/Compare Mode Register 1 - channel configured in output
                           000007   771  TIM1_CCMR1_OC1CE = (7)
                           000006   772  TIM1_CCMR1_OC1M2 = (6)
                           000005   773  TIM1_CCMR1_OC1M1 = (5)
                           000004   774  TIM1_CCMR1_OC1M0 = (4)
                           000003   775  TIM1_CCMR1_OC1PE = (3)
                           000002   776  TIM1_CCMR1_OC1FE = (2)
                           000001   777  TIM1_CCMR1_CC1S1 = (1)
                           000000   778  TIM1_CCMR1_CC1S0 = (0)
                                    779 
                                    780 ; Capture/Compare Mode Register 1 - channel configured in input
                           000007   781  TIM1_CCMR1_IC1F3 = (7)
                           000006   782  TIM1_CCMR1_IC1F2 = (6)
                           000005   783  TIM1_CCMR1_IC1F1 = (5)
                           000004   784  TIM1_CCMR1_IC1F0 = (4)
                           000003   785  TIM1_CCMR1_IC1PSC1 = (3)
                           000002   786  TIM1_CCMR1_IC1PSC0 = (2)
                                    787 ;  TIM1_CCMR1_CC1S1 = (1)
                           000000   788  TIM1_CCMR1_CC1S0 = (0)
                                    789 
                                    790 ; Capture/Compare Mode Register 2 - channel configured in output
                           000007   791  TIM1_CCMR2_OC2CE = (7)
                           000006   792  TIM1_CCMR2_OC2M2 = (6)
                           000005   793  TIM1_CCMR2_OC2M1 = (5)
                           000004   794  TIM1_CCMR2_OC2M0 = (4)
                           000003   795  TIM1_CCMR2_OC2PE = (3)
                           000002   796  TIM1_CCMR2_OC2FE = (2)
                           000001   797  TIM1_CCMR2_CC2S1 = (1)
                           000000   798  TIM1_CCMR2_CC2S0 = (0)
                                    799 
                                    800 ; Capture/Compare Mode Register 2 - channel configured in input
                           000007   801  TIM1_CCMR2_IC2F3 = (7)
                           000006   802  TIM1_CCMR2_IC2F2 = (6)
                           000005   803  TIM1_CCMR2_IC2F1 = (5)
                           000004   804  TIM1_CCMR2_IC2F0 = (4)
                           000003   805  TIM1_CCMR2_IC2PSC1 = (3)
                           000002   806  TIM1_CCMR2_IC2PSC0 = (2)
                                    807 ;  TIM1_CCMR2_CC2S1 = (1)
                           000000   808  TIM1_CCMR2_CC2S0 = (0)
                                    809 
                                    810 ; Capture/Compare Mode Register 3 - channel configured in output
                           000007   811  TIM1_CCMR3_OC3CE = (7)
                           000006   812  TIM1_CCMR3_OC3M2 = (6)
                           000005   813  TIM1_CCMR3_OC3M1 = (5)
                           000004   814  TIM1_CCMR3_OC3M0 = (4)
                           000003   815  TIM1_CCMR3_OC3PE = (3)
                           000002   816  TIM1_CCMR3_OC3FE = (2)
                           000001   817  TIM1_CCMR3_CC3S1 = (1)
                           000000   818  TIM1_CCMR3_CC3S0 = (0)
                                    819 
                                    820 ; Capture/Compare Mode Register 3 - channel configured in input
                           000007   821  TIM1_CCMR3_IC3F3 = (7)
                           000006   822  TIM1_CCMR3_IC3F2 = (6)
                           000005   823  TIM1_CCMR3_IC3F1 = (5)
                           000004   824  TIM1_CCMR3_IC3F0 = (4)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 18.
Hexadecimal [24-Bits]



                           000003   825  TIM1_CCMR3_IC3PSC1 = (3)
                           000002   826  TIM1_CCMR3_IC3PSC0 = (2)
                                    827 ;  TIM1_CCMR3_CC3S1 = (1)
                           000000   828  TIM1_CCMR3_CC3S0 = (0)
                                    829 
                                    830 ; Capture/Compare Mode Register 4 - channel configured in output
                           000007   831  TIM1_CCMR4_OC4CE = (7)
                           000006   832  TIM1_CCMR4_OC4M2 = (6)
                           000005   833  TIM1_CCMR4_OC4M1 = (5)
                           000004   834  TIM1_CCMR4_OC4M0 = (4)
                           000003   835  TIM1_CCMR4_OC4PE = (3)
                           000002   836  TIM1_CCMR4_OC4FE = (2)
                           000001   837  TIM1_CCMR4_CC4S1 = (1)
                           000000   838  TIM1_CCMR4_CC4S0 = (0)
                                    839 
                                    840 ; Capture/Compare Mode Register 4 - channel configured in input
                           000007   841  TIM1_CCMR4_IC4F3 = (7)
                           000006   842  TIM1_CCMR4_IC4F2 = (6)
                           000005   843  TIM1_CCMR4_IC4F1 = (5)
                           000004   844  TIM1_CCMR4_IC4F0 = (4)
                           000003   845  TIM1_CCMR4_IC4PSC1 = (3)
                           000002   846  TIM1_CCMR4_IC4PSC0 = (2)
                                    847 ;  TIM1_CCMR4_CC4S1 = (1)
                           000000   848  TIM1_CCMR4_CC4S0 = (0)
                                    849 
                                    850 ; Timer 2 - 16-bit timer
                           005300   851  TIM2_CR1  = (0x5300)
                           005301   852  TIM2_IER  = (0x5301)
                           005302   853  TIM2_SR1  = (0x5302)
                           005303   854  TIM2_SR2  = (0x5303)
                           005304   855  TIM2_EGR  = (0x5304)
                           005305   856  TIM2_CCMR1  = (0x5305)
                           005306   857  TIM2_CCMR2  = (0x5306)
                           005307   858  TIM2_CCMR3  = (0x5307)
                           005308   859  TIM2_CCER1  = (0x5308)
                           005309   860  TIM2_CCER2  = (0x5309)
                           00530A   861  TIM2_CNTRH  = (0x530A)
                           00530B   862  TIM2_CNTRL  = (0x530B)
                           00530C   863  TIM2_PSCR  = (0x530C)
                           00530D   864  TIM2_ARRH  = (0x530D)
                           00530E   865  TIM2_ARRL  = (0x530E)
                           00530F   866  TIM2_CCR1H  = (0x530F)
                           005310   867  TIM2_CCR1L  = (0x5310)
                           005311   868  TIM2_CCR2H  = (0x5311)
                           005312   869  TIM2_CCR2L  = (0x5312)
                           005313   870  TIM2_CCR3H  = (0x5313)
                           005314   871  TIM2_CCR3L  = (0x5314)
                                    872 
                                    873 ; TIM2_CR1 bitfields
                           000000   874  TIM2_CR1_CEN=(0) ; Counter enable
                           000001   875  TIM2_CR1_UDIS=(1) ; Update disable
                           000002   876  TIM2_CR1_URS=(2) ; Update request source
                           000003   877  TIM2_CR1_OPM=(3) ; One-pulse mode
                           000007   878  TIM2_CR1_ARPE=(7) ; Auto-reload preload enable
                                    879 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 19.
Hexadecimal [24-Bits]



                                    880 ; TIMER2_CCMR bitfields 
                           000000   881  TIM2_CCMR_CCS=(0) ; input/output select
                           000003   882  TIM2_CCMR_OCPE=(3) ; preload enable
                           000004   883  TIM2_CCMR_OCM=(4)  ; output compare mode 
                                    884 
                                    885 ; TIMER2_CCER1 bitfields
                           000000   886  TIM2_CCER1_CC1E=(0)
                           000001   887  TIM2_CCER1_CC1P=(1)
                           000004   888  TIM2_CCER1_CC2E=(4)
                           000005   889  TIM2_CCER1_CC2P=(5)
                                    890 
                                    891 ; TIMER2_EGR bitfields
                           000000   892  TIM2_EGR_UG=(0) ; update generation
                           000001   893  TIM2_EGR_CC1G=(1) ; Capture/compare 1 generation
                           000002   894  TIM2_EGR_CC2G=(2) ; Capture/compare 2 generation
                           000003   895  TIM2_EGR_CC3G=(3) ; Capture/compare 3 generation
                           000006   896  TIM2_EGR_TG=(6); Trigger generation
                                    897 
                                    898 ; Timer 3
                           005320   899  TIM3_CR1  = (0x5320)
                           005321   900  TIM3_IER  = (0x5321)
                           005322   901  TIM3_SR1  = (0x5322)
                           005323   902  TIM3_SR2  = (0x5323)
                           005324   903  TIM3_EGR  = (0x5324)
                           005325   904  TIM3_CCMR1  = (0x5325)
                           005326   905  TIM3_CCMR2  = (0x5326)
                           005327   906  TIM3_CCER1  = (0x5327)
                           005328   907  TIM3_CNTRH  = (0x5328)
                           005329   908  TIM3_CNTRL  = (0x5329)
                           00532A   909  TIM3_PSCR  = (0x532A)
                           00532B   910  TIM3_ARRH  = (0x532B)
                           00532C   911  TIM3_ARRL  = (0x532C)
                           00532D   912  TIM3_CCR1H  = (0x532D)
                           00532E   913  TIM3_CCR1L  = (0x532E)
                           00532F   914  TIM3_CCR2H  = (0x532F)
                           005330   915  TIM3_CCR2L  = (0x5330)
                                    916 
                                    917 ; TIM3_CR1  fields
                           000000   918  TIM3_CR1_CEN = (0)
                           000001   919  TIM3_CR1_UDIS = (1)
                           000002   920  TIM3_CR1_URS = (2)
                           000003   921  TIM3_CR1_OPM = (3)
                           000007   922  TIM3_CR1_ARPE = (7)
                                    923 ; TIM3_CCR2  fields
                           000000   924  TIM3_CCMR2_CC2S_POS = (0)
                           000003   925  TIM3_CCMR2_OC2PE_POS = (3)
                           000004   926  TIM3_CCMR2_OC2M_POS = (4)  
                                    927 ; TIM3_CCER1 fields
                           000000   928  TIM3_CCER1_CC1E = (0)
                           000001   929  TIM3_CCER1_CC1P = (1)
                           000004   930  TIM3_CCER1_CC2E = (4)
                           000005   931  TIM3_CCER1_CC2P = (5)
                                    932 ; TIM3_CCER2 fields
                           000000   933  TIM3_CCER2_CC3E = (0)
                           000001   934  TIM3_CCER2_CC3P = (1)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 20.
Hexadecimal [24-Bits]



                                    935 
                                    936 ; Timer 4
                           005340   937  TIM4_CR1  = (0x5340)
                           005341   938  TIM4_IER  = (0x5341)
                           005342   939  TIM4_SR  = (0x5342)
                           005343   940  TIM4_EGR  = (0x5343)
                           005344   941  TIM4_CNTR  = (0x5344)
                           005345   942  TIM4_PSCR  = (0x5345)
                           005346   943  TIM4_ARR  = (0x5346)
                                    944 
                                    945 ; Timer 4 bitmasks
                                    946 
                           000007   947  TIM4_CR1_ARPE = (7)
                           000003   948  TIM4_CR1_OPM = (3)
                           000002   949  TIM4_CR1_URS = (2)
                           000001   950  TIM4_CR1_UDIS = (1)
                           000000   951  TIM4_CR1_CEN = (0)
                                    952 
                           000000   953  TIM4_IER_UIE = (0)
                                    954 
                           000000   955  TIM4_SR_UIF = (0)
                                    956 
                           000000   957  TIM4_EGR_UG = (0)
                                    958 
                           000002   959  TIM4_PSCR_PSC2 = (2)
                           000001   960  TIM4_PSCR_PSC1 = (1)
                           000000   961  TIM4_PSCR_PSC0 = (0)
                                    962 
                           000000   963  TIM4_PSCR_1 = 0
                           000001   964  TIM4_PSCR_2 = 1
                           000002   965  TIM4_PSCR_4 = 2
                           000003   966  TIM4_PSCR_8 = 3
                           000004   967  TIM4_PSCR_16 = 4
                           000005   968  TIM4_PSCR_32 = 5
                           000006   969  TIM4_PSCR_64 = 6
                           000007   970  TIM4_PSCR_128 = 7
                                    971 
                                    972 ; ADC2
                           005400   973  ADC_CSR  = (0x5400)
                           005401   974  ADC_CR1  = (0x5401)
                           005402   975  ADC_CR2  = (0x5402)
                           005403   976  ADC_CR3  = (0x5403)
                           005404   977  ADC_DRH  = (0x5404)
                           005405   978  ADC_DRL  = (0x5405)
                           005406   979  ADC_TDRH  = (0x5406)
                           005407   980  ADC_TDRL  = (0x5407)
                                    981  
                                    982 ; ADC bitmasks
                                    983 
                           000007   984  ADC_CSR_EOC = (7)
                           000006   985  ADC_CSR_AWD = (6)
                           000005   986  ADC_CSR_EOCIE = (5)
                           000004   987  ADC_CSR_AWDIE = (4)
                           000003   988  ADC_CSR_CH3 = (3)
                           000002   989  ADC_CSR_CH2 = (2)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 21.
Hexadecimal [24-Bits]



                           000001   990  ADC_CSR_CH1 = (1)
                           000000   991  ADC_CSR_CH0 = (0)
                                    992 
                           000006   993  ADC_CR1_SPSEL2 = (6)
                           000005   994  ADC_CR1_SPSEL1 = (5)
                           000004   995  ADC_CR1_SPSEL0 = (4)
                           000001   996  ADC_CR1_CONT = (1)
                           000000   997  ADC_CR1_ADON = (0)
                                    998 
                           000006   999  ADC_CR2_EXTTRIG = (6)
                           000005  1000  ADC_CR2_EXTSEL1 = (5)
                           000004  1001  ADC_CR2_EXTSEL0 = (4)
                           000003  1002  ADC_CR2_ALIGN = (3)
                           000001  1003  ADC_CR2_SCAN = (1)
                                   1004 
                           000007  1005  ADC_CR3_DBUF = (7)
                           000006  1006  ADC_CR3_DRH = (6)
                                   1007 
                                   1008 ; beCAN
                           005420  1009  CAN_MCR = (0x5420)
                           005421  1010  CAN_MSR = (0x5421)
                           005422  1011  CAN_TSR = (0x5422)
                           005423  1012  CAN_TPR = (0x5423)
                           005424  1013  CAN_RFR = (0x5424)
                           005425  1014  CAN_IER = (0x5425)
                           005426  1015  CAN_DGR = (0x5426)
                           005427  1016  CAN_FPSR = (0x5427)
                           005428  1017  CAN_P0 = (0x5428)
                           005429  1018  CAN_P1 = (0x5429)
                           00542A  1019  CAN_P2 = (0x542A)
                           00542B  1020  CAN_P3 = (0x542B)
                           00542C  1021  CAN_P4 = (0x542C)
                           00542D  1022  CAN_P5 = (0x542D)
                           00542E  1023  CAN_P6 = (0x542E)
                           00542F  1024  CAN_P7 = (0x542F)
                           005430  1025  CAN_P8 = (0x5430)
                           005431  1026  CAN_P9 = (0x5431)
                           005432  1027  CAN_PA = (0x5432)
                           005433  1028  CAN_PB = (0x5433)
                           005434  1029  CAN_PC = (0x5434)
                           005435  1030  CAN_PD = (0x5435)
                           005436  1031  CAN_PE = (0x5436)
                           005437  1032  CAN_PF = (0x5437)
                                   1033 
                                   1034 
                                   1035 ; CPU
                           007F00  1036  CPU_A  = (0x7F00)
                           007F01  1037  CPU_PCE  = (0x7F01)
                           007F02  1038  CPU_PCH  = (0x7F02)
                           007F03  1039  CPU_PCL  = (0x7F03)
                           007F04  1040  CPU_XH  = (0x7F04)
                           007F05  1041  CPU_XL  = (0x7F05)
                           007F06  1042  CPU_YH  = (0x7F06)
                           007F07  1043  CPU_YL  = (0x7F07)
                           007F08  1044  CPU_SPH  = (0x7F08)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 22.
Hexadecimal [24-Bits]



                           007F09  1045  CPU_SPL   = (0x7F09)
                           007F0A  1046  CPU_CCR   = (0x7F0A)
                                   1047 
                                   1048 ; global configuration register
                           007F60  1049  CFG_GCR   = (0x7F60)
                           000001  1050  CFG_GCR_AL = 1
                           000000  1051  CFG_GCR_SWIM = 0
                                   1052 
                                   1053 ; interrupt software priority 
                           007F70  1054  ITC_SPR1   = (0x7F70) ; (0..3) 0->resreved,AWU..EXT0 
                           007F71  1055  ITC_SPR2   = (0x7F71) ; (4..7) EXT1..EXT4 RX 
                           007F72  1056  ITC_SPR3   = (0x7F72) ; (8..11) beCAN RX..TIM1 UPDT/OVR  
                           007F73  1057  ITC_SPR4   = (0x7F73) ; (12..15) TIM1 CAP/CMP .. TIM3 UPDT/OVR 
                           007F74  1058  ITC_SPR5   = (0x7F74) ; (16..19) TIM3 CAP/CMP..I2C  
                           007F75  1059  ITC_SPR6   = (0x7F75) ; (20..23) UART3 TX..TIM4 CAP/OVR 
                           007F76  1060  ITC_SPR7   = (0x7F76) ; (24..29) FLASH WR..
                           007F77  1061  ITC_SPR8   = (0x7F77) ; (30..32) ..
                                   1062 
                           000001  1063 ITC_SPR_LEVEL1=1 
                           000000  1064 ITC_SPR_LEVEL2=0
                           000003  1065 ITC_SPR_LEVEL3=3 
                                   1066 
                                   1067 ; SWIM, control and status register
                           007F80  1068  SWIM_CSR   = (0x7F80)
                                   1069 ; debug registers
                           007F90  1070  DM_BK1RE   = (0x7F90)
                           007F91  1071  DM_BK1RH   = (0x7F91)
                           007F92  1072  DM_BK1RL   = (0x7F92)
                           007F93  1073  DM_BK2RE   = (0x7F93)
                           007F94  1074  DM_BK2RH   = (0x7F94)
                           007F95  1075  DM_BK2RL   = (0x7F95)
                           007F96  1076  DM_CR1   = (0x7F96)
                           007F97  1077  DM_CR2   = (0x7F97)
                           007F98  1078  DM_CSR1   = (0x7F98)
                           007F99  1079  DM_CSR2   = (0x7F99)
                           007F9A  1080  DM_ENFCTR   = (0x7F9A)
                                   1081 
                                   1082 ; Interrupt Numbers
                           000000  1083  INT_TLI = 0
                           000001  1084  INT_AWU = 1
                           000002  1085  INT_CLK = 2
                           000003  1086  INT_EXTI0 = 3
                           000004  1087  INT_EXTI1 = 4
                           000005  1088  INT_EXTI2 = 5
                           000006  1089  INT_EXTI3 = 6
                           000007  1090  INT_EXTI4 = 7
                           000008  1091  INT_CAN_RX = 8
                           000009  1092  INT_CAN_TX = 9
                           00000A  1093  INT_SPI = 10
                           00000B  1094  INT_TIM1_OVF = 11
                           00000C  1095  INT_TIM1_CCM = 12
                           00000D  1096  INT_TIM2_OVF = 13
                           00000E  1097  INT_TIM2_CCM = 14
                           00000F  1098  INT_TIM3_OVF = 15
                           000010  1099  INT_TIM3_CCM = 16
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 23.
Hexadecimal [24-Bits]



                           000011  1100  INT_UART1_TX_COMPLETED = 17
                           000012  1101  INT_AUART1_RX_FULL = 18
                           000013  1102  INT_I2C = 19
                           000014  1103  INT_UART3_TX_COMPLETED = 20
                           000015  1104  INT_UART3_RX_FULL = 21
                           000016  1105  INT_ADC2 = 22
                           000017  1106  INT_TIM4_OVF = 23
                           000018  1107  INT_FLASH = 24
                                   1108 
                                   1109 ; Interrupt Vectors
                           008000  1110  INT_VECTOR_RESET = 0x8000
                           008004  1111  INT_VECTOR_TRAP = 0x8004
                           008008  1112  INT_VECTOR_TLI = 0x8008
                           00800C  1113  INT_VECTOR_AWU = 0x800C
                           008010  1114  INT_VECTOR_CLK = 0x8010
                           008014  1115  INT_VECTOR_EXTI0 = 0x8014
                           008018  1116  INT_VECTOR_EXTI1 = 0x8018
                           00801C  1117  INT_VECTOR_EXTI2 = 0x801C
                           008020  1118  INT_VECTOR_EXTI3 = 0x8020
                           008024  1119  INT_VECTOR_EXTI4 = 0x8024
                           008028  1120  INT_VECTOR_CAN_RX = 0x8028
                           00802C  1121  INT_VECTOR_CAN_TX = 0x802c
                           008030  1122  INT_VECTOR_SPI = 0x8030
                           008034  1123  INT_VECTOR_TIM1_OVF = 0x8034
                           008038  1124  INT_VECTOR_TIM1_CCM = 0x8038
                           00803C  1125  INT_VECTOR_TIM2_OVF = 0x803C
                           008040  1126  INT_VECTOR_TIM2_CCM = 0x8040
                           008044  1127  INT_VECTOR_TIM3_OVF = 0x8044
                           008048  1128  INT_VECTOR_TIM3_CCM = 0x8048
                           00804C  1129  INT_VECTOR_UART1_TX_COMPLETED = 0x804c
                           008050  1130  INT_VECTOR_UART1_RX_FULL = 0x8050
                           008054  1131  INT_VECTOR_I2C = 0x8054
                           008058  1132  INT_VECTOR_UART3_TX_COMPLETED = 0x8058
                           00805C  1133  INT_VECTOR_UART3_RX_FULL = 0x805C
                           008060  1134  INT_VECTOR_ADC2 = 0x8060
                           008064  1135  INT_VECTOR_TIM4_OVF = 0x8064
                           008068  1136  INT_VECTOR_FLASH = 0x8068
                                   1137 
                                   1138 ; Condition code register bits
                           000007  1139 CC_V = 7  ; overflow flag 
                           000005  1140 CC_I1= 5  ; interrupt bit 1
                           000004  1141 CC_H = 4  ; half carry 
                           000003  1142 CC_I0 = 3 ; interrupt bit 0
                           000002  1143 CC_N = 2 ;  negative flag 
                           000001  1144 CC_Z = 1 ;  zero flag  
                           000000  1145 CC_C = 0 ; carry bit 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 24.
Hexadecimal [24-Bits]



                                     31     .include "inc/nucleo_8s208.inc"
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
                                     25 ; mcu on board is stm8s208rbt6
                                     26 
                                     27 ; crystal on board is 8Mhz
                           7A1200    28 FHSE = 8000000
                                     29 
                                     30 ; LED2 is user LED
                                     31 ; connected to PC5 via Q2 -> 2N7002 MOSFET
                           00500A    32 LED_PORT = PC_BASE ;port C  ODR
                           000005    33 LED_BIT = 5
                           000020    34 LED_MASK = (1<<LED_BIT) ;bit 5 mask
                                     35 
                                     36      
                                     37 ; B1 on schematic is user button
                                     38 ; connected to PE4
                                     39 ; external pullup resistor R6 4k7 and debounce capacitor C5 100nF
                           005015    40 USR_BTN_PORT = PE_BASE+GPIO_IDR 
                           000004    41 USR_BTN_BIT = 4
                           000010    42 USR_BTN_MASK = (1<<USR_BTN_BIT) ;bit 4 mask
                                     43 
                                     44 ;  user interface UART via ST-LINK , (T-VCP)
                                     45 
                           000000    46 UART=UART1
                                     47 ; port used by  UART3 
                           005000    48 UART_PORT_ODR=PA_ODR 
                           005002    49 UART_PORT_DDR=PA_DDR 
                           005001    50 UART_PORT_IDR=PA_IDR 
                           005003    51 UART_PORT_CR1=PA_CR1 
                           005004    52 UART_PORT_CR2=PA_CR2 
                                     53 
                                     54 ; clock enable bit 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 25.
Hexadecimal [24-Bits]



                           000002    55 UART_PCKEN=CLK_PCKENR1_UART1
                                     56 
                                     57 ; UART1 registers 
                           005230    58 UART_SR=UART1_SR
                           005231    59 UART_DR=UART1_DR
                           005232    60 UART_BRR1=UART1_BRR1
                           005233    61 UART_BRR2=UART1_BRR2
                           005234    62 UART_CR1=UART1_CR1
                           005235    63 UART_CR2=UART1_CR2
                                     64 
                                     65 ; TX, RX pin
                           000005    66 UART_TX_PIN=UART1_TX_PIN
                           000004    67 UART_RX_PIN=UART1_RX_PIN 
                                     68 
                                     69 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 26.
Hexadecimal [24-Bits]



                                     32 .endif  
                                     33 
                                     34 ; NUCLEO-8S207K8 config. 
                           000000    35 .if NUCLEO_8S207K8 
                                     36     SB5_SHORT=1 ; when SB5 short on board STM8 OSCIN is connected to 8Mhz TMCO signal  
                                     37     .include "inc/stm8s207.inc" 
                                     38     .include "inc/nucleo_8s207.inc"
                                     39 .endif 
                                     40 
                                     41 ; all boards includes 
                                     42 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 27.
Hexadecimal [24-Bits]



                                     43 	.include "inc/ascii.inc"
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



                                     44 	.include "inc/gen_macros.inc" 
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 32.
Hexadecimal [24-Bits]



                                     45     .include "sys_globals.inc" 
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
                                     19 ;-----------------------------------------
                                     20 ;   system global definitions 
                                     21 ;-----------------------------------------
                                     22 
                           000100    23     STACK_SIZE==256 ; mcu stack size  
                           000080    24     TIB_SIZE==128 ; input buffer size 
                           000080    25     PAD_SIZE==128 ; working buffer 
                                     26 
                           000002    27     INT_SIZE=2 ; int16 size in bytes
                           000002    28     CELL_SIZE=INT_SIZE 
                                     29 
                                     30 ;------------------
                                     31 ; 'bool.flags' bits 
                                     32 ;------------------
                           000000    33 F_AUTO=0 ; BASIC automatic line number 
                           000001    34 F_RUN=1  ; BASIC program running 
                           000002    35 F_IF=2   ; BASIC if statement condition 
                           000003    36 F_CR=3   ; BASIC print CR at end of line  
                           000004    37 F_UPALPHA=4 ; termios getchar uppercase letter 
                                     38 
                                     39 
                                     40 
                                     41 
                                     42     ; reset BASIC pointer
                                     43     ; to beginning of last token
                                     44     ; extracted except if it was end of line 
                                     45     .macro _unget_token
                                     46         decw y
                                     47     .endm
                                     48 
                                     49     ; extract 16 bits address from BASIC code  
                                     50     .macro _get_addr
                                     51         ldw x,y     ; 1 cy 
                                     52         ldw x,(x)   ; 2 cy 
                                     53         addw y,#2   ; 2 cy 
                                     54     .endm           ; 5 cy 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 33.
Hexadecimal [24-Bits]



                                     55 
                                     56     ; alias for _get_addr 
                                     57     .macro _get_word 
                                     58         _get_addr
                                     59         clr a  
                                     60     .endm ; 6 cy 
                                     61 
                                     62     ; extract character from BASIC code 
                                     63     .macro _get_char 
                                     64         ld a,(y)    ; 1 cy 
                                     65         incw y      ; 1 cy 
                                     66     .endm           ; 2 cy 
                                     67     
                                     68     ; extract next token 
                                     69     .macro _next_token 
                                     70         _get_char 
                                     71     .endm  ; 2 cy 
                                     72 
                                     73     ; extract next command token id 
                                     74     .macro _next_cmd     
                                     75         _get_char       ; 2 cy 
                                     76     .endm               ; 2 cy 
                                     77 
                                     78     ; get code address in x
                                     79     .macro _code_addr 
                                     80         clrw x   ; 1 cy 
                                     81         ld xl,a  ; 1 cy 
                                     82         sllw x   ; 2 cy 
                                     83         ldw x,(code_addr,x) ; 2 cy 
                                     84     .endm        ; 6 cy 
                                     85 
                                     86     ; call subroutine from index in a 
                                     87     .macro _call_code
                                     88         _code_addr  ; 6 cy  
                                     89         call (x)    ; 4 cy 
                                     90     .endm  ; 10 cy 
                                     91 
                                     92     ; jump to bytecode routine 
                                     93     ; routine must jump back to 
                                     94     ; interp_loop 
                                     95     .macro _jp_code 
                                     96         _code_addr 
                                     97         jp (x)
                                     98     .endm  ; 8 cycles 
                                     99 
                                    100     ; jump back to interp_loop 
                                    101     .macro _next 
                                    102         jp interp_loop 
                                    103     .endm ; 2 cycles 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 34.
Hexadecimal [24-Bits]



                                     46 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 35.
Hexadecimal [24-Bits]



                                     29 
                                     30 ;;-----------------------------------
                                     31     .area SSEG (ABS)
                                     32 ;; I prefer to put stack at end of RAM. 	
                                     33 ;;-----------------------------------
      001700                         34     .org RAM_SIZE-STACK_SIZE  
      001700                         35 stack_space: .ds STACK_SIZE ; stack size 256 bytes maximum  
      001800                         36 stack_full: ; after RAM end    
                                     37 
                                     38 ;--------------------------------------
                                     39     .area DATA  (ABS)
      000000                         40 	.org 0
                                     41 ;--------------------------------------	
      000000                         42 SW_RESET: .blkw 2  ; jump or call here reset mcu  
                                     43 
                                     44 ;--------------------------------------
                                     45 ; variables used by Wozmon
                                     46 ;--------------------------------------
                                     47 ; bytes order of words is inverted for stm8
                                     48 ; compared to Apple I wozmon  
                                     49 ; examine memory address 
      000004                         50 XAMADR: .blkw 1
                                     51 ; store address 
      000006                         52 STORADR: .blkw 1 
                                     53 ; to hold hex number  parsed 
                                     54 ; also last address for BLOK_XAM  
      000008                         55 LAST: .blkw 1
                                     56 ; save Y register 
      00000A                         57 YSAV: .blkw 1 
                                     58 ; operating mode 0=read byte, '.'=block read, ':'=store 
      00000C                         59 MODE: .blkb 1 
                                     60 ; boolean flags 
      00000D                         61 bool.flags: .blkb 1 
                                     62 
                                     63 ; the following 2 track terminal cursor location  
      00000E                         64 cursor.h: .blkb 1 ; cursor horz position 
      00000F                         65 cursor.v: .blkb 1 ; cursor vertical location 
                                     66 
                                     67 ;-----------------------------------
                                     68 ;  variables used by BASIC
                                     69 ;-----------------------------------
                                     70     .area BASIC (ABS) 
                                     71 
                                     72 ; RAM reserved for BASIC program   
      000000                         73 code.start: .blkw 1 ;  
      000002                         74 code.end: .blkw 1 
      000004                         75 rnd: .blkw 1 ; PRNG seed 
      000006                         76 pp: .blkw 1  ;  pointer to end fo program
      000008                         77 pv: .blkw 1  ;  pointer to end of variable storage
      00000A                         78 for.nest.count: .blkb 1 ; depth of FOR..NEXT nesting 
      00000B                         79 gosub.nest.count: .blkb 1 ; depgth of GOSUB nesting tib
      00000C                         80 synpag: .blkb 1 ; 
      00000D                         81 Z1d: .blkb 1 ; 
      00000E                         82 ch: .blkb 1 ; 
      00000F                         83 leadzr: .blkb 1 ;
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 36.
Hexadecimal [24-Bits]



      000010                         84 auto.ln: .blkw 1 ; automtic line number 
      000012                         85 auto.inc: .blkb 1 ; line# step 
      000013                         86 acc: .blkw 1 ;  accumulator 
                                     87 
                                     88 ;; set input buffer at page 1 
                                     89 ;; stm8 default stack is at end of RAM 
                                     90 ;;---------------------------------------
                                     91    .area DATA (ABS)
      000100                         92    .org 0x100 
                                     93 ;;---------------------------------------
      000100                         94 tib: .ds TIB_SIZE ; input buffer 
      000180                         95 pad: .ds PAD_SIZE ; working buffer 
                                     96 ;;--------------------------------------
                                     97     .area HOME 
                                     98 ;; interrupt vector table at 0x8000
                                     99 ;;--------------------------------------
                                    100 
      008000 82 00 80 08            101     int RESET			; reset vector 
      008004 82 00 80 20            102     int TrapHandler     ; syscall handler 
                                    103     
                                    104 
                                    105 ;;----------------------------------------
                                    106 ;; no interrupt used so program code 
                                    107 ;; can start after reset vector 
                                    108     .area  CODE (ABS)
      008008                        109     .org 0x8008 
                                    110 ;;----------------------------------------
                                    111 ; hardware initialisation 
      008008                        112 RESET: 
                                    113 ; Set Fmaster and Fcpu for maximum frequency 16Mhz
      008008 72 5F 50 C6      [ 1]  114     clr CLK_CKDIVR
                                    115 ; stack pointer is a RAM_SIZE-1 at reset 
                                    116 ; no need to initialize it.
                                    117 ; initialize UART  
      00800C CD 80 73         [ 4]  118     call uart_init
                                    119 ; copy softare reset code in RAM 
                                    120 ; at address 0 
      00800F CE 80 1C         [ 2]  121     ldw x,sw_reset 
      008012                        122     _strxz 0 
      008012 BF 00                    1     .byte 0xbf,0 
      008014 CE 80 1E         [ 2]  123     ldw x,sw_reset+2 
      008017                        124     _strxz 2 
      008017 BF 02                    1     .byte 0xbf,2 
      008019 CC 81 63         [ 2]  125     jp WOZMON ; enter monitor 
                                    126 
                                    127 ;-----------------------------
                                    128 ; this code is copied in RAM 
                                    129 ; at address at startup 
                                    130 ; so that a jump or call 
                                    131 ; to NUL pointer 
                                    132 ; reset MCU 
                                    133 ;-----------------------------
      00801C                        134 sw_reset: 
      00801C                        135     _swreset ; 4 bytes code 
      00801C 35 80 50 D1      [ 1]    1     mov WWDG_CR,#0X80
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 37.
Hexadecimal [24-Bits]



                                    136 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 38.
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
                                     27 
                                     28 ;---------------------------------------------
                                     29 ;  kernel functions table 
                                     30 ;  functions code is passed in A 
                                     31 ;  parameters are passed in X,Y
                                     32 ;  output returned in A,X,Y,CC  
                                     33 ;
                                     34 ;  code |  function      | input    |  output
                                     35 ;  -----|----------------|----------|---------
                                     36 ;    0  | launch BASIC   | none     | none 
                                     37 ;    1  | putchar        | X=char   | none 
                                     38 ;    2  | getchar        | none     | A=char
                                     39 ;    3  | querychar      | none     | A=0,-1
                                     40 ;    4  | clr_screen     | none     | none 
                                     41 ;    5  | delback        | none     | none 
                                     42 ;    6  | getline        | a=buflen | A= line length
                                     43 ;       |                | x=lnlen  |  
                                     44 ;       |                | y=bufadr | 
                                     45 ;    7  | puts           | X=*str   | none 
                                     46 ;----------------------------------------------
                                     47 ; functions codes 
                                     48 ; global constants 
                           000000    49     IBASIC==0 
                           000001    50     PUTC==1
                           000002    51     GETC==2 
                           000003    52     QCHAR==3
                           000004    53     CLS==4
                           000005    54     DELBK=5
                           000006    55     GETLN=6 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 39.
Hexadecimal [24-Bits]



                           000007    56     PUTSTR=7 
                                     57 
                                     58 ;    .area CODE (ABS)
                                     59 
                                     60 ;-------------------------
                                     61 ;  syscall handler 
                                     62 ;-------------------------
      008020                         63 TrapHandler::
      008020 A1 00            [ 1]   64     cp a,#IBASIC
      008022 26 07            [ 1]   65     jrne 1$ 
      008024 AE 82 62         [ 2]   66     ldw x,#BASIC ; cold start entry point address  
      008027 1F 08            [ 2]   67     ldw (8,sp),x ; replace IRET address
      008029 20 47            [ 2]   68     jra syscall_exit
      00802B                         69 1$:
      00802B A1 01            [ 1]   70     cp a,#PUTC 
      00802D 26 06            [ 1]   71     jrne 2$
      00802F 9F               [ 1]   72     ld a,xl 
      008030 CD 80 84         [ 4]   73     call putchar
      008033 20 3D            [ 2]   74     jra syscall_exit 
      008035                         75 2$:
      008035 A1 02            [ 1]   76     cp a,#GETC 
      008037 26 07            [ 1]   77     jrne 3$ 
      008039 CD 80 95         [ 4]   78     call getchar 
      00803C 6B 02            [ 1]   79     ld (2,sp),a ; force value of A=char after IRET  
      00803E 20 32            [ 2]   80     jra syscall_exit
      008040                         81 3$:
      008040 A1 03            [ 1]   82     cp a,#QCHAR 
      008042 26 0A            [ 1]   83     jrne 4$ 
      008044 CD 80 AD         [ 4]   84     call querychar 
      008047 6B 02            [ 1]   85     ld (2,sp),a ; force value of A=char after IRET 
      008049                         86     _drop 1  ; drop CC 
      008049 5B 01            [ 2]    1     addw sp,#1 
      00804B 8A               [ 1]   87     push CC  ; replace with new state 
      00804C 20 24            [ 2]   88     jra syscall_exit
      00804E                         89 4$:
      00804E A1 04            [ 1]   90     cp a,#CLS 
      008050 26 05            [ 1]   91     jrne 5$ 
      008052 CD 80 B5         [ 4]   92     call clr_screen
      008055 20 1B            [ 2]   93     jra syscall_exit 
      008057                         94 5$: 
      008057 A1 05            [ 1]   95     cp a,#DELBK 
      008059 26 05            [ 1]   96     jrne 6$
      00805B CD 80 C9         [ 4]   97     call delback 
      00805E 20 12            [ 2]   98     jra syscall_exit 
      008060 A1 06            [ 1]   99 6$: cp a,#GETLN 
      008062 26 07            [ 1]  100     jrne 7$ 
      008064 CD 80 DD         [ 4]  101     call getline 
      008067 6B 02            [ 1]  102     ld (2,sp),a  ; force value of A=LEN after IRET 
      008069 20 07            [ 2]  103     jra syscall_exit 
      00806B B1 07            [ 1]  104 7$: cp a,PUTSTR 
      00806D 26 03            [ 1]  105     jrne syscall_exit 
      00806F CD 81 36         [ 4]  106     call puts 
                                    107 ; bad codes ignored 
      008072                        108 syscall_exit:
      008072 80               [11]  109     iret 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 40.
Hexadecimal [24-Bits]



                                    110 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 41.
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
                                     19     .module TERMIOS 
                                     20 
                                     21 ;-------------------------------
                                     22 ;   Terminal I/Os 
                                     23 ;   functions 
                                     24 ;-------------------------------
                                     25 
                                     26 ;    .area CODE (ABS)
                                     27 
                                     28 ;----------------------------------
                                     29 ;  initialize UART at 
                                     30 ;  115200 BAUD 8N1 
                                     31 ;  expect Fmaster=16Mhz 
                                     32 ;-----------------------------------
      008073                         33 uart_init:
                                     34 ; baud rate setting, 16Mhz/115200=139 (0x8b)
      008073 35 0B 52 33      [ 1]   35     mov UART_BRR2,#0xb 
      008077 35 08 52 32      [ 1]   36     mov UART_BRR1,#0x8 
      00807B 35 2C 52 35      [ 1]   37   	mov UART_CR2,#((1<<UART_CR2_TEN)|(1<<UART_CR2_REN)|(1<<UART_CR2_RIEN));
      00807F 72 10 00 00      [ 1]   38 	bset UART,#UART_CR1_PIEN
      008083 81               [ 4]   39     ret 
                                     40 
                                     41 ;--------------------------
                                     42 ; send character 
                                     43 ; to terminal 
                                     44 ; input:
                                     45 ;   A    character 
                                     46 ; output:
                                     47 ;   none   A not modified
                                     48 ;-------------------------
      008084                         49 putchar::
      008084 72 0F 52 30 FB   [ 2]   50     btjf UART_SR,#UART_SR_TXE,.
      008089 C7 52 31         [ 1]   51     ld UART_DR,a
      00808C A1 0D            [ 1]   52     cp a,#CR 
      00808E 26 02            [ 1]   53     jrne 1$
      008090                         54     _clrz cursor.h 
      008090 3F 0E                    1     .byte 0x3f, cursor.h 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 42.
Hexadecimal [24-Bits]



      008092                         55 1$:
      008092                         56     _incz cursor.h 
      008092 3C 0E                    1     .byte 0x3c, cursor.h 
      008094 81               [ 4]   57     ret 
                                     58 
                                     59 ;--------------------------------
                                     60 ;  retreive a character from 
                                     61 ;  terninal wait until 
                                     62 ;  character available 
                                     63 ;  input:
                                     64 ;     none
                                     65 ;  output:
                                     66 ;     A     character 
                                     67 ;--------------------------------
      008095                         68 getchar::
      008095 72 0B 52 30 FB   [ 2]   69     btjf UART_SR,#UART_SR_RXNE,.
      00809A C6 52 31         [ 1]   70     ld a,UART_DR 
      00809D 72 09 00 0D 0A   [ 2]   71     btjf bool.flags,#F_UPALPHA,9$
      0080A2 A1 61            [ 1]   72     cp a,#'a 
      0080A4 2B 06            [ 1]   73     jrmi 9$ 
      0080A6 A1 7B            [ 1]   74     cp a,#'z+1 
      0080A8 2A 02            [ 1]   75     jrpl 9$
      0080AA A4 DF            [ 1]   76     and a,#0xdf ; clear bit 5 
      0080AC                         77 9$:
      0080AC 81               [ 4]   78     ret 
                                     79 
                                     80 
                                     81 ;---------------------------------
                                     82 ;  verify if a character is available 
                                     83 ;  from terminal. Return immedialety
                                     84 ;  input:
                                     85 ;       none 
                                     86 ;  output:
                                     87 ;      A     0=no char, -1=available
                                     88 ;     CC     N,Z flags reflect state of A 
                                     89 ;-------------------------------------
      0080AD                         90 querychar::
      0080AD 4F               [ 1]   91     clr a ; Z=1,N=0 
      0080AE 72 0B 52 30 01   [ 2]   92     btjf UART_SR,#UART_SR_RXNE,9$
      0080B3 43               [ 1]   93     cpl a ; Z=0,N=1
      0080B4                         94 9$:
      0080B4 81               [ 4]   95     ret 
                                     96 
                                     97 ;-----------------------------------
                                     98 ;  send clear screen command 
                                     99 ;  to terminal. 
                                    100 ;  pour un terminal VT10x la
                                    101 ;  sequence: ESC'c' efface 
                                    102 ;  l'écran et place le curseur 
                                    103 ;  dans le coin supérieur gauche.
                                    104 ;  input:
                                    105 ;    none 
                                    106 ;  output:
                                    107 ;    none 
                                    108 ;------------------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 43.
Hexadecimal [24-Bits]



      0080B5                        109 clr_screen::
      0080B5 88               [ 1]  110     push a ; preserve register 
      0080B6 A6 1B            [ 1]  111     ld a,#ESC
      0080B8 CD 80 84         [ 4]  112     call putchar 
      0080BB A6 63            [ 1]  113     ld a,#'c
      0080BD CD 80 84         [ 4]  114     call putchar 
      0080C0 4F               [ 1]  115     clr a 
      0080C1                        116     _straz cursor.h 
      0080C1 B7 0E                    1     .byte 0xb7,cursor.h 
      0080C3                        117     _straz cursor.v
      0080C3 B7 0F                    1     .byte 0xb7,cursor.v 
      0080C5                        118     _incz cursor.h  
      0080C5 3C 0E                    1     .byte 0x3c, cursor.h 
      0080C7 84               [ 1]  119     pop a
      0080C8 81               [ 4]  120     ret 
                                    121 
                                    122 ;-------------------------------
                                    123 ;  delete character left of 
                                    124 ;  cursor
                                    125 ;  input:
                                    126 ;    Y    buffer pointer to tib 
                                    127 ;  output:
                                    128 ;     Y    decremented  
                                    129 ;-------------------------------
      0080C9                        130 delback::
      0080C9 A6 08            [ 1]  131     ld a,#BS 
      0080CB CD 80 84         [ 4]  132     call putchar 
      0080CE A6 20            [ 1]  133     ld a,#SPACE 
      0080D0 CD 80 84         [ 4]  134     call putchar 
      0080D3 A6 08            [ 1]  135     ld a,#BS 
      0080D5 CD 80 84         [ 4]  136     call putchar
      0080D8 72 5A 00 0E      [ 1]  137     dec cursor.h
      0080DC                        138 9$:
      0080DC 81               [ 4]  139     ret 
                                    140 
                                    141 ;------------------------------
                                    142 ;  input line from terminal 
                                    143 ;  CR end line input 
                                    144 ;  BS delete last character 
                                    145 ;  ESC cancel input. 
                                    146 ;  CTRL+D  clear F_AUTO 
                                    147 ;  exit with 0 terminate 
                                    148 ;  line. 
                                    149 ;  input:
                                    150 ;     A     buffer length
                                    151 ;     X     initial line length (maximum 255) 
                                    152 ;     Y     buffer address 
                                    153 ;  output:
                                    154 ;     A    line length  
                                    155 ;------------------------------
                           000001   156     LEN=1 ; line length 2 byte 
                           000003   157     BUFLEN=3 ; buffer length  1 byte 
                           000004   158     BUFADR=4 ; buffer address 2 bytes 
                           000005   159     VSIZE=5 
      0080DD                        160 getline::
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 44.
Hexadecimal [24-Bits]



      0080DD 90 89            [ 2]  161     pushw y ; BUFADR 
      0080DF 4A               [ 1]  162     dec a   ; keep 1 char for terminal 0 
      0080E0 88               [ 1]  163     push a  ; BUFLEN 
      0080E1 89               [ 2]  164     pushw x   
      0080E2 72 F9 01         [ 2]  165     addw y,(LEN,sp)
      0080E5 90 7F            [ 1]  166     clr (y)
      0080E7                        167 0$: 
      0080E7 CD 80 95         [ 4]  168     call getchar
      0080EA A1 08            [ 1]  169     cp a,#BS
      0080EC 26 0D            [ 1]  170     jrne 1$
      0080EE 0D 02            [ 1]  171     tnz (LEN+1,sp)
      0080F0 27 F5            [ 1]  172     jreq 0$ 
      0080F2 90 5A            [ 2]  173     decw y 
      0080F4 90 7F            [ 1]  174     clr (y)
      0080F6 0A 02            [ 1]  175     dec (LEN+1,sp)
      0080F8 CD 80 C9         [ 4]  176     call delback 
      0080FB                        177 1$:
      0080FB A1 04            [ 1]  178     cp a,#CTRL_D 
      0080FD 26 06            [ 1]  179     jrne 2$
      0080FF 72 11 00 0D      [ 1]  180     bres bool.flags,#F_AUTO 
      008103 A6 1B            [ 1]  181     ld a,#ESC  
      008105                        182 2$:
      008105 A1 1B            [ 1]  183     cp a,#ESC 
      008107 26 08            [ 1]  184     jrne 3$
      008109 16 04            [ 2]  185     ldw y,(BUFADR,sp)  
      00810B 90 7F            [ 1]  186     clr (y)
      00810D 0F 02            [ 1]  187     clr (LEN+1,sp)
      00810F A6 0D            [ 1]  188     ld a,#CR  
      008111                        189 3$:    
      008111 A1 0D            [ 1]  190     cp a,#CR 
      008113 27 19            [ 1]  191     jreq 9$ ; exit 
      008115 A1 20            [ 1]  192     cp a,#SPACE 
      008117 2B CE            [ 1]  193     jrmi 0$ ; control char rejected
                                    194 ; character accepted 
      008119 90 F7            [ 1]  195     ld (y),a 
      00811B 7B 02            [ 1]  196     ld a,(LEN+1,sp)
      00811D 11 03            [ 1]  197     cp a,(BUFLEN,sp) 
      00811F 2A 09            [ 1]  198     jrpl 4$ ; can't accept line too long 
      008121 90 F6            [ 1]  199     ld a,(y)
      008123 CD 80 84         [ 4]  200     call putchar 
      008126 90 5C            [ 1]  201     incw y
      008128 0C 02            [ 1]  202     inc (LEN+1,sp) 
      00812A                        203 4$:    
      00812A 90 7F            [ 1]  204     clr (y)
      00812C 20 B9            [ 2]  205     jra 0$ 
      00812E                        206 9$: 
      00812E CD 80 84         [ 4]  207     call putchar     
      008131 7B 02            [ 1]  208     ld a,(LEN+1,sp)
      008133                        209     _drop VSIZE 
      008133 5B 05            [ 2]    1     addw sp,#VSIZE 
      008135 81               [ 4]  210     ret 
                                    211 
                                    212 
                                    213 ;--------------------------
                                    214 ; send string to terminal 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 45.
Hexadecimal [24-Bits]



                                    215 ; strings are ASCIZ 
                                    216 ; input:
                                    217 ;   X    pointer to string 
                                    218 ; output:
                                    219 ;   none 
                                    220 ;--------------------------
      008136                        221 puts::
      008136 F6               [ 1]  222     ld a,(x)
      008137 27 06            [ 1]  223     jreq 9$ 
      008139 CD 80 84         [ 4]  224     call putchar 
      00813C 5C               [ 1]  225     incw x 
      00813D 20 F7            [ 2]  226     jra puts
      00813F 81               [ 4]  227 9$: ret 
                                    228 
                                    229 ;-------------------------
                                    230 ; advance cursor to next 
                                    231 ; column. 
                                    232 ; column width=8 characters 
                                    233 ;--------------------------- 
      008140                        234 tabout::	
      008140                        235     _ldaz cursor.h
      008140 B6 0E                    1     .byte 0xb6,cursor.h 
      008142 AA 07            [ 1]  236  	or a, #7
      008144 4C               [ 1]  237  	inc a 
      008145 88               [ 1]  238     push a 
      008146 A6 20            [ 1]  239 1$:	ld a,#SPACE 
      008148 CD 80 84         [ 4]  240 	call putchar
      00814B                        241     _ldaz cursor.h 
      00814B B6 0E                    1     .byte 0xb6,cursor.h 
      00814D 11 01            [ 1]  242     cp a,(1,sp) 
      00814F 2B F5            [ 1]  243     jrmi 1$ 
      008151 84               [ 1]  244     pop a 
      008152 81               [ 4]  245     ret 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 46.
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
                                     31 ;    .area CODE (ABS)
                                     32 ;    .org 0xff00 
                                     33 ;--------------------------------------------------
                                     34 ; command line interface
                                     35 ; input formats:
                                     36 ;       hex_number  -> display byte at that address 
                                     37 ;       hex_number.hex_number -> display bytes in that range 
                                     38 ;       hex_number: hex_byte [hex_byte]*  -> modify content of RAM or peripheral registers 
                                     39 ;       hex_numberR  -> run machine code a hex_number  address  
                                     40 ;       CTRL_B -> launch pomme BASIC
                                     41 ;----------------------------------------------------
                                     42 ; operating modes
                           000000    43 XAM=0
                           00002E    44 XAM_BLOK='.
                           00003A    45 STOR=': 
                                     46 
                                     47 ; Modeled on Apple I monitor Written by Steve Wozniak 
                                     48 
      008153 70 6F 6D 6D 65 20 49    49 mon_str: .asciz "pomme I monitor" 
             20 6D 6F 6E 69 74 6F
             72 00
      008163                         50 WOZMON:: 
      008163 CD 80 B5         [ 4]   51     call clr_screen
      008166 AE 81 53         [ 2]   52     ldw x,#mon_str
      008169 CD 81 36         [ 4]   53     call puts 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 47.
Hexadecimal [24-Bits]



      00816C                         54 GETLINE: 
      00816C A6 0D            [ 1]   55     ld a,#CR 
      00816E CD 80 84         [ 4]   56     call putchar 
      008171 A6 23            [ 1]   57     ld a,#'# 
      008173 CD 80 84         [ 4]   58     call putchar
      008176 90 5F            [ 1]   59     clrw y 
      008178 20 09            [ 2]   60     jra NEXTCHAR 
      00817A                         61 BACKSPACE:
      00817A 90 5D            [ 2]   62     tnzw y 
      00817C 27 05            [ 1]   63     jreq NEXTCHAR 
      00817E CD 80 C9         [ 4]   64     call delback 
      008181 90 5A            [ 2]   65     decw y 
      008183                         66 NEXTCHAR:
      008183 CD 80 95         [ 4]   67     call getchar 
      008186 A1 08            [ 1]   68     cp a,#BS  
      008188 27 F0            [ 1]   69     jreq BACKSPACE 
      00818A A1 1B            [ 1]   70     cp a,#ESC 
      00818C 27 DE            [ 1]   71     jreq GETLINE ; rejected characters cancel input, start over  
      00818E A1 02            [ 1]   72     cp a,#CTRL_B 
      008190 26 03            [ 1]   73     jrne 1$
      008192 CD 82 62         [ 4]   74     call BASIC
      008195                         75 1$:
      008195 A1 60            [ 1]   76     cp a,#'`
      008197 2B 02            [ 1]   77     jrmi UPPER ; already uppercase 
                                     78 ; uppercase character
                                     79 ; all characters from 0x60..0x7f 
                                     80 ; are folded to 0x40..0x5f     
      008199 A4 DF            [ 1]   81     and a,#0XDF  
      00819B                         82 UPPER: ; there is no lower case letter in buffer 
      00819B 90 D7 01 00      [ 1]   83     ld (tib,y),a 
      00819F CD 80 84         [ 4]   84     call putchar
      0081A2 A1 0D            [ 1]   85     cp a,#CR 
      0081A4 27 04            [ 1]   86     jreq EOL
      0081A6 90 5C            [ 1]   87     incw y 
      0081A8 20 D9            [ 2]   88     jra NEXTCHAR  
      0081AA                         89 EOL: ; end of line, now analyse input 
      0081AA 90 AE FF FF      [ 2]   90     ldw y,#-1
      0081AE 4F               [ 1]   91     clr a  
      0081AF                         92 SETMODE: 
      0081AF                         93     _straz MODE  
      0081AF B7 0C                    1     .byte 0xb7,MODE 
      0081B1                         94 BLSKIP: ; skip blank  
      0081B1 90 5C            [ 1]   95     incw y 
      0081B3                         96 NEXTITEM:
      0081B3 90 D6 01 00      [ 1]   97     ld a,(tib,y)
      0081B7 A1 0D            [ 1]   98     cp a,#CR ; 
      0081B9 27 B1            [ 1]   99     jreq GETLINE ; end of input line  
      0081BB A1 2E            [ 1]  100     cp a,#XAM_BLOK
      0081BD 2B F2            [ 1]  101     jrmi BLSKIP 
      0081BF 27 EE            [ 1]  102     jreq SETMODE 
      0081C1 A1 3A            [ 1]  103     cp a,#STOR 
      0081C3 27 EA            [ 1]  104     jreq SETMODE 
      0081C5 A1 52            [ 1]  105     cp a,#'R 
      0081C7 27 45            [ 1]  106     jreq RUN
      0081C9                        107     _stryz YSAV ; save for comparison
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 48.
Hexadecimal [24-Bits]



      0081C9 90 BF 0A                 1     .byte 0x90,0xbf,YSAV 
      0081CC 5F               [ 1]  108     clrw x 
      0081CD                        109 NEXTHEX:
      0081CD 90 D6 01 00      [ 1]  110     ld a,(tib,y)
      0081D1 A8 30            [ 1]  111     xor a,#0x30 
      0081D3 A1 0A            [ 1]  112     cp a,#10 
      0081D5 2B 06            [ 1]  113     jrmi DIG 
      0081D7 A1 71            [ 1]  114     cp a,#0x71 
      0081D9 2B 10            [ 1]  115     jrmi NOTHEX 
      0081DB A0 67            [ 1]  116     sub a,#0x67
      0081DD                        117 DIG: 
      0081DD 4B 04            [ 1]  118     push #4
      0081DF 4E               [ 1]  119     swap a 
      0081E0                        120 HEXSHIFT:
      0081E0 48               [ 1]  121     sll a 
      0081E1 59               [ 2]  122     rlcw x  
      0081E2 0A 01            [ 1]  123     dec (1,sp)
      0081E4 26 FA            [ 1]  124     jrne HEXSHIFT
      0081E6 84               [ 1]  125     pop a 
      0081E7 90 5C            [ 1]  126     incw y
      0081E9 20 E2            [ 2]  127     jra NEXTHEX
      0081EB                        128 NOTHEX:
      0081EB 90 C3 00 0A      [ 2]  129     cpw y,YSAV 
      0081EF 26 03            [ 1]  130     jrne GOTNUMBER
      0081F1 CC 81 6C         [ 2]  131     jp GETLINE ; no hex number  
      0081F4                        132 GOTNUMBER: 
      0081F4                        133     _ldaz MODE 
      0081F4 B6 0C                    1     .byte 0xb6,MODE 
      0081F6 26 09            [ 1]  134     jrne NOTREAD ; not READ mode  
                                    135 ; set XAM and STOR address 
      0081F8                        136     _strxz XAMADR 
      0081F8 BF 04                    1     .byte 0xbf,XAMADR 
      0081FA                        137     _strxz STORADR 
      0081FA BF 06                    1     .byte 0xbf,STORADR 
      0081FC                        138     _strxz LAST 
      0081FC BF 08                    1     .byte 0xbf,LAST 
      0081FE 4F               [ 1]  139     clr a 
      0081FF 20 16            [ 2]  140     jra NXTPRNT 
      008201                        141 NOTREAD:  
                                    142 ; which mode then?        
      008201 A1 3A            [ 1]  143     cp a,#': 
      008203 26 0C            [ 1]  144     jrne XAM_BLOCK
      008205 9F               [ 1]  145     ld a,xl 
      008206                        146     _ldxz STORADR 
      008206 BE 06                    1     .byte 0xbe,STORADR 
      008208 F7               [ 1]  147     ld (x),a 
      008209 5C               [ 1]  148     incw x 
      00820A                        149     _strxz STORADR 
      00820A BF 06                    1     .byte 0xbf,STORADR 
      00820C                        150 TONEXTITEM:
      00820C 20 A5            [ 2]  151     jra NEXTITEM 
      00820E                        152 RUN:
      00820E                        153     _ldxz XAMADR 
      00820E BE 04                    1     .byte 0xbe,XAMADR 
      008210 FC               [ 2]  154     jp (x)
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 49.
Hexadecimal [24-Bits]



      008211                        155 XAM_BLOCK:
      008211                        156     _strxz LAST 
      008211 BF 08                    1     .byte 0xbf,LAST 
      008213                        157     _ldxz XAMADR
      008213 BE 04                    1     .byte 0xbe,XAMADR 
      008215 5C               [ 1]  158     incw x 
      008216 9F               [ 1]  159     ld a,xl
      008217                        160 NXTPRNT:
      008217 26 12            [ 1]  161     jrne PRDATA 
      008219 A6 0D            [ 1]  162     ld a,#CR 
      00821B CD 80 84         [ 4]  163     call putchar 
      00821E 9E               [ 1]  164     ld a,xh 
      00821F CD 82 3F         [ 4]  165     call PRBYTE 
      008222 9F               [ 1]  166     ld a,xl 
      008223 CD 82 3F         [ 4]  167     call PRBYTE 
      008226 A6 3A            [ 1]  168     ld a,#': 
      008228 CD 80 84         [ 4]  169     call putchar 
      00822B                        170 PRDATA:
      00822B A6 20            [ 1]  171     ld a,#SPACE 
      00822D CD 80 84         [ 4]  172     call putchar
      008230 F6               [ 1]  173     ld a,(x)
      008231 CD 82 3F         [ 4]  174     call PRBYTE
      008234 5C               [ 1]  175     incw x
      008235                        176 XAMNEXT:
      008235 C3 00 08         [ 2]  177     cpw x,LAST 
      008238 22 D2            [ 1]  178     jrugt TONEXTITEM
      00823A                        179 MOD8CHK:
      00823A 9F               [ 1]  180     ld a,xl 
      00823B A4 07            [ 1]  181     and a,#7 
      00823D 20 D8            [ 2]  182     jra NXTPRNT
      00823F                        183 PRBYTE:
      00823F 88               [ 1]  184     push a 
      008240 4E               [ 1]  185     swap a 
      008241 CD 82 45         [ 4]  186     call PRHEX 
      008244 84               [ 1]  187     pop a 
      008245                        188 PRHEX:
      008245 A4 0F            [ 1]  189     and a,#15 
      008247 AB 30            [ 1]  190     add a,#'0
      008249 A1 3A            [ 1]  191     cp a,#'9+1  
      00824B 2B 02            [ 1]  192     jrmi ECHO 
      00824D AB 07            [ 1]  193     add a,#7 
      00824F                        194 ECHO:
      00824F CD 80 84         [ 4]  195     call putchar 
      008252 81               [ 4]  196     RET 
                                    197 
                                    198 ;----------------------------
                                    199 ; code to test 'R' command 
                                    200 ; blink LED on NUCLEO board 
                                    201 ;----------------------------
                           000000   202 .if 0
                                    203 r_test:
                                    204     bset PC_DDR,#5
                                    205     bset PC_CR1,#5
                                    206 1$: bcpl PC_ODR,#5 
                                    207 ; delay 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 50.
Hexadecimal [24-Bits]



                                    208     ld a,#4
                                    209     clrw x
                                    210 2$:
                                    211     decw x 
                                    212     jrne 2$
                                    213     dec a 
                                    214     jrne 2$ 
                                    215 ; if key exit 
                                    216     btjf UART_SR,#UART_SR_RXNE,1$
                                    217     ld a,UART_DR 
                                    218 ; reset MCU to ensure monitor
                                    219 ; with peripherals in known state
                                    220     _swreset
                                    221 
                                    222 ;------------------------------------
                                    223 ; another program to test 'R' command
                                    224 ; print ASCII characters to terminal
                                    225 ; in loop 
                                    226 ;-------------------------------------
                                    227 ascii:
                                    228     ld a,#SPACE
                                    229 1$:
                                    230     call putchar 
                                    231     inc a 
                                    232     cp a,#127 
                                    233     jrmi 1$
                                    234     ld a,#CR 
                                    235     call putchar 
                                    236 ; if key exit 
                                    237     btjf UART_SR,#UART_SR_RXNE,ascii
                                    238     ld a,UART_DR 
                                    239 ; reset MCU to ensure monitor
                                    240 ; with peripherals in known state
                                    241     _swreset
                                    242 
                                    243 .endif 
                                    244 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 51.
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
                                     19 ;------------------------------------
                                     20 ;  stm8_iBASIC 
                                     21 ;
                                     22 ;  Integer BASIC
                                     23 ;  for STM8 compatible in source 
                                     24 ;  and token form with Steve Wozniak 
                                     25 ;  Integer BASIC for Apple I
                                     26 ;------------------------------------
                                     27 
                                     28     .module WOZBASIC 
                                     29 
                                     30 ;--------------------------------
                                     31 ; entry point of Integer BASIC
                                     32 ; BASIC exit by software reset 
                                     33 ; to go back to monitor.
                                     34 ; QUIT command exit to monitor 
                                     35 ;-------------------------------
                                     36  ; cold start
                                     37  ; clear all variables 
                                     38  ; and code space  
      008253 70 6F 6D 6D 65 2D 49    39 p1b_str: .asciz "pomme-I BASIC\r"
             20 42 41 53 49 43 0D
             00
      008262                         40 BASIC::
      008262 CD 80 B5         [ 4]   41     call clr_screen
      008265 AE 82 53         [ 2]   42     ldw x,#p1b_str
      008268 CD 81 36         [ 4]   43     call puts 
                                     44 
                                     45 ;-----------------------------
                                     46 ; reset BASIC states and stack  
                                     47 ;-----------------------------
      00826B                         48 cold:
      00826B CD 83 04         [ 4]   49     call mem_init 
                                     50 ;-----------------------------
                                     51 ; warm start
                                     52 ; keep BASIC states   
                                     53 ;-----------------------------
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 52.
Hexadecimal [24-Bits]



      00826E                         54 warm:
                                     55 ; reset stack 
      00826E 72 13 00 0D      [ 1]   56     bres bool.flags,#F_RUN
      008272 72 18 00 0D      [ 1]   57     bset bool.flags,#F_UPALPHA ; uppercase letter  
                           000000    58 .if 0
                                     59 bset bool.flags,#F_AUTO
                                     60 ldw x,#10
                                     61 _strxz auto.ln
                                     62 _strxz auto.inc
                                     63 .endif  
      008276                         64 0$:
      008276 AE 17 FF         [ 2]   65     ldw x,#RAM_SIZE-1 
      008279 94               [ 1]   66     ldw sp,x  ; reset hardware stack 
      00827A CD 82 A4         [ 4]   67     call crout
                                     68 ; print prompt character     
      00827D A6 3E            [ 1]   69     ld a,#'>
      00827F CD 80 84         [ 4]   70     call putchar 
      008282 5F               [ 1]   71     clrw x 
      008283 72 01 00 0D 0D   [ 2]   72     btjf bool.flags,#F_AUTO,1$ 
      008288                         73     _ldxz auto.ln 
      008288 BE 10                    1     .byte 0xbe,auto.ln 
      00828A CD 82 AA         [ 4]   74     call prt_ln_no
      00828D A6 20            [ 1]   75     ld a,#SPACE 
      00828F CD 80 84         [ 4]   76     call putchar
      008292 AE 00 05         [ 2]   77     ldw x,#5
      008295                         78 1$: 
      008295 90 AE 01 00      [ 2]   79     ldw y,#tib 
      008299 A6 80            [ 1]   80     ld a,#TIB_SIZE 
      00829B CD 80 DD         [ 4]   81     call getline 
      00829E 20 D6            [ 2]   82     jra 0$
      0082A0                         83     _swreset 
      0082A0 35 80 50 D1      [ 1]    1     mov WWDG_CR,#0X80
                                     84 
                                     85 ;----------------------------
                                     86 ; reset 'cursor_h' 
                                     87 ; and send carriage return 
                                     88 ; to terminal.
                                     89 ;-----------------------------
      0082A4                         90 crout: 
      0082A4 A6 0D            [ 1]   91     ld a,#CR 
      0082A6 CD 80 84         [ 4]   92     call putchar 
      0082A9 81               [ 4]   93     ret 
                                     94 
                                     95 ;-----------------------------
                                     96 ; construct line# in buffer 
                                     97 ; then print it.  
                                     98 ; width 5 characters right align 
                                     99 ; input:
                                    100 ;    X    value to print 
                                    101 ; output:
                                    102 ;    tib   updated with line#
                                    103 ;-------------------------------
      0082AA                        104 prt_ln_no:
      0082AA 89               [ 2]  105     pushw x 
      0082AB 90 AE 01 06      [ 2]  106     ldw y,#tib+6
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 53.
Hexadecimal [24-Bits]



      0082AF 90 7F            [ 1]  107     clr (y)
      0082B1 90 5A            [ 2]  108 1$: decw y    
      0082B3 5D               [ 2]  109     tnzw x 
      0082B4 27 09            [ 1]  110     jreq 4$ 
      0082B6 A6 0A            [ 1]  111     ld a,#10 
      0082B8 62               [ 2]  112     div x,a     
      0082B9 AB 30            [ 1]  113     add a,#'0 
      0082BB 90 F7            [ 1]  114     ld (y),a
      0082BD 20 F2            [ 2]  115     jra 1$ 
      0082BF A6 20            [ 1]  116 4$: ld a,#SPACE 
      0082C1 90 F7            [ 1]  117     ld (y),a 
      0082C3 90 5A            [ 2]  118     decw y 
      0082C5 90 A3 01 00      [ 2]  119     cpw y,#tib 
      0082C9 2A F4            [ 1]  120     jrpl 4$
      0082CB AE 01 00         [ 2]  121     ldw x,#tib 
      0082CE CD 81 36         [ 4]  122     call puts
      0082D1 85               [ 2]  123     popw x 
      0082D2 72 01 00 0D 06   [ 2]  124     btjf bool.flags,#F_AUTO,9$ 
      0082D7 72 BB 00 12      [ 2]  125     addw x,auto.inc  
      0082DB                        126     _strxz auto.ln  
      0082DB BF 10                    1     .byte 0xbf,auto.ln 
      0082DD                        127 9$:  
      0082DD 81               [ 4]  128     ret 
                                    129 
      0082DE                        130 get16bit:
                                    131 
      0082DE 81               [ 4]  132     ret 
                                    133 
                                    134 ;----------------------------
                                    135 ; reset F_AUTO 
                                    136 ; initialize 'pp' with 'code.end'
                                    137 ;-----------------------------
      0082DF                        138 new_cmd:
      0082DF 72 11 00 0D      [ 1]  139     bres bool.flags,#F_AUTO 
      0082E3                        140     _ldxz code.end
      0082E3 BE 02                    1     .byte 0xbe,code.end 
      0082E5                        141     _strxz pp 
      0082E5 BF 06                    1     .byte 0xbf,pp 
                                    142 
                                    143 ;-----------------------------
                                    144 ; init 'pv' with 'code.start' 
                                    145 ; clear 'Z1d','for.nest.count'
                                    146 ; 'gosub.nest.count'
                                    147 ;-----------------------------
      0082E7                        148 clr_cmd:
      0082E7                        149     _ldxz code.start
      0082E7 BE 00                    1     .byte 0xbe,code.start 
      0082E9                        150     _strxz pv
      0082E9 BF 08                    1     .byte 0xbf,pv 
      0082EB                        151     _clrz for.nest.count 
      0082EB 3F 0A                    1     .byte 0x3f, for.nest.count 
      0082ED                        152     _clrz gosub.nest.count 
      0082ED 3F 0B                    1     .byte 0x3f, gosub.nest.count 
      0082EF                        153     _clrz synpag 
      0082EF 3F 0C                    1     .byte 0x3f, synpag 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 54.
Hexadecimal [24-Bits]



      0082F1                        154     _clrz Z1d  
      0082F1 3F 0D                    1     .byte 0x3f, Z1d 
      0082F3 81               [ 4]  155     ret 
                                    156 
      0082F4                        157 auto_cmd:
      0082F4 CD 82 DE         [ 4]  158     call get16bit 
      0082F7                        159     _ldxz acc 
      0082F7 BE 13                    1     .byte 0xbe,acc 
      0082F9                        160     _strxz auto.ln 
      0082F9 BF 10                    1     .byte 0xbf,auto.ln 
      0082FB AE 00 0A         [ 2]  161     ldw x,#10 
      0082FE                        162     _strxz auto.inc 
      0082FE BF 12                    1     .byte 0xbf,auto.inc 
      008300 72 10 00 0D      [ 1]  163     bset bool.flags,#F_AUTO 
                                    164 
                                    165 ;---------------------------
                                    166 ; initialize BASIC pointers 
                                    167 ; to code space 
                                    168 ; and clear memory 
                                    169 ;----------------------------
      008304                        170 mem_init:
      008304 AE 02 00         [ 2]  171     ldw x,#0x200 
      008307                        172     _strxz code.start 
      008307 BF 00                    1     .byte 0xbf,code.start 
      008309 AE 17 00         [ 2]  173     ldw x,#RAM_SIZE-256
      00830C                        174     _strxz code.end 
      00830C BF 02                    1     .byte 0xbf,code.end 
      00830E CC 82 DF         [ 2]  175     jp new_cmd 
                                    176 
                                    177     
                                    178 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 55.
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
    AFR     =  004803     |     AFR0_ADC=  000000     |     AFR1_TIM=  000001 
    AFR2_CCO=  000002     |     AFR3_TIM=  000003     |     AFR4_TIM=  000004 
    AFR5_TIM=  000005     |     AFR6_I2C=  000006     |     AFR7_BEE=  000007 
    AWU_APR =  0050F1     |     AWU_CSR =  0050F0     |     AWU_CSR_=  000004 
    AWU_TBR =  0050F2     |     B0_MASK =  000001     |     B115200 =  000006 
    B19200  =  000003     |     B1_MASK =  000002     |     B230400 =  000007 
    B2400   =  000000     |     B2_MASK =  000004     |     B38400  =  000004 
    B3_MASK =  000008     |     B460800 =  000008     |     B4800   =  000001 
    B4_MASK =  000010     |     B57600  =  000005     |     B5_MASK =  000020 
    B6_MASK =  000040     |     B7_MASK =  000080     |     B921600 =  000009 
    B9600   =  000002     |   9 BACKSPAC   00817A R   |   9 BASIC      008262 GR
    BEEP_BIT=  000004     |     BEEP_CSR=  0050F3     |     BEEP_MAS=  000010 
    BEEP_POR=  00000F     |     BELL    =  000007     |     BIT0    =  000000 
    BIT1    =  000001     |     BIT2    =  000002     |     BIT3    =  000003 
    BIT4    =  000004     |     BIT5    =  000005     |     BIT6    =  000006 
    BIT7    =  000007     |     BLOCK_SI=  000080     |   9 BLSKIP     0081B1 R
    BOOT_ROM=  006000     |     BOOT_ROM=  007FFF     |     BS      =  000008 
    BUFADR  =  000004     |     BUFLEN  =  000003     |     CAN     =  000018 
    CAN_DGR =  005426     |     CAN_FPSR=  005427     |     CAN_IER =  005425 
    CAN_MCR =  005420     |     CAN_MSR =  005421     |     CAN_P0  =  005428 
    CAN_P1  =  005429     |     CAN_P2  =  00542A     |     CAN_P3  =  00542B 
    CAN_P4  =  00542C     |     CAN_P5  =  00542D     |     CAN_P6  =  00542E 
    CAN_P7  =  00542F     |     CAN_P8  =  005430     |     CAN_P9  =  005431 
    CAN_PA  =  005432     |     CAN_PB  =  005433     |     CAN_PC  =  005434 
    CAN_PD  =  005435     |     CAN_PE  =  005436     |     CAN_PF  =  005437 
    CAN_RFR =  005424     |     CAN_TPR =  005423     |     CAN_TSR =  005422 
    CC_C    =  000000     |     CC_H    =  000004     |     CC_I0   =  000003 
    CC_I1   =  000005     |     CC_N    =  000002     |     CC_V    =  000007 
    CC_Z    =  000001     |     CELL_SIZ=  000002     |     CFG_GCR =  007F60 
    CFG_GCR_=  000001     |     CFG_GCR_=  000000     |     CLKOPT  =  004807 
    CLKOPT_C=  000002     |     CLKOPT_E=  000003     |     CLKOPT_P=  000000 
    CLKOPT_P=  000001     |     CLK_CCOR=  0050C9     |     CLK_CKDI=  0050C6 
    CLK_CKDI=  000000     |     CLK_CKDI=  000001     |     CLK_CKDI=  000002 
    CLK_CKDI=  000003     |     CLK_CKDI=  000004     |     CLK_CMSR=  0050C3 
    CLK_CSSR=  0050C8     |     CLK_ECKR=  0050C1     |     CLK_ECKR=  000000 
    CLK_ECKR=  000001     |     CLK_HSIT=  0050CC     |     CLK_ICKR=  0050C0 
    CLK_ICKR=  000002     |     CLK_ICKR=  000000     |     CLK_ICKR=  000001 
    CLK_ICKR=  000003     |     CLK_ICKR=  000004     |     CLK_ICKR=  000005 
    CLK_PCKE=  0050C7     |     CLK_PCKE=  000000     |     CLK_PCKE=  000001 
    CLK_PCKE=  000007     |     CLK_PCKE=  000005     |     CLK_PCKE=  000006 
    CLK_PCKE=  000004     |     CLK_PCKE=  000002     |     CLK_PCKE=  000003 
    CLK_PCKE=  0050CA     |     CLK_PCKE=  000003     |     CLK_PCKE=  000002 
    CLK_PCKE=  000007     |     CLK_SWCR=  0050C5     |     CLK_SWCR=  000000 
    CLK_SWCR=  000001     |     CLK_SWCR=  000002     |     CLK_SWCR=  000003 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 56.
Hexadecimal [24-Bits]

Symbol Table

    CLK_SWIM=  0050CD     |     CLK_SWR =  0050C4     |     CLK_SWR_=  0000B4 
    CLK_SWR_=  0000E1     |     CLK_SWR_=  0000D2     |     CLS     =  000004 G
    COLON   =  00003A     |     COMMA   =  00002C     |     CPU_A   =  007F00 
    CPU_CCR =  007F0A     |     CPU_PCE =  007F01     |     CPU_PCH =  007F02 
    CPU_PCL =  007F03     |     CPU_SPH =  007F08     |     CPU_SPL =  007F09 
    CPU_XH  =  007F04     |     CPU_XL  =  007F05     |     CPU_YH  =  007F06 
    CPU_YL  =  007F07     |     CR      =  00000D     |     CTRL_A  =  000001 
    CTRL_B  =  000002     |     CTRL_C  =  000003     |     CTRL_D  =  000004 
    CTRL_E  =  000005     |     CTRL_F  =  000006     |     CTRL_G  =  000007 
    CTRL_H  =  000008     |     CTRL_I  =  000009     |     CTRL_J  =  00000A 
    CTRL_K  =  00000B     |     CTRL_L  =  00000C     |     CTRL_M  =  00000D 
    CTRL_N  =  00000E     |     CTRL_O  =  00000F     |     CTRL_P  =  000010 
    CTRL_Q  =  000011     |     CTRL_R  =  000012     |     CTRL_S  =  000013 
    CTRL_T  =  000014     |     CTRL_U  =  000015     |     CTRL_V  =  000016 
    CTRL_W  =  000017     |     CTRL_X  =  000018     |     CTRL_Y  =  000019 
    CTRL_Z  =  00001A     |     DC1     =  000011     |     DC2     =  000012 
    DC3     =  000013     |     DC4     =  000014     |     DEBUG   =  000000 
    DEBUG_BA=  007F00     |     DEBUG_EN=  007FFF     |     DELBK   =  000005 
    DEVID_BA=  0048CD     |     DEVID_EN=  0048D8     |     DEVID_LO=  0048D2 
    DEVID_LO=  0048D3     |     DEVID_LO=  0048D4     |     DEVID_LO=  0048D5 
    DEVID_LO=  0048D6     |     DEVID_LO=  0048D7     |     DEVID_LO=  0048D8 
    DEVID_WA=  0048D1     |     DEVID_XH=  0048CE     |     DEVID_XL=  0048CD 
    DEVID_YH=  0048D0     |     DEVID_YL=  0048CF     |   9 DIG        0081DD R
    DLE     =  000010     |     DM_BK1RE=  007F90     |     DM_BK1RH=  007F91 
    DM_BK1RL=  007F92     |     DM_BK2RE=  007F93     |     DM_BK2RH=  007F94 
    DM_BK2RL=  007F95     |     DM_CR1  =  007F96     |     DM_CR2  =  007F97 
    DM_CSR1 =  007F98     |     DM_CSR2 =  007F99     |     DM_ENFCT=  007F9A 
  9 ECHO       00824F R   |     EEPROM_B=  004000     |     EEPROM_E=  0047FF 
    EEPROM_S=  000800     |     EM      =  000019     |     ENQ     =  000005 
    EOF     =  00001A     |   9 EOL        0081AA R   |     EOT     =  000004 
    ESC     =  00001B     |     ETB     =  000017     |     ETX     =  000003 
    EXTI_CR1=  0050A0     |     EXTI_CR2=  0050A1     |     FF      =  00000C 
    FHSE    =  7A1200     |     FHSI    =  F42400     |     FLASH_BA=  008000 
    FLASH_CR=  00505A     |     FLASH_CR=  000002     |     FLASH_CR=  000000 
    FLASH_CR=  000003     |     FLASH_CR=  000001     |     FLASH_CR=  00505B 
    FLASH_CR=  000005     |     FLASH_CR=  000004     |     FLASH_CR=  000007 
    FLASH_CR=  000000     |     FLASH_CR=  000006     |     FLASH_DU=  005064 
    FLASH_DU=  0000AE     |     FLASH_DU=  000056     |     FLASH_EN=  027FFF 
    FLASH_FP=  00505D     |     FLASH_FP=  000000     |     FLASH_FP=  000001 
    FLASH_FP=  000002     |     FLASH_FP=  000003     |     FLASH_FP=  000004 
    FLASH_FP=  000005     |     FLASH_IA=  00505F     |     FLASH_IA=  000003 
    FLASH_IA=  000002     |     FLASH_IA=  000006     |     FLASH_IA=  000001 
    FLASH_IA=  000000     |     FLASH_NC=  00505C     |     FLASH_NF=  00505E 
    FLASH_NF=  000000     |     FLASH_NF=  000001     |     FLASH_NF=  000002 
    FLASH_NF=  000003     |     FLASH_NF=  000004     |     FLASH_NF=  000005 
    FLASH_PU=  005062     |     FLASH_PU=  000056     |     FLASH_PU=  0000AE 
    FLASH_SI=  020000     |     FLASH_WS=  00480D     |     FLSI    =  01F400 
    FMSTR   =  000010     |     FS      =  00001C     |     F_AUTO  =  000000 
    F_CR    =  000003     |     F_IF    =  000002     |     F_RUN   =  000001 
    F_UPALPH=  000004     |     GETC    =  000002 G   |   9 GETLINE    00816C R
    GETLN   =  000006     |   9 GOTNUMBE   0081F4 R   |     GPIO_BAS=  005000 
    GPIO_CR1=  000003     |     GPIO_CR2=  000004     |     GPIO_DDR=  000002 
    GPIO_IDR=  000001     |     GPIO_ODR=  000000     |     GPIO_SIZ=  000005 
    GS      =  00001D     |   9 HEXSHIFT   0081E0 R   |     HSE     =  000000 
    HSECNT  =  004809     |     HSI     =  000001     |     I2C_BASE=  005210 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 57.
Hexadecimal [24-Bits]

Symbol Table

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
    I2C_TRIS=  000005     |     I2C_TRIS=  000011     |     I2C_TRIS=  000011 
    I2C_TRIS=  000011     |     I2C_WRIT=  000000     |     IBASIC  =  000000 G
    INPUT_DI=  000000     |     INPUT_EI=  000001     |     INPUT_FL=  000000 
    INPUT_PU=  000001     |     INT_ADC2=  000016     |     INT_AUAR=  000012 
    INT_AWU =  000001     |     INT_CAN_=  000008     |     INT_CAN_=  000009 
    INT_CLK =  000002     |     INT_EXTI=  000003     |     INT_EXTI=  000004 
    INT_EXTI=  000005     |     INT_EXTI=  000006     |     INT_EXTI=  000007 
    INT_FLAS=  000018     |     INT_I2C =  000013     |     INT_SIZE=  000002 
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
    ITC_SPR1=  007F70     |     ITC_SPR2=  007F71     |     ITC_SPR3=  007F72 
    ITC_SPR4=  007F73     |     ITC_SPR5=  007F74     |     ITC_SPR6=  007F75 
    ITC_SPR7=  007F76     |     ITC_SPR8=  007F77     |     ITC_SPR_=  000001 
    ITC_SPR_=  000000     |     ITC_SPR_=  000003     |     IWDG_KEY=  000055 
    IWDG_KEY=  0000CC     |     IWDG_KEY=  0000AA     |     IWDG_KR =  0050E0 
    IWDG_PR =  0050E1     |     IWDG_RLR=  0050E2     |   4 LAST       000008 R
    LED_BIT =  000005     |     LED_MASK=  000020     |     LED_PORT=  00500A 
    LEN     =  000001     |     LF      =  00000A     |   9 MOD8CHK    00823A R
  4 MODE       00000C R   |     NAFR    =  004804     |     NAK     =  000015 
    NCLKOPT =  004808     |   9 NEXTCHAR   008183 R   |   9 NEXTHEX    0081CD R
  9 NEXTITEM   0081B3 R   |     NFLASH_W=  00480E     |     NHSECNT =  00480A 
    NOPT1   =  004802     |     NOPT2   =  004804     |     NOPT3   =  004806 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 58.
Hexadecimal [24-Bits]

Symbol Table

    NOPT4   =  004808     |     NOPT5   =  00480A     |     NOPT6   =  00480C 
    NOPT7   =  00480E     |     NOPTBL  =  00487F     |   9 NOTHEX     0081EB R
  9 NOTREAD    008201 R   |     NUBC    =  004802     |     NUCLEO_8=  000000 
    NUCLEO_8=  000001     |     NWDGOPT =  004806     |     NWDGOPT_=  FFFFFFFD 
    NWDGOPT_=  FFFFFFFC     |     NWDGOPT_=  FFFFFFFF     |     NWDGOPT_=  FFFFFFFE 
  9 NXTPRNT    008217 R   |     OFS_UART=  000002     |     OFS_UART=  000003 
    OFS_UART=  000004     |     OFS_UART=  000005     |     OFS_UART=  000006 
    OFS_UART=  000007     |     OFS_UART=  000008     |     OFS_UART=  000009 
    OFS_UART=  000001     |     OFS_UART=  000009     |     OFS_UART=  00000A 
    OFS_UART=  000000     |     OPT0    =  004800     |     OPT1    =  004801 
    OPT2    =  004803     |     OPT3    =  004805     |     OPT4    =  004807 
    OPT5    =  004809     |     OPT6    =  00480B     |     OPT7    =  00480D 
    OPTBL   =  00487E     |     OPTION_B=  004800     |     OPTION_E=  00487F 
    OPTION_S=  000080     |     OUTPUT_F=  000001     |     OUTPUT_O=  000000 
    OUTPUT_P=  000001     |     OUTPUT_S=  000000     |     PA      =  000000 
    PAD_SIZE=  000080 G   |     PA_BASE =  005000     |     PA_CR1  =  005003 
    PA_CR2  =  005004     |     PA_DDR  =  005002     |     PA_IDR  =  005001 
    PA_ODR  =  005000     |     PB      =  000005     |     PB_BASE =  005005 
    PB_CR1  =  005008     |     PB_CR2  =  005009     |     PB_DDR  =  005007 
    PB_IDR  =  005006     |     PB_ODR  =  005005     |     PC      =  00000A 
    PC_BASE =  00500A     |     PC_CR1  =  00500D     |     PC_CR2  =  00500E 
    PC_DDR  =  00500C     |     PC_IDR  =  00500B     |     PC_ODR  =  00500A 
    PD      =  00000F     |     PD_BASE =  00500F     |     PD_CR1  =  005012 
    PD_CR2  =  005013     |     PD_DDR  =  005011     |     PD_IDR  =  005010 
    PD_ODR  =  00500F     |     PE      =  000014     |     PE_BASE =  005014 
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
  9 PRBYTE     00823F R   |   9 PRDATA     00822B R   |   9 PRHEX      008245 R
    PUTC    =  000001 G   |     PUTSTR  =  000007     |     QCHAR   =  000003 G
    RAM_BASE=  000000     |     RAM_END =  0017FF     |     RAM_SIZE=  001800 
  9 RESET      008008 R   |     ROP     =  004800     |     RS      =  00001E 
    RST_SR  =  0050B3     |   9 RUN        00820E R   |     SB5_SHOR=  000000 
    SEMIC   =  00003B     |   9 SETMODE    0081AF R   |     SFR_BASE=  005000 
    SFR_END =  0057FF     |     SHARP   =  000023     |     SI      =  00000F 
    SO      =  00000E     |     SOH     =  000001     |     SPACE   =  000020 
    SPI_CR1 =  005200     |     SPI_CR1_=  000003     |     SPI_CR1_=  000000 
    SPI_CR1_=  000001     |     SPI_CR1_=  000007     |     SPI_CR1_=  000002 
    SPI_CR1_=  000006     |     SPI_CR2 =  005201     |     SPI_CR2_=  000007 
    SPI_CR2_=  000006     |     SPI_CR2_=  000005     |     SPI_CR2_=  000004 
    SPI_CR2_=  000002     |     SPI_CR2_=  000000     |     SPI_CR2_=  000001 
    SPI_CRCP=  005205     |     SPI_DR  =  005204     |     SPI_ICR =  005202 
    SPI_RXCR=  005206     |     SPI_SR  =  005203     |     SPI_SR_B=  000007 
    SPI_SR_C=  000004     |     SPI_SR_M=  000005     |     SPI_SR_O=  000006 
    SPI_SR_R=  000000     |     SPI_SR_T=  000001     |     SPI_SR_W=  000003 
    SPI_TXCR=  005207     |     STACK_SI=  000100 G   |     STOR    =  00003A 
  4 STORADR    000006 R   |     STX     =  000002     |     SUB     =  00001A 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 59.
Hexadecimal [24-Bits]

Symbol Table

    SWIM_CSR=  007F80     |   4 SW_RESET   000000 R   |     SYN     =  000016 
    TAB     =  000009     |     TIB_SIZE=  000080 G   |     TICK    =  000027 
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
    TIM2_CNT=  00530A     |     TIM2_CNT=  00530B     |     TIM2_CR1=  005300 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 60.
Hexadecimal [24-Bits]

Symbol Table

    TIM2_CR1=  000007     |     TIM2_CR1=  000000     |     TIM2_CR1=  000003 
    TIM2_CR1=  000001     |     TIM2_CR1=  000002     |     TIM2_EGR=  005304 
    TIM2_EGR=  000001     |     TIM2_EGR=  000002     |     TIM2_EGR=  000003 
    TIM2_EGR=  000006     |     TIM2_EGR=  000000     |     TIM2_IER=  005301 
    TIM2_PSC=  00530C     |     TIM2_SR1=  005302     |     TIM2_SR2=  005303 
    TIM3_ARR=  00532B     |     TIM3_ARR=  00532C     |     TIM3_CCE=  005327 
    TIM3_CCE=  000000     |     TIM3_CCE=  000001     |     TIM3_CCE=  000004 
    TIM3_CCE=  000005     |     TIM3_CCE=  000000     |     TIM3_CCE=  000001 
    TIM3_CCM=  005325     |     TIM3_CCM=  005326     |     TIM3_CCM=  000000 
    TIM3_CCM=  000004     |     TIM3_CCM=  000003     |     TIM3_CCR=  00532D 
    TIM3_CCR=  00532E     |     TIM3_CCR=  00532F     |     TIM3_CCR=  005330 
    TIM3_CNT=  005328     |     TIM3_CNT=  005329     |     TIM3_CR1=  005320 
    TIM3_CR1=  000007     |     TIM3_CR1=  000000     |     TIM3_CR1=  000003 
    TIM3_CR1=  000001     |     TIM3_CR1=  000002     |     TIM3_EGR=  005324 
    TIM3_IER=  005321     |     TIM3_PSC=  00532A     |     TIM3_SR1=  005322 
    TIM3_SR2=  005323     |     TIM4_ARR=  005346     |     TIM4_CNT=  005344 
    TIM4_CR1=  005340     |     TIM4_CR1=  000007     |     TIM4_CR1=  000000 
    TIM4_CR1=  000003     |     TIM4_CR1=  000001     |     TIM4_CR1=  000002 
    TIM4_EGR=  005343     |     TIM4_EGR=  000000     |     TIM4_IER=  005341 
    TIM4_IER=  000000     |     TIM4_PSC=  005345     |     TIM4_PSC=  000000 
    TIM4_PSC=  000007     |     TIM4_PSC=  000004     |     TIM4_PSC=  000001 
    TIM4_PSC=  000005     |     TIM4_PSC=  000002     |     TIM4_PSC=  000006 
    TIM4_PSC=  000003     |     TIM4_PSC=  000000     |     TIM4_PSC=  000001 
    TIM4_PSC=  000002     |     TIM4_SR =  005342     |     TIM4_SR_=  000000 
    TIM_CR1_=  000007     |     TIM_CR1_=  000000     |     TIM_CR1_=  000006 
    TIM_CR1_=  000005     |     TIM_CR1_=  000004     |     TIM_CR1_=  000003 
    TIM_CR1_=  000001     |     TIM_CR1_=  000002     |   9 TONEXTIT   00820C R
  9 TrapHand   008020 GR  |     UART    =  000000     |     UART1   =  000000 
    UART1_BA=  005230     |     UART1_BR=  005232     |     UART1_BR=  005233 
    UART1_CR=  005234     |     UART1_CR=  005235     |     UART1_CR=  005236 
    UART1_CR=  005237     |     UART1_CR=  005238     |     UART1_DR=  005231 
    UART1_GT=  005239     |     UART1_PO=  000000     |     UART1_PS=  00523A 
    UART1_RX=  000004     |     UART1_SR=  005230     |     UART1_TX=  000005 
    UART2   =  000001     |     UART3   =  000002     |     UART3_BA=  005240 
    UART3_BR=  005242     |     UART3_BR=  005243     |     UART3_CR=  005244 
    UART3_CR=  005245     |     UART3_CR=  005246     |     UART3_CR=  005247 
    UART3_CR=  004249     |     UART3_DR=  005241     |     UART3_PO=  00000F 
    UART3_RX=  000006     |     UART3_SR=  005240     |     UART3_TX=  000005 
    UART_BRR=  005232     |     UART_BRR=  005233     |     UART_CR1=  005234 
    UART_CR1=  000004     |     UART_CR1=  000002     |     UART_CR1=  000000 
    UART_CR1=  000001     |     UART_CR1=  000007     |     UART_CR1=  000006 
    UART_CR1=  000005     |     UART_CR1=  000003     |     UART_CR2=  005235 
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
    UART_DR =  005231     |     UART_PCK=  000002     |     UART_POR=  005003 
    UART_POR=  005004     |     UART_POR=  005002     |     UART_POR=  005001 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 61.
Hexadecimal [24-Bits]

Symbol Table

    UART_POR=  005000     |     UART_RX_=  000004     |     UART_SR =  005230 
    UART_SR_=  000001     |     UART_SR_=  000004     |     UART_SR_=  000002 
    UART_SR_=  000003     |     UART_SR_=  000000     |     UART_SR_=  000005 
    UART_SR_=  000006     |     UART_SR_=  000007     |     UART_TX_=  000005 
    UBC     =  004801     |   9 UPPER      00819B R   |     US      =  00001F 
    USR_BTN_=  000004     |     USR_BTN_=  000010     |     USR_BTN_=  005015 
    VSIZE   =  000005     |     VT      =  00000B     |     WDGOPT  =  004805 
    WDGOPT_I=  000002     |     WDGOPT_L=  000003     |     WDGOPT_W=  000000 
    WDGOPT_W=  000001     |   9 WOZMON     008163 GR  |     WWDG_CR =  0050D1 
    WWDG_WR =  0050D2     |     XAM     =  000000     |   4 XAMADR     000004 R
  9 XAMNEXT    008235 R   |   9 XAM_BLOC   008211 R   |     XAM_BLOK=  00002E 
    XOFF    =  000013     |     XON     =  000011     |   4 YSAV       00000A R
  5 Z1d        00000D R   |   5 acc        000013 R   |   5 auto.inc   000012 R
  5 auto.ln    000010 R   |   9 auto_cmd   0082F4 R   |   4 bool.fla   00000D R
  5 ch         00000E R   |   9 clr_cmd    0082E7 R   |   9 clr_scre   0080B5 GR
  5 code.end   000002 R   |   5 code.sta   000000 R   |   9 cold       00826B R
  9 crout      0082A4 R   |   4 cursor.h   00000E R   |   4 cursor.v   00000F R
  9 delback    0080C9 GR  |   5 for.nest   00000A R   |   9 get16bit   0082DE R
  9 getchar    008095 GR  |   9 getline    0080DD GR  |   5 gosub.ne   00000B R
  5 leadzr     00000F R   |   9 mem_init   008304 R   |   9 mon_str    008153 R
  9 new_cmd    0082DF R   |   9 p1b_str    008253 R   |   6 pad        000180 R
  5 pp         000006 R   |   9 prt_ln_n   0082AA R   |   9 putchar    008084 GR
  9 puts       008136 GR  |   5 pv         000008 R   |   9 querycha   0080AD GR
  5 rnd        000004 R   |   2 stack_fu   001800 R   |   2 stack_sp   001700 R
  9 sw_reset   00801C R   |   5 synpag     00000C R   |   9 syscall_   008072 R
  9 tabout     008140 GR  |   6 tib        000100 R   |   9 uart_ini   008073 R
  9 warm       00826E R

ASxxxx Assembler V02.00 + NoICE + SDCC mods  (STMicroelectronics STM8), page 62.
Hexadecimal [24-Bits]

Area Table

   0 _CODE      size      0   flags    0
   1 SSEG       size      0   flags    8
   2 SSEG0      size    100   flags    8
   3 DATA       size      0   flags    8
   4 DATA1      size     10   flags    8
   5 BASIC      size     15   flags    8
   6 DATA2      size    100   flags    8
   7 HOME       size      8   flags    0
   8 CODE       size      0   flags    8
   9 CODE3      size    309   flags    8

