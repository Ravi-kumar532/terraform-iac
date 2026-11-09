resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnets"
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

resource "aws_db_instance" "this" {
  identifier                  = var.name
  engine                      = "sqlserver-se"
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  username                    = var.master_username
  manage_master_user_password = true
  allocated_storage           = var.allocated_storage
  storage_encrypted           = true
  kms_key_id                  = var.kms_key_arn
  db_subnet_group_name        = aws_db_subnet_group.this.name
  vpc_security_group_ids      = var.security_group_ids
  multi_az                    = var.multi_az
  publicly_accessible         = false
  backup_retention_period     = var.backup_retention_days
  deletion_protection         = true
  skip_final_snapshot         = false
  final_snapshot_identifier   = "${var.name}-final"
  auto_minor_version_upgrade  = true
  tags                        = var.tags
}
