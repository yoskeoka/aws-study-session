terraform {
  // terraform version
  required_version = ">= 1.9.5"

  // aws provider version
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.64"
    }
  }
}

// aws provider setting
provider "aws" {
  region = "ap-northeast-1"
}
