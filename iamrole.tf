# resource "aws_iam_role" "eks-cluster-role" {
#   name = "${var.product}-${var.environment}-cluster-role"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "eks.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }



# resource "aws_iam_role_policy_attachment" "eks-cluster-role-policy-aws_iam_role_policy_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.eks-cluster-role.name
# }


# resource "aws_iam_role" "eks-managed-nodes-role" {
#   name = "${var.product}-${var.environment}-node-instance-role"

#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }

# resource "aws_iam_role_policy_attachment" "eks-workernode-policy-attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.eks-managed-nodes-role.name
# }

# resource "aws_iam_role_policy_attachment" "eks-cni-policy-attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.eks-managed-nodes-role.name
# }

# resource "aws_iam_role_policy_attachment" "eks-EC2-container-registory-policy-attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.eks-managed-nodes-role.name
# }
