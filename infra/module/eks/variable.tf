variable "addons" {
  type = map
  default = {
     vpc-cni      = "",
    kube-proxy   = "",
    coredns      = "",

  }
}
variable "eks_cluster_role" {
  type = string
  description = "name for EKS Cluster Role"
  default = "eks_cluster_role"
}

variable "eks_cluster_name" {
  description = "Name for the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "version for the kubernetes"
  type = string
  default = "1.29"
}

variable "subnet_ids" {
  description = "subnet id for creating cluster"
  type = list(string)
  default = [ "" ]
}
variable "eks_node_group_role" {
  type = string
  description = "role name for the EKS node group"
  default = "eks_node_role"
}

variable "eks_node_group_name" {
  description = "Name for the EKS node group"
  type        = string
}
variable "instance_types" {
  description = "List of EC2 instance types for the EKS node group"
  type        = list(string)
  default     = ["t3.micro"]
}

variable "desired_capacity" {
  description = "Desired number of nodes in the node group"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Maximum number of nodes in the node group"
  type        = number
  default     = 3
}

variable "min_capacity" {
  description = "Minimum number of nodes in the node group"
  type        = number
  default     = 1
}

variable "disk_size" {
  description = "Size of the EBS volume attached to the instances in GiB"
  type        = number
  default     = 20
}

variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) for instances in the node group"
  type        = string
  default     = "AL2_x86_64"
}

variable "capacity_type" {
  description = "Capacity type for instances in the node group (ON_DEMAND or SPOT)"
  type        = string
  default     = "ON_DEMAND"
}

