#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "demo" {
  cidr_block = "10.0.0.0/16"

  tags = merge({ "Name" = format("k.kotov-test -> %s -> %s", substr ("🤔🤷", 0,1), data.aws_ami.ubuntu.name) }, var.tags)

}

resource "aws_subnet" "demo" {
  count = 2

  availability_zone = var.availability_zone
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = aws_vpc.demo.id

  tags = merge({ "Name" = format("k.kotov-test -> %s -> %s", substr ("🤔🤷", 0,1), data.aws_ami.ubuntu.name) }, var.tags)

}

resource "aws_internet_gateway" "demo" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name = "terraform-eks-demo"
  }
}

resource "aws_route_table" "demo" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo.id
  }
}

resource "aws_route_table_association" "demo" {
  count = 2

  subnet_id      = aws_subnet.demo.*.id[count.index]
  route_table_id = aws_route_table.demo.id
}
