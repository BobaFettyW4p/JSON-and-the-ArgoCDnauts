resource "aws_route_table" "main" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gateway.id
}

tags = {
    Name = "${var.project}-routingTable"
}
}

resource "aws_route_table_association" "internet_access" {
    count = var.availability_zones_count

    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.main.id
}

resource "aws_route" "main" {
    route_table_id = aws_vpc.vpc.default_route_table_id
    nat_gateway_id = aws_nat_gateway.nat.id
    destination_cidr_block = "0.0.0.0/0"
}