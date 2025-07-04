
# Create a VPC
resource "aws_vpc" "Wordpress_VPC" {
  cidr_block = "10.0.0.0/26"
}

# Create a Route Table
resource "aws_route_table" "Public_Route_Table" {
  vpc_id = aws_vpc.Wordpress_VPC.id
}

resource "aws_route_table" "Private_Route_Table" {
  vpc_id = aws_vpc.Wordpress_VPC.id
}
