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


provider "vault" {
  address = "http://127.0.0.1:8200"
}
