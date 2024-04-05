#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {

  if [[ $1 ]]; then
    echo -e "\n$1"
  fi

  echo "Welcome to My Salon, how can I help you?"
  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
  1) SERVICE_MENU "cut" ;;
  2) SERVICE_MENU "color" ;;
  3) SERVICE_MENU "perm" ;;
  4) SERVICE_MENU "style" ;;
  5) SERVICE_MENU "trim" ;;
  *) MAIN_MENU "Please enter a valid option." ;;
  esac

}

SERVICE_MENU() {

  if [[ $1 ]]; then
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    # get service id
    SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE name='$1'")

    if [[ -z SERVICE_ID ]]; then
      echo MAIN_MENU "Error."
    fi

    # get customer name
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    # if customer doesn't exist
    if [[ -z $CUSTOMER_NAME ]]; then
      # get new customer name
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME

      # insert new customer
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    fi
    # get customer id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    echo -e "\nWhat time would you like your $1, $CUSTOMER_NAME"
    read SERVICE_TIME

    # insert appointment info
    APPOINTMENT_INSERT_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID,'$SERVICE_TIME')")
    echo -e "\nI have put you down for a $1 at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

MAIN_MENU
