#!/bin/env bash

function showMenu(){

    local _full_text=${*}
    local _cut_text=${_full_text/:-:0*/}
    local _show

    clear

    echo -e "\n    ${_cut_text}\n"

    for(( _show = 1; _show < ${_full_text: -2}; _show++ )); do

        _full_text=${_full_text/*:-:$(( _show - 1 ))/}
        _cut_text=${_full_text/:-:${_show}*/}
    
        echo -e "\t${txt_green}${_show})${txt_none} ${_cut_text}"
    
    done

    _full_text=${_full_text/*:-:$(( _show - 1 ))/}
    echo -en "\t${txt_red}0)${txt_none} ${_full_text/${_full_text: -2}/}\n\n"

    read -n1 -p "    : " option

    echo -e "\n"

    return 0

}

function pause(){

    echo ''

    local _in

    while [[ -n ${1} ]]; do

        _in=${1}

        if [[ ${1,,} == -*beg* ]]; then
            
            shift
            local _beg_txt=${1}
            shift
            

        fi

        if [[ ${1,,} == -*end* ]]; then

            shift
            local _end_txt=${1}
            shift

        fi

        if [[ ${1,,} == -*t+([0-9]) ]]; then

            local _time=${1,,//-*t/-t}
            shift

        fi

        [[ ${_in} == ${1} ]] && \
            shift

    done

    if [[ -n ${_beg_txt} && -n ${_end_txt} ]]; then
    
        if [[ ${_beg_txt} = 0 ]]; then
            
            clear && echo ''
            _beg_txt="Empty folder"

        elif [[ ${_beg_txt} = -1 ]]; then
            _beg_txt="Invalid value"
        fi
        
        if [[ ${_end_txt} = 0 ]]; then
            _end_txt="exit"
        elif [[ ${_end_txt} = 1 ]]; then
            _end_txt="continue"
        elif [[ ${_end_txt} = -1 ]]; then
    
            clear && echo ''
            _end_txt="try again"
    
        fi
        
        read -sn1 ${_time} -p "    ${_beg_txt}, type something to ${_end_txt}. . . " enterKey
    
    else

        read -sn1 ${_time} -p "    Type something to continue. . . " enterKey

    fi

    echo ''
    
    return 0

}

function setMainFolder(){

    clear

    main_folder=${*}

    until

        [[ -z ${main_folder} ]] && \
            read -p "    In which folder do you want to run the program? " main_folder

        validateFolder ${main_folder}

        local _ret=${?}

        if [[ ${_ret} -eq 0 ]]; then

            main_folder=${vfReturn}
            unset vfReturn

        elif [[ ${_ret} -eq 1 ]]; then
            pause -beg "You can't continue without defining the main folder" -end -1
        fi

    [[ ${_ret} -eq 0  ]]
    do false; done

    cd ${main_folder// /?}

    return 0

}

function validateFolder(){
    
    local _folder=${*}

    until

        clear

        if [[ -d ${_folder} ]]; then

            break

        else

            ${call_func} showMenu "Invalid folder (${txt_yellow}${_folder}${txt_none}), you want to::-:0Create a new folder.:-:1Retype the folder name.:-:2Cancel.03"
            
            case ${option} in

                # Close
                0)
                    clear
                    return 1
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
                    clear; pause -beg -1 -end -1
                ;;

            esac
        fi

    [[ ${option} -ge 0 && ${option} -le 2 ]]
    do false; done

    vfReturn=${_folder}

    return 0

}

function validateFolderList(){

    local _list_size=${#folderList[*]}
    local _fl

    for (( _fl = 0; _fl < ${_list_size}; _fl++ )); do
        
        validateFolder "${folderList[${_fl}]}"

        local _ret=${?}
        
        if [[ ${_ret} -eq 0 ]]; then
        
            folderList[${_fl}]=${vfReturn}    
            unset vfReturn

        elif [[ ${_ret} -eq 1 ]]; then
            
            unset folderList[${_fl}]
        
        fi

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
                    pause -beg "You can't remove folders of the list because the folder list is empty" -end 1

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

                    local _position=0                                       # count the positions
                    local _element=0                                        # count the positions not empty
                    local _full_list=$(( ${#folderList[*]} + ${_removed} )) # List size if full
                    
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
                    pause -beg "You can't continue because there are no folders in the list" -end -1
                else
                                        
                    # create subfolder
                    while

                        echo -en "\n    Do you want to create subfolders?(${txt_green}Y${txt_none}/${txt_red}N${txt_none}): "
                        read -n1 option
                        option=${option,,}

                        if [[ ${option} = 'y' || ${option} -eq 1  ]]; then
                            clear; read -p "    Enter the name to the subfolder: " _newFolder
                            subFolder=${_newFolder// /-}/

                            for a in ${folderList[@]}; do
                                mkdir -p ${a}/${subFolder}
                                validateFolder ${a}/${subFolder}
                            done

                            unset _newFolder

                        elif [[ ${option} != 'n' && ${option} -ne 0 ]]; then
                            pause -beg -1 end -1
                        fi

                        clear

                    [[ ${option} != 'y' && ${option} != 'n' && ${option} -ne 1 && ${option} -ne 0 ]]
                    do true ; done

                    clear

                    createFiles m

                fi
                    
            ;;

            *) 
                pause -beg -1 -end -1
            ;;
        esac

        [[ ! -z ${folderList[*]} ]] && \
            echo -e "\n    Folder(s): ${txt_yellow}${folderList[*]// /,}${txt_none}" && \
            pause
        
        clear

    [[ ${option} -eq 0 ]]
    do false; done
    
}
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
            clear && pause -beg "You can't create a file without name" -end -1
        
        done
        
        while [[ -z $extension_list ]]; do
            
            clear
            
            echo -en "\n    Enter the name of the extensions ${txt_bold}(different extensions separated by space and without dot)${txt_none}: "
            
            read -ra extension_list

            [[ -z $extension_list ]] && \
                clear && pause -beg "You can't create a file without extension" -end -1
        
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
                    
                    for(( _el = 0; _el < ${#extension_list[@]}; _el++ ));
                    do                        
                      
                        if [[ -z $no_txt ]]; then

                            clear
                            
                            echo -en "\n    Enter text to be added to all files of extension ${txt_yellow}${extension_list[${_el}]}${txt_bold}(use '${txt_blue}ENTER${txt_bold}' to create an empty file)${txt_none}: " 
                            
                            read -r fileText

                        fi

                        for fil in ${file_list[@]}
                        do
                            
                            echo -e "${fileText}" >> ${folderList[${_el}]}/${subFolder}${fil//./}.${extension_list[${_el}]//./}

                            [[ ${?} -eq 0 ]] && \
                                let contFiles++;
                    
                        done

                    done

                    unset _el
                        
                else
                    clear; pause -beg "When using this method, the number of files must equal the number of extensions" -end -1
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
                pause -beg -1 -end -1
            ;;

        esac

    [[ ${option} -ge 1 && ${option} -le 2 || -z ${option} ]]
    do false ; done

    clear
    pause -beg "${contFiles} of ${fileNumber} files created successfully" -end 0
    exit 0

}

${*}