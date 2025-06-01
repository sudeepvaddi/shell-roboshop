#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-03724a8dfd2a68383"
INSTANCES=("mongodb" "redis" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "disaptch" "frontend")
ZONE_ID="Z0417974VNU4EJ9PF5SZ"
DOMAIN_NAME="sudeepdevops.fun"

for instance in $@
do
    INSTANCE_ID=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t3.micro --security-group-ids sg-03724a8dfd2a68383 --tag-specifications "ResourceType=instance,Tags=[{Key=Name, Value=$instance}]" --query "Instances[0].InstanceId" --output text)
    if [ $instance != "frontend" ]
    then
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
    else
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
    fi
    echo "$instance IP address: $IP"
done
