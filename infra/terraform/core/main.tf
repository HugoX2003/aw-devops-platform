terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "./modules/network"

  name = "aw-bootcamp-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  tags = {
    project = "aw-bootcamp"
  }
}

output "vpc_id" {
  value = module.network.vpc_id
}

resource "random_id" "id" {
  byte_length = 4
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "aw-bootcamp-tfstate-${random_id.id.hex}"

  tags = {
    project = "aw-bootcamp"
  }
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "aw-bootcamp-tf-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    project = "aw-bootcamp"
  }
}



