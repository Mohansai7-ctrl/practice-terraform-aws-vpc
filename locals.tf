locals {
    resourec_name = "${var.project}-${var.environment}"
    az_names = slice(data.aws_vpc.main.names, 0, 2)
}