
# Create a VPC
resource "aws_vpc" "Wordpress_VPC" {
  cidr_block = "10.0.0.0/27"
}

# Create a Route Table
resource "aws_route_table" "Public_Route_Table" {
  vpc_id = aws_vpc.Wordpress_VPC.id
}
