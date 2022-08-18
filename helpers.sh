#!/bin/bash
. $(dirname "$(readlink -f "$BASH_SOURCE")")/logger.sh -c=true

function CreateDirIfNotExist() {
    if [[ ! -e "$1" ]]; then
       mkdir -p "$1"
    elif [[ ! -d "$1" ]]; then
        >&2 printf "%s %s already exists but is not a directory\n" "`RedStr "Error:"`" "`YellowStr "$1"`"
        exit 1
    fi
}

function Kmerge() {
#  if [[ ! -e "$HOME/.kube/config.d" ]]; then
#     mkdir -p "$HOME/.kube/config.d"
#  elif [[ ! -d "$HOME/.kube/config.d" ]]; then
#      >&2 printf "%s %s already exists but is not a directory\n" "`RedStr "Error:"`" "`YellowStr "$HOME/.kube/config.d"`"
#      exit 1
#  fi

  CreateDirIfNotExist "$3"

  DATE=$(date +"%Y-%m-%d.%H:%M:%S")
  cp $HOME/.kube/config $HOME/.kube/config.d/config.backup.$DATE
  KUBECONFIG=$1:$HOME/.kube/config kubectl config view --merge --flatten > \
  $HOME/.kube/config.d/$2
  export KUBECONFIG=$HOME/.kube/config.d/$2
}

installation_multipass()
{
  ### Install multipass
  if command -v multipass > /dev/null 2>&1; then
    INFO "Multipass installation: Already installed"
  else
    brew cask install multipass 2>/dev/null
    [ $? -eq 0 ] && INFO "Multipass installation: OK" || (ERROR "Multipass installation: KO" && exit 1)
  fi
}

chack_os() {
  case $(uname | tr '[:upper:]' '[:lower:]') in
    linux*)
      printf "linux"
      ;;
    darwin*)
      printf "darwin"
      ;;
    *)
      >&2 printf "$%s Not supported OS\n" `RedStr "Error:"`
      exit 1
      ;;
  esac
}