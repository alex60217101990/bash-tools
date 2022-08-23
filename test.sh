#!/bin/bash
# shellcheck disable=SC2128,SC1094
. "$(cd "$(dirname "$(readlink "$BASH_SOURCE" || echo "$BASH_SOURCE")")" && pwd)"/logger.sh -c=true
. "$(cd "$(dirname "$(readlink "$BASH_SOURCE" || echo "$BASH_SOURCE")")" && pwd)"/helpers.sh

INFO "test some text"
DEBUG "test some debug"
ERROR "test some error"
# shellcheck disable=SC2059,SC2128
printf "${Blue}$(dirname "$(readlink -n "$BASH_SOURCE")")${Color_Off}\n"