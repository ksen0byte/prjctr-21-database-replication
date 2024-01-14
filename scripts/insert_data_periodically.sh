#!/bin/bash

# Set the parameters
HOST="mysql_master"
DB_USER="root"
DB_PASS="111"
DB_NAME="mydb"
SLEEP_TIME=2 # Time in seconds between inserts

echo "Starting to write to [$HOST] once in [$SLEEP_TIME] seconds"

# Infinite loop to insert data
while true; do
    # Generate a random number or any data you want to insert
    RANDOM_LO=$((RANDOM % 1000))
    RANDOM_MID=$((RANDOM % 1000))
    RANDOM_HI=$((RANDOM % 1000))
    CURRENT_TIME=$(date +"%Y-%m-%d %T")

    # Execute the insert command
    docker exec $HOST sh -c "export MYSQL_PWD=$DB_PASS; mysql -u $DB_USER $DB_NAME -e 'insert into code (low, mid, high) values ($RANDOM_LO, $RANDOM_MID, $RANDOM_HI)'"

    # Output the inserted data and the current time
    echo "[$CURRENT_TIME]:    Inserted: ($RANDOM_LO, $RANDOM_MID, $RANDOM_HI)"

    # Wait for the specified sleep time
    sleep $SLEEP_TIME
done
