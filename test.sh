#!/bin/bash
. $(dirname "$(readlink -f "$BASH_SOURCE")")/logger.sh -c=true

INFO "test some text"
DEBUG "test some debug"
ERROR "test some error"
printf "${Blue}$(dirname "$(readlink -f "$BASH_SOURCE")")${Color_Off}\n"