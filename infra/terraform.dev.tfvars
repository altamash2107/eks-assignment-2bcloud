tags = {

}

extra_tags = {
  Project          = "2bCloud EKS Assignement",
  Environment      = "Dev",
  TerraformManaged = true // Add tags here
}


#################################################################
#                          Networking                           #
#################################################################


vpc_cidr              = "172.40.0.0/16" // Change CIDR Range
vpc_name              = "dev-vpc-eks-assignment"
eip_name              = "dev-nat-elastic-ip-eks-assignment"
nat_gateway_name      = "dev-nat-gateway-eks-assignment"
internet_gateway_name = "dev-igw-eks-assignment"
pub_route_table_name  = "dev-pub-route-table-eks-assignment"
priv_route_table_name = "dev-pvt-route-table-eks-assignment"
pub_route_dest_cidr   = "0.0.0.0/0"
priv_route_dest_cidr  = "0.0.0.0/0"

#################################################################
#                          EKS                           #
#################################################################

eks_cluster_role         = "eks_cluster_role-eks-assignment"
eks_cluster_name         = "aws-eks-assignment-cluster"
kubernetes_version       = "1.28"
eks_node_group_role      = "eks_node_role-eks-assignment"
eks_node_group_name      = "aws-node-group-eks-assignment"
desired_capacity         =  2
max_capacity             =  2
min_capacity             =  1
ami_type                 = "AL2_x86_64"
instance_types           = ["t3.medium"] // Change instance type as per requirement
capacity_type            = "ON_DEMAND"
disk_size                =  20
addons                   = {
    vpc-cni      = "v1.19.5-eksbuild.3",
    kube-proxy   = "v1.28.15-eksbuild.20",
    coredns      = "v1.10.1-eksbuild.18",
  }


# #################################################################
# #                          ECR                                  #
# #################################################################
repositories = {
  "dev-backend-poc-repo" = {
    name                 = "dev-backend-eks-assignment-repo"
    image_tag_mutability = "MUTABLE"
    scan_on_push         = true
    tags = {

    }
  }

}