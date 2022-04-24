#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv |  while IFS="," read YEAR ROUND WINNER_NAME OPPONENT_NAME WINNER_GOALS OPPONENT_GOALS
do
 #insert teams:
if [[ $WINNER_NAME != 'winner' && $OPPONENT_NAME != 'opponent' ]]
then
  # check for if team exist
  SEARCH_TEAM_RESULT=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER_NAME'")
  echo $SEARCH_TEAM_RESULT
  if [[ -z $SEARCH_TEAM_RESULT ]]
  then
   # insert team
   ADD_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER_NAME')")
   echo $ADD_TEAM_RESULT winner
  fi
  SEARCH_TEAM_RESULT=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT_NAME'")
  echo $SEARCH_TEAM_RESULT
  if [[ -z $SEARCH_TEAM_RESULT ]]
  then
   # insert team
    ADD_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT_NAME')")
    echo $ADD_TEAM_RESULT oppo
  fi
fi
done

COUNTER=0
cat games.csv |  while IFS="," read YEAR ROUND WINNER_NAME OPPONENT_NAME WINNER_GOALS OPPONENT_GOALS
do
 if [[ $COUNTER != 0 ]]
 then
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER_NAME'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT_NAME'")
  INSERT_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
  echo $INSERT_GAME
 fi
 (( COUNTER++ ))
done
