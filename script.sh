#! /bin/bash
# user interaction
clear
echo -e "
=====\n\nThis little script generates a table with the dimensions X*Y (based on user input) with cells that are either alive or dead.\nEvery cell interacts with its 8 neighbors. Here are the rules:\n\n1) A living cell with fewer than two living neighbors dies.\n2) A living cell with two or three living neighbors survives.\n3) A living cell with more than three living neighbors dies.\n4) A dead cell with three living neighbors is reborn.\n\nThe script randomly generates the starting scene (probability of living cell is P=.5).\n\n====="
x=""
while ! [[ "$x" =~ ^[0-9]+$ ]]
do
	echo -e "\n\nHow many columns do you want the table to have (integer)?\n"
	read x
done
y=""
while ! [[ "$y" =~ ^[0-9]+$ ]]
do
	echo -e "\n\nHow many rows do you want the table to have (integer)?\n"
	read y
done

# function that returns char at position n
function getchar () {
	if [ $1 -ge 0 ] && [ $1 -le $field_length ]
	then
		echo -n "${field:$1:1}"
	fi
}

# declaration of shell variables
alive=■
dead=□
fields=("")
field=""
new_field=""
field_length=$(($x*$y))
n=0

# generation of start scene (probability P=.5)
for i in $(seq $field_length)
do
	if [ $RANDOM -gt 16383 ]
	then
		new_field+=$alive
	else
		new_field+=$dead
	fi
done

# as long as table at step n is not equivalent to table at step n-1, continue...
while [ "$new_field" != "$field" ]
do
	clear
	n=$(($n+1))
	echo -e "n=$n\n■ =alive\n□ =dead\n"
	[[ " ${fields[@]} " =~ " ${new_field} " ]] && echo "Reoccuring scene detected. Since this is a loop that will not end, we'll exit the script here." && exit 0
	fields+=($field)
	field=$new_field
	new_field=""

	# print table
	position=0
	for i in $(seq $y)
	do
		for o in $(seq $x)
		do
			echo -n "$(getchar $(($position+$o-1))) "
		done
		echo ""
		position=$(($position+$x))
	done

	# iterate over all cells 
	for i in $(seq $field_length)
	do
		# the status of the cell directly above and directly below the current cell will be needed in any case (since top and bottom line are handled in function 'get character')
		array_neighbors=( $(($i-1-$x)) $(($i-1+$x)) )
		# if the cell is not in the first column, get the status of the cells left to it
		if [ $(($i % $x)) -ne 1 ]
		then
			array_neighbors+=( $(($i-2-$x)) $(($i-2)) $(($i-2+$x)) )
		fi
		# if the cell is not in the last column, get the status of the cells right to it
		if [ $(($i % $x)) -ne 0 ]
		then
			array_neighbors+=( $(($i-$x)) $(($i+$x)) $i )
		fi
		
		# count alive / dead neighbors	
		neighbors_alive=0
		neighbors_dead=0
		for e in ${array_neighbors[@]}
		do
			if [ "$(getchar $e)" == "$alive" ]
			then
				neighbors_alive=$((neighbors_alive+1))
			elif [ "$(getchar $e)" == "$dead" ]
			then
				neighbors_dead=$((neighbors_dead+1))
			fi
		done

		# follow rules mentioned in the intro
		if [ "$(getchar $(($i-1)))" == "$alive" ]
		then
			if [ $neighbors_alive -lt 2 ]
			then
				new_field+=$dead
			elif [ $neighbors_alive -lt 4 ]
			then
				new_field+=$alive
			elif [ $neighbors_alive -gt 3 ]
			then
				new_field+=$dead
			fi
		elif [ "$(getchar $(($i-1)))" == "$dead" ]
		then
			if [ $neighbors_alive -eq 3 ]
			then
				new_field+=$alive
			else
				new_field+=$dead
			fi
		fi
	done
	sleep .5
done
echo -e "\nDone! This script ended after $n iterations. This is how the final scene looks like.\n"
exit 0
