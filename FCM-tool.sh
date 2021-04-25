#!/bin/env bash

clear

# - - Program Path
cd $(dirname "$0")
file_path=$(pwd)
cd ${OLDPWD}

echo $file_path
sleep

# - - Read File thats create the main variables of the files
source ${file_path}/variables.sh "${@//'\ '/' '}"

# - - - - Menu
until

    clear

    # - - Main
    [[ ${#} -le 2 ]] && \
        ${call_func} showMenu " \t \b /----------\ \n\t\b <| FCM-tool |> \n \t \b \----------/\n\n\t\b\b\b\bWhat do you want to do?:-:0Start file creation.:-:1See control manual.:-:2Change main folder.\n\t<| ${main_folder} |>:-:3Exit.04" || \
        option=1

    case ${option} in
            
        # Close
        0)
            exit 0
        ;;

        # Create file
        1)
                        
            until

                # - - How many folders
                [[ -z ${folder_structures} ]] && \
                    ${call_func} showMenu "How do you want to create the file?:-:0In a single folder.:-:1In multiple folder.:-:2Back.03" || \
                    option=${folder_structures}

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
                                        
                                        ${call_func} pause -beg 0 -end 1
                                        
                                        option=0
                                    
                                    else
                                    
                                        echo -e "\n    You will create your files in the folder(s): ${txt_yellow}${folderList[*]}${txt_none}\n"

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
                                        
                                        echo -en "\n    Enter the name of the folders ${txt_bold}(different folders separated by space)${txt_none}: "
                                        
                                        read -ra folderList

                                        [[ -z $folderList ]] && \
                                            clear && \
                                            pause -beg "You can't use the option to create files in multiple folder without providing the folder name" -end 1

                                    done

                                    clear

                                    echo -e "\n    You will create your files in the folder(s): ${txt_yellow}${folderList[*]}${txt_none}\n"
                                    
                                    ${call_func} pause

                                    clear

                                    ${call_func} validateFolderList

                                    clear

                                    ${call_func} editFolderList

                                ;;

                                *) 
                                    ${call_func} pause beg -1 -eng -1
                                ;;

                            esac
                            
                        [[ ${option} -ge 1 && ${option} -le 2 ]]
                        do false ; done

                    ;;

                    # Try again
                    *) 
                        ${call_func} pause -beg -1 -end -1
                    ;;

                esac

            [[ ${option} -ge 1 && ${option} -le 2 ]]
            do true ; done

        ;;

        # Help
        2)
            
            clear

            echo -e "$help_text" | less 

        ;;

        # change main folder
        3) 
            ${call_func} setMainFolder
        ;;

        # Try again
        *) 
            ${call_func} pause -beg -1 -end -1
        ;;

    esac

[[ ${option} -eq 1 ]]
do false ; done
