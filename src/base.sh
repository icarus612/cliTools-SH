function lcount() {
	ls -1 $1 | wc -l
}

function bfor() {
	echo $1 
	echo $2
	$1 | xargs -I {} exec "$2" 
}

function lfor() {
	location=""
	command="$1"
	if [[ -z $2 ]]
	then
		location="$1"
		command="$2"
	fi
	
	bfor "ls $location" "$command"
}

function cfor() {
	location=""
	command="$1"
	if [[ -n $2 ]]
	then
		location="$1"
		command="$2"
	fi
	
	bfor "$(cat $location)" "$command"
}