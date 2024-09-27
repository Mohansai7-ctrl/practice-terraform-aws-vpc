data "availability_zones" "available" {
    state = "available"   
}

data "aws_vpc" "default" {
    default = true

}

data "aws_route_table" "default" {
    vpc_id = aws_vpc.default.id

    filter {
        name = "association.main"
        values = ["true"]
    }
}