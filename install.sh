#!/bin/bash
function install_all() {
  local dae=/usr/bin/.daedalus.sh
  local install_files=./src/**.sh
  local files_to_check=(~/.bashrc ~/.bash_profile ~/.zshrc ~/.zprofile)
  local source_found=false
  local installed_items=()
  
  echo "Installing Daedalus"
  echo "Warning: This is a linux/unix only script"
  touch $dae
  cat $install_files >> $dae
  echo "Added scripts to $dae"
      
  for rc_file in "${files_to_check[@]}"
  do
    echo $rc_file
    if [[ -f "$rc_file" ]]; then
      echo "Found $rc_file"
      echo "Adding to $rc_file"
      cat "$dae" >> $rc_file
      source $rc_file
      source_found=true
      break
    fi
  done

  if [[ "$source_found" == false ]]
  then
    echo "No source file found"
    echo "Please add the following line to your source file"
    echo "source $dae"
  else 
    echo "Source file found"
    echo "Installation complete"
    echo "Scripts installed:"
    installed_items+=$(grep -r -Po "(?<=^function).+?(?=[\({])" $install_files)
    installed_items+=$(grep -r -Po "^alias.*=" $install_files)
    echo $installed_items
  fi
}

install_all