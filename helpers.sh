#!/bin/bash
. $(dirname "$(readlink -f "$BASH_SOURCE")")/logger.sh -c=true

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
      printf "macos"
      ;;
    *)
      >&2 printf "$%s Not supported OS\n" `RedStr "Error:"`
      exit 1
      ;;
  esac
}