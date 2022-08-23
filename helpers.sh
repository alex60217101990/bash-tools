#!/bin/bash
# shellcheck disable=SC2128,SC1094
. "$(dirname "$BASH_SOURCE")"/logger.sh -c=true

function GetTerminalType() {
  local terminal
  terminal="$(ps -p$$ -o cmd=\"\",comm=\"\",fname=\"\" 2>/dev/null | sed 's/^-//')"
  echo "${terminal##*/}"
}

function CreateDirIfNotExist() {
    if [[ ! -e "$1" ]]; then
       mkdir -p "$1"
    elif [[ ! -d "$1" ]]; then
        >&2 printf "%s %s already exists but is not a directory\n" "$(RedStr "Error:")" "$(YellowStr "$1")"
        exit 1
    fi
}

function Kmerge() {
  CreateDirIfNotExist "$3"
  DATE=$(date +"%Y-%m-%d.%H:%M:%S")
  cp "$HOME"/.kube/config "$HOME"/.kube/config.d/config.backup."$DATE"
  KUBECONFIG=$1:"$HOME"/.kube/config kubectl config view --merge --flatten > \
  "$HOME"/.kube/config.d/"$2"
  export KUBECONFIG="$HOME"/.kube/config.d/"$2"
}

installation_multipass()
{
  if command -v multipass > /dev/null 2>&1; then
    INFO "Multipass installation: Already installed"
  else
    if brew install --cask multipass
    then
      INFO "Multipass installation: OK"
    else
      ERROR "Multipass installation: KO";
      exit 1;
    fi
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
      >&2 printf "%s Not supported OS\n" "$(RedStr "Error:")"
      exit 1
      ;;
  esac
}