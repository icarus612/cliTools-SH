function lcount() {
	ls -1 $1 | wc -l
}

function bfor() {
	for i in $1
	do
		exec $2 $i
	done
}

function lfor() {
	location=""
	command="$1"
	if [[ -n $2 ]]
	then
		echo "location"
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