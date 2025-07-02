resource "aws_db_instance" "Wordpress_DB" {
  allocated_storage        = 5
  multi_az                 = false
  db_name                  = "wordpress"
  engine                   = "mysql"
  engine_version           = "8.4"
  instance_class           = "db.t3.micro"
  password_wo              = var.DB_PASSWORD
  username                 = "root"
  password_wo_version      = "1.0"
  engine_lifecycle_support = "open-source-rds-extended-support-disabled"
  vpc_security_group_ids   = [aws_security_group.DB_Security_Group.id]
  db_subnet_group_name     = aws_db_subnet_group.wordpress_db_subnet_group.name
  backup_retention_period  = 0
}
