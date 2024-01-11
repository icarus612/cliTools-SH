#!/bin/bash

function gsfor() {
    git submodule foreach --recursive "$@"
}

function gup() {
    local message="update"
		local add="."
		local isSubmodule=false
		local branch=""
		while getopts "bams" flag
		do
			case "${flag}" in
				m) message=$OPTARG;;
				a) add="--all";;
				s) isSubmodule=true;;
				b) branch=$OPTARG;;
			esac
		done
		
		if [[ "$isSubmodule" = true ]]
		then
		  gsfor "git add $add; git commit -m \"$message\"; git push $branch"
		fi
		
    
    git add $add
    git commit -m "$message"
    git push $branch
}

function gsinit() {
    git submodule update --init --recursive
}

function gclone() {
    local name=$1
    if [[ -n $2 ]]
    then
        name=$2 
    fi
    git clone git@github.com:icarus612/"$1".git $name
    cd $name 
    gsinit &
    cd -
}

function gsadd() {
    local name=$1
    if [[ -n $2 ]]
    then
        name=$2 
    fi
    git submodule add git@github.com:icarus612/"$1".git $name
}

function gspull() {
		local branch=$1
    if [[ -z "$message" ]]
    then
      branch="main" 
    fi
    git pull --recurse-submodules
    git submodule foreach --recursive 'git pull origin $branch'
}