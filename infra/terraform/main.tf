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

data "aws_caller_identity" "current" {}

resource "random_id" "bucket_id" {
  byte_length = 8
}

# 1) Artifacts S3 bucket
resource "aws_s3_bucket" "artifacts" {
  bucket = "aw-bootcamp-artifacts-${random_id.bucket_id.hex}"

  tags = {
    project = "aw-bootcamp"
  }
}

# Versioning ENABLED
resource "aws_s3_bucket_versioning" "artifacts_versioning" {
  bucket = aws_s3_bucket.artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Lifecycle: expire objects after 30 days
resource "aws_s3_bucket_lifecycle_configuration" "artifacts_lifecycle" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    id     = "expire-30-days"
    status = "Enabled"
    
    filter {}

    expiration {
      days = 30
    }
  }
}


# 2) CI Role + Least-Privilege Policy

# Trust policy (base) - role can be assumed from this AWS account
data "aws_iam_policy_document" "ci_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

resource "aws_iam_role" "ci_role" {
  name               = "aw-bootcamp-ci-role-${random_id.bucket_id.hex}"
  assume_role_policy = data.aws_iam_policy_document.ci_assume.json
}

# Least-privilege permissions for artifacts bucket
resource "aws_iam_policy" "ci_policy" {
  name = "aw-bootcamp-ci-policy-${random_id.bucket_id.hex}"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Bucket-level permission
      {
        Effect = "Allow",
        Action = ["s3:ListBucket"],
        Resource = [aws_s3_bucket.artifacts.arn]
      },
      # Object-level permissions
      {
        Effect = "Allow",
        Action = ["s3:GetObject", "s3:PutObject"],
        Resource = ["${aws_s3_bucket.artifacts.arn}/*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ci_policy" {
  role       = aws_iam_role.ci_role.name
  policy_arn = aws_iam_policy.ci_policy.arn
}