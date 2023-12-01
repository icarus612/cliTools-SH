#!/bin/bash

function gup() {
    local message=$1
    echo $message
    if [[ -z "$message" ]]; then
        echo "No commit message supplied, using default message"
        message="update" 
    fi
    git add .
    git commit -m "$message"
    git push
}