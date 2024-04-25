# resource "aws_eks_node_group" "private-nodes" {
#   cluster_name    = "eks-${var.product}-${var.environment}-cluster"
#   node_group_name = "eks-${var.product}-${var.environment}-manages-nodes"
#   node_role_arn   = aws_iam_role.eks-managed-nodes-role.arn

#   subnet_ids = [
#     var.subnet_ids.0 , var.subnet_ids.1
#   ]

#   capacity_type  = var.capacityType
#   instance_types = [var.instanceType]

#   scaling_config {
#     desired_size = var.desired_size
#     max_size     = var.max_size
#     min_size     = var.min_size
#   }

#   update_config {
#     max_unavailable = var.max_unavailable
#   }

#   labels = {
#     product = var.product,
#     environment = var.environment
#     clustername = "eks-${var.product}-${var.environment}-cluster"

#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.eks-workernode-eks-workernode-policy-attachment,
#     aws_iam_role_policy_attachment.nodes-eks-cni-policy-attachment,
#     aws_iam_role_policy_attachment.nodes-eks-EC2-container-registory-policy-attachment,
#   ]
# }