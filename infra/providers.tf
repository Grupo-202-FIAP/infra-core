terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.14.1"
    }
  }

  backend "s3" {
    bucket  = "terraform-state-bucket"
    key     = "nexTime/infra.tfstate"
    region  = "us-east-1"
    encrypt = true

    role_arn = "arn:aws:iam::975049999399:role/LabRole"
  }

}

provider "aws" {
  region = "us-east-1"
}
