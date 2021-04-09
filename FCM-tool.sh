#!/bin/env bash

# Program file folders
path=`echo $(pwd)/$0 | rev | cut -c13- | rev`

# Program file 
source $path/functions.sh
source $path/setMainFolder.sh $1

clear

until

    clear

    echo -e "    How do you want to create the file?\n\n\t1) In a single folder\n\t2) In multiple folder\n"

    read option

    case $option in
        
        # Close
        0)
            exit 0
        ;;
        
        # Single folder
        1)

            clear
            # TODO (Arquivo) Add the file function

        ;;

        # Multiple folders
        2) 
        
            until

                clear
                
                echo -e "    In which directories do you want to create the files? \n\n\t1) In all directories in the main folder.\n\t2) Enter the name of the folders.\n\t0) Back.\n"
            
                read option

                case $option in

                    # Empty just to don't show error message i the * case (Back)
                    0)
                    ;;

                     # All
                    1)

                        clear; read -ra folderList -d '' <<<`ls -I '*.*' -I '* *'`
                        
                        if [ `echo ${#folderList[*]}` -eq 0 ]; then
                            echo -n "    Empty folder."
                        
                        else
                            echo -e "    You will create your files in the folder(s): `echo ${folderList[*]} | tr -s ' ' ', '`\n"

                            validateFolderList

                            editFolderList

                        fi

                    ;;
                    
                    # Type name
                    2) 

                        clear; read -p "    Enter the name of the folders (different folders separated by space): " -ra folderList

                        echo -e "    You will create your files in the folder(s): `echo ${folderList[*]} | tr -s ' ' ', '`\n"
                        
                        validateFolderList

                        editFolderList

                    ;;

                    *) 

                        clear ;
                        read -sp "    Invalid value, type ENTER and try again: " enterKey

                    ;;

                esac
                
            [[ $option -ge 0 && $option -le 2 ]]
            do true ; done

        ;;

        # Try again
        *) 
            clear; read -sp "    Invalid value, type ENTER and try again: " enterKey
        ;;

    esac

[[ $option -ge 1 && $option -le 2 ]]
    do true ; done

# TODO usar funções para automatizar tudo 

