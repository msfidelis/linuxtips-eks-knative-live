resource "aws_eks_fargate_profile" "kube_system" {
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = "kube-system"
  pod_execution_role_arn = aws_iam_role.eks_fargate_role.arn
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1b.id,
    aws_subnet.private_subnet_1c.id
  ]

  selector {
    namespace = "kube-system"
  }
}

resource "aws_eks_fargate_profile" "prometheus" {
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = "prometheus"
  pod_execution_role_arn = aws_iam_role.eks_fargate_role.arn
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1b.id,
    aws_subnet.private_subnet_1c.id
  ]

  selector {
    namespace = "prometheus"
  }
}


resource "aws_eks_fargate_profile" "cert_manager" {
  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = "cert-manager"
  pod_execution_role_arn = aws_iam_role.eks_fargate_role.arn
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1b.id,
    aws_subnet.private_subnet_1c.id
  ]

  selector {
    namespace = "cert-manager"
  }
}

# resource "aws_eks_fargate_profile" "knative" {
#   cluster_name           = aws_eks_cluster.eks_cluster.name
#   fargate_profile_name   = "knative"
#   pod_execution_role_arn = aws_iam_role.eks_fargate_role.arn
#   subnet_ids = [
#     aws_subnet.private_subnet_1a.id,
#     aws_subnet.private_subnet_1b.id,
#     aws_subnet.private_subnet_1c.id
#   ]

#   selector {
#     namespace = "knative-operator"
#   }

#   selector {
#     namespace = "knative-serving"
#   }

#   selector {
#     namespace = "knative-eventing"
#   }

# }