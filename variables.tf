variable "vpc_cidr" {
    default = {}
}

variable "enabling_dns_hostnames"{
    default = true
}

variable "common_tags" {
    default = {
        
    }
}

variable "vpc_cidr_tags" {
    default = {}
}

variable "project" {
    type = string
}

variable "environment" {
    type = string
}

variable "igw_tags" {
    default = {}
}

variable "public_subnet_cidrs" {
    type = list
    validation {
        condition = length(var.public_subnet_cidrs) == 2
        error_message = "user/you have to provide 2 respective public_subnet cidr blocks"
    }
}

variable "public_subnet_tags" {
    default = {}
}

variable "private_subnet_cidrs" {
    type = list
    validation {
        condition = length(var.private_subnet_cidrs) == 2
        error_message = "user/you have to provide 2 respective private_subnet cidr blocks"
    }
}

variable "private_subnet_tags" {
    default = {}
}

variable "database_subnet_cidrs" {
    type = list
    validation {
        condition = length(var.database_subnet_cidrs) == 2
        error_message = "user/you have to provide 2 respective database_subnet cidr blocks"
    }
}

variable "database_subnet_tags" {
    default = {}
}

variable "db_subnet_group_tags" {
    default = {}

}

variable "public_route_table" {
    default = {}
}

variable "private_route_table" {
    default = {}
}

variable "database_route_table" {
    default = {}
}

variable "is_peering_required" {
    default = false
}

variable "peering_tags" {
    default = {}
}

variable "nat_gateway_tags" {
    default = {}
}