resource "aws_elasticache_subnet_group" "redis" {
  name       = "aw-redis-subnets"
  subnet_ids = module.network.private_subnets
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id         = "aw-bootcamp-redis"
  engine             = "redis"
  node_type          = "cache.t3.small"
  num_cache_nodes    = 1
  port               = 6379
  subnet_group_name  = aws_elasticache_subnet_group.redis.name
  security_group_ids = [aws_security_group.redis_sg.id]
}