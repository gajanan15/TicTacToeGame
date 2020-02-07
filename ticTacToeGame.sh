#!/bin/bash
echo "Welcome To Tic Tac Toe Game"

#Constants
ROWS=3
COLUMNS=3
PLAYER=0
TOTAL_MOVE=9

#Variable
count=0
flag=0
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
			checkFlag=0
			echo "Computer Play"
			computerWinningBoard $COMPUTER_LETTER $COMPUTER_LETTER
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
	winAtDiagonal $letter
	if [ $tieCount -gt 8 ]
	then
		echo "It's  a Tie"
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

function computerWinningBoard() {
	checkLetter=$1
	putLetter=$2
	checkFlag=0
	checkFlag1=0
	#for row win check
	if [ $checkFlag1 -eq 0 ]
	then
		for((i=0;i<3;i++))
		do
			checkCount=0
			newLetterCount=0
			for((j=0;j<3;j++))
			do
				computerWinChecking $i $j $checkLetter
			done
		if [[ $checkCount -eq 2 && $newLetterCount -eq 1 ]]
		then
			boardOfGame[$row,$column]=$putLetter
			checkFlag1=1
			checkFlag=1
		fi
	done
	fi

	#for col win check
	if [ $checkFlag1 -eq 0 ]
	then
		for((i=0;i<3;i++))
		do
			checkCount=0
			newLetterCount=0
			for((j=0;j<3;j++))
			do
				computerWinChecking $j $i $checkLetter
			done
			if [[ $checkCount -eq 2 && $newLetterCount -eq 1 ]]
			then
				boardOfGame[$row,$column]=$putLetter
				checkFlag1=1
				checkFlag=1
			fi
		done
	fi

	#for diagonal
	if [ $checkFlag1 -eq 0 ]
	then
		checkCount=0
		newLetterCount=0
		for((i=0;i<3;i++))
		do
			for((j=0;j<3;j++))
			do
				if [ $i -eq $j ]
				then
					computerWinChecking $i $j $checkLetter
				fi
			done
		done
		if [ $checkCount -eq 2 -a $newLetterCount -eq 1 ]
		then
			boardOfGame[$row,$column]=$putLetter
			checkFlag1=1
			checkFlag=1
		fi
	fi

	#diagonal right to left
	if [ $checkFlag1 -eq 0 ]
	then
		checkCount=0
		newLetterCount=0
		for((i=0;i<3;i++))
		do
			for((j=$((2-$i));j<3;j++))
			do
				computerWinChecking $i $j $checkLetter
				break
			done
		done
		if [[ $checkCount -eq 2 && $newLetterCount -eq 1 ]]
		then
			boardOfGame[$row,$column]=$putLetter
			checkFlag1=1
			checkFlag=1
		fi
	fi
}

function playerOrComputerWon() {
	local Letter=$1
	if [[ $Letter == $PLAYER_LETTER ]]
	then
		echo "Player Won"
	else
		echo "Computer Won"
	fi
	exit
}

function winAtRowAndColumnPosition() {
	letter=$1
	for((r=0;r<$ROWS;r++))
	do
		for((c=0;c<$COLUMNS;c++))
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

function winAtDiagonal() {
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
