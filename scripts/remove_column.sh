#!/bin/bash

# Set the parameters
HOST="mysql_slave"
DB_USER="root"
DB_PASS="111"
DB_NAME="mydb"
TABLE_NAME="code"
COLUMN_NAME="$1"  # Column name passed as a parameter

# Check if column name is provided
if [ -z "$COLUMN_NAME" ]; then
    echo "Please provide a column name as a parameter."
    exit 1
fi

# Connect to the MySQL Slave and remove the specified column
docker exec $HOST sh -c "export MYSQL_PWD=$DB_PASS; \
                         mysql -u $DB_USER $DB_NAME \
                         -e 'SET FOREIGN_KEY_CHECKS=0; \
                             ALTER TABLE $TABLE_NAME \
                             DROP COLUMN $COLUMN_NAME; \
                             SET FOREIGN_KEY_CHECKS=1;'"

echo "Column '$COLUMN_NAME' removed from table $TABLE_NAME in the slave database."
