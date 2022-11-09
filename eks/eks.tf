#Create IAM Role For EKS Creation
resource "aws_iam_role" "gal_eks_cluster" {
  name               = "gal_eks_cluster"
  assume_role_policy = <<POLICY
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "eks.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
    POLICY
}

#Attach Policy To Role
resource "aws_iam_role_policy_attachment" "gal_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.gal_eks_cluster.name
}

#EKS Cluster
resource "aws_eks_cluster" "gal_eks" {
  name     = "gal_eks"
  role_arn = aws_iam_role.gal_eks_cluster.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.gal_private_subnet_01.id,
      aws_subnet.gal_private_subnet_02.id
    ]
  }
  depends_on = [
    aws_iam_role_policy_attachment.gal_eks_cluster_policy
  ]
}
