# Create a IGW
resource "aws_internet_gateway" "IGW" {
}

# Attatch the IGW to the public Subnet
resource "aws_internet_gateway_attachment" "igw_attachment" {
  vpc_id              = aws_vpc.Wordpress_VPC.id
  internet_gateway_id = aws_internet_gateway.IGW.id
}


# Add Route to Route Table
resource "aws_route" "IGW_Route" {
  route_table_id         = aws_route_table.Public_Route_Table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.IGW.id
}
