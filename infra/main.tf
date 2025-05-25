################################################################
#                        Networking                           #
################################################################


module "vpc" {
  source = "./module/networking/vpc"

  cidr_block                             = var.vpc_cidr
  vpc-name                               = var.vpc_name
  tags                                   = var.tags
  extra_tags                             = var.extra_tags
}

module "pvt-sub" {
  source = "./module/networking/subnet"
  for_each                               = { for pvt_subnets in flatten(local.pvt_subnets) : pvt_subnets.cidr_block => pvt_subnets }

  subnet-name                            = each.value.subnet_name
  cidr_block                             = each.value.cidr_block
  availability_zone                      = each.value.availability_zone
  vpc_id                                 = module.vpc.vpc_id
  tags                                   = var.tags
  extra_tags                             = var.extra_tags
}

module "pub-sub" {
  source = "./module/networking/subnet"
  for_each                               = { for pub_subnets in flatten(local.pub_subnets) : pub_subnets.cidr_block => pub_subnets }

  subnet-name                            = each.value.subnet_name
  cidr_block                             = each.value.cidr_block
  availability_zone                      = each.value.availability_zone
  vpc_id                                 = module.vpc.vpc_id
  tags                                   = var.tags
  extra_tags                             = var.extra_tags
}

module "eip" {
  source = "./module/networking/elastic-ip"

  eip-name                               = var.eip_name
  tags                                   = var.tags
  extra_tags                             = var.extra_tags
}

module "natgw" {
  source = "./module/networking/nat-gateway"

  ng-name                                = var.nat_gateway_name
  allocation_id                          = module.eip.eip_id
  subnet_id                              = local.pub_subnet_ids[0]
  tags                                   = var.tags
  extra_tags                             = var.extra_tags
}

module "internet_gateway" {
  source = "./module/networking/internet-gateway"

  ig-name                                = var.internet_gateway_name
  vpc_id                                 = module.vpc.vpc_id
  tags                                   = var.tags
  extra_tags                             = var.extra_tags
}

module "pub_route_table" {
  source = "./module/networking/route-table"

  rt-name                                = var.pub_route_table_name
  vpc_id                                 = module.vpc.vpc_id
  subnet_ids                             = concat(local.pub_subnet_ids)
  # subnet_ids = concat(    // This will give accosiate igw to all subnets 
  #   local.pub_subnet_ids,
  #   local.pvt_subnet_ids 
  # )
  tags                                   = var.tags
  extra_tags                             = var.extra_tags
}

module "pub_route" {
  source = "./module/networking/routes"

  route_table_id                         = module.pub_route_table.route_table_ids
  destination_cidr_block                 = var.pub_route_dest_cidr // 0.0.0.0/0
  gateway_id                             = module.internet_gateway.igw_id
}



module "pvt_route_table" {
  source = "./module/networking/route-table"

  rt-name                                = var.priv_route_table_name
  vpc_id                                 = module.vpc.vpc_id
  subnet_ids                             = concat(local.pvt_subnet_ids)
  tags                                   = var.tags
  extra_tags                             = var.extra_tags
}

module "pvt_route" {
  source = "./module/networking/routes"

  route_table_id                         = module.pvt_route_table.route_table_ids
  destination_cidr_block                 = var.priv_route_dest_cidr
  nat_gateway_id                         = module.natgw.natgw_ids
}


#################################################################
#                          EKS                  #
#################################################################
module "eks" {
  source = "./module/eks"
  eks_cluster_role                = var.eks_cluster_role
  eks_cluster_name                = var.eks_cluster_name
  kubernetes_version              = var.kubernetes_version
  eks_node_group_role             = var.eks_node_group_role
  eks_node_group_name             = var.eks_node_group_name
  desired_capacity                = var.desired_capacity
  max_capacity                    = var.max_capacity
  min_capacity                    = var.min_capacity
  ami_type                        = var.ami_type
  instance_types                  = var.instance_types
  capacity_type                   = var.capacity_type
  disk_size                       = var.disk_size
  addons                          = var.addons # Example addons
  subnet_ids                      = local.pvt_subnet_ids

}


# # #################################################################
# # #                          ECR                                  #
# # #################################################################
 module "ecr" {
  source   = "./module/ecr"

   for_each                              = var.repositories
   ecr_name                              = each.value.name
   tags                                  = var.tags
   extra_tags                            = var.extra_tags
  
}
