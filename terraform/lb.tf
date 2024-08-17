resource "aws_lb" "ingress" {
  name               = var.cluster_name
  internal           = false
  load_balancer_type = "network"

  subnets = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1b.id,
    aws_subnet.public_subnet_1c.id
  ]

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = false

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_lb_target_group" "http" {
  name     = format("%s-http", var.cluster_name)
  port     = 30080
  protocol = "TCP"
  vpc_id   = aws_vpc.cluster_vpc.id

  # health_check {
  #   matcher             = "200-404"
  #   path                = "/"
  #   healthy_threshold   = "3"
  #   unhealthy_threshold = "10"
  #   interval            = "10"
  #   timeout             = "30"
  # }
}

resource "aws_lb_listener" "ingress_80" {
  load_balancer_arn = aws_lb.ingress.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}