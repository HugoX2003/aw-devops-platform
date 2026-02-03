output "aurora_endpoint" {
  value = module.rds.cluster_endpoint
}

output "redis_endpoint" {
  value = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "opensearch_endpoint" {
  value = aws_opensearch_domain.os.endpoint
}