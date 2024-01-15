locals {
  rds_password_name = join("-", tolist([upper(var.project), upper(var.stage), "rds-pass"]))
  rds_name          = join("-", tolist([var.project, lower(var.stage), "rds"]))
}

#===============================================================================
# AWS SECRETS MANAGER
#===============================================================================
resource "random_password" "rds_password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "rds_password" {
  name                    = local.rds_password_name
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rds_password" {
  secret_id     = aws_secretsmanager_secret.rds_password.id
  secret_string = random_password.rds_password.result
}

#===============================================================================
# AWS RDS
#===============================================================================
data "aws_secretsmanager_secret" "rds_password" {
  name = aws_secretsmanager_secret.rds_password.name
}

data "aws_secretsmanager_secret_version" "rds_password" {
  secret_id = data.aws_secretsmanager_secret.rds_password.id
  depends_on = [
    aws_secretsmanager_secret_version.rds_password
  ]
}

resource "aws_security_group" "rds_sg" {
  name        = var.security_group_name
  description = "Allow RDS access"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL ingress"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description      = "PostgreSQL egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.security_group_name
  }
}
resource "aws_db_instance" "rds" {
  identifier              = local.rds_name
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "13.7"
  instance_class          = "db.t4g.medium"
  db_name                 = "airflow"
  username                = "postgres"
  password                = sensitive(data.aws_secretsmanager_secret_version.rds_password.secret_string)
  skip_final_snapshot     = true
  max_allocated_storage   = 200
  backup_retention_period = 3
  apply_immediately       = true
  db_subnet_group_name    = var.rds_subnet_group_name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]

  lifecycle {
    ignore_changes = [password]
  }
  tags = {
    Backup = "true"
  }
}
