#!/bin/bash
# shellcheck disable=SC2128,SC1094
. "$(cd "$(dirname "$(readlink "$BASH_SOURCE" || echo "$BASH_SOURCE")")" && pwd)"/colors.sh

display_help() {
    local s=" "
    # shellcheck disable=SC2059
    printf "\v${s}${Green}Usage:${s}source ./logger.sh [Flags...]${Color_Off}\n${Blue}" >&2
    printf "%4s-c, --colors%10susing colors for output (optional)\n" "$s" "$s"
    printf "%-4s-h, --help%12shelp information${Color_Off}" "$s" "$s"
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
      >&2 printf "%s Invalid argument\n" "$(RedStr "Error:")"
      exit 1
      ;;
  esac
  shift
done

# Define a timestamp function
function timestamp {
    DATE=$(date +"%Y-%m-%d")
    TIME=$(date +"%H:%M:%S")
    ZONE=$(date +"%Z %z")
    printf "%s%s%s" "$DATE" "$TIME" "$ZONE"
}

function printfuncName {
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
        # shellcheck disable=SC2059
        if [[ -n "${tmp%$space}" ]]; then printf "${tmp%$space}"; else printf "${color}$2${Color_Off}"; fi
    else
        # shellcheck disable=SC2059
        if [[ -n "${tmp%$space}" ]]; then printf "${tmp%$space}"; else printf "$2"; fi
    fi
}

function execStr() {
    local whoRun
    whoRun="${1}"
    local fName
    fName="${2}"
    whoRun="${whoRun#[$'\r\t\n -']}"
    whoRun="${whoRun%[$'\r\t\n -']}"
    local shell
    # shellcheck disable=SC2059
    shell="$(if [[ -n "$(which bash)" ]]; then printf "$(which bash)"; else printf "$(which sh)"; fi)"
    # shellcheck disable=SC2059
    if [[ "${whoRun}" != "" && "${whoRun}" != "$fName" ]]; then printf "${whoRun}"; else printf "${shell}"; fi
}

function INFO {
    local stack
    stack=""
    local fName
    fName=INFO
    local result
    result="$(printfuncName "${Blue}" "${FUNCNAME[@]}" "$fName")"
    local msg
    msg="$1"
    local timeAndDate
    timeAndDate="$(timestamp)"
    local whoRun
    whoRun=$(execStr "${0}" "$fName")
    local line
    # shellcheck disable=SC2059,SC2030,SC2031
    line="$(if [[ -n $BASH_LINENO && "$BASH_LINENO" != "$fName" ]]; then printf " $BASH_LINENO"; fi)"
    if [[ "${Colors}" == true ]]
    then
        stack="${whoRun}${Cyan}${line}"
        # shellcheck disable=SC2059
        printf "[${Yellow}$timeAndDate${Color_Off}] [${result}] [${BIWhite}${stack#$fName}${Color_Off}] $msg\n"
    else
        stack="${whoRun}${line}"
        # shellcheck disable=SC2059
        printf "[$timeAndDate] [${result}] [${stack#$fName}] $msg\n"
    fi
}

function DEBUG(){
    local stack
    stack=""
    local fName
    fName=DEBUG
    local result
    result="$(printfuncName "${Purple}" "${FUNCNAME[@]}" $fName)"
    local msg
    msg="$1"
    local timeAndDate
    timeAndDate="$(timestamp)"
    local whoRun
    whoRun=$(execStr "${0}" "$fName")
    local line
    # shellcheck disable=SC2059,SC2030,SC2031
    line="$(if [[ -n $BASH_LINENO && "$BASH_LINENO" != "$fName" ]]; then printf " $BASH_LINENO"; fi)"
    if [[ "${Colors}" == true ]]
    then
        stack="${whoRun}${Cyan}${line}"
        # shellcheck disable=SC2059
        printf "[${Yellow}$timeAndDate${Color_Off}] [${result}] [${BIWhite}${stack#$fName}${Color_Off}] $msg\n"
    else
        stack="${whoRun}${line}"
        # shellcheck disable=SC2059
        printf "[$timeAndDate] [${result}] [${stack#$fName}] $msg\n"
    fi
}

function ERROR(){
    local stack
    stack=""
    local fName
    fName=ERROR
    local result
    result="$(printfuncName "${Red}" "${FUNCNAME[@]}" "$fName")"
    local msg
    msg="$1"
    local timeAndDate
    timeAndDate="$(timestamp)"
    local whoRun
    whoRun=$(execStr "${0}" "$fName")
    local line
    # shellcheck disable=SC2059,SC2030,SC2031
    line="$(if [[ -n $BASH_LINENO && "$BASH_LINENO" != "$fName" ]]; then printf " $BASH_LINENO"; fi)"
    if [[ "${Colors}" == true ]]
    then
        stack="${whoRun}${Cyan}${line}"
        # shellcheck disable=SC2059
        printf "[${Yellow}$timeAndDate${Color_Off}] [${result}] [${BIWhite}${stack#$fName}${Color_Off}] $msg\n"
    else
        stack="${whoRun}${line}"
        # shellcheck disable=SC2059
        printf "[$timeAndDate] [${result}] [${stack#$fName}] $msg\n"
    fi
}

