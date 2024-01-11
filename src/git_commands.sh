#!/bin/bash

function gsfor() {
    git submodule foreach --recursive "$@"
}

function gup() {
    local message="update"
		local isSubmodule=false
		local branch=""
		while getopts "bms" flag
		do
			case "${flag}" in
				m) message=$OPTARG;;
				s) isSubmodule=true;;
				b) branch=$OPTARG;;
				\?) echo "Invalid option: -$OPTARG" >&2; exit 1;;
			esac
		done
		
		if [[ "$isSubmodule" = true ]]
		then
		  gsfor "git add --all; git commit -m \"$message\"; git push $branch"
		fi
		
    
    git add --all
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
		local branch="main"
		local fetch=false
		
    while getopts "bf" flag
		do
			case "${flag}" in
				b) branch=$OPTARG;;
				f) fetch=true;;
				\?) echo "Invalid option: -$OPTARG" >&2; exit 1;;
			esac
		done
		
		if [[ "$fetch" = true ]]
    	git pull --recurse-submodules
		then
		
    gsfor 'git pull origin $branch'
}