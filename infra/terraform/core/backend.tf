terraform {
  backend "s3" {
    bucket         = "aw-bootcamp-tfstate-9503f193"
    key            = "core/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "aw-bootcamp-tf-locks"
    encrypt        = true
  }
}