
# Amazon Elastic Kubernetes Service (Amazon EKS)

## Overview

Amazon Elastic Kubernetes Service (Amazon EKS) is AWS's fully managed Kubernetes service, streamlining deployment and management of containerized applications. With high availability and seamless AWS integration, developers can focus on application development, leaving Kubernetes control plane and node management to Amazon EKS.


## Table of Contents

- [Prerequisites](#prerequisites)
- [Inputs](#inputs)
- [Module Usage](#module-usage)


## Prerequisites

Before using these Terraform modules, make sure you have the following prerequisites installed on your machine:

- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://aws.amazon.com/cli/)


## Inputs

| Name                  | Type          | Default      | Mandatory | Description                                                                                                                                                 |
|-----------------------|---------------|--------------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| eks_cluster_role      | string        |    "eks_cluster_role"          | No       | The IAM role for the EKS cluster.                                                                                                                           |
| eks_cluster_name      | string        |  | Yes       | The name of the EKS cluster.                                                                                                                                |
| kubernetes_version    | string        | "1.28"       | No        | The desired Kubernetes version for the EKS cluster.                                                                                                         |
| eks_node_group_role   | string        |    "eks_node_role"          | No       | The IAM role for the EKS node group.                                                                                                                        |
| eks_node_group_name   | string        |  | Yes      | The name of the EKS node group.                                                                                                                             |
| desired_capacity      | number        | 2            | No        | The desired number of nodes in the EKS node group.                                                                                                          |
| max_capacity          | number        | 3            | No        | The maximum number of nodes in the EKS node group.                                                                                                          |
| min_capacity          | number        | 1            | No        | The minimum number of nodes in the EKS node group.                                                                                                          |
| ami_type              | string        | "AL2_x86_64" | No        | The Amazon Machine Image (AMI) type for the EKS node group.                                                                                                 |
| instance_types        | list(string)  | ["t3.micro"] | No        | The EC2 instance types for the EKS node group.                                                                                                              |
| capacity_type         | string        | "ON_DEMAND"  | No        | The capacity type for the EKS node group.                                                                                                                   |
| disk_size             | number        | 20           | No        | The disk size (in GB) for the EKS node group instances.                                                                                                     |
| addons                | map(string)   | ""            | No        | Additional addons to be installed in the EKS cluster. Key-value pairs where the key is the addon name and the value is the version.                         |





## Module Usage

```hcl
module "eks" {
  source = "../eks"

eks_cluster_role         = "eks_cluster_role"
eks_cluster_name         = "aws-eks-cluster"
kubernetes_version       = "1.28"
eks_node_group_role      = "eks_node_role"
eks_node_group_name      = "aws-node-group"
desired_capacity         =  2
max_capacity             =  3
min_capacity             =  1
ami_type                 = "AL2_x86_64"
instance_types           = ["t3.micro"]
capacity_type            = "ON_DEMAND"
disk_size                =  20
addons                   = {
     vpc-cni      = "v1.16.2-eksbuild.1",
    kube-proxy   = "v1.28.2-eksbuild.2",
    coredns      = "v1.10.1-eksbuild.4",
    
  }
}  

```

