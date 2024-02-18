#!/bin/bash

# declare variable PSQL for execute sql command
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAIN_MENU() {
  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  else
    if [[ $1 =~ ^[0-9]+$ ]]
    then
      ELEMENT_RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE (atomic_number = $1)")
    else
      if [[ ${#1} -eq 1 || ${#1} -eq 2 ]]
      then
        ELEMENT_RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE (symbol = '$1')")
      else 
        ELEMENT_RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE (name = '$1')")
      fi
    fi

    if [[ $ELEMENT_RESULT ]]
    then
      echo $ELEMENT_RESULT | while read TYPE_ID BAR ATOMIC_NUMBER BAR ATOMIC_SYMBOL BAR ATOM_NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR ATOM_TYPE
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $ATOM_NAME ($ATOMIC_SYMBOL). It's a $ATOM_TYPE, with a mass of $ATOMIC_MASS amu. $ATOM_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    else 
      echo "I could not find that element in the database."
    fi
  fi
}

MAIN_MENU $1