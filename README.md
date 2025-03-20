# RDS PostgreSQL Setup with Terraform, HashiCorp Vault, and Ansible

## Project Overview
This project demonstrates how to set up an AWS RDS PostgreSQL database using Terraform, manage database secrets with HashiCorp Vault, and automate post-deployment tasks with Ansible. The workflow ensures secure handling of credentials and simplifies database configuration.

<img src="https://github.com/caxsolindia/terraform-ansible-rds-setup/main/architecture_diagram/image.png" />
---

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Project Structure](#project-structure)
3. [Setup Instructions](#setup-instructions)
4. [Usage](#usage)
5. [Outputs](#outputs)
6. [Verification Steps](#verification-steps)
7. [Cleanup](#cleanup)

---

## Prerequisites

### 1. Python Environment Setup
1. Create and activate a Python virtual environment:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```
2. Install required Python packages:
   ```bash
   pip install psycopg2 psycopg2-binary
   ```

### 2. Install HashiCorp Vault on WSL
1. Add the HashiCorp Linux repository:
   ```bash
   curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   ```
2. Update the package list and install Vault:
   ```bash
   sudo apt update && sudo apt install vault
   ```
3. Verify the installation:
   ```bash
   vault --version
   ```

### 3. Start Vault in Dev Mode
1. Start the Vault server:
   ```bash
   vault server -dev
   ```
2. Set the environment variable for Vault:
   ```bash
   export VAULT_ADDR='http://127.0.0.1:8200'
   ```

### 4. Enable KV Secrets Engine
1. Enable the KV secrets engine:
   ```bash
   vault secrets enable -path=secret kv
   ```
2. Store RDS credentials in Vault:
   ```bash
   vault kv put secret/db db_username="postgres" db_password="postgres1234!"
   ```
3. Test the secret retrieval:
   ```bash
   vault kv get secret/db
   ```

---

## Project Structure
```
.
├── modules
│   └── rds
│       ├── main.tf
│       ├── outputs.tf
│       ├── variables.tf
├── ansible
│   ├── db_setup.yml
│   ├── inventory.ini
│   └── update_inventory.sh
├── main.tf
├── outputs.tf
├── variables.tf
├── backend.tf
├── provider.tf
├── terraform.tfvars
└── README.md
```

---

## Setup Instructions

### 1. Initialize Terraform
1. Initialize the Terraform configuration and backend:
   ```bash
   terraform init
   ```
2. Refresh the state:
   ```bash
   terraform refresh
   ```

### 2. Deploy the RDS Instance
1. Apply the Terraform configuration to create the RDS instance:
   ```bash
   terraform apply
   ```

### 3. Update Ansible Inventory
1. Run the `update_inventory.sh` script to fetch RDS details and update the Ansible inventory file:
   ```bash
   bash ./ansible/update_inventory.sh
   ```

### 4. Run Ansible Playbook
1. Execute the playbook to configure the RDS instance:
   ```bash
   ansible-playbook -i ./ansible/inventory.ini ./ansible/db_setup.yml
   ```

---

## Outputs
- **RDS Endpoint**: The connection endpoint for the RDS instance.
- **Instance ID**: The unique identifier for the RDS instance.
- **Username**: The username used for RDS access (sensitive).
- **Password**: The password used for RDS access (sensitive).

---

## Verification Steps
1. Verify that the database is created in RDS.
2. Check the Ansible playbook logs to ensure successful database setup and table creation.
3. Use the following commands to manually verify:
   ```bash
   PGPASSWORD=<password> psql -h <endpoint> -U <username> -d <database_name> -c '\dt'
   ```
   ```bash
   PGPASSWORD=<password> psql -h <endpoint> -U <username> -d <database_name> -c "SELECT grantee, table_schema, table_name, privilege_type FROM information_schema.role_table_grants WHERE grantee = 'app_user' AND table_schema = 'public';"
   ```

---

## Cleanup
1. Destroy the Terraform-managed infrastructure:
   ```bash
   terraform destroy
   ```
2. Disable Vault Dev Mode:
   ```bash
   pkill vault
   ```
3. Deactivate the Python virtual environment:
   ```bash
   deactivate
   ```

---

## Notes
- Use secure storage solutions for sensitive files like `terraform.tfstate` and `inventory.ini`.
- Avoid using Vault Dev Mode in production environments; configure Vault with proper storage backends and authentication methods for security.

---

## Author
[Parth]
Junior DevOps Engineer

---

