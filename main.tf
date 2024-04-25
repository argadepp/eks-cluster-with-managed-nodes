

resource "aws_security_group" "all_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_iam_role" "eks-cluster-role" {
  name = "${var.product}-${var.environment}-cluster-role"

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



resource "aws_iam_role_policy_attachment" "eks-cluster-role-policy-aws_iam_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}


resource "aws_iam_role" "eks-managed-nodes-role" {
  name = "${var.product}-${var.environment}-node-instance-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks-workernode-policy-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-managed-nodes-role.name
}

resource "aws_iam_role_policy_attachment" "eks-cni-policy-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-managed-nodes-role.name
}

resource "aws_iam_role_policy_attachment" "eks-EC2-container-registory-policy-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-managed-nodes-role.name
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  iam_role_arn = aws_iam_role.eks-cluster-role.arn
  cluster_name = "eks-${var.product}-${var.environment}-cluster"
  cluster_version = var.cluster_version
    cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }


  vpc_id = var.vpc_id
  subnet_ids = [ var.subnet_ids.0  , var.subnet_ids.1 ]
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true

  aws_auth_accounts = ["734522607489"]
  aws_auth_users = [
    {
        userararn = "arn:aws:iam::734522607489:user/terraform"
        username = "terraform"
        groups = ["system:masters"]
    }
  ]

# eks_managed_node_group_defaults = {
#     instance_types = var.instanceType
# }

eks_managed_node_groups = {
      blue = {}
    green = {
      name = "${var.product}-${var.environment}"
      
      cluster_name = module.eks.cluster_name
      cluster_version = module.eks.cluster_version


      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.desired_size

      instance_types = var.instanceType
      capacity_type  = var.capacityType
    }

}

#   eks_managed_node_groups = {

#   node_group_name = "eks-${var.product}-${var.environment}-manages-nodes"

#   node_role_arn = aws_iam_role.eks-managed-nodes-role.arn

#   capacity_type = var.capacityType
#   instance_types = var.instanceType

#   min_size= var.min_size
#   max_size= var.max_size
#   desired_size= var.desired_size

#   max_unavailable= var.max_unavailable


#   depends_on = [
#     aws_iam_role_policy_attachment.eks-workernode-policy-attachment,
#     aws_iam_role_policy_attachment.eks-cni-policy-attachment,
#     aws_iam_role_policy_attachment.eks-EC2-container-registory-policy-attachment
#     ]
#   }

  tags = {
    Terraform = true
    Product = var.product
    Environment = var.environment
  }
  
}