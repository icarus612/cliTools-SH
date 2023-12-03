#!/usr/bin/python3

function dae () {
  local HOME_DIR=$HOME
  if $USER == "root"
  then
    HOME_DIR=$(getent passwd $SUDO_USER | cut -d: -f6)
  fi
  python3 $HOME_DIR/.daedalus/python/$1.py $@
}