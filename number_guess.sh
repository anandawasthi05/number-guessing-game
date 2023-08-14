#!/bin/bash

NUMBER_GUESS() {
  echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
}

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# echo "$($PSQL "TRUNCATE TABLE users;")"
echo "Enter your username:"
read USERNAME
NUMBER_OF_GUESSES=0
GAMES_PLAYED=0
BEST_GAME=0
SECRET_NUMBER=$(( RANDOM%1000 + 1 ))
echo "Secret Number is: $SECRET_NUMBER"
USER="$($PSQL "SELECT username FROM users WHERE username='$USERNAME';")"
if [[ -z $USER ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER_RESULT="$($PSQL "INSERT INTO users(username) VALUES('$USERNAME');")"
  echo "Guess the secret number between 1 and 1000:"
  read NUMBER
  while [ $NUMBER != $SECRET_NUMBER ]
  do
    if [[ !($NUMBER =~ ^[0-9]+$) ]]
    then
      echo "That is not an integer, guess again:"
    elif [[ "$NUMBER" -gt "$SECRET_NUMBER" ]]
    then
      echo "It's higher than that, guess again:"
      NUMBER_OF_GUESSES=$(( NUMBER_OF_GUESSES + 1 ))
    elif [[ "$NUMBER" -lt "$SECRET_NUMBER" ]]
    then
      echo "It's lower than that, guess again:"
      NUMBER_OF_GUESSES=$(( $NUMBER_OF_GUESSES + 1 ))
    fi
    read NUMBER
  done
  NUMBER_OF_GUESSES=$(( NUMBER_OF_GUESSES + 1 ))
  GAMES_PLAYED=$(( GAMES_PLAYED + 1 ))
  GAMES_PLAYED_RESULT="$($PSQL "UPDATE users SET games_played=$GAMES_PLAYED WHERE username='$USERNAME';")"
  BEST_GAME="$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME'")"
  if [[ "$BEST_GAME" -eq 0 || "$BEST_GAME" -gt "$NUMBER_OF_GUESSES" ]]
  then
    BEST_GAME=$(( NUMBER_OF_GUESSES ))
    UPDATE_RESULT="$($PSQL "UPDATE users SET best_game=$BEST_GAME WHERE username='$USERNAME';")"
  fi
  NUMBER_GUESS
else
  GAMES_PLAYED="$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME';")"
  BEST_GAME="$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME';")"
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  echo "Guess the secret number between 1 and 1000:"
  read NUMBER
  while [ $NUMBER != $SECRET_NUMBER ]
  do
    if [[ !($NUMBER =~ ^[0-9]+$) ]]
    then
      echo "That is not an integer, guess again:"
    elif [[ "$NUMBER" -gt "$SECRET_NUMBER" ]]
    then
      echo "It's higher than that, guess again:"
      NUMBER_OF_GUESSES=$(( NUMBER_OF_GUESSES + 1 ))
    elif [[ "$NUMBER" -lt "$SECRET_NUMBER" ]]
    then
      echo "It's lower than that, guess again:"
      NUMBER_OF_GUESSES=$(( $NUMBER_OF_GUESSES + 1 ))
    fi
    read NUMBER
  done
  NUMBER_OF_GUESSES=$(( NUMBER_OF_GUESSES + 1 ))
  GAMES_PLAYED=$(( GAMES_PLAYED + 1 ))
  GAMES_PLAYED_RESULT="$($PSQL "UPDATE users SET games_played=$GAMES_PLAYED WHERE username='$USERNAME';")"
  BEST_GAME="$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME'")"
  if [[ "$BEST_GAME" -eq 0 || "$BEST_GAME" -gt "$NUMBER_OF_GUESSES" ]]
  then
    BEST_GAME=$(( NUMBER_OF_GUESSES ))
    UPDATE_RESULT="$($PSQL "UPDATE users SET best_game=$BEST_GAME WHERE username='$USERNAME';")"
  fi
  NUMBER_GUESS
fi