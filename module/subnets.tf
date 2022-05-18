# VPC of the subnets
data "aws_vpc" "main" {
  tags = {
    Name = var.vpc_name
    Environment = var.environment
  }
}

# Subnets
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  tags = {
    Zone = "private"
  }
}