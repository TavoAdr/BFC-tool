#!/bin/env bash

source $path/functions.sh

# - - If None -> Type it
if [ $# -eq 0 ]; then
    read -p "    In which folder do you want to run the program? " mainFolder

# - - If One -> It's okay!
elif [ $# -ge 1 ]; then
    mainFolder=$1
fi

clear

# Choose Remove space
[[ `echo $mainFolder | grep -c " "` -ne 0 ]] && \

    while
    
        echo -en "    The path to the folder has space, do you want enter a path without space to avoid errors?(\033[1;32mY\033[0m/\033[1;31mN\033[0m): "
        read option
        option=${option,,}

        if [[ $option = 'y' || $option -eq 1 ]]; then
            clear; read -p "    Enter a path to the main folder: " mainFolder

        elif [[ $option != 'n' && $option -ne 0 ]]; then
            clear; echo -en "    Invalid value, type '\033[1;36mENTER\033[0m' and try again: "; read -s enterKey
        fi

        clear

    [[ $option != 'y' && $option != 'n' && $option -ne 1 && $option -ne 0 ]]
    do true ; done

validateFolder $mainFolder main

cd $mainFolder

 # TEST $#=0 (0 folder)
  # válido -> continue 
  # inválido -> retype | create
  # espaço -> choose remove space
 # TEST $#=1 (1 folder)
  # válido -> continue 
  # inválido -> retype | create
  # espaço -> take just the first