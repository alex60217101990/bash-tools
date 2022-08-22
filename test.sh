#!/bin/bash
# shellcheck disable=SC2128,SC1094
. "$(dirname "$(readlink -n "$BASH_SOURCE")")"/logger.sh -c=true

INFO "test some text"
DEBUG "test some debug"
ERROR "test some error"
# shellcheck disable=SC2059,SC2128
printf "${Blue}$(dirname "$(readlink -n "$BASH_SOURCE")")${Color_Off}\n"