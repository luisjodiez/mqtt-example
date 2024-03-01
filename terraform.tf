
# Set up backend for aws provider using s3 bucket and dynamodb table
terraform {
  backend "s3" {
    bucket = "ljdb-tfstate-bucket"
    key    = "terraform.tfstate"
    region = "eu-west-1"
    dynamodb_table = "terraform-state-lock"
  }
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}
