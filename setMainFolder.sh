#!/bin/env bash

source $path/functions.sh

# - - If None -> Type it
if [ $# -eq 0 ]; then
    read -p "    In which folder do you want to run the program? " mainFolder

# - - If One -> It's okay!
elif [ $# -ge 1 ]; then
    mainFolder=$1
fi

# Choose Remove space
[[ `echo $mainFolder | grep -c " "` -ne 0 ]] && \

    while
    
        read -p "    The path to the folder has space, do you want enter a path without space to avoid errors(Y/N): " option

        if [[ $option = 'Y' || $option = 'y' ]]; then
            clear; read -p "    Enter a path to the main folder: " $mainFolder

        elif [[ $option != 'N' && $option != 'n' ]]; then
            clear; read -sp "    Invalid value, type ENTER and try again: " enterKey
        fi

        clear

    [[ $option != 'Y' && $option != 'y' && $option != 'N' && $option != 'n' ]]
    do true ; done

validateFolder $mainFolder main

cd $mainFolder