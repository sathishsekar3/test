module "db" {
  source = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = "demodb"
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_encrypted = false

  name     = "demodb"
  username = var.username
  password = var.db_password
  port     = "3306"

  vpc_security_group_ids = [
     var.sec_rds_sg,
  ]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  multi_az = false

  backup_retention_period = 0

  tags = {
    Name = "${terraform.workspace}"
  }

  enabled_cloudwatch_logs_exports = ["audit", "general"]

  # DB subnet group
  subnet_ids = var.subnet_id

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "demodb"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}
