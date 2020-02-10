#!/bin/bash
echo "Welcome To Tic Tac Toe Game"

#Constants
ROWS=3
COLUMNS=3
PLAYER=0

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
		PLAYER_SYMBOL="X"
		COMPUTER_SYMBOL="O"
	else
		PLAYER_SYMBOL="O"
		COMPUTER_SYMBOL="X"
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
	while [[ $count -lt $(($ROWS*$COLUMNS)) ]]
	do
		if [ $flag == 0 ]
		then
			echo "Player Play"
			read -p "Enter Player Row " row
			read -p "Enter Player Col " column
			if [[ $row -ge $ROWS || $column -ge $COLUMNS ]]
			then
				echo "Invalid"
			elif [[ ${boardOfGame[$row,$column]} != $PLAYER_SYMBOL && ${boardOfGame[$row,$column]} != $COMPUTER_SYMBOL ]]
			then
				boardOfGame[$row,$column]=$PLAYER_SYMBOL
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
			if [ $checkFlag -eq 0 ]
			then
				takingSidePosition
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
	winAtRowAndColumnPosition $symbol
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
	fi
	if [[ ${boardOfGame[$m,$n]} == "-" ]]
	then
		((newSymbolCount++))
		row=$m
		column=$n
	fi
}

#reset Counter
function reassignCounter() {
		checkCount=0
		newSymbolCount=0
}

#check Counter and Change falg value
function checkCounterAndChangeFlagValue() {
	local rowValue=$1
	local columnValue=$2
	if [[ $checkCount -eq 2 && $newSymbolCount -eq 1 ]]
	then
		boardOfGame[$rowValue,$columnValue]=$COMPUTER_SYMBOL
		checkFlag1=1
		checkFlag=1
		checkColumnFlag=0
	fi
}

function winAndBlockRowAndColumn() {
	for((i=0;i<ROWS;i++))
	do
		reassignCounter
		for((j=0;j<COLUMNS;j++))
		do
			if [ $checkColumnFlag -eq 1 ]
			then
				computerWinChecking $j $i $checkSymbol
			else
				computerWinChecking $i $j $checkSymbol
			fi
		done
		checkCounterAndChangeFlagValue $row $column
	done
}

#Check All 24 Cases
function computerWinningBoard() {
	checkSymbol=$1
	checkColumnFlag=0
	checkFlag=0
	checkFlag1=0
	if [ $checkFlag1 -eq 0 ]
	then
		checkColumnFlag=0
		winAndBlockRowAndColumn
	fi

	if [ $checkFlag1 -eq 0 ]
	then
		checkColumnFlag=1
		winAndBlockRowAndColumn
	fi

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

#Check Corner Position
function takingCornerPosition(){
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

#Check Center Position
function takingCenterPosition() {
	if [[ ${boardOfGame[1,1]} == "-" ]]
	then
		boardOfGame[1,1]=$COMPUTER_SYMBOL
		checkFlag=1
	fi
}

#check Side Position
function takingSidePosition() {
	for((i=0;i<ROWS;i++))
	do
		for((j=1;j<COLUMNS;j++))
		do
			if [ ${boardOfGame[$i,$j]} == "-" ]
			then
				boardOfGame[$i,$j]=$COMPUTER_SYMBOL
				checkFlag=1
			fi
		done
		if [ $checkFlag -eq 1 ]
		then
			break
		fi
	done
}

#check Player Or Computer Won
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

#check Winning condtion of row and column
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

#check Winning Condition Of Diagonal
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
