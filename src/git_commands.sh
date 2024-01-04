#!/bin/bash

function gup() {
    local message=$1
    if [[ -z "$message" ]]
    then
        echo "No commit message supplied, using default message"
        message="update" 
    fi
    
    git add --all
    git commit -m "$message"
    git push
}
function gsfor() {
    git submodule foreach --recursive "$@"
}

function gsup() {
    local message=$1
    if [[ -z "$message" ]]
    then
        echo "No commit message supplied, using default message"
        message="update" 
    fi
    gsfor "git add --all; git commit -m \"$message\"; git push"
    gup "$message"
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

function gsclone() {
    local name=$1
    if [[ -n $2 ]]
    then
        name=$2 
    fi
    git submodule add git@github.com:icarus612/"$1".git $name
}

function gspull() {
    git submodule foreach --recursive 'git pull origin main'
    git pull --recurse-submodules
}