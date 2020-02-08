#!/bin/bash
echo "Welcome To Tic Tac Toe Game"

#Constants
ROWS=3
COLUMNS=3
PLAYER=0
TOTAL_MOVE=9

#Variable
count=0
tieCount=0

#Declare Dictionary
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

#Game Start
function playGame() {
	while [[ $count -lt $TOTAL_MOVE ]]
	do
		if [ $flag == 0 ]
		then
			echo "Player Play"
			read -p "Enter Player Row " row
			read -p "Enter Player Col " col
			if [[ $row -ge $ROWS || $col -ge $COLUMNS ]]
			then
				echo "Invalid"
			elif [[ ${boardOfGame[$row,$col]} != $PLAYER_LETTER && ${boardOfGame[$row,$col]} != $COMPUTER_LETTER ]]
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
			checkFlag=0
			echo "Computer Play"
			if [ $checkFlag -eq 0 ]
			then
				computerWinningBoard $COMPUTER_LETTER $COMPUTER_LETTER
			fi
			if [ $checkFlag -eq 0 ]
			then
				computerWinningBoard $PLAYER_LETTER $COMPUTER_LETTER
			fi
			if [ $checkFlag -eq 0 ]
			then
				takingCornerPosition $COMPUTER_LETTER
			fi
			checkForWin $COMPUTER_LETTER
			((count++))
			flag=0
		fi
	done
}

function checkForWin() {
	((tieCount++))
	letter=$1
	displayGameBoard
	winAtRowAndColumnPosition	$letter
	winAtDiagonalPosition $letter
	if [ $tieCount -gt 8 ]
	then
		echo "It's a Tie"
		exit
	fi
}

function computerWinChecking() {
	local m=$1
	local n=$2
	letter=$3
	if [[ ${boardOfGame[$m,$n]} == $letter ]]
	then
		((checkCount++))
	elif [[ ${boardOfGame[$m,$n]} == $"-" ]]
	then
		((newLetterCount++))
		row=$m
		column=$n
	fi
}

function reassignCounter() {
		checkCount=0
		newLetterCount=0
}

function checkCounterAndChangeFlagValue() {
	if [[ $checkCount -eq 2 && $newLetterCount -eq 1 ]]
	then
		boardOfGame[$row,$column]=$putLetter
		checkFlag1=1
		checkFlag=1
	fi
}

function computerWinningBoard() {
	checkLetter=$1
	putLetter=$2
	checkFlag=0
	checkFlag1=0

	#Computer Checks All 3 Possible Winning Row Position
	if [ $checkFlag1 -eq 0 ]
	then
		for((i=0;i<ROWS;i++))
		do
			reassignCounter
			for((j=0;j<COLUMNS;j++))
			do
				computerWinChecking $i $j $checkLetter
			done
			checkCounterAndChangeFlagValue $row $column $putLetter
		done
	fi

	#Computer Checks All 3 Possible Winning Columns Position
	if [ $checkFlag1 -eq 0 ]
	then
		for((i=0;i<ROWS;i++))
		do
			reassignCounter
			for((j=0;j<COLUMNS;j++))
			do
				computerWinChecking $j $i $checkLetter
			done
			checkCounterAndChangeFlagValue $row $column $putLetter
		done
	fi

	#Computer Check 1 Possible Winning Diagonal Position
	if [ $checkFlag1 -eq 0 ]
	then
		reassignCounter
		for((i=0;i<ROWS;i++))
		do
			for((j=0;j<COLUMNS;j++))
			do
				if [ $i -eq $j ]
				then
					computerWinChecking $i $j $checkLetter
				fi
			done
		done
		checkCounterAndChangeFlagValue $row $column $putLetter
	fi

	#Computer Check 2nd Possible Winning Diagonal Position
	if [ $checkFlag1 -eq 0 ]
	then
		reassignCounter
		for((i=0;i<ROWS;i++))
		do
			for((j=$((2-$i));j<COLUMNS;j++))
			do
				computerWinChecking $i $j $checkLetter
				break
			done
		done
		checkCounterAndChangeFlagValue $row $column $putLetter
	fi
}

function takingCornerPosition(){
	checkFlag=0
	local putLetter=$1
	for((i=0;i<ROWS;i=$(($i+2))))
	do
		for((j=0;j<COLUMNS;j=$(($j+2))))
		do
			if [[ ${boardOfGame[$i,$j]} == "-" ]]
			then
				boardOfGame[$i,$j]=$putLetter
				checkFlag=1
				return
			fi
		done
	done
}

function playerOrComputerWon() {
	local letter=$1
	if [[ $letter == $PLAYER_LETTER ]]
	then
		echo "Player Won"
	else
		echo "Computer Won"
	fi
	exit
}

function winAtRowAndColumnPosition() {
	letter=$1
	for((r=0;r<ROWS;r++))
	do
		for((c=0;c<COLUMNS;c++))
		do
			if [[ ${boardOfGame[$r,$c]} == ${boardOfGame[$r,$(($c+1))]} ]] && [[ ${boardOfGame[$r,$(($c+1))]} == ${boardOfGame[$r,$(($c+2))]} ]] && [[ ${boardOfGame[$r,$c]} == $letter ]]
			then
				playerOrComputerWon $letter
			elif [[ ${boardOfGame[$r,$c]} == ${boardOfGame[$(($r+1)),$c]} ]] && [[ ${boardOfGame[$(($r+1)),$c]} == ${boardOfGame[$(($r+2)),$c]} ]] && [[ ${boardOfGame[$r,$c]} == $letter ]]
			then
				playerOrComputerWon $letter
			fi
		done
	done
}

function	winAtDiagonalPosition() {
	letter=$1
	if [[ ${boardOfGame[0,0]} == ${boardOfGame[1,1]} ]] && [[ ${boardOfGame[1,1]} == ${boardOfGame[2,2]} ]] && [[ ${boardOfGame[0,0]} == $letter ]]
	then
		playerOrComputerWon $letter
	elif [[ ${boardOfGame[0,2]} == ${boardOfGame[1,1]} ]] && [[ ${boardOfGame[1,1]} == ${boardOfGame[2,0]} ]] && [[ ${boardOfGame[0,2]} == $letter ]]
	then
		playerOrComputerWon $letter
	fi
}

resettingBoard
assignedLetter
whoWillPlayFirst
displayGameBoard
playGame
