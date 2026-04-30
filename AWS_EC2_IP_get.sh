#!/bin/bash

# Fetch the instance ID dynamically, assuming you tag your instance
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=MyEC2Instance" \
  --query "Reservations[*].Instances[*].InstanceId" \
  --output text)

# Fetch the public IP dynamically
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --query "Reservations[*].Instances[*].PublicIpAddress" \
  --output text)

# Use the dynamic public IP in the SSH command
ssh -i "blog_project.pem" ubuntu@$PUBLIC_IP

