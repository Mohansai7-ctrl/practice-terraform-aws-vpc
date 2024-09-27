output "vpc_info" {
    value = aws_vpc.main.id
}

output "public_subnet_id" {
    value = aws_subnet.public[*].id
}

output "private_subnet_id" {
    value = aws_subnet.private[*].id
}

output "database_subnet_id" {
    value = aws_subet.database[*].id
}

output "az_info" {
    value = aws_availability_zones.available
}

output "default_vpc_info" {
    value = data.aws_vpc.default  #will provide all default vpc info
}

output "default_vpc_route_table_info" {
    value = data.aws_route_table.default #will provide all default vpc route_tables info

}