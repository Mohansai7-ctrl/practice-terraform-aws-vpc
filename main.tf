#Going to create vpc infra

resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = var.enabling_dns_hostnames

    tags = merge(
        var.common_tags,
        var.vpc_cidr_tags,
        {
            Name = local.resource_name
        }
    )
}

#creating internet_gateway and associating with vpc:

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.vpc_id

    tags = merge(
        var.common_tags,
        var.igw_tags,
        {
            Name = local.resource_name
        }
    )
}

#creating subnets:

resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zones = local.az_names[count.index]

    tags = merge(
        var.common_tags,
        var.public_subnet_tags,
        {
            Name = "${local.resource_name}-public-${local.az_names[count.index]}"
        }
    )
}

resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zones = local.az_names[count.index]

    tags = merge(
        var.common_tags,
        var.private_subnet_tags,
        {
            Name = "${local.resource_name}-private-${local.az_names[count.index]}"
        }
    )
}

resource "aws_subnet" "database" {
    count = length(var.database_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.database_subnet_cidrs[count.index]
    availability_zones = local.az_names[count.index]

    tags = merge(
        var.common_tags,
        var.database_subnet_tags,
        {
            Name = "${local.resource_name}-database-${local.az_names[count.index]}"
        }
    )
}

resource "aws_db_subnet_group" "main" {
    name = local.resource_name 
    subnet_ids = aws_subnet.database[*].id
    tags = merge(
        var.common_tags,
        var.db_subnet_group_tags,
        {
            Name = local.resource_name
        }
    )

}

#creating route tables

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.common_tags,
        var.public_route_table,
        {
            Name = "expense-public"
        }
    )
}

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.common_tags,
        var.private_route_table,
        {
            Name = "expense-private"
        }
    )
}

resource "aws_route_table" "database_route_table" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.common_tags,
        var.database_route_table,
        {
            Name = "expense-database"
        }
    )
}

#creating elastic ip:

resource "aws_eip" "main" {
    domain = "vpc"

    tags = {
        Name = "${project}-eip"
    }
}

#creating nat gateway and associating it with elastic ip:
resource "nat_gateway" "main" {
    subnet_id = aws_subnet.public[0].id
    allocation_id = aws_eip.main.id

    tags = merge(
        var.common_tags,
        var.nat_gateway_tags,
        {
            Name = "${local.resource_name}-nat_gw"
        }
        depends_on = [aws_internet_gateway.main] #depends on internet_gateway, not with its id
    )
}
#creating routes:

resource "aws_route" "public" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
}

resource "aws_route" "private" {
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route" "public" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
}

#associating route_tables with its respective subnets:

resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidrs)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidrs)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
    count = length(var.database_subnet_cidrs)
    route_table_id = aws_route_table.database.id
    subnet_id = aws_subnet.database[count.index].id  #becuase it should route with 2 public subnets which are in 2 regions

}