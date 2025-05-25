
resource "aws_iam_role" "eks_cluster" {
  name = var.eks_cluster_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com",
      },
    }],
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}


resource "aws_eks_cluster" "my_cluster" {
  name               = var.eks_cluster_name
  role_arn           = aws_iam_role.eks_cluster.arn
  version            = var.kubernetes_version 
  vpc_config {
    subnet_ids = var.subnet_ids  # Replace with your subnet IDs
  }
  depends_on = [aws_iam_role_policy_attachment.eks_cluster]
}

resource "aws_eks_addon" "addons" {
  for_each = var.addons

  cluster_name  = aws_eks_cluster.my_cluster.name
  addon_name    = each.key
  addon_version = each.value
}

//node group

resource "aws_iam_role" "eks_node_group" {
  name = var.eks_node_group_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_eks_node_group" "my-node" {
 cluster_name    = aws_eks_cluster.my_cluster.name
 node_group_name = var.eks_node_group_name
 node_role_arn   = aws_iam_role.eks_node_group.arn
 subnet_ids      = var.subnet_ids

 scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_capacity
    min_size     = var.min_capacity
 }

 ami_type       = var.ami_type
 instance_types = var.instance_types
 capacity_type = var.capacity_type
 disk_size      = var.disk_size

 depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy
 ]
}



