resource "helm_release" "ingress-nginx" {
  name = "ingress-nginx"

  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  wait             = true
  timeout          = 600
  create_namespace = true

  set {
    name  = "letsEncrypt.ingress.class"
    value = "nginx"
  }
  set {
    name  = "ingress.extraAnnotations.'cert-manager.io/cluster-issuer'"
    value = "letsencrypt-prod"
  }
  set {
    name  = "controller.tcp.configMapNamespace"
    value = "ingress-nginx"
  }
  set {
    name  = "controller.extraArgs.tcp-services-configmap"
    value = "$(POD_NAMESPACE)/tcp-services"
  }
}

data "kubernetes_service" "ingress_controller_service" {
  depends_on = [
    helm_release.ingress-nginx
  ]
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}

resource "helm_release" "cert-manager" {
  name = "cert-manager"

  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  wait             = true
  create_namespace = true

  set {
    name  = "createCustomResource"
    value = "true"
  }
  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "kubectl_manifest" "cluster-issuer-prod" {
  yaml_body  = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
 name: letsencrypt-prod
spec:
 acme:
   server: https://acme-v02.api.letsencrypt.org/directory
   email: ${var.cluster_issuer_mail}
   privateKeySecretRef:
     name: letsencrypt-prod
   solvers:
   - http01:
       ingress:
         class: nginx
YAML
  depends_on = [helm_release.ingress-nginx]
}
