#!/bin/bash

function install_all() {
  local home_dir=$HOME
  if [[ $USER == "root" ]]
  then
    home_dir=$(getent passwd $SUDO_USER | cut -d: -f6)
  fi
  local dae_dir=$home_dir/.daedalus
  local dae_sh="$dae_dir/bash"
  local dae_py="$dae_dir/python"
  local entry_file="$dae_sh/workbench.sh"
  local files_to_check=(.bashrc .bash_profile .zshrc .zprofile)
  local source_found=false
  local installed_items=()
  local bash_files=./bash_scripts/*.sh
  local python_files=./python_scripts/*.py

  echo "Installing Daedalus: This is a linux/unix only script"
  if [[ -d "$dae_dir" ]]
  then
    echo "Warning: This script will overwrite any existing daedalus installation"
    echo "Removing existing daedalus installation"
    rm -rf $dae_dir
  fi
  
  mkdir $dae_dir
  mkdir $dae_sh
  mkdir $dae_py
  touch $entry_file
  
  cp -r $bash_files $dae_sh
  chmod +x $dae_sh/*.sh
  echo "Added scripts to $dae_sh"
      
  cp -r $python_files $dae_py
  chmod +x $dae_py/*.py
  echo "Added scripts to $dae_py"

  for file in "$dae_sh"/*.sh
  do
    if [[ "$file" != "$entry_file" ]]
    then
      echo "source $file" >> $entry_file 
    fi
  done
  
  for rc_file in "${files_to_check[@]}"
  do
    local usr_rc=$home_dir/$rc_file
    echo $usr_rc
    if [[ -f "$usr_rc" ]]
    then
      source_found=true
      echo "Found $rc_file"
      local src_cmd="source $entry_file"
      if grep -q "$src_cmd" $usr_rc
      then
        echo "Daedalus already installed in $rc_file"
      else 
        echo "Adding Daedalus to $rc_file"
        printf "\n$src_cmd" >> $usr_rc
      fi
      source $usr_rc
      break
    fi
  done

  if [[ "$source_found" == false ]]
  then
    echo "No source file found"
    echo "Please add the following line to your source file"
    echo "source $dae_sh"
  else 
    echo "Installation complete"
    echo "Scripts installed:"
    installed_items+=($(grep -Prho "(?<=^function).+?(?=[\({])" $bash_files))
    installed_items+=($(grep -Prho "(?<=^alias).*(?=\=)" $bash_files))
    for item in "${installed_items[@]}"
    do
      printf "* $item\n"
    done
  fi
}

install_all