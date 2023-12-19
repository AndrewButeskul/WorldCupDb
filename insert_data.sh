#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE games, teams")"

# Adding names to the table 'teams'
while IFS="," read -r winner opponent
do
  Insert_winner=$($PSQL "INSERT INTO teams(name) VALUES('$winner') ON CONFLICT (name) DO NOTHING;")  
  Inssert_opponent=$($PSQL "INSERT INTO teams(name) VALUES('$opponent') ON CONFLICT (name) DO NOTHING;")
done < <(cut -d "," -f3,4 games.csv | tail -n +2)

# Adding data to the table 'games'
while IFS="," read -r year round winner opponent winner_goals opponent_goals
do
  winner_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")
  opponent_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$opponent'")

  INSERT_DATA=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $winner_ID, $opponent_ID, $winner_goals, $opponent_goals);")
done < <(tail -n +2 games.csv)
echo "All data have been written down!"