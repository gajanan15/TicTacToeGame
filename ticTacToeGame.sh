#!/bin/bash -x
echo "Welcome To Tic Tac Toe Game"

#Constants
ROWS=3
COLUMNS=3
PLAYER=0
TOTAL_MOVE=9

#Variable
count=0
flag=0

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
		COMPUTER_LETTER=$"O"
	else
		PLAYER_LETTER=$"O"
		COMPUTER_LETTER=$"X"
	fi
	echo "Assigned Player Letter: " $PLAYER_LETTER
	echo "Assigned Computer Letter: " $COMPUTER_LETTER
}

function whoWillPlayFirst() {
	if [ $((RANDOM%2)) -eq $PLAYER ]
	then
		flag=0
		echo "Player Play First"
	else
		flag=1
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
	while [[ $count -lt $TOTAL_MOVE ]]
	do
		if [ $flag == 0 ]
		then
			echo "Player Play"
			read -p "Enter Player Row " row
			read -p "Enter Player Col " col
			if [[ $row -ge $ROWS && $col -ge $COLUMNS ]]
			then
				echo "Invalid"
			elif [[ ${boardOfGame[$row,$col]} != $PLAYER_LETTER ]]
			then
				boardOfGame[$row,$col]=$PLAYER_LETTER
				checkForWin $PLAYER_LETTER
				((count++))
				flag=1
			else
				echo "Cell Is Not Empty"
			fi
		elif [ $flag == 1 ]
		then
			echo "Computer Play"
			row=$((RANDOM%3))
			col=$((RANDOM%3))
			if [[ ${boardOfGame[$row,$col]} != $PLAYER_LETTER && ${boardOfGame[$row,$col]} != $COMPUTER_LETTER ]]
			then
				boardOfGame[$row,$col]=$COMPUTER_LETTER
				checkForWin $COMPUTER_LETTER
				flag=0
				((count++))
			fi
		fi
	done
}

function checkForWin() {
	Letter=$1
	displayGameBoard
	winAtRowPosition	$1
	winAtColumnPosition $1
	winAtDiagonal $1
}
function winAtRowPosition() {
	Letter=$1
	for((r=0;r<$ROWS;r++))
	do
		for((c=0;c<$COLUMNS;c++))
		do
			if [[ ${boardOfGame[$r,$c]} == ${boardOfGame[$r,$(($c+1))]} ]] && [[ ${boardOfGame[$r,$(($c+1))]} == ${boardOfGame[$r,$(($c+2))]} ]] && [[ ${boardOfGame[$r,$c]} == $Letter ]]
			then
				echo $Letter "Win"
				exit
			fi
		done
	done
}

function winAtColumnPosition() {
	Letter=$1
	for((r=0;r<$ROWS;r++))
	do
		for((c=0;c<$COLUMNS;c++))
		do
			if [[ ${boardOfGame[$r,$c]} == ${boardOfGame[$(($r+1)),$c]} ]] && [[ ${boardOfGame[$(($r+1)),$c]} == ${boardOfGame[$(($r+2)),$c]} ]] && [[ ${boardOfGame[$r,$c]} == $Letter ]]
			then
				echo $Letter "Win"
				exit
			fi
		done
	done
}

function winAtDiagonal() {
	Letter=$1
	if [[ ${boardOfGame[0,0]} == ${boardOfGame[1,1]} ]] && [[ ${boardOfGame[1,1]} == ${boardOfGame[2,2]} ]] && [[ ${boardOfGame[0,0]} == $Letter ]]
	then
		echo $Letter "Win"
		exit
	elif [[ ${boardOfGame[0,2]} == ${boardOfGame[1,1]} ]] && [[ ${boardOfGame[1,1]} == ${boardOfGame[2,0]} ]] && [[ ${boardOfGame[0,2]} == $Letter ]]
	then
		echo $Letter "Win"
		exit
	fi
}

resettingBoard
assignedLetter
whoWillPlayFirst
displayGameBoard
playGame
