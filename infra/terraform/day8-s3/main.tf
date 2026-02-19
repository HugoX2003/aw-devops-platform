terraform {
    required_providers {
        aws = { source = "hashicorp/aws", version = "~> 5.50" }
        kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.28" }
    }
}

provider "aws" {
    region = var.region
}

provider "kubernetes" {
    config_path = "~/.kube/config"
}

resource "aws_kms_key" "s3_enc" {
    description = "KMS key for S3 encryption"
    deletion_window_in_days = 7
}

resource "aws_s3_bucket" "files" {
    bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "v" {
    bucket = aws_s3_bucket.files.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
    bucket = aws_s3_bucket.files.id
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "aws:kms"
            kms_master_key_id = aws_kms_key.s3_enc.arn
        }
    }
}

resource "aws_s3_bucket_public_access_block" "block" {
    bucket = aws_s3_bucket.files.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

resource "kubernetes_config_map" "kms_info" {
    metadata { 
        name = "kms-config"
        namespace = "default" 
    }

    data = {
        KMS_KEY_ID = aws_kms_key.s3_enc.id
    }
}

output "bucket_name" { value = aws_s3_bucket.files.id }
output "kms_key_id" { value = aws_kms_key.s3_enc.id }