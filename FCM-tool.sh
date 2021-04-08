#!/bin/env bash

function validateFolder(){
    
    folder=$1
    
    cd $folder &> /dev/null

    # Don't write nothing here, next line take te return of the cd command

    if [ $? -ne 0 ]
    then

        echo -e "    invalid folder ($folder), you want to:\n\n\t1) Create a new folder\n\t2) Retype the folder name\n\t0) Exit"
        
        read option

        case $option in
            

            0) # Close

                exit 0
            
            ;;

            1) # Create Folder
            
                folder=`echo $folder | tr -s ' ' '-'`;
                mkdir $folder;
                clear;
                validateFolder $folder
            
            ;;

            2) # Retype
            
                clear;
                read -p "    Enter a folder name: " folder;
                validateFolder $folder
            
            ;;

            *) # Try again
            
                clear ;
                read -sp "    Invalid value, type ENTER and try again: " enterKey
            
            ;;

        esac
    
    fi

    # makes the variable get its real value (In the case of use ./ or ../ )
    if [[ $mainFolder != $folder && $2 == 'main' ]]
    then
        
        $mainFolder=`echo $(pwd)`

    # Back to the main directory
    elif [[ $2 != 'main' ]]
    then
        
        cd $mainFolder

    fi  

}

clear

# Filters the arguments

# - - If None -> Type it
if [ $# -eq 0 ]; then
    read -p "    In which folder do you want to run the program? " mainFolder

# - - If One -> It's okay!
elif [ $# -eq 1 ]; then
    mainFolder=$1

# -- Many -> Retype or Cancel
elif [ $# -gt 1 ]; then

    until

        clear

        echo -en "    You typed a lot of arguments, do you want retype it?(Y/N) "
        read option

        case $option in
            
            'Y'|'y') # Retype
                clear; read -p "    Enter an argument: " mainFolder
            ;;

            'N'|'n') # Close
                exit 0
            ;;

            *) # Try again
                clear; read -sp "    Invalid value, type ENTER and try again: " enterKey
            ;;

        esac
        
    [[ $option = 'Y' || $option = 'y' ]]
    do true ; done

fi

clear

# Choose Remove space
[[ `echo $mainFolder | grep -c " "` -ne 0 ]] && \

    while
    
        read -p "    The path to the folder has space, do you want enter a path without space to avoid errors(Y/N): " option

        if [[ $option = 'Y' || $option = 'y' ]]
        then

            clear
            read -p "    Enter a path to the main folder: " $mainFolder

        elif [[ $option != 'N' && $option != 'n' ]] 
        then
            
            clear ;
            read -sp "    Invalid value, type ENTER and try again: " enterKey

        fi

        clear

    [[ $option != 'Y' && $option != 'y' && $option != 'N' && $option != 'n' ]]
do true ; done

validateFolder $mainFolder main #Function that calls itself while the value is invalid

until

    clear

    echo -e "    How do you want to create the file?\n\n\t1) In a single folder\n\t2) In multiple folder\n"

    read option

    case $option in
        
        0) # Close
            exit 0
        ;;
        
        1) # Single folder

            clear
            # file parts

        ;;

        2) # Multiple folders
        
            until

                clear
                
                echo -e "    In which directories do you want to create the files? \n\n\t1) In all directories in the main folder.\n\t2) Enter the name of the folders.\n\t0) Back.\n"
            
                read option

                case $option in

                    0) # Empty just to don't show error message i the * case (Back)
                    ;;

                    1) # All

                        clear
                
                        read -ra folderList -d '' <<<`ls -I '*.*' -I '* *'`
                        
                        if [ `echo ${#folderList[*]}` -eq 0 ]; then
                            echo -n "    Empty folder."
                        
                        else
                            echo -e "    You will create your files in the folder(s): `echo ${folderList[*]} | tr -s ' ' ', '`\n"

                            # Validate all dirs
                            for a in ${folderList[@]}; do
                                validateFolder $a
                            done

                            until
                        
                                echo -e "    Do you want to:\n\n\t1) Create and add a new folder to list\n\t2) Remove folder\n\t3) Continue"

                                read option

                                case $option in
                                    
                                    1) # Crate and Add to list

                                        clear

                                        read -p "    Enter the name of the new folder: " newFolder
                                        folderList[`echo ${#folderList[*]}`]=`echo $newFolder | tr -s ' ' '-'`
                                        
                                        mkdir ${folderList[`echo $(expr ${#folderList[*]} - 1)`]}
                                        
                                        validateFolder ${folderList[`echo $(expr ${#folderList[*]} - 1)`]}

                                    ;;
                                    
                                    2) # Remove folder

                                        clear
                                        echo -e "    The folder list is:\n"
                                        
                                        i=0
                                        for a in ${folderList[@]}
                                        do

                                           let i++ 
                                            echo -e "\t$i) $a"

                                        done
                                        
                                        echo -e "\n"

                                        until

                                            read -p "    Enter the name of the folder to be removed from the list: " folderPosition
                                            
                                            [[ $folderPosition -lt 1 || $folderPosition -gt ${#folderList[*]} ]] && \
                                            echo -e "    Type the value in the range.\n"
                                        
                                        [[ $folderPosition -gt 0 && $folderPosition -lt ${#folderList[*]} ]]
                                        do true ; done

                                        let folderPosition--
                                        unset folderList[folderPosition]

                                    ;;
                                    
                                    3) # Empty to continue without error message

                                        clear


                                    ;;

                                    *) echo default
                                    ;;
                                esac
                                
                                echo -e "\n    Folder(s): `echo ${folderList[*]} | tr -s ' ' ', '`\n"

                                read -sp "    Type ENTER to continue. . ." enterKey
                                clear

                            [[ $option -eq 3 ]]
                            do true; done

                        fi

                    ;;
                    
                    2) # Type name

                        

                    ;;

                    *) 

                        clear ;
                        read -sp "    Invalid value, type ENTER and try again: " enterKey

                    ;;

                esac
                
            [[ $option -ge 1 && $option -le 2 ]]
            do true ; done

        ;;

        *) # Try again
        
            clear ;
            read -sp "    Invalid value, type ENTER and try again: " enterKey
        
        ;;

    esac

[[ $option -ge 1 && $option -le 2 ]]
    do true ; done



