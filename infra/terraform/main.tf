terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "random_id" "bucket_id" {
  byte_length = 8
}

resource "aws_s3_bucket" "frontend" {
  bucket = "aw-bootcamp-frontend-${random_id.bucket_id.hex}"

  tags = {
    project = "aw-bootcamp"
  }
}

resource "aws_s3_bucket_website_configuration" "frontend_website" {
  bucket          = aws_s3_bucket.frontend.bucket
  
  index_document {
    suffix = "index.html"
  }
}


resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.frontend.bucket_regional_domain_name
    origin_id   = "S3-aw-frontend"
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    target_origin_id      = "S3-aw-frontend"

  forwarded_values {
    query_string = true

    cookies {
      forward = "none"
    }
  }
}

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}