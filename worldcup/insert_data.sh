#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $WINNER != "winner" ]]
  then
  TEAMS=$($PSQL "SELECT name from teams where name='$WINNER'")
 if [[ -z $TEAMS ]]
    then
     INSERT_TEAM=$($PSQL "INSERT into teams(name) values('$WINNER')")

    if [[ INSERT_TEAM == "INSERT 0 1" ]]
     then
      echo Inserted into teams, $WINNER
    fi
    TEAMS=$($PSQL "SELECT name from teams where name='$WINNER'")
  fi
if [[ $OPOONENT != "opponent" ]]
  TEAMS2=$($PSQL "SELECT name from teams where name='$OPPONENT'")
    then
    if [[ -z $TEAMS2 ]]
    then
       INSERT_TEAM2=$($PSQL "INSERT into teams(name) values('$OPPONENT')")
      if [[ INSERT_TEAM2 == "INSERT 0 1" ]]
       then
       echo Inserted into teams, $OPPONENT
      fi
    fi
  fi
fi


TEAM_ID_W=$($PSQL "SELECT team_id from teams where name='$WINNER'")
TEAM_ID_O=$($PSQL "SELECT team_id from teams where name='$OPPONENT'")

  if [[ -n $TEAM_ID_W || -n $TEAM_ID_O ]]
    then
    if [[ $YEAR != "year" ]]
      then 
      INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $TEAM_ID_W, $TEAM_ID_O, $WINNER_GOALS, $OPPONENT_GOALS)")
      if [[ INSERT_GAME == "INSERT 0 1" ]]
      then
        echo Inserted into games, $YEAR
      fi
    fi
  fi  
done
