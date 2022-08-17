#!/bin/bash
. $(dirname "$(readlink -f "$BASH_SOURCE")")/../colors.sh
. $(dirname "$(readlink -f "$BASH_SOURCE")")/../helpers.sh

display_help() {
    clear
    local s=" "
    printf "\v${s}${Green}Usage:${s}source ./library.sh [Flags...]${Color_Off}\n${Blue}" >&2
    printf "%-4s-h, --help%16shelp information (optional)\n" $s $s
    printf "%-4s-sc, --slaves%13scount of slave nodes (optional)\n" $s $s
    printf "%-4s-n, --name%16scluster name (required)\n" $s $s
    printf "%-4s-rm, --masterRam%10smaster nodes RAM size (optional)\n" $s $s
    printf "%-4s-rs, --slaveRam%11sslave nodes RAM size (optional)\n" $s $s
    printf "%-4s-mm, --masterMemory%7smaster nodes drive memory size (optional)\n" $s $s
    printf "%-4s-ms, --slaveMemory%8sslave nodes drive memory size (optional)\n" $s $s
    printf "%-4s-cm, --masterCpu%10smaster nodes CPU count for node (optional)\n" $s $s
    printf "%-4s-cs, --slaveCpu%11sslave nodes CPU count for node (optional)\n" $s $s
    printf "%-4s-a, --action%14stype of action ['apply', 'delete', 'stop', 'start']${Color_Off}" $s $s
}

action=""

clusterName=""

mastersCount=1
slavesCount=1

masterRam=2Gi
slaveRam=2Gi
masterCpu=2
slaveCpu=2
masterDrive=30Gi
slaveDrive=30Gi


while [ $# -gt 0 ]; do
  case "$1" in
    --help*|-h*)
      if [[ "$1" != *=* ]]; then shift; fi
      display_help
      exit 0
      ;;
    --action*|-a*)
      if [[ "$1" != *=* ]]; then shift; fi
      action="${1#*=}"
      ;;
    --name*|-n*)
      if [[ "$1" != *=* ]]; then shift; fi
      clusterName="${1#*=}"
      ;;
    --slaves*|-sc*)
      if [[ "$1" != *=* ]]; then shift; fi
      slavesCount="${1#*=}"
      slavesCount="${slavesCount//[^0-9]/}"
      ;;
    --masterRam*|-rm*)
      if [[ "$1" != *=* ]]; then shift; fi
      masterRam="${1#*=}"
      masterRam="${masterRam//[^0-9]G/}"
      ;;
    --slaveRam*|-rs*)
      if [[ "$1" != *=* ]]; then shift; fi
      slaveRam="${1#*=}"
      slaveRam="${slaveRam//[^0-9]G/}"
      ;;
    --masterMemory*|-mm*)
      if [[ "$1" != *=* ]]; then shift; fi
      masterDrive="${1#*=}"
      masterDrive="${masterDrive//[^0-9]G/}"
      ;;
    --slaveMemory*|-ms*)
      if [[ "$1" != *=* ]]; then shift; fi
      slaveDrive="${1#*=}"
      slaveDrive="${slaveDrive//[^0-9]G/}"
      ;;
    --masterCpu*|-cm*)
      if [[ "$1" != *=* ]]; then shift; fi
      masterCpu="${1#*=}"
      masterCpu="${masterCpu//[^0-9]/}"
      ;;
    --slaveCpu*|-cs*)
      if [[ "$1" != *=* ]]; then shift; fi
      slaveCpu="${1#*=}"
      slaveCpu="${slaveCpu//[^0-9]/}"
      ;;
    *)
      shift
      >&2 printf "${Red}Error:${Color_Off} Invalid argument\n"
      exit 1
      ;;
  esac
  shift
done

installation_multipass
os=`chack_os`

case $action in
  apply)
    printf "\v${Green}Start apply cluster: ${Yellow}[%s]${Color_Off} with:\n" $clusterName >&2
    printf "%4s masters count: %s %-2s slaves count: %s\n" ' ' `PurpleStr $mastersCount` ' ' `PurpleStr $slavesCount`
    printf "%4s masters RAM: %s %-2s slaves RAM: %s\n" ' ' `PurpleStr $masterRam` ' ' `PurpleStr $slaveRam`
    printf "%4s masters CPU: %s %-2s slaves CPU: %s\n" ' ' `PurpleStr $masterCpu` ' ' `PurpleStr $slaveCpu`
    printf "%4s masters memory: %s %-2s slaves memory: %s${Color_Off}\n" ' ' `PurpleStr $masterDrive` ' ' `PurpleStr $slaveDrive`
    source $(dirname "$(readlink -f "$BASH_SOURCE")")/${os}/addCluster.sh $clusterName $slavesCount $masterCpu $slaveCpu $masterRam $slaveRam $masterDrive $slaveDrive
    exit 0
    ;;
  start)
    printf "%s %s" "$(dirname "$(readlink -f "$BASH_SOURCE")")/${os}/startCluster.sh" $clusterName
    source $(dirname "$(readlink -f "$BASH_SOURCE")")/${os}/startCluster.sh $clusterName
    exit 0
    ;;
  stop)
    printf "%s %s" "$(dirname "$(readlink -f "$BASH_SOURCE")")/${os}/stopCluster.sh" $clusterName
    source $(dirname "$(readlink -f "$BASH_SOURCE")")/${os}/stopCluster.sh $clusterName
    exit 0
    ;;
  delete)
    printf "%s %s" "$(dirname "$(readlink -f "$BASH_SOURCE")")/${os}/purgeCluster.sh" $clusterName
    source $(dirname "$(readlink -f "$BASH_SOURCE")")/${os}/purgeCluster.sh $clusterName
    ;;
  *)
    >&2 printf "${Red}Error:${Color_Off} Invalid or empty action\n"
    exit 1
    ;;
esac