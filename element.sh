#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  element=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $1")
else
  element=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name = '$1' OR symbol = '$1'")
fi

if [[ -z $element ]]
then
  echo  "I could not find that element in the database."
  exit
fi
echo "$element" | while IFS=" |" read AN S N T AM MP BP
do
  echo "The element with atomic number $AN is $N ($S). It's a $T, with a mass of $AM amu. $N has a melting point of $MP celsius and a boiling point of $BP celsius."
done
