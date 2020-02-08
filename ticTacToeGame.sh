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

function assignedSymbol() {
	if [ $((RANDOM%2)) -eq 1 ]
	then
		PLAYER_SYMBOL=$"X"
		COMPUTER_SYMBOL=$"O"
	else
		PLAYER_SYMBOL=$"O"
		COMPUTER_SYMBOL=$"X"
	fi
	echo "Assigned Player Symbol: " $PLAYER_SYMBOL
	echo "Assigned Computer Symbol: " $COMPUTER_SYMBOL
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
			elif [[ ${boardOfGame[$row,$col]} != $PLAYER_SYMBOL && ${boardOfGame[$row,$col]} != $COMPUTER_SYMBOL ]]
			then
				boardOfGame[$row,$col]=$PLAYER_SYMBOL
				checkForWin $PLAYER_SYMBOL
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
				computerWinningBoard $COMPUTER_SYMBOL
			fi
			if [ $checkFlag -eq 0 ]
			then
				computerWinningBoard $PLAYER_SYMBOL
			fi
			if [ $checkFlag -eq 0 ]
			then
				takingCornerPosition
			fi
			if [ $checkFlag -eq 0 ]
			then
				takingCenterPosition
			fi
			checkForWin $COMPUTER_SYMBOL
			((count++))
			flag=0
		fi
	done
}

function checkForWin() {
	((tieCount++))
	symbol=$1
	displayGameBoard
	winAtRowAndColumnPosition	$symbol
	winAtDiagonalPosition $symbol
	if [ $tieCount -gt 8 ]
	then
		echo "It's a Tie"
		exit
	fi
}

function computerWinChecking() {
	local m=$1
	local n=$2
	symbol=$3
	if [[ ${boardOfGame[$m,$n]} == $symbol ]]
	then
		((checkCount++))
	elif [[ ${boardOfGame[$m,$n]} == $"-" ]]
	then
		((newSymbolCount++))
		row=$m
		column=$n
	fi
}

function reassignCounter() {
		checkCount=0
		newSymbolCount=0
}

function checkCounterAndChangeFlagValue() {
	if [[ $checkCount -eq 2 && $newSymbolCount -eq 1 ]]
	then
		boardOfGame[$row,$column]=$COMPUTER_SYMBOL
		checkFlag1=1
		checkFlag=1
	fi
}

function computerWinningBoard() {
	checkSymbol=$1
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
				computerWinChecking $i $j $checkSymbol
			done
			checkCounterAndChangeFlagValue $row $column
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
				computerWinChecking $j $i $checkSymbol
			done
			checkCounterAndChangeFlagValue $row $column
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
					computerWinChecking $i $j $checkSymbol
				fi
			done
		done
		checkCounterAndChangeFlagValue $row $column
	fi

	#Computer Check 2nd Possible Winning Diagonal Position
	if [ $checkFlag1 -eq 0 ]
	then
		reassignCounter
		for((i=0;i<ROWS;i++))
		do
			for((j=$((2-$i));j<COLUMNS;j++))
			do
				computerWinChecking $i $j $checkSymbol
				break
			done
		done
		checkCounterAndChangeFlagValue $row $column
	fi
}

function takingCornerPosition(){
	checkFlag=0
	for((i=0;i<ROWS;i=$(($i+2))))
	do
		for((j=0;j<COLUMNS;j=$(($j+2))))
		do
			if [[ ${boardOfGame[$i,$j]} == "-" ]]
			then
				boardOfGame[$i,$j]=$COMPUTER_SYMBOL
				checkFlag=1
				return
			fi
		done
	done
}

function takingCenterPosition() {
	checkFlag=0
	if [[ ${boardOfGame[1,1]} == $"-" ]]
	then
		boardOfGame[1,1]=$COMPUTER_SYMBOL
	else
		checkFlag=1
	fi
}

function playerOrComputerWon() {
	local symbol=$1
	if [[ $symbol == $PLAYER_SYMBOL ]]
	then
		echo "Player Won"
	else
		echo "Computer Won"
	fi
	exit
}

function winAtRowAndColumnPosition() {
	symbol=$1
	for((r=0;r<ROWS;r++))
	do
		for((c=0;c<COLUMNS;c++))
		do
			if [[ ${boardOfGame[$r,$c]} == ${boardOfGame[$r,$(($c+1))]} ]] && [[ ${boardOfGame[$r,$(($c+1))]} == ${boardOfGame[$r,$(($c+2))]} ]] && [[ ${boardOfGame[$r,$c]} == $symbol ]]
			then
				playerOrComputerWon $symbol
			elif [[ ${boardOfGame[$r,$c]} == ${boardOfGame[$(($r+1)),$c]} ]] && [[ ${boardOfGame[$(($r+1)),$c]} == ${boardOfGame[$(($r+2)),$c]} ]] && [[ ${boardOfGame[$r,$c]} == $symbol ]]
			then
				playerOrComputerWon $symbol
			fi
		done
	done
}

function	winAtDiagonalPosition() {
	symbol=$1
	if [[ ${boardOfGame[0,0]} == ${boardOfGame[1,1]} ]] && [[ ${boardOfGame[1,1]} == ${boardOfGame[2,2]} ]] && [[ ${boardOfGame[0,0]} == $symbol ]]
	then
		playerOrComputerWon $symbol
	elif [[ ${boardOfGame[0,2]} == ${boardOfGame[1,1]} ]] && [[ ${boardOfGame[1,1]} == ${boardOfGame[2,0]} ]] && [[ ${boardOfGame[0,2]} == $symbol ]]
	then
		playerOrComputerWon $symbol
	fi
}

resettingBoard
assignedSymbol
whoWillPlayFirst
displayGameBoard
playGame
