#!/bin/env bash

# Set the path to Program file folders (Use to call others files of the program)
cd `echo $0 | rev | cut -c13- | rev`
path=`echo $(pwd)`
 # NOTE | Define Path : if use ../FCM-tool to call the program ($0=..FCM-tool), use cd $0 and path=pwd work, but path=$pwd/$0 no, because it's equal ~/dir/../FCM-tool, the is invalide because no exist FCM-tool in ~

 # TEST path 
  # $HOME or $OLDPWD
  # ~ 
  # ./ or ../

cd $OLDPWD

clear

source $path/setMainFolder.sh $1

clear

until

    clear

    echo -e "    How do you want to create the file?\n\n\t\033[1;32m1)\033[0m In a single folder\n\t\033[1;32m2)\033[0m In multiple folder\n\t\033[1;31m0)\033[0m Exit\n"

    read option

    case $option in
        
        # Close
        0)
            exit 0
        ;;
        
        # Single folder
        1)

            clear
            createFiles

        ;;

        # Multiple folders
        2) 
        
            until

                clear
                
                echo -e "    In which directories do you want to create the files? \n\n\t\033[1;32m1)\033[0m In all directories in the main folder.\n\t\033[1;32m2)\033[0m Enter the name of the folders.\n\t\033[1;31m0)\033[0m Back.\n"
            
                read option

                case $option in

                    # Empty just to don't show error message i the * case (Back)
                    0)
                    ;;

                     # All
                    1)

                         # NOTE | read all folders: use <<< for the read command to read the return from ls, except for files with a dot in their middle (delete files) and space (avoid errors) and place them inside the folderList in the array format (-a) and delimit folders by the presence of space (-d '') 
                        clear; read -ra folderList -d '' <<<`ls -I '*.*' -I '* *'`
                        
                        if [ `echo ${#folderList[*]}` -eq 0 ]; then
                            read -sn1 -p "    Empty folder, type something and try again. . . " enterKey
                            option=0
                        
                        else
                            # NOTE | Echo FolderList and Text : Echoes the formatted text (-e) on the screen, also showing the return of the code that shows the list of folders in the folderList, exchanging space for comma. (It causes the return of the function that shows the list and not the direct list, as this part is accompanied by the tr -s, which changes the space ('') with a comma (','), which if it were together would exchange the space for comma of entire text
                            echo -e "    You will create your files in the folder(s): `echo ${folderList[*]} | tr -s ' ' ', '`\n"

                            clear

                            source $path/functions.sh validateFolderList

                            clear

                            source $path/functions.sh editFolderList

                        fi

                    ;;
                    
                    # Type name
                    2) 

                        clear; echo -en "    Enter the name of the folders \033[1;37m(different folders separated by space)\033[0m: "; read -ra folderList

                        echo -e "\n    You will create your files in the folder(s): \033[1;33m`echo ${folderList[*]} | tr -s ' ' ', '`\033[0m\n"
                        
                        read -sn1 -p "    Type something and try again. . . " enterKey
                        clear

                        source $path/functions.sh validateFolderList

                        clear

                        source $path/functions.sh editFolderList

                    ;;

                    *) 
                        clear; read -sn1 -p "    Invalid value, type something and try again. . . " enterKey
                    ;;

                esac
                
            [[ $option -ge 0 && $option -le 2 ]]
            do false ; done

        ;;

        # Try again
        *) 
            clear; read -sn1 -p "    Invalid value, type something and try again. . . " enterKey
        ;;

    esac

[[ $option -ge 1 && $option -le 2 ]]
do false ; done

# TEST type 1
 # -1 and 7 -> Error message
 # o ->  Exit
 # 1 ->  Continue ( file )
 # 2 ->  Continue ( single or all )
# TEST type 2 ( single or all )
 # 0 -> Back ( Lose list )
 # 1 -> Empty -> Error message | continue ( Edit List )
 # 2 -> Empty -> ( Continue, but show Error message if don't include a folder to list ) | sdfghghj -> error message ( validate folder )
