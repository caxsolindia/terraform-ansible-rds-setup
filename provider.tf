terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.82.2"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}


# provider "vault" {
#   address = "http://13.233.134.64:8200"
# }

provider "vault" {
  address = "https://13.233.134.64:8200"  # Use HTTP since Vault is not configured for HTTPS
}
