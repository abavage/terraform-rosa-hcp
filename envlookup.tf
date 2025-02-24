data "aws_vpc" "get-rosa-vpc" {
  filter {
    name = "tag:Name"
    #values = ["rosa-hcp-0"]
    values = ["rosa-vpc"]
  }
}

output "got-the-rosa-vpc" {
  value = data.aws_vpc.get-rosa-vpc.id
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.get-rosa-vpc.id]
  }
}

# This split out the id's from above
data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.subnets.ids)
  id       = each.value
}

output "got-the-subnets" {
  value = data.aws_subnets.subnets.ids
}


###
# test this out public

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.get-rosa-vpc.id]
  }

  tags = {
    Name = "rosa-public-subnet*"
  }
}

# This split out the id's from above
data "aws_subnet" "public_subnets" {
  for_each = toset(data.aws_subnets.subnets.ids)
  id       = each.value
  
}

output "got-the-public-subnets" {
  value = tolist(data.aws_subnets.public_subnets.ids)[0]
}




#####
# test this out private

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.get-rosa-vpc.id]
  }

  tags = {
    Name = "rosa-private-subnet*"
  }
}

# This split out the id's from above
data "aws_subnet" "private_subnets" {
  for_each = toset(data.aws_subnets.subnets.ids)
  id       = each.value

}

output "got-the-private-subnets" {
  #value = "${slice(data.aws_subnets.private_subnets.ids, 0, 3)}"
  value = slice(data.aws_subnets.private_subnets.ids, 0, 3)
}

