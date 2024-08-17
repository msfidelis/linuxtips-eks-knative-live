resource "helm_release" "knative_operator" {
  namespace        = "knative-operator"
  create_namespace = true

  name  = "knative"
  chart = "./helm/knative"

  depends_on = [
    aws_eks_cluster.eks_cluster,
    kubernetes_config_map.aws-auth,
    aws_eks_fargate_profile.karpenter
  ]

}
