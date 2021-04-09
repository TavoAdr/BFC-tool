#!/bin/env bash

function validateFolder(){
    
    folder=$1
   
    if [[ ! -d $folder ]]; then

        echo -e "    invalid folder ($folder), you want to:\n\n\t1) Create a new folder\n\t2) Retype the folder name\n\t0) Exit"
        
        read option

        case $option in

            # Close
            0)
                exit 0
            ;;

            1) # Create Folder
            
                folder=`echo $folder | tr -s ' ' '-'`
                mkdir $folder; clear
                validateFolder $folder
            
            ;;

            2) # Retype
            
                clear; read -p "    Enter a folder name: " folder
                validateFolder $folder
            
            ;;

            *) # Try again
            
                clear
                read -sp "    Invalid value, type ENTER and try again: " enterKey
            
            ;;

        esac
    
    fi

    # makes the variable get its real value (In the case of use ./ or ../ )
    if [[ $mainFolder != $folder && $2 == 'main' ]]; then
        $mainFolder=`echo $(pwd)`
    fi

}

function validateFolderList(){

    for a in ${folderList[@]}; do
        validateFolder $a
    done

}

function editFolderList(){
    
    until

        echo -e "    Do you want to:\n\n\t1) Create and add a new folder to list\n\t2) Remove folder\n\t3) Continue\n\t0) Back\n"

        read option

        case $option in
            
            0) # Empty to continue without error message
                clear;
            ;;
            
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
                for a in ${folderList[@]}; do
                    let i++; echo -e "\t$i) $a"
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

            # Continue
            3)
                # TODO (Arquivo) Add the file function
                    
            ;;
            
            *) 
                clear; read -sp "    Invalid value, type ENTER and try again: " enterKey
            ;;
        esac
        
        echo -e "\n    Folder(s): `echo ${folderList[*]} | tr -s ' ' ', '`\n"

        read -sp "    Type ENTER to continue. . ." enterKey
        clear

    [[ $option -eq 0 ]]
    do true; done
    
}

# $1 $2