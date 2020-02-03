#!/bin/bash -x
echo "Welcome To Tic Tac Toe Game"

#Constants
ROWS=3
COLUMNS=3

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
resettingBoard
