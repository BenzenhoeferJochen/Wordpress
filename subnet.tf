
# Public Subnet
resource "aws_subnet" "Public_Subnet" {
  vpc_id            = aws_vpc.Wordpress_VPC.id
  availability_zone = "${aws_vpc.Wordpress_VPC.region}a"
  cidr_block        = "10.0.0.0/28"
}

# Public Subnet 2
resource "aws_subnet" "Public_Subnet2" {
  vpc_id            = aws_vpc.Wordpress_VPC.id
  availability_zone = "${aws_vpc.Wordpress_VPC.region}b"
  cidr_block        = "10.0.0.16/28"
}

# Associate the Subnet to a route table
resource "aws_route_table_association" "Public_Route_Table_Association" {
  route_table_id = aws_route_table.Public_Route_Table.id
  subnet_id      = aws_subnet.Public_Subnet.id
}

# Associate the Subnet to a route table
resource "aws_route_table_association" "Public_Route_Table_Association2" {
  route_table_id = aws_route_table.Public_Route_Table.id
  subnet_id      = aws_subnet.Public_Subnet2.id
}

resource "aws_db_subnet_group" "wordpress_db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = [aws_subnet.Public_Subnet.id, aws_subnet.Public_Subnet2.id]
}
