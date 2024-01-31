#!/bin/bash 

# usage:
# ./build.sh board  [flash]
# board is s207 or s208 
# flash after build 

if [ $1 == "s208" ]; then
    if [ ! -d "build/stm8s208rb" ] 
    then 
        mkdir "build/stm8s208rb"
    fi 
    make -fnucleo_8s208.mk 
    if [[ ! -z $2 && ($2 == "flash") ]]; then 
        make -fnucleo_8s208.mk && make -fnucleo_8s208.mk flash 
    else 
        make -fnucleo_8s208.mk
    fi 
elif [ $1 == "s207" ]; then 
    if [ ! -d "build/stm8s207k8" ] 
    then 
        mkdir "build/stm8s207k8"
    fi 
    if [[ ! -z $2 && ($2 == "flash") ]]; then 
        make -fnucleo_8s207.mk && make -fnucleo_8s207.mk flash 
    else 
        make -fnucleo_8s207.mk
    fi 
fi


