#!/bin/bash

# Set the parameters
HOST="mysql_slave"
DB_USER="root"
DB_PASS="111"
DB_NAME="mydb"
SLEEP_TIME=1 # Time in seconds between queries

echo "Starting to query [$HOST] once in [$SLEEP_TIME] seconds"

# Initialize previous row count
PREV_ROW_COUNT=0

# Infinite loop to query the slave database
while true; do
    CURRENT_TIME=$(date +"%Y-%m-%d %T")

    # Execute the query command to get the last row and row count
    LAST_ROW=$(docker exec $HOST sh -c "export MYSQL_PWD=$DB_PASS; mysql -u $DB_USER $DB_NAME -e 'SELECT * FROM code ORDER BY created_at DESC LIMIT 1;'")

    # Execute the query command
    CURRENT_ROW_COUNT=$(docker exec $HOST sh -c "export MYSQL_PWD=$DB_PASS; mysql -u $DB_USER $DB_NAME -e 'SELECT COUNT(*) FROM code'" | tail -n 1)

    # Calculate the difference in row count since last query
    ROW_DIFF=$((CURRENT_ROW_COUNT - PREV_ROW_COUNT))

    # Update previous row count
    PREV_ROW_COUNT=$CURRENT_ROW_COUNT

    # Check if the difference is non-zero
    if [ "$ROW_DIFF" -ne 0 ]; then
        # Output the row count and the current time with difference in green
        echo -e "[$CURRENT_TIME]:   Row count in [code] table: [$CURRENT_ROW_COUNT]     \e[32m+$ROW_DIFF\e[0m"
        echo -e "Last row:\n$LAST_ROW"
    else
        # Output the row count and the current time without difference
        echo "[$CURRENT_TIME]:   Row count in [code] table: [$CURRENT_ROW_COUNT]"
    fi

    # Wait for the specified sleep time
    sleep $SLEEP_TIME
done
