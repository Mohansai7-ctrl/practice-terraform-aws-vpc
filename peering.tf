resource "aws_vpc_peering_connection" "peering" {
    count = var.is_peering_required ? 1 : 0
    vpc_id = aws_vpc.main.id #requestor 
    peer_vpc_id = data.aws_vpc.default.id #acceptor

    auto_accept = true
    tags = merge(
        var.common_tags,
        var.peering_tags,
        {
            Name = "${local.resource_name}-default"
        }
    )

}

#creating routes of main vpc route_tables with default vpc

resource "aws_route" "public_peering" {
    count = var.is_peering_required ? 1 : 0
    route_table_id = aws_route_table.public_route_table.id
    destination_cidr_block = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id  #here count.index is for if user sets true for peering_connection then only it will create routes with both vpcs
}

resource "aws_route" "private_peering" {
    count = var.is_peering_required ? 1 : 0
    route_table_id = aws_route_table.private_route_table.id
    destination_cidr_block = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id
}

resource "aws_route" "database_peering" {
    count = var.is_peering_required ? 1 : 0
    route_table_id = aws_route_table.database_route_table.id
    destination_cidr_block = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id
}

#creating route of default vpc route tables with main vpc expense:

resource "aws_route" "default_peering" {
    count = var.is_peering_required ? 1 : 0
    route_table_id = data.aws_route_table.default.id
    destination_cidr_block = var.vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id
}