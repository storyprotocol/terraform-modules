resource "aws_security_group" "this" {
  name = var.name

  ingress {
    from_port   = var.params.port
    to_port     = var.params.port
    protocol    = "tcp"
    description = "PostgreSQL"
    cidr_blocks = ["0.0.0.0/0"] // >
  }

  ingress {
    from_port        = var.params.port
    to_port          = var.params.port
    protocol         = "tcp"
    description      = "PostgreSQL"
    ipv6_cidr_blocks = ["::/0"] // >
  }

  timeouts {
    delete = "2m"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "this" {
  identifier                    = var.name
  allocated_storage             = var.params.allocated_storage
  storage_type                  = var.params.storage_type
  engine                        = var.params.engine
  engine_version                = var.params.engine_version
  instance_class                = var.params.instance_class
  db_name                       = var.params.db_name
  username                      = var.params.username
  manage_master_user_password   = true
  master_user_secret_kms_key_id = var.aws_kms_key.key_id
  publicly_accessible           = true
  parameter_group_name          = var.params.parameter_group_name
  vpc_security_group_ids        = [aws_security_group.this.id]
  skip_final_snapshot           = true
}
