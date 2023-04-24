resource "aws_db_subnet_group" "this" {
  name       = "this-subnet-group"
  subnet_ids = var.public_subnets
}

data "aws_db_snapshot" "this" {
  db_snapshot_identifier = var.snapshot_arn
}

resource "aws_security_group" "this_db_sg" {
  name_prefix = "this-db-sg-"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Update with your desired CIDR block
  }
}

resource "aws_db_parameter_group" "this" {
  name   = "this-db-param-group"
  family = "mysql8.0"
}

resource "aws_db_instance" "this_rds" {
  identifier              = "this-db-instance"
  engine                  = "mysql"
  engine_version          = "8.0.32"
  instance_class          = "db.t3.small"
  allocated_storage       = 20
  storage_type            = "gp2"
  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.this_db_sg.id]
  db_name                 = var.db_paramters["database"]
  username                = var.db_paramters["username"]
  password                = var.db_paramters["password"]
  backup_retention_period = 0
  skip_final_snapshot     = true
  snapshot_identifier     = data.aws_db_snapshot.this.id
  tags = {
    Name = "this-db-instance"
  }
}

resource "aws_ssm_parameter" "db_endpoint" {
  name      = "host"
  type      = "String"
  value     = aws_db_instance.this_rds.address
  overwrite = true
}
