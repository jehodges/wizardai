terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = local.aws_region
  assume_role {
    role_arn     = local.role_arn
    session_name = local.session_name
  }
}
