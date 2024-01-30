#!/bin/bash

function gsfor() {
  git submodule foreach --recursive "$@"
}

function gup() {
	local message="update"
	local isSubmodule=false
	local branch=""
	OPTIND=1
	while getopts ":b:m:s" flag
	do
		case "${flag}" in
			m) message=$OPTARG;;
			b) branch=$OPTARG;;
			s) isSubmodule=true;;
			\?) 
				echo "Invalid option: -$OPTARG" >&2
				return 
			;;
		esac
	done
	shift $((OPTIND - 1))
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
	OPTIND=1
	while getopts ":b:if" flag
	do
		case "${flag}" in
			b) branch=$OPTARG;;
			i) git submodule update --init --recursive;;
			f) git fetch --recurse-submodules;;
			\?) echo "Invalid option: -$OPTARG" >&2; exit 1;;
		esac
	done
	shift $((OPTIND - 1))
	gsfor 'git pull origin $branch'
	git pull
}