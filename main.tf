terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                   = "us-west-2"
  shared_credentials_files = ["credentials"]
}

data "http" "myip" {
  url = "https://ipinfo.io/ip"
}
