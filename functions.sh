#!/bin/env bash

function validateFolder(){
    
    folder=$1

    until

        clear

        if [[ ! -d $folder ]]; then

            echo -e "    Invalid folder (\033[1;33m$folder\033[0m), you want to:\n\n\t\033[1;32m1)\033[0m Create a new folder\n\t\033[1;32m2)\033[0m Retype the folder name\n\t\033[1;31m0)\033[0m Exit"
            
            read option

            case $option in

                # Close
                0)
                    exit 0
                ;;

                1) # Create Folder

                    folder=`echo $folder | tr -s ' ' '-'` # change space to hyphen
                    mkdir $folder; clear
                    validateFolder $folder
                
                ;;

                2) # Retype
                
                    clear; read -p "    Enter a folder name: " folder
                    validateFolder $folder
                
                ;;

                *) # Try again
                    clear; read -sn1 -p "    Empty folder, type something and try again. . . " enterKey
                ;;

            esac
        
        fi

    [[ $option -ge 0 && $option -le 2 ]]
    do false; done

}
# TEST create folder (1)
# normal -> create
# with space -> change space to hyphen
# TEST retype (2)
# valid -> retest
# invalid -> choose again what to do

function validateFolderList(){

    for a in ${folderList[@]}; do
        validateFolder $a
    done

}

function editFolderList(){
    
    removed=0 # counts the number of values removed from the list
    
    until

        echo -e "    Do you want to:\n\n\t\033[1;32m1)\033[0m Create and add a new folder to list\n\t\033[1;32m2)\033[0m Remove folder\n\t\033[1;32m3)\033[0m Continue\n\t\033[1;31m0)\033[0m Back\n"

        read option

        case $option in
            
            # Empty to continue without error message
            0)
                clear;
            ;;
            
            # Crate and Add to list
            1)

                clear

                read -p "    Enter the name of the new folder: " newFolder
                # NOTE | add val to list: it's adds a value (value of the var newFolder with hyphen to replace space) to the last position in the list of folders (position of return of the function to show the size of the list of folders)
                folderList[`echo ${#folderList[*]}`]=`echo $newFolder | tr -s ' ' '-'`
                
                # NOTE | mk fold. : This creates a folder called the value in the return position of the command that shows the return of the account that calculate the size of the list minus one
                mkdir ${folderList[`echo $(expr ${#folderList[*]} - 1)`]}
                
                validateFolder ${folderList[`echo $(expr ${#folderList[*]} - 1)`]}

            ;;

            
            # Remove folder
            2) 

                clear

                if [[ -z ${folderList[*]} ]]; then
                    read -sn1 -p "    You can't remove folders of the list because the folder list is empty, type something and try again. . . " enterKey

                else

                    echo -e "    The folder list is:\n"
                    
                    cont=0
                    for a in ${folderList[@]}; do
                        let cont++; echo -e "\t\033[1;32m$cont)\033[0m $a"
                    done
                    
                    echo -e "\n"

                    until

                        read -p "    Enter the number of the folder to be removed from the list: " folderPosition
                        
                        [[ $folderPosition -le 0 || $folderPosition -gt ${#folderList[*]} ]] && \
                            echo -e "    Type the value in the range.\n"
                    
                    [[ $folderPosition -ge 1 && $folderPosition -le ${#folderList[*]} ]]
                    do true ; done

                    position=0 # count the number of positions in the list
                    element=0 # count the number of positions not empty in the list
                    fullList=`expr ${#folderList[*]} + $removed ` # List size if full
                    
                    while [[ $position -lt fullList && $elemento -ne $folderPosition ]]; do

                        # Count the number of positions not empty
                        [[ -n ${folderList[$position]} ]] && \
                            let element++
                        
                        # Remove the element from the list if it is in the position I am looking for
                        [[ $element -eq $folderPosition ]] && \
                            unset folderList[$position]

                        let position++

                    done

                    let removed++

                fi

            ;;

             
            # Continue
            3)
                clear
                if [[ -z ${folderList[*]} ]]; then
                    read -sn1 -p "    You can't continue because there are no folders in the list, type something and try again. . . " enterKey
                else
                    
                    createSubFolder

                    clear

                    createFiles m
                fi
                    
            ;;

            *) 
                clear; read -sn1 -p "    Invalid value, type something and try again. . . " enterKey
            ;;
        esac

        [[ ! -z ${folderList[*]} ]] && \
            echo -e "\n    Folder(s): \033[1;33m`echo ${folderList[*]} | tr -s ' ' ', '`\033[0m" && \
            read -sn1 -p "    Type something and try again. . . " enterKey
        
        clear

    [[ $option -eq 0 ]]
    do false; done
    
}
             # TEST mk n ad to list (1)
              # sem espaço -> just create
              # com espaço -> add hyphen
             # TEST remove (2)
              # invalid position -> error message
              # 1 position -> remove
              # all elements -> empty list
             # TEST continue (3)
              # continue if empty list -> error message

function createSubFolder(){

    while

        echo -en "    Do you want to create subfolders?(\033[1;32mY\033[0m/\033[1;31mN\033[0m): "
        read option
        option=${option,,}

        if [[ $option = 'y' ]]; then
            clear; read -p "    Enter the name to the subfolder: " newFolder
            subFolder=`echo $newFolder/ | tr -s ' ' '-'`

            for a in ${folderList[@]}; do
                mkdir -p $a/$subFolder
                validateFolder $a/$subFolder
            done

        elif [[ $option != 'n' ]]; then
            clear; read -sn1 -p "    Invalid value, type something and try again. . . " enterKey
        fi

        clear

    [[ $option != 'y' && $option != 'n' ]]
    do true ; done

}
 # TEST subFolder (*)
 # Error message
 # TEST subFolder (n)
  # Continue (file)
 # TEST subFolder (y)
  # type with space -> replace the space to hyphen
  # ENTER -> validate folder

function createFiles(){

    unset option

    until

        clear

        if [[ $1 == m ]]; then
            echo -e "    What method do you want to use to create the files?\n\n\t\033[1;32m1)\033[0m Organize files in folders according to their extension \033[1;37m(Files with extension x in folder y)\033[0m.\n\t\033[1;32m2)\033[0m All files, with all extensions in all folders.\n"
            read option
        fi

        clear; echo -en "    Enter the name of the files \033[1;37m(different files separated by space)\033[0m: "; read -ra fileList
        
        clear; echo -en "    Enter the name of the extensions \033[1;37m(different extensions separated by space and without dot)\033[0m: "; read -ra extensionList

        
        clear; echo -e "    You intend to create the \033[1;33m`echo ${fileList[@]} | tr -s ' ' ','`\033[0m files of extension \033[1;33m`echo ${extensionList[@]} | tr -s ' ' ','`\033[0m.\n"

        if [[ -n $option ]]; then
            fileNumber=$(( ${#folderList[@]} * ${#fileList[@]} * ${#extensionList[@]} ))
        else
            fileNumber=$(( ${#fileList[@]} * ${#extensionList[@]} ))
        fi
        contFiles=0

        read -sn1 -p "    Empty folder, type something and try again. . . " enterKey; clear

        case $option in

            # 1 - 1
            1)

                if [[ ${#folderList[@]} -eq ${#extensionList[@]} ]]; then
                    
                    for(( i=0; i<${#extensionList[@]}; i++ ));
                    do                        
                      
                        clear; echo -en "    Enter text to be added to all files of extension \033[1;33m${extensionList[$i]}\033[1;37m(use '\033[1;36mENTER\033[1;37m' to create empty file)\033[0m: "; read fileText

                        for fil in ${fileList[@]}
                        do
                            
                            echo $fileText > `echo ${folderList[$i]}`/`echo $subFolder``echo $fil | tr -d '.'`.`echo ${extensionList[$i]}  | tr -d '.'`

                            [[ $? -eq 0 ]] && \
                                let contFiles++;
                    
                        done

                    done
                        
                else
                    clear; echo -en "    When using this method, the number of files must equal the number of extensions, "; read -sn1 -p "type something and try again. . . " enterKey
                    option=127
                fi

            ;;
            
            # all - all
            2)

                for ext in ${extensionList[@]}
                do

                    clear; echo -en "    Enter text to be added to all files of extension \033[1;33m$ext\033[1;37m(use '\033[1;36mENTER\033[1;37m' to create empty file)\033[0m: "; read fileText
                        
                    for fold in ${folderList[@]}
                    do

                        for fil in ${fileList[@]}
                        do
                            
                            echo $fileText >> `echo $fold`/`echo $subFolder``echo $fil | tr -d '.'`.`echo $ext  | tr -d '.'`

                            [[ $? -eq 0 ]] && \
                                let contFiles++;
                    
                        done
                        
                    done
                
                done
                
            ;;

            # simple
            '')

                for ext in ${extensionList[@]}
                do
                    
                    clear; echo -en "    Enter text to be added to all files of extension \033[1;33m$ext\033[1;37m(use '\033[1;36mENTER\033[1;37m' to create empty file)\033[0m: "; read fileText

                    for fil in ${fileList[@]}
                    do
                        
                        echo $fileText > `echo $fil | tr -d '.'`.`echo $ext  | tr -d '.'`

                        [[ $? -eq 0 ]] && \
                            let contFiles++;
                   
                    done
                    
                done
                

            ;;
            
            # try again
            *) 
                clear; read -sn1 -p "    Invalid value, type '\033[1;36mENTER\033[0m' and try again: " enterKey
            ;;

        esac

    [[ $option -ge 1 && $option -le 2 || -z $option ]]
    do false ; done

    clear; read -sn1 -p "    $contFiles of $fileNumber files created successfully, type something and try again. . . " enterKey
    exit 0

}
 # TEST enter var
  # File and Extensions with dot -> create file without dot
  # File and Extensions without dot -> create file without dot
 # TEST method
  # 1
   # ne sizes of vars -> show error message
   # eq sizes of vars -> continue
  # 2
  # ''

$1 $2 # Call the function and one argument