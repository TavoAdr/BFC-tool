#!/bin/env bash

# - - - - Define Variable
 # global    ->  NAMEVAR
 # local     ->  _name_var
 # program   ->  name_var
 # function  ->  nameFunction

# - - Text Style
txt_none="\033[m"           # Normal Text
txt_red="\033[1;31m"        # Options like Cancel/Back
txt_green="\033[1;32m"      # Normal Options
txt_yellow="\033[1;33m"     # Lists of folders, files and extensions
txt_blue="\033[1;36m"       # Keys
txt_bold="\033[1;37m"          # Notes to user

# - - Program Path
cd ${0/${0/*\//}/}
file_path=$(pwd)
cd ${OLDPWD}

# - - Read File that Calls the Functions
call_func="source ${file_path}/functions.sh"

# - - Define Main Folder
${call_func} setMainFolder ${*//'\ '/' '}

# - - - - Menu
until

    clear

    # - - Main
    ${call_func} showMenu "\n \t \b /----------\ \n\t\b <| FCM-tool |> \n \t \b \----------/\n\n\t\b\b\b\bWhat do you want to do?:-:0Start file creation.:-:1See control manual.:-:2Change main folder.:-:3Exit.04"

    case ${option} in
            
        # Close
        0)
            exit 0
        ;;

        # Create file
        1)
                        
            until

                # - - How many folders
                ${call_func} showMenu "How do you want to create the file?:-:0In a single folder.:-:1In multiple folder.:-:2Back.03"

                case ${option} in
                    
                    # Back
                    0)
                        break
                    ;;
                    
                    # Single folder
                    1)
                        createFiles
                    ;;

                    # Multiple folders
                    2) 
                    
                        until

                            ${call_func} showMenu "In which directories do you want to create the files?:-:0In all directories in the main folder.:-:1Enter the name of the folders.:-:2Back.03"

                            case ${option} in

                                # Back
                                0)
                                    break
                                ;;

                                # All
                                1)

                                    clear
                                    
                                    read -ra folderList -d '' <<<`ls -d * 2> /dev/null`
                                    
                                    if [ ${#folderList[*]} -eq 0 ]; then
                                        
                                        ${call_func} pause 0
                                        
                                        option=0
                                    
                                    else
                                    
                                        echo -e "    You will create your files in the folder(s): ${txt_yellow}${folderList[*]}${txt_none}\n"

                                        ${call_func} pause

                                        clear

                                        ${call_func} validateFolderList

                                        clear

                                        ${call_func} editFolderList

                                    fi

                                ;;
                                
                                # Type name
                                2) 

                                    while [[ -z $folderList ]]; do
                                    
                                        clear
                                        
                                        echo -en "    Enter the name of the folders ${txt_bold}(different folders separated by space)${txt_none}: "
                                        
                                        read -ra folderList

                                        [[ -z $folderList ]] && \
                                            clear && \
                                            pause "You can't use the option to create files in multiple folder without providing the folder name"

                                    done

                                    clear

                                    echo -e "    You will create your files in the folder(s): ${txt_yellow}${folderList[*]}${txt_none}\n"
                                    
                                    ${call_func} pause

                                    clear

                                    ${call_func} validateFolderList

                                    clear

                                    ${call_func} editFolderList

                                ;;

                                *) 
                                    ${call_func} pause -1
                                ;;

                            esac
                            
                        [[ ${option} -ge 1 && ${option} -le 2 ]]
                        do false ; done

                    ;;

                    # Try again
                    *) 
                        ${call_func} pause -1
                    ;;

                esac

            [[ ${option} -ge 1 && ${option} -le 2 ]]
            do true ; done

        ;;

        # Help
        2)
            
            clear

            echo -e "\n FCM-tool.sh [-d DIR] [-sing/-mult] [-f FILES] [-e EXTENSIONS]\n\n    Description:\n\n\tBasic commands for creating multiple files at once.\n\n    Options:\n\n\b\t-d DIRECTORY\tDefines the main folder where the files\n\t\t\twill be created, in case a single folder\n\t\t\tor other folders will be located, if you\n\t\t\tchoose multiple folders.\n\n\t-sing\t\tCreate files in the main folder.\n\n\t-mult\t\tCreate files in some folder within the\n\t\t\tmain folder. It also allows you to add\n\t\t\tother options like -af to all folders in\n\t\t\tthe main folder and even -t to type the\n\t\t\tname of the folders (-tc creates folders\n\t\t\tif they don't exist), and you can even\n\t\t\tuse -af combined with -t or -tc and -sub\n\t\t\tSUBFOLDER to define the name of the\n\t\t\tsubfolder.\n\n\t-f FILE\t\tDefines the name of the files.\n\n\t-e EXTENSIONS\tDefines file extensions.\n\n\tType Q to quit.\n" | less 

        ;;

        # change main folder
        3) 
            ${call_func} setMainFolder
        ;;

        # Try again
        *) 
            ${call_func} pause -1
        ;;


    esac

[[ ${option} -eq 1 ]]
do false ; done

 # TEST path 
  # $HOME or $OLDPWD
  # ~ 
  # ./ or ../
# TEST type 1
 # -1 and 7 -> Error message
 # o ->  Exit
 # 1 ->  Continue ( file )
 # 2 ->  Continue ( single or all )
# TEST type 2 ( single or all )
 # 0 -> Back ( Lose list )
 # 1 -> Empty -> Error message | continue ( Edit List )
 # 2 -> Empty -> ( Continue, but show Error message if don't include a folder to list ) | sdfghghj -> error message ( validate folder )
