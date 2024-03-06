#!/bin/bash

function gsf() {
	git submodule foreach $@
}

function gsfor() {
	if [[ $(git rev-parse --is-inside-work-tree) != true ]]; then
		return
	fi
	
	local sub_base=$(git rev-parse --show-toplevel)
	local current_dir=$(pwd)

	while getopts "l" flag; do
		case "${flag}" in
		l) sub_base="." ;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			return
			;;
		esac
	done

	shift $((OPTIND - 1))
	OPTIND=1

	find $sub_base -type f -name .git | while read line; do
		local location=$(dirname $line)
		local loc_base=$(basename $location)
		cd $location
		$@
	done
	cd $current_dir
}

function gup() {
	if [[ $(git rev-parse --is-inside-work-tree) != true ]]; then
		return
	fi

	local is_remote_init=false
	local is_submodule_init=false
	local is_submodule=false
	local is_origin=false
	local remote_opts=""
	local message="update"
	local sub_base='.'
	local branch=""

	while getopts ":b:B:m:i:I:sS" flag; do
		case "${flag}" in
		b) branch=$OPTARG ;;
		B)
			branch=$OPTARG
			is_origin=true
			;;
		m) message=$OPTARG ;;
		i)
			is_remote_init=true
			remote_opts=$OPTARG
			;;
		I)
			is_remote_init=true
			is_submodule_init=true
			remote_opts=$OPTARG
			;;
		s) is_submodule=true ;;
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

	if [[ "$is_submodule" = true ]]; then
		find $sub_base -type f -name .git | while read line; do
			local location=$(dirname $line)
			local loc_base=$(basename $location)
			echo "Entering $location"
			cd $location
			git add --all
			if ! git diff-index --quiet $branch HEAD; then
				echo "Changes found"
				git push origin $branch -q

				git commit -m "$message" -q
				echo "Pushing changes to $loc_base"
			else
				echo "No changes in $loc_base"
			fi
			echo ""
			cd - >/dev/null
		done
	fi

	if [[ "$is_remote_init" = true ]]; then
		echo "Creating remote repository"
		gh repo create
		branch="-u origin main"
		if [[ "$is_submodule_init" = true ]]; then
			echo "Initializing as submodules"
			local repo_url=$(git config --get remote.origin.url)
			local current_dir=$(pwd)
			rm -rf .git
			cd ..
			git rm --cached -r $current_dir
			git submodule add $repo_url $current_dir
			cd $current_dir
		fi
	fi

	git add --all
	git commit -m "$message"
	if [[ "$is_origin" = true ]]; then
		git push -u origin $branch
	else
		git push $branch
	fi
}

function gsinit() {
	git submodule update --init --recursive
	gsfor 'git checkout main'
}

function gclone() {
	local name=$1
	if [[ -n $2 ]]; then
		name=$2
	fi
	git clone git@github.com:icarus612/"$1".git $name
	cd $name
	gsinit &
	cd -
}

function gsclone() {
	local name=$1
	if [[ -n $2 ]]; then
		name=$2
	fi
	git submodule add git@github.com:icarus612/"$1".git $name
}

function gspull() {
	local branch="main"
	while getopts "b:if" flag; do
		case "${flag}" in
		b) branch=$OPTARG ;;
		i) git submodule update --init --recursive ;;
		f) git fetch --recurse-submodules ;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			exit 1
			;;
		esac
	done
	shift $((OPTIND - 1))
	OPTIND=1
	gsfor 'git pull origin $branch'
	git pull

}
