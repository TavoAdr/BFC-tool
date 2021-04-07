#!/bin/bash

clear

# Filters the arguments

# - - If None -> Type it
if [ $# -eq 0 ]
then
    read -p "    In which folder do you want to run the program? " mainFolder

# - - If One -> It's okay!
elif [ $# -eq 1 ]
then
    mainFolder=$1

# -- Many -> Retype or Cancel
elif [ $# -gt 1 ]
then

    until

        clear

        echo -en "    You typed a lot of arguments, do you want retype it?(Y/N) "
        read option

        case $option in
            
            'Y'|'y') # Retype
            
                clear
                read -p "    Enter an argument: " mainFolder
            
            ;;

            'N'|'n') # Close
            
                clear;
                echo "Finishing . . ." ;
                exit 0
            
            ;;

            *) # Try again
            
                clear ;
                read -sp "    Invalid value, type ENTER and try again: " enterKey
            
            ;;

        esac
        
    [[ option -ge 0 && option -le 2 ]]
    do true ; done

fi

clear

# validate folder
cd $mainFolder #&> /dev/null

# Don't write nothing here, next line take te return of the cd command

[[ $? -ne 0 ]] && read -p "    Invalid folder, insert another: " mainFolder