provider "aws" {
  region      = "us-east-2"
  profile     = "default"
}

terraform {
  backend "s3" {
    bucket = "ihillaws-terraform-configuration"
    key    = "externaldns/terraform.tfstate"
    region = "us-east-2"
  }
}
