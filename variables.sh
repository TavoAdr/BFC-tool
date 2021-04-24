#!/bin/env bash

 # - - Text Style
  txt_none="\033[m"           # Normal Text
  txt_red="\033[1;31m"        # Cancel/Back
  txt_green="\033[1;32m"      # Normal Options
  txt_yellow="\033[1;33m"     # Lists
  txt_blue="\033[1;36m"       # Keys
  txt_bold="\033[1;37m"       # Notes to user
 # - - Read File that Calls the Functions
  call_func="source ${file_path}/functions.sh"
 # - - Help
  help_text="\n   FCM-tool.sh [-d DIR] [-sing/-mult] [-f FILES] [-e EXTENSIONS]\n\n------------------------------------------------------------------\n\n    Description:\n\n\tBasic commands for creating multiple files at once.\n\n------------------------------------------------------------------\n\n    Options:\n\n\b\t-d DIRECTORY\tDefines the main folder where the files\n\t\t\twill be created, in case a single folder\n\t\t\tor other folders will be located, if you\n\t\t\tchoose multiple folders.\n\n\t-sing\t\tCreate files in the main folder.\n\n\t-mult\t\tCreate files in some folder within the\n\t\t\tmain folder. It also allows you to add\n\t\t\tother options like -af to all folders in\n\t\t\tthe main folder and even -t to type the\n\t\t\tname of the folders (-tc creates folders\n\t\t\tif they don't exist), and you can even\n\t\t\tuse -af combined with -t or -tc and -sub\n\t\t\tSUBFOLDER to define the name of the\n\t\t\tsubfolder.\n\n\t-f FILE\t\tDefines the name of the files.\n\n\t-e EXTENSIONS\tDefines file extensions.\n\n------------------------------------------------------------------\n\n    NOTE:\n\n\tOptions that depend on the passage of a text to the\n\tside, as is the case with -d, -f, -and among many\n\tothers must always be alone or at the end of a set\n\tof arguments, having at most one argument of this\n\ttype at a time.\n\n------------------------------------------------------------------\n\n\t\t\t /-----------------\ \n\t\t\t<| Type Q to quit. |>\n\t\t\t \-----------------/ \n"
# --------------- DEFINE MAIN VARIABLES ---------------

 # help
  [[ `echo ${*} | grep -ci 'help'` == 1 ]] && \
    echo -e "${help_text}" | less && \
    exit 0

 # file without text
  [[ `echo ${*} | grep -ci 'notxt'` == 1 ]] && \
    no_txt=1

 # sing folder
  [[ `echo ${*} | grep -ci 'sing'` == 1 ]] && \
    folder_structures=1

 # mult folder}
  [[ `echo ${*} | grep -ci 'mult'` == 1 ]] && \
    if [[ -z ${folder_structures} ]]; then
        folder_structures=2
    else

        clear
        echo -e "\n    You can't use the -sing e -mult argument together.\n"
        exit 0

    fi

 while [[ -n $1 ]]; do

    _in=${1}

   # dir
    if [[ ${1,,} == -*d* ]]; then
        
        if [[ -z $main_folder ]]; then
        
            shift
            main_folder="${1}"
            shift
        
        else

            echo -e "\n   You cannot use more than one parent folder.\n"
            exit 0
        
        fi

    fi

   # file
    if [[ ${1,,} == -*fl* ]]; then
        
        shift
        read -ra file_list <<< `echo "${1}"`
        shift

    fi

    # extension
    if [[ ${1,,} == -*ext* ]]; then
        
        shift
        read -ra extension_list <<< `echo "${1}"`
        shift

    fi
    
   # mult options
    if [[  $folder_structures == mult ]]; then

        # all files
        if [[ ${1,,} == -*af* ]]; then
            echo '-af'
        fi
        
        # subfolder
        if [[ ${1,,} == -*sub* ]]; then
            echo '-sub'
        fi
        
        # type
        if [[ ${1,,} == -*tpc* ]]; then
            echo '-tc'
        elif [[ ${1,,} == -*tp* ]]; then
            echo '-t'
        fi

   fi

    [[ ${_in} == ${1} ]] && \
        shift
    
 done

unset _in

 echo $no_txt -- no_txt
 echo $folder_structures -- folder_structures
 echo $main_folder -- main_folder
 echo ${file_list[0]} -- file_list0
 echo ${file_list[1]} -- file_list1
 echo ${file_list[2]} -- file_list2
 echo ${file_list[3]} -- file_list3
 echo ${file_list[4]} -- file_list4
 echo ${file_list[5]} -- file_list5
 echo ${extension_list[0]} -- extension_list0
 echo ${extension_list[1]} -- extension_list1
 echo ${extension_list[2]} -- extension_list2
 echo ${extension_list[3]} -- extension_list3
 echo ${extension_list[4]} -- extension_list4
 echo ${extension_list[5]} -- extension_list5

${call_func} pause -beg 0 -end 1

# -----------------------------------------------------

# - - Define Main Folder
${call_func} setMainFolder "${main_folder}"

 # - - - - Roles to Define Variable an Functions
  # global    ->  NAMEVAR
  # local     ->  _name_var
  # program   ->  name_var
  # function  ->  nameFunction