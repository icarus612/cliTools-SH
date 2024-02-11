#!/bin/bash

function gsfor() {
  git submodule foreach --recursive "$@"
}

function gup() {
	if [[ $(git rev-parse --is-inside-work-tree) != true ]]
	then
		return
	fi

	local message="update"
	local is_submodule=false
	local sub_base='.'
	local branch=""
	while getopts "b:m:sS" flag
	do
		case "${flag}" in
			m) message=$OPTARG;;
			b) branch=$OPTARG;;
			s) is_submodule=true;;
			S) 
				is_submodule=true
				sub_base=$(git rev-parse --show-toplevel)
				;;
			\?) 
				echo "Invalid option: -$OPTARG" >&2
				return 
			;;
		esac
	done
	shift $((OPTIND - 1))
	OPTIND=1

	if [[ "$is_submodule" = true ]]
	then
		find $sub_base -name .git | while read line
		do
			local location=$(dirname $line)
			echo "Entering $(basename $location)" 
			cd $location
			git add --all
			if ! git diff-index --quiet $branch HEAD
			then
				git commit -m "$message" -q
				git push $branch -q
			fi
			cd -
		done
	fi
	
	git add --all
	git commit -m "$message"
	git push $branch
}

function gsinit() {
  git submodule update --init --recursive
  gsfor 'git checkout main'
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
	while getopts "b:if" flag
	do
		case "${flag}" in
			b) branch=$OPTARG;;
			i) git submodule update --init --recursive;;
			f) git fetch --recurse-submodules;;
			\?) echo "Invalid option: -$OPTARG" >&2; exit 1;;
		esac
	done
	shift $((OPTIND - 1))
	OPTIND=1
	gsfor 'git pull origin $branch'
	git pull
}