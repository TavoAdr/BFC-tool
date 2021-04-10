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
            createFiles

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

                         # NOTE | read all folders: use <<< for the read command to read the return from ls, except for files with a dot in their middle (delete files) and space (avoid errors) and place them inside the folderList in the array format (-a) and delimit folders by the presence of space (-d '') 
                        clear; read -ra folderList -d '' <<<`ls -I '*.*' -I '* *'`
                        
                        if [ `echo ${#folderList[*]}` -eq 0 ]; then
                            echo -n "    Empty folder"
                            read -sp ", type ENTER and try again: " enterKey
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

                        clear; read -p "    Enter the name of the folders (different folders separated by space): " -ra folderList

                        echo -e "    You will create your files in the folder(s): `echo ${folderList[*]} | tr -s ' ' ', '`\n"
                        
                        clear

                        source $path/functions.sh validateFolderList

                        clear

                        source $path/functions.sh editFolderList

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
