output "vpc_id" {  
    value = aws_vpc.main.id #here value names same as reference_type.reference_name and this can be different from output name and we get these output value names in readme.MD File from developer , id == attribute reference
}


output "public_subnet_ids" {
    value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
    value = aws_subnet.private[*].id
}

output "database_subnet_ids" {
    value = aws_subnet.database[*].id
}

output "az_info" {
    value = data.aws_availability_zones.available
}

output "default_vpc_info" {
    value = data.aws_vpc.default  #will provide all default vpc info
}

output "default_vpc_route_table_info" {
    value = data.aws_route_table.default #will provide all default vpc route_tables info

}