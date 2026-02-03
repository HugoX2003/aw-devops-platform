resource "aws_security_group" "aurora_sg" {
  name        = "aw-bootcamp-aurora-sg"
  description = "Aurora MySQL - internal only"
  vpc_id      = module.network.vpc_id

  ingress {
    description = "MySQL from VPC only"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "redis_sg" {
  name        = "aw-bootcamp-redis-sg"
  description = "Redis - internal only"
  vpc_id      = module.network.vpc_id

  ingress {
    description = "Redis from VPC only"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}