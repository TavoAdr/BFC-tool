#!/bin/env bash

function showMenu(){

    local _full_text=${*}
    local _cut_text=${_full_text/:-:0*/}

    clear

    echo -e "\n    ${_cut_text}\n"

    for(( i = 1; i < ${_full_text: -2}; i++ )); do

        _full_text=${_full_text/*:-:$(( i - 1 ))/}
        _cut_text=${_full_text/:-:${i}*/}
    
        echo -e "\t${txt_green}${i})${txt_none} ${_cut_text}"
    
    done

    _full_text=${_full_text/*:-:$(( i - 1 ))/}
    echo -en "\t${txt_red}0)${txt_none} ${_full_text/${_full_text: -2}/}\n\n"

    read -n1 -p "    : " option

    echo -e "\n"

    return 0

}

function pause(){

    if [[ -n ${*} ]]; then
    
        if [[ ${*} = 0 ]]; then
            read -sn1 -p "    Empty folder, type something and to continue. . . " enterKey

        elif [[ ${*} = -1 ]]; then
            clear; read -sn1 -p "    Invalid value, type something and to continue. . . " enterKey

        else
            read -sn1 -p "    ${*}, type something and to continue. . . " enterKey
        fi
    
    else
        read -sn1 -p "    Type something and to continue. . . " enterKey
    fi

    echo -e '\n'
    
    return 0

}

function setMainFolder(){

    clear

    main_folder=${*}

    [[ -z ${main_folder} ]] && \
        read -p "    In which folder do you want to run the program? " main_folder

    validateFolder ${main_folder}
    main_folder=${vfReturn}
    unset vfReturn

    cd ${main_folder// /?}

}

function validateFolder(){
    
    local _folder=${*}

    until

        clear

        if [[ -d ${_folder} ]]; then

            break

        else

            ${call_func} showMenu "Invalid folder (${txt_yellow}${_folder}${txt_none}), you want to::-:0Create a new folder.:-:1Retype the folder name.:-:2Exit.03"
            
            case ${option} in

                # Close
                0)
                    exit 0
                ;;

                1) # Create Folder

                    _folder=${_folder/' '/'-'} # change space to hyphen
                    mkdir ${_folder}; clear
                    validateFolder ${_folder}
                
                ;;

                2) # Retype
                
                    clear; read -p "    Enter a folder name: " _folder
                    validateFolder ${_folder}
                
                ;;

                *) # Try again
                    clear; pause -1
                ;;

            esac
        fi

    [[ ${option} -ge 0 && ${option} -le 2 ]]
    do false; done

    vfReturn=${_folder}

    return 0

}
 # TEST create folder (1)
  # normal -> create
  # with space -> change space to hyphen
 # TEST retype (2)
  # valid -> retest
  # invalid -> choose again what to do

function validateFolderList(){

    for a in ${folderList[@]}; do
        validateFolder ${a}
    done

}

function editFolderList(){
    
    local _removed=0 # counts the number of values removed from the list
    
    until

        ${call_func} showMenu "Do you want to::-:0Create and add a new folder to list.:-:1Remove folder.:-:2Continue.:-:3Back.04"

        case ${option} in
            
            # Empty to continue without error message
            0)
                clear;
            ;;
            
            # Crate and Add to list
            1)

                clear

                local _newFolder

                read -p "    Enter the name of the new folder: " _newFolder
                folderList[${#folderList[*]}]=${_newFolder// /-}
                
                mkdir ${folderList[$(( ${#folderList[*]} - 1 ))]}
                
                validateFolder ${folderList[$(( ${#folderList[*]} - 1 ))]}

            ;;

            
            # Remove folder
            2) 

                clear

                if [[ -z ${folderList[*]} ]]; then
                    pause "You can't remove folders of the list because the folder list is empty"

                else

                    echo -e "\n    The folder list is:\n"
                    
                    cont=0
                    for a in ${folderList[@]}; do
                        let cont++; echo -e "\t${txt_green}${cont})${txt_none} ${a}"
                    done
                    
                    echo -e "\n"

                    until

                        local _folder_position

                        read -p "    Enter the number of the folder to be removed from the list: " _folder_position
                        
                        [[ ${_folder_position} -le 0 || ${_folder_position} -gt ${#folderList[*]} ]] && \
                            echo -e "\n    Type the value in the range.\n"
                    
                    [[ ${_folder_position} -ge 1 && ${_folder_position} -le ${#folderList[*]} ]]
                    do true ; done

                    local _position=0                                           # count the number of positions in the list
                    local _element=0                                            # count the number of positions not empty in the list
                    local _full_list=$(( ${#folderList[*]} + ${_removed} ))    # List size if full
                    
                    while [[ ${_position} -lt ${_full_list} && ${_elemento} -ne ${_folder_position} ]]; do

                        # Count the number of positions not empty
                        [[ -n ${folderList[${_position}]} ]] && \
                            let _element++
                        
                        # Remove the element from the list if it is in the position I am looking for
                        [[ ${_element} -eq ${_folder_position} ]] && \
                            unset folderList[${_position}]

                        let _position++

                    done

                    let _removed++

                fi

            ;;

             
            # Continue
            3)
                clear
                if [[ -z ${folderList[*]} ]]; then
                    pause "You can't continue because there are no folders in the list"
                else
                    
                    createSubFolder

                    clear

                    createFiles m
                fi
                    
            ;;

            *) 
                pause -1
            ;;
        esac

        [[ ! -z ${folderList[*]} ]] && \
            echo -e "\n    Folder(s): ${txt_yellow}${folderList[*]// /,}${txt_none}" && \
            pause
        
        clear

    [[ ${option} -eq 0 ]]
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

        echo -en "\n    Do you want to create subfolders?(${txt_green}Y${txt_none}/${txt_red}N${txt_none}): "
        read -n1 option
        option=${option,,}

        if [[ ${option} = 'y' || ${option} -eq 1  ]]; then
            local _newFolder
            clear; read -p "    Enter the name to the subfolder: " _newFolder
            subFolder=${_newFolder// /-}/

            for a in ${folderList[@]}; do
                mkdir -p ${a}/${subFolder}
                validateFolder ${a}/${subFolder}
            done

        elif [[ ${option} != 'n' && ${option} -ne 0 ]]; then
            pause -1
        fi

        clear

    [[ ${option} != 'y' && ${option} != 'n' && ${option} -ne 1 && ${option} -ne 0 ]]
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

        [[ ${*} == 'm' ]] && \
            showMenu "What method do you want to use to create the files?:-:0Organize files in folders according to their extension ${txt_bold}(Files with extension x in folder y).${txt_none}:-:1All files, with all extensions in all folders.:-:2Exit03"

        while [[ -z $file_list ]]; do
            
            clear
            
            echo -en "\n    Enter the name of the files ${txt_bold}(different files separated by space)${txt_none}: "
            
            read -ra file_list

            [[ -z $file_list ]] && \
            clear && pause "You can't create a file without name"
        
        done
        
        while [[ -z $extension_list ]]; do
            
            clear
            
            echo -en "\n    Enter the name of the extensions ${txt_bold}(different extensions separated by space and without dot)${txt_none}: "
            
            read -ra extension_list

            [[ -z $extension_list ]] && \
                clear && pause "You can't create a file without extension"
        
        done
        
        clear
        
        echo -e "\n    You intend to create the ${txt_yellow}${file_list[@]// /,}${txt_none} files of extension ${txt_yellow}${extension_list[@]// /,}${txt_none}.\n"

        contFiles=0

        pause
        clear

        case ${option} in

            # Close
            0)
                exit 0
            ;;            

            # 1 - 1
            1)

                fileNumber=$(( ${#folderList[@]} * ${#file_list[@]} ))

                if [[ ${#folderList[@]} -eq ${#extension_list[@]} ]]; then
                    
                    for(( i=0; i<${#extension_list[@]}; i++ ));
                    do                        
                      
                        if [[ -z $no_txt ]]; then

                            clear
                            
                            echo -en "\n    Enter text to be added to all files of extension ${txt_yellow}${extension_list[${i}]}${txt_bold}(use '${txt_blue}ENTER${txt_bold}' to create an empty file)${txt_none}: " 
                            
                            read -r fileText

                        fi

                        for fil in ${file_list[@]}
                        do
                            
                            echo -e "${fileText}" >> ${folderList[${i}]}/${subFolder}${fil//./}.${extension_list[${i}]//./}

                            [[ ${?} -eq 0 ]] && \
                                let contFiles++;
                    
                        done

                    done
                        
                else
                    clear; pause "When using this method, the number of files must equal the number of extensions"
                    option=127
                fi

            ;;
            
            # all - all
            2)

                fileNumber=$(( ${#folderList[@]} * ${#file_list[@]} * ${#extension_list[@]} ))

                for ext in ${extension_list[@]}
                do


                    if [[ -z $no_txt ]]; then
                        
                        clear
                        
                        echo -en "\n    Enter text to be added to all files of extension ${txt_yellow}${ext}${bold}(use '${txt_blue}ENTER${txt_bold}' to create an empty file)${txt_none}: "
                    
                        read -r fileText

                    fi
                        
                    for fold in ${folderList[@]}
                    do

                        for fil in ${file_list[@]}
                        do
                            
                            echo -e "${fileText}" >> ${fold}/${subFolder}${fil//./}.${ext//./}

                            [[ ${?} -eq 0 ]] && \
                                let contFiles++;
                    
                        done
                        
                    done
                
                done
                
            ;;

            # simple
            '')

                fileNumber=$(( ${#file_list[@]} * ${#extension_list[@]} ))

                for ext in ${extension_list[@]}
                do
                    
                    if [[ -z $no_txt ]]; then
                        
                        clear
                        
                        echo -en "\n    Enter text to be added to all files of extension ${txt_yellow}${ext}${txt_bold}(use '${txt_blue}ENTER${txt_bold}' to create an empty file)${txt_none}: "
                        
                        read -r fileText

                    fi

                    for fil in ${file_list[@]}
                    do
                        
                        echo -e "${fileText}" >> ${fil//./}.${ext//./}

                        [[ ${?} -eq 0 ]] && \
                            let contFiles++;
                   
                    done
                    
                done
                
            ;;
            
            # try again
            *) 
                pause -1
            ;;

        esac

    [[ ${option} -ge 1 && ${option} -le 2 || -z ${option} ]]
    do false ; done

    clear
    pause "${contFiles} of ${fileNumber} files created successfully"
    exit 0

}
 # TEST enter var
  # File and Extensions with an without dot -> create the file with just one point if extension is not empty
  # Empty file and Extensions -> Error message
  # File name that already exists -> Add a new line in the end of the file
 # TEST method
  # 1
   # ne sizes of vars -> show error message
   # eq sizes of vars -> continue
  # 2
  # ''

${*}