#!/bin/bash

function install_all() {
  local dae_dir=/usr/bin/.daedalus
  local dae_sh="$dae_dir/bash.sh"
  local dae_py="$dae_dir/python"
  local bash_files=./bash_scripts/**.sh
  local files_to_check=(.bashrc .bash_profile .zshrc .zprofile)
  local source_found=false
  local installed_items=()
  
  echo "Installing Daedalus: This is a linux/unix only script"
  if [[ -d "$dae_dir" ]]; then
    echo "Warning: This script will overwrite any existing daedalus installation"
    echo "Removing existing daedalus installation"
    rm -rf $dae_dir
  fi
  mkdir $dae_dir
  
  touch $dae_sh
  for b_file in "${bash_files[@]}"
  do
    if ### need to finish out this line
    cat $b_file >> $dae_sh
  done
  echo "Added scripts to $dae_sh"
      
  mkdir $dae_py
  cp -r ./python_scripts/*.py $dae_py
  chmod +x $dae_py/*.py
  echo "Added scripts to $dae_py"
  source $dae_sh

  for rc_file in "${files_to_check[@]}"
  do
    local usr_rc=/home/$(logname)/$rc_file
    
    if [[ -f "$usr_rc" ]]; then
      source_found=true
      echo "Found $rc_file"
      if grep -q "source $dae_sh" $usr_rc
      then
        echo "Daedalus already installed in $rc_file"
      else 
        echo "Adding Daedalus to $rc_file"
        printf "\nsource $dae_sh" >> $usr_rc
        source $usr_rc
      fi
      break
    fi
  done

  if [[ "$source_found" == false ]]
  then
    echo "No source file found"
    echo "Please add the following line to your source file"
    echo "source $dae_sh"
  else 
    echo "Source file found"
    echo "Installation complete"
    echo "Scripts installed:"
    installed_items+=($(grep -Prho "(?<=^function).+?(?=[\({])" $bash_files))
    installed_items+=($(grep -Prho "^alias.*=" $bash_files))
    for item in "${installed_items[@]}"
    do
      echo $item
    done
  fi
}

install_all