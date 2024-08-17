
data "aws_ssm_parameter" "eks" {
  name = format("/aws/service/eks/optimized-ami/%s/amazon-linux-2/recommended/image_id", var.k8s_version)
}

resource "aws_launch_template" "main" {
  image_id = data.aws_ssm_parameter.eks.value
  name     = format("%s-template", var.cluster_name)

  update_default_version = true

  vpc_security_group_ids = [
    aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
  ]

  user_data = base64encode(templatefile(
    "${path.module}/files/user-data/userdata.tpl",
    {
      CLUSTER_NAME       = var.cluster_name,
      CLUSTER_ID         = var.cluster_name,
      APISERVER_ENDPOINT = aws_eks_cluster.eks_cluster.endpoint,
      B64_CLUSTER_CA     = aws_eks_cluster.eks_cluster.certificate_authority.0.data,
    }
  ))

  iam_instance_profile {
    name = aws_iam_instance_profile.nodes.name
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      "Name" : var.cluster_name,
      "aws-node-termination-handler/managed" = "true"
    }
  }
}
