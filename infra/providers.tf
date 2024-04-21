terraform {
  backend "s3" {
    bucket = "tofu-backend-17a24c039bd0bbae"
    key    = "tofu-backend/tofu.tfstate"
    region = "us-west-2"
    assume_role = {
      role_arn = "arn:aws:iam::388179514488:role/tofu"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region = "us-west-2"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}
