#!/bin/bash -x
echo "Welcome To Tic Tac Toe Game"

#Constants
ROWS=3
COLUMNS=3
PLAYER=0

#Variable
count=0

#Declare Array
declare -A boardOfGame


function resettingBoard() {
	for((i=0;i<ROWS;i++))
	do
		for((j=0;j<COLUMNS;j++))
		do
			boardOfGame[$i,$j]="-"
		done
	done
}

function assignedLetter() {
	if [ $((RANDOM%2)) -eq 1 ]
	then
		PLAYER_LETTER=$"X"
	else
		PLAYER_LETTER=$"O"
	fi
	echo "Assigned Letter: " $PLAYER_LETTER
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
	echo "==============="
	for((i=0;i<ROWS;i++))
	do
		for((j=0;j<COLUMNS;j++))
		do
			echo -n "| ${boardOfGame[$i,$j]} |"
		done
		echo
		echo "==============="
	done
}

function playGame() {
	while [[ $count -lt 9 ]]
	do
		read -p "Enter Player Row " row
		read -p "Enter Player Col " col
		if [[ ${boardOfGame[$row,$col]} != $PLAYER_LETTER ]]
		then
			boardOfGame[$row,$col]=$PLAYER_LETTER
			displayGameBoard
			winAtRowPosition	$PLAYER_LETTER
			winAtColPosition $PLAYER_LETTER
			winAtDia $PLAYER_LETTER
			((count++))
		else
			echo "Invalid"
		fi
	done
}

function winAtRowPosition() {
	for((r=0;r<3;r++))
	do
		for((c=0;c<3;c++))
		do
			if [[ ${boardOfGame[$r,$c]} == ${boardOfGame[$r,$(($c+1))]} ]] && [[ ${boardOfGame[$r,$(($c+1))]} == ${boardOfGame[$r,$(($c+2))]} ]] && [[ ${boardOfGame[$r,$c]} == $1 ]]
			then
				echo $1 "Win"
				exit
			fi
		done
	done
}

function winAtColPosition() {
	for((r=0;r<3;r++))
	do
		for((c=0;c<3;c++))
		do
			if [[ ${boardOfGame[$r,$c]} == ${boardOfGame[$(($r+1)),$c]} ]] && [[ ${boardOfGame[$(($r+1)),$c]} == ${boardOfGame[$(($r+2)),$c]} ]] && [[ ${boardOfGame[$r,$c]} == $1 ]]
			then
				echo $1 "Win"
				exit
			fi
		done
	done
}

function winAtDia() {
	if [[ ${boardOfGame[0,0]} == ${boardOfGame[1,1]} ]] && [[ ${boardOfGame[1,1]} == ${boardOfGame[2,2]} ]] && [[ ${boardOfGame[0,0]} == $1 ]]
	then
		echo $1 "Win"
		exit
	elif [[ ${boardOfGame[0,2]} == ${boardOfGame[1,1]} ]] && [[ ${boardOfGame[1,1]} == ${boardOfGame[2,0]} ]] && [[ ${boardOfGame[0,2]} == $1 ]]
	then
		echo $1 "Win"
		exit
	fi
}

resettingBoard
assignedLetter
whoWillPlayFirst
displayGameBoard
playGame
