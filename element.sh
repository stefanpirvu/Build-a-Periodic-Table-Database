#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

INPUT=$1

# Verifica si no se proporciona ningún argumento
if [[ -z "$INPUT" ]]
    then
        echo Please provide an element as an argument.
elif [[ "$INPUT" =~ ^[0-9]+$ ]]
    then
    # if input = atomic_number
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = '$INPUT'")

    # Verifica si no se encontró el elemento en la base de datos
    if [[ -z "$ATOMIC_NUMBER" ]]
        then
        echo I could not find that element in the database.
    else
        ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
        SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
        TYPE=$($PSQL "SELECT type FROM types WHERE type_id IN (SELECT type_id FROM properties WHERE atomic_number IN (SELECT atomic_number FROM elements WHERE atomic_number = $ATOMIC_NUMBER))")
        ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number IN (SELECT atomic_number FROM elements WHERE atomic_number = $ATOMIC_NUMBER)")
        MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number IN (SELECT atomic_number FROM elements WHERE atomic_number = $ATOMIC_NUMBER)")
        BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number IN (SELECT atomic_number FROM elements WHERE atomic_number = $ATOMIC_NUMBER)")
    
        echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi

elif [[ "$INPUT" =~ ^[A-Za-z]+$ ]]
    then
    # if input = symbol
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$INPUT'")
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE name = '$INPUT'")
  
    if [[ "$INPUT" == $SYMBOL ]] || [[ "$INPUT" == $ELEMENT_NAME ]]
        then
            if [[ "$INPUT" == $SYMBOL ]]
                then
                    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$SYMBOL'")
            elif [[ "$INPUT" == $ELEMENT_NAME ]]
                then
                    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$ELEMENT_NAME'")
    fi
    
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$ELEMENT_NAME'")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id IN (SELECT type_id FROM properties WHERE atomic_number IN (SELECT atomic_number FROM elements WHERE name = '$ELEMENT_NAME'))")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number IN (SELECT atomic_number FROM elements WHERE name = '$ELEMENT_NAME')")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number IN (SELECT atomic_number FROM elements WHERE name = '$ELEMENT_NAME')")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number IN (SELECT atomic_number FROM elements WHERE name = '$ELEMENT_NAME')")

    echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    
    else
        echo I could not find that element in the database.
    fi
fi
