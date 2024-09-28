data "aws_availability_zones" "available" {
    state = "available"   
}

data "aws_vpc" "default" {
    default = true

}

data "aws_route_table" "default" {
    vpc_id = data.aws_vpc.default.id

    filter {  #Here from entire output of default vpc route_tables , we are filtering for associated main route_table
        name = "association.main"
        values = ["true"]
    }
}