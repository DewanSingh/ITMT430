#!/bin/bash

# Replace 'your-db-instance-identifier' with your actual RDS instance identifier
DB_INSTANCE_IDENTIFIER="coursera-mysql-instance"

# Start the RDS instance
aws rds start-db-instance --db-instance-identifier $DB_INSTANCE_IDENTIFIER

# Wait for the instance to become available
aws rds wait db-instance-available --db-instance-identifier $DB_INSTANCE_IDENTIFIER

echo "RDS instance $DB_INSTANCE_IDENTIFIER has started and is now available."
