#!/bin/sh
# Logger from this post http://www.cubicrace.com/2016/03/log-tracing-mechnism-for-shell-scripts.html
source ./colors.sh
#${BASH_SOURCE}

display_help() {
    local s=" "
    printf "\v${s}${Green}Usage:${s}source ./logger.sh [Flags...]${Color_Off}\n${Blue}" >&2
    printf "%4s-c, --colors%10susing colors for output (optional)\n" $s $s
    printf "%-4s-h, --help%12shelp information${Color_Off}" $s $s
    exit 1
}

colors=true

while [ $# -gt 0 ]; do
  case "$1" in
    --help*|-h*)
      if [[ "$1" != *=* ]]; then shift; fi
      display_help
      exit 0
      ;;
    --colors*|-c*)
      if [[ "$1" != *=* ]]; then shift; fi
      colors="${1#*=}"
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
    echo $DATE $TIME $ZONE
}

function INFO(){
    local function_name="${FUNCNAME[1]}"
    local msg="$1"
    timeAndDate=`timestamp`
    if [ "${colors}" == true ]
    then
        echo "[${Yellow}$timeAndDate${Color_Off}] [${Blue}INFO${Color_Off}] [${BIWhite}${0} ${BCyan}$BASH_LINENO${Color_Off}] $msg"
    else
        echo "[$timeAndDate] [INFO] [${0} $BASH_LINENO] $msg"
    fi
}

function DEBUG(){
    local function_name="${FUNCNAME[1]}"
    local msg="$1"
    timeAndDate=`timestamp`
    if [ "${colors}" == true ]
    then
        echo "[${Yellow}$timeAndDate${Color_Off}] [${Purple}DEBUG${Color_Off}] [${BIWhite}${0} ${BCyan}$BASH_LINENO${Color_Off}] $msg"
    else
        echo "[$timeAndDate] [DEBUG] [${0} $BASH_LINENO] $msg"
    fi
}

function ERROR(){
    local function_name="${FUNCNAME[1]}"
    local msg="$1"
    timeAndDate=`timestamp`
    if [ "${colors}" == true ]
    then
        echo "[${Yellow}$timeAndDate${Color_Off}] [${Red}ERROR${Color_Off}] [${BIWhite}${0} ${BCyan}$BASH_LINENO${Color_Off}] $msg"
    else
        echo "[$timeAndDate] [ERROR] [${0} $BASH_LINENO] $msg"
    fi
}

