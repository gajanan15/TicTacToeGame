#!/bin/bash
echo "Welcome To Tic Tac Toe Game"

#Constants
ROWS=3
COLUMNS=3
X=0
O=1

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

resettingBoard
assignedLetter
