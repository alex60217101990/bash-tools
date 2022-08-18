#!/bin/bash

# Reset
# shellcheck disable=SC2034
Color_Off='\033[0m'       # Text Reset

# Regular Colors
# shellcheck disable=SC2034
Black='\033[0;30m'        # Black
# shellcheck disable=SC2034
Red='\033[0;31m'          # Red
# shellcheck disable=SC2034
Green='\033[0;32m'        # Green
# shellcheck disable=SC2034
Yellow='\033[0;33m'       # Yellow
# shellcheck disable=SC2034
Blue='\033[0;34m'         # Blue
# shellcheck disable=SC2034
Purple='\033[0;35m'       # Purple
# shellcheck disable=SC2034
Cyan='\033[0;36m'         # Cyan
# shellcheck disable=SC2034
White='\033[0;37m'        # White

# Bold
# shellcheck disable=SC2034
BBlack='\033[1;30m'       # Black
# shellcheck disable=SC2034
BRed='\033[1;31m'         # Red
# shellcheck disable=SC2034
BGreen='\033[1;32m'       # Green
# shellcheck disable=SC2034
BYellow='\033[1;33m'      # Yellow
# shellcheck disable=SC2034
BBlue='\033[1;34m'        # Blue
# shellcheck disable=SC2034
BPurple='\033[1;35m'      # Purple
# shellcheck disable=SC2034
BCyan='\033[1;36m'        # Cyan
# shellcheck disable=SC2034
BWhite='\033[1;37m'       # White

# Underline
# shellcheck disable=SC2034
UBlack='\033[4;30m'       # Black
# shellcheck disable=SC2034
URed='\033[4;31m'         # Red
# shellcheck disable=SC2034
UGreen='\033[4;32m'       # Green
# shellcheck disable=SC2034
UYellow='\033[4;33m'      # Yellow
# shellcheck disable=SC2034
UBlue='\033[4;34m'        # Blue
# shellcheck disable=SC2034
UPurple='\033[4;35m'      # Purple
# shellcheck disable=SC2034
UCyan='\033[4;36m'        # Cyan
# shellcheck disable=SC2034
UWhite='\033[4;37m'       # White

# Background
# shellcheck disable=SC2034
On_Black='\033[40m'       # Black
# shellcheck disable=SC2034
On_Red='\033[41m'         # Red
# shellcheck disable=SC2034
On_Green='\033[42m'       # Green
# shellcheck disable=SC2034
On_Yellow='\033[43m'      # Yellow
# shellcheck disable=SC2034
On_Blue='\033[44m'        # Blue
# shellcheck disable=SC2034
On_Purple='\033[45m'      # Purple
# shellcheck disable=SC2034
On_Cyan='\033[46m'        # Cyan
# shellcheck disable=SC2034
On_White='\033[47m'       # White

# High Intensity
# shellcheck disable=SC2034
IBlack='\033[0;90m'       # Black
# shellcheck disable=SC2034
IRed='\033[0;91m'         # Red
# shellcheck disable=SC2034
IGreen='\033[0;92m'       # Green
# shellcheck disable=SC2034
IYellow='\033[0;93m'      # Yellow
# shellcheck disable=SC2034
IBlue='\033[0;94m'        # Blue
# shellcheck disable=SC2034
IPurple='\033[0;95m'      # Purple
# shellcheck disable=SC2034
ICyan='\033[0;96m'        # Cyan
# shellcheck disable=SC2034
IWhite='\033[0;97m'       # White

# Bold High Intensity
# shellcheck disable=SC2034
BIBlack='\033[1;90m'      # Black
# shellcheck disable=SC2034
BIRed='\033[1;91m'        # Red
# shellcheck disable=SC2034
BIGreen='\033[1;92m'      # Green
# shellcheck disable=SC2034
BIYellow='\033[1;93m'     # Yellow
# shellcheck disable=SC2034
BIBlue='\033[1;94m'       # Blue
# shellcheck disable=SC2034
BIPurple='\033[1;95m'     # Purple
# shellcheck disable=SC2034
BICyan='\033[1;96m'       # Cyan
# shellcheck disable=SC2034
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
# shellcheck disable=SC2034
On_IBlack='\033[0;100m'   # Black
# shellcheck disable=SC2034
On_IRed='\033[0;101m'     # Red
# shellcheck disable=SC2034
On_IGreen='\033[0;102m'   # Green
# shellcheck disable=SC2034
On_IYellow='\033[0;103m'  # Yellow
# shellcheck disable=SC2034
On_IBlue='\033[0;104m'    # Blue
# shellcheck disable=SC2034
On_IPurple='\033[0;105m'  # Purple
# shellcheck disable=SC2034
On_ICyan='\033[0;106m'    # Cyan
# shellcheck disable=SC2034
On_IWhite='\033[0;107m'   # White

function PurpleStr() {
  # shellcheck disable=SC2059
  print "${Purple}$1${Color_Off}"
}

function RedStr() {
  # shellcheck disable=SC2059
  print "${Red}$1${Color_Off}"
}

function YellowStr() {
  # shellcheck disable=SC2059
  print "${Yellow}$1${Color_Off}"
}

function GreenStr() {
  # shellcheck disable=SC2059
  print "${Green}$1${Color_Off}"
}

function RepeatColorStr() {
  local symbol="$2"
  local color="$1"
  local count="$3"
  # shellcheck disable=SC2059
  printf "${color}${symbol}%.0s${Color_Off}" $(seq 1 ${count//[^0-9]/})

}

function CyanStr() {
  # shellcheck disable=SC2059
  print "${Cyan}$1${Color_Off}"
}

function BlueStr() {
  print "${Blue}$1${Color_Off}"
}