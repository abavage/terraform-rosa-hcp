locals {
  
  rosa_subnet_ids = concat(
    [data.aws_subnets.public_subnets.ids[0]],  
    data.aws_subnets.private_subnets.ids
  )

  all_rosa_subnet_ids = concat(
    data.aws_subnets.public_subnets.ids,  
    data.aws_subnets.private_subnets.ids
  )
  

  aws_zones = data.aws_availability_zones.available.names
  
  tags = {
    cluster_name = var.cluster_name
    region       = "ap-southeast-2"
    this         = "that"
    one          = "one"
    two          = "two"
  }


  labels = {
    "k8s.ovn.org/egress-assignable" = "",
    "the-role"                      = "blah"
  }

  taints = [{ 
     key = "nvidia.com/gpu"
     value = "present"
     schedule_type = "NoSchedule"
   }]


}
