#!/bin/bash


# Stop the RDS instance (add this to stop the instance)
aws rds stop-db-instance --db-instance-identifier coursera-mysql-instance
