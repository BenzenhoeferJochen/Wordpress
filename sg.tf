# Create a Security Group
resource "aws_security_group" "SSH_Security_Group" {
  description = "Allows SSH Access for Me"
  name        = "SSH_Security_Group"
  vpc_id      = aws_vpc.Wordpress_VPC.id
}

# Allow SSH ingress
resource "aws_vpc_security_group_ingress_rule" "SSH_Rule" {
  security_group_id = aws_security_group.SSH_Security_Group.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "${data.http.myip.response_body}/32"
}
