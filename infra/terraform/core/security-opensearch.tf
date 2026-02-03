resource "aws_security_group" "opensearch_sg" {
  name        = "aw-bootcamp-opensearch-sg"
  description = "OpenSearch - internal only"
  vpc_id      = module.network.vpc_id

  ingress {
    description = "HTTPS from VPC only"
    from_port   = 443
    to_port     = 443
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