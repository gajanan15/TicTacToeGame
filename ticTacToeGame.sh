#!/bin/bash
echo "Welcome To Tic Tac Toe Game"

#Constants
ROWS=3
COLUMNS=3
X=0
PLAYER=1

#Variable
counter=1

#Declare Array
declare -a boardOfGame

function resettingBoard() {
	for((i=0;i<ROWS;i++))
	do
		for((j=0;j<COLUMNS;j++))
		do
			boardOfGame[$i,$j]=""
		done
	done
}

function assignedLetter() {
	if [ $((RANDOM%2)) -eq $X ]
	then
		echo "Assigned Letter: X"
	else
		echo "Assigned Letter: O"
	fi
}

function whoWillPlayFirst() {
	if [ $((RANDOM%2)) -eq $PLAYER ]
	then
		echo "Player Play First"
	else
		echo "Computer Play First"
	fi
}

function displayGameBoard() {
	for((i=1;i<=ROWS;i++))
	do
		echo "=================="
		echo -n "||"
		for((j=1;j<=COLUMNS;j++))
		do
			if [ boardOfGame[$i,$j] == 0 ]
			then
				echo " X |"
			elif [ boardOfGame[$i,$j] == 1 ]
			then
				echo " O |"
			else
				#echo -n "   |"
				echo -n " $counter  |"
				((counter++))
			fi
		done
		echo  "|"
	done
	echo "=================="
}
resettingBoard
assignedLetter
whoWillPlayFirst
displayGameBoard
