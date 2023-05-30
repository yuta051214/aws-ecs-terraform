module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  # VPC
  name = local.name
  cidr = "10.0.0.0/16"

  # サブネット
  azs             = ["${local.region}a", "${local.region}c"]
  public_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  public_subnet_names  = ["Public Subnet 1a", "Public Subnet 1c"]
  private_subnet_names = ["Private Subnet 1a", "Private Subnet 1c"]

  # DNS
  enable_dns_hostnames = true
  enable_dns_support   = true

  # NAT ゲートウェイ(各 public サブネットに１つずつ配置)
  enable_nat_gateway = true
}
