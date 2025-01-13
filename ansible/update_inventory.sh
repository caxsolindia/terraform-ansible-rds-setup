#!/bin/bash

# Initialize Terraform configuration and backend
terraform init

# Refresh the state to ensure outputs are available
terraform refresh

# Fetch the Terraform outputs
DB_ENDPOINT=$(terraform output -raw rds_endpoint)
DB_USERNAME=$(terraform output -raw rds_username)
DB_PASSWORD=$(terraform output -raw rds_password)

DBE=$(echo $DB_ENDPOINT | cut -d':' -f1)

# Update ansible/inventory.ini with the fetched values
cat > ./ansible/inventory.ini <<EOL
[db]
localhost ansible_connection=local

[db:vars]
db_endpoint=$DBE
db_username=$DB_USERNAME
db_password=$DB_PASSWORD
EOL

echo "inventory.ini has been updated with the new RDS details in the ansible directory."
