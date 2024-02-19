#!/bin/bash 

# usage:
# ./build.sh  [ flash_hsi|flash_hse ]
# flash_hsi -> flash 16Mhz internal oscillator version after build
# flash_hse -> flash external 24Mhz crystal version after build
# no option -> build both versions without flashing 

if [ ! -d "build/stm8s207k8" ] 
then 
    mkdir "build/stm8s207k8"
fi 

if [ -z $1 ]; then 
# build HSI 16Mhz version 
sed -i 's/HSI=0/HSI=1/' config.inc 
make -B hsi16m

# build HSE 24Mhz version 
sed -i 's/HSI=1/HSI=0/' config.inc
make -B hse24m
fi 

if [  ! -z $1 ]; then 
    if [ $1 == "flash_hsi" ]; then 
            make flash_hsi16m 
    elif [ $1 == "flash_hse" ]; then
            make flash_hse24m  
    fi
fi 

