resource "aws_opensearch_domain" "os" {
  domain_name    = "aw-bootcamp-os"
  engine_version = "OpenSearch_1.0"

  cluster_config {
    instance_type  = "t3.small.search"
    instance_count = 1
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  vpc_options {
    subnet_ids         = [module.network.private_subnets[0]]
    security_group_ids = [aws_security_group.opensearch_sg.id]
  }
}