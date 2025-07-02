# data "aws_ami" "Amazon_Linux_2023" {

#   filter {
#     name   = "name"
#     values = ["Amazon Linux 2023 AMI"]
#   }
# }

# import {
#   to = data.aws_key_pair.keypair
#   id = "vockey"
# }

data "aws_key_pair" "keypair" {
  key_name = "vockey"
}

# Create a EC2 Instance with Wordpress
resource "aws_instance" "Wordpress_Server" {
  ami                         = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type               = "t3.micro"
  security_groups             = [aws_security_group.SSH_Security_Group.id, aws_security_group.HTTP_Security_Group.id, aws_security_group.DB_Security_Group.id, aws_security_group.Out_Security_Group.id]
  subnet_id                   = aws_subnet.Public_Subnet.id
  associate_public_ip_address = true
  key_name                    = data.aws_key_pair.keypair.key_name
  user_data                   = templatefile("user_data.sh", { db_address = aws_db_instance.Wordpress_DB.address, db_port = aws_db_instance.Wordpress_DB.port, db_password = var.DB_PASSWORD })
}
