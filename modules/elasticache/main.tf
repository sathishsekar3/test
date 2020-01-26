resource "aws_elasticache_subnet_group" "ec" {
  name       = "ec-sub-grp"
  subnet_ids = var.subnets
}

resource "aws_elasticache_replication_group" "ec_redis" {
  replication_group_id          = "redis"
  replication_group_description = "redis replication group"
  engine               = "redis"
  node_type            = var.nodetype
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.3"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.ec.name
  automatic_failover_enabled = true
  cluster_mode {
    replicas_per_node_group = 1
    num_node_groups         = 1
  }
}
