
# Create a VPC
resource "aws_subnet" "Public_Subnet" {
  vpc_id     = aws_vpc.Wordpress_VPC.id
  cidr_block = aws_vpc.Wordpress_VPC.cidr_block
}

# Associate the Subnet to a route table
resource "aws_route_table_association" "Public_Route_Table_Association" {
  route_table_id = aws_route_table.Public_Route_Table.id
  subnet_id      = aws_subnet.Public_Subnet.id
}
