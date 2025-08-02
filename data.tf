data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "get_rosa_vpc" {
  filter {
    name = "tag:Name"
    values = ["rosa-vpc"]
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.get_rosa_vpc.id]
  }

  tags = {
    Name = "rosa-public-subnet*"
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.get_rosa_vpc.id]
  }

  tags = {
    Name = "rosa-private-subnet*"
  }
}

data "aws_caller_identity" "current" {}




