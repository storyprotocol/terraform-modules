data "aws_vpc" "selected" {
  tags = {
    Name = "vpc-${var.cluster_name}"
  }
}

# print out the VPC ID
output "vpc_id" {
  value = data.aws_vpc.selected.id
}

resource "aws_security_group" "this" {

  name = var.name

  vpc_id = data.aws_vpc.selected.id
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all traffic out"
  }

  timeouts {
    delete = "2m"
  }

  lifecycle {
    ignore_changes = all
  }
}

# Select all private subnets in the VPC
data "aws_subnets" "private" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

# output "private_subnets"
output "private_subnets" {
  value = data.aws_subnets.private.ids
}

# Create aws_db_subnet_group resource since we are using a custom VPC
resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-db-subnet-group"
  subnet_ids = data.aws_subnets.private.ids
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
  db_subnet_group_name = aws_db_subnet_group.this.name
}
