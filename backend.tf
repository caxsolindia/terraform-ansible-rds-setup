terraform {
  backend "s3" {
    bucket = "terraform-ansible-statefiles"
    key    = "tfstate/terraform.tfstate"
    region = "ap-south-1"
  }
}