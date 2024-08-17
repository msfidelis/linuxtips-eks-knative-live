resource "kubernetes_namespace" "knative_serving" {
  metadata {
    name = "knative-serving"
  }

  depends_on = [helm_release.knative_operator]
}

resource "kubectl_manifest" "knative_serving" {

  yaml_body = <<YAML
apiVersion: operator.knative.dev/v1beta1
kind: KnativeServing
metadata:
  name: knative-serving
  namespace: knative-serving
spec:
  ingress:
    kourier:
      enabled: true
      service-type: NodePort
      http-port: 30080
  config:
    network:
      ingress-class: "kourier.ingress.networking.knative.dev"
  YAML

  depends_on = [
    kubernetes_namespace.knative_serving
  ]
}

resource "kubectl_manifest" "kourier_binding" {

  yaml_body = <<YAML
apiVersion: elbv2.k8s.aws/v1beta1
kind: TargetGroupBinding
metadata:
  name: kourier
  namespace: knative-serving
spec:
  serviceRef:
    name: kourier
    port: 80
  targetGroupARN: ${aws_lb_target_group.http.arn}
YAML

  depends_on = [
    kubernetes_namespace.knative_serving
  ]
}