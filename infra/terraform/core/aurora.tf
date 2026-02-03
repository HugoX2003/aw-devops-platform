module "rds" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 8.0"

  name           = "awdb"
  engine         = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.11.1"

  master_username = "admin"
  master_password = var.db_password

  vpc_id  = module.network.vpc_id
  subnets = module.network.private_subnets

  create_db_subnet_group = true

  create_security_group  = false
  vpc_security_group_ids = [aws_security_group.aurora_sg.id]

  storage_encrypted   = true
  apply_immediately   = true
  skip_final_snapshot = true
}