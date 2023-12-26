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

function gsup() {
    local message=$1
    if [[ -z "$message" ]]
    then
        echo "No commit message supplied, using default message"
        message="update" 
    fi
    git submodule foreach --recursive 'git add .; git commit -m "Your commit message"; git push origin main'
    gup "$message"
}

function gclone() {
    local name=$1
    if [[ -n $2 ]]
    then
        name=$2 
    fi
    git clone git@github.com:icarus612/"$1".git $name
}

function gsubclone() {
    local name=$1
    if [[ -n $2 ]]
    then
        name=$2 
    fi
    git submodule add git@github.com:icarus612/"$1".git $name
}
