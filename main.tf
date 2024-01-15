#VPC
module "network" {
  source = "./modules/aws_vpc"

  name_prefix = var.name_prefix
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  azs         = var.azs
}
#!VPC
