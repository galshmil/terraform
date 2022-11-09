#Create IAM Role For EKS Creation
resource "aws_iam_role" "gal_nodes" {
  name               = "gal_eks_nodes_group"
  assume_role_policy = <<POLICY
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "ec2.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
    POLICY
}

#Policy Creation For Worker Nodes [EKS Demand]
resource "aws_iam_role_policy_attachment" "gal_eks_workernode_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.gal_nodes.name
}

resource "aws_iam_role_policy_attachment" "gal_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.gal_nodes.name
}

resource "aws_iam_role_policy_attachment" "gal_ec2_container_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.gal_nodes.name
}

#Node Group Create
resource "aws_eks_node_group" "gal_node_group" {
  cluster_name    = aws_eks_cluster.gal_eks.name
  node_group_name = "gal_eks_workers_node"
  node_role_arn   = aws_iam_role.gal_nodes.arn
  subnet_ids = [
    aws_subnet.gal_private_subnet_01.id,
    aws_subnet.gal_private_subnet_02.id
  ]
  instance_types = ["t3.medium"]
  capacity_type  = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.gal_eks_workernode_policy,
    aws_iam_role_policy_attachment.gal_eks_cni_policy,
    aws_iam_role_policy_attachment.gal_ec2_container_registry_policy
  ]
}
