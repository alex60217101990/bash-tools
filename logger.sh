#!/bin/bash
. $(dirname "$(readlink -f "$BASH_SOURCE")")/colors.sh

display_help() {
    local s=" "
    printf "\v${s}${Green}Usage:${s}source ./logger.sh [Flags...]${Color_Off}\n${Blue}" >&2
    printf "%4s-c, --colors%10susing colors for output (optional)\n" $s $s
    printf "%-4s-h, --help%12shelp information${Color_Off}" $s $s
    exit 0
}

Colors=true

while [ $# -gt 0 ]; do
  case "$1" in
    --help*|-h*)
      if [[ "$1" != *=* ]]; then shift; fi
      display_help
      exit 0
      ;;
    --colors*|-c*)
      if [[ "$1" != *=* ]]; then shift; fi
      Colors="${1#*=}"
      ;;
    *)
      >&2 printf "${Red}Error:${Color_Off} Invalid argument\n"
      exit 1
      ;;
  esac
  shift
done

# Define a timestamp function
function timestamp {
    DATE=`date +%Y-%m-%d`
    TIME=`date +%H:%M:%S`
    ZONE=`date +"%Z %z"`
    printf "$DATE $TIME $ZONE"
}

function printFuncName {
    local fn=""
    local postfix="=>"
    local space=" "
    local color=$1
    for value in "${@:3}"
    do
      if [ "${value}" != "" ]
      then
        if [ "${fn}" != "" ]
        then
          fn+=" "
        fi
        fn="${fn}${color}${value}${Color_Off} $postfix"
      fi
    done
    tmp="${fn%$postfix}"
    if [[ "${Colors}" == true ]]
    then
        if [[ -n "${tmp%$space}" ]]; then printf "${tmp%$space}"; else printf "${color}$2${Color_Off}"; fi
    else
        if [[ -n "${tmp%$space}" ]]; then printf "${tmp%$space}"; else printf "$2"; fi
    fi
}

function execStr() {
    local whoRun="${1}"
    local fName="${2}"
    local trimStr=${whoRun%"-"}
    whoRun="${whoRun#[$'\r\t\n -']}"
    whoRun="${whoRun%[$'\r\t\n -']}"
    local shell=$(if [[ -n "$(which bash)" ]]; then printf "$(which bash)"; else printf "$(which sh)"; fi)
    if [[ "${whoRun}" != "" && "${whoRun}" != "$fName" ]]; then printf "${whoRun}"; else printf "${shell}"; fi
}

function INFO {
    local stack=""
    local fName=INFO
    local result="$(printFuncName ${Blue} ${FUNCNAME[@]} "$fName")"
    local msg="$1"
    local timeAndDate=`timestamp`
    local whoRun=$(execStr ${0} $fName)
    local line=$(if [[ -n $BASH_LINENO && "$BASH_LINENO" != "$fName" ]]; then printf " $BASH_LINENO"; fi)
    local stack=""
    local fName=INFO
    if [[ "${Colors}" == true ]]
    then
        stack="${whoRun}${Cyan}${line}"
        printf "[${Yellow}$timeAndDate${Color_Off}] [${result}] [${BIWhite}${stack#$fName}${Color_Off}] $msg\n"
    else
        stack="${whoRun}${line}"
        printf "[$timeAndDate] [${result}] [${stack#$fName}] $msg\n"
    fi
}

function DEBUG(){
    local stack=""
    local fName=DEBUG
    local result="$(printFuncName ${Purple} ${FUNCNAME[@]} $fName)"
    local msg="$1"
    local timeAndDate=`timestamp`
    local whoRun=$(execStr ${0} $fName)
    local line=$(if [[ -n $BASH_LINENO && "$BASH_LINENO" != "$fName" ]]; then printf " $BASH_LINENO"; fi)
    if [[ "${Colors}" == true ]]
    then
        stack="${whoRun}${Cyan}${line}"
        printf "[${Yellow}$timeAndDate${Color_Off}] [${result}] [${BIWhite}${stack#$fName}${Color_Off}] $msg\n"
    else
        stack="${whoRun}${line}"
        printf "[$timeAndDate] [${result}] [${stack#$fName}] $msg\n"
    fi
}

function ERROR(){
    local stack=""
    local fName=ERROR
    local result="$(printFuncName ${Red} ${FUNCNAME[@]} $fName)"
    local msg="$1"
    local timeAndDate=`timestamp`
    local whoRun=$(execStr ${0} $fName)
    local line=$(if [[ -n $BASH_LINENO && "$BASH_LINENO" != "$fName" ]]; then printf " $BASH_LINENO"; fi)
    if [[ "${Colors}" == true ]]
    then
        stack="${whoRun}${Cyan}${line}"
        printf "[${Yellow}$timeAndDate${Color_Off}] [${result}] [${BIWhite}${stack#$fName}${Color_Off}] $msg\n"
    else
        stack="${whoRun}${line}"
        printf "[$timeAndDate] [${result}] [${stack#$fName}] $msg\n"
    fi
}

