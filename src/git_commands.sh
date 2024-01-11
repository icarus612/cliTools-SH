#!/bin/bash

function gsfor() {
    git submodule foreach --recursive "$@"
}

function gup() {
    local message="update"
    local branch=""
    while getopts "bms" flag
    do
        case "${flag}" in
            m) message=$OPTARG;;
            b) branch=$OPTARG;;
            s) gsfor "git add --all; git commit -m \"$message\"; git push $branch";;
            \?) echo "Invalid option: -$OPTARG" >&2; exit 1;;
        esac
    done
		
    
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
		
    while getopts "bif" flag
		do
			case "${flag}" in
				b) branch=$OPTARG;;
				i) git submodule update --init --recursive;;
				f) git pull --recurse-submodules;;
				\?) echo "Invalid option: -$OPTARG" >&2; exit 1;;
			esac
		done
		
    gsfor 'git pull origin $branch'
}