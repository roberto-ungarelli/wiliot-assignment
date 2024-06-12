
output "loadbalancer_address" {
  value = data.kubernetes_service.ingress_controller_service.status.0.load_balancer.0.ingress.0.hostname
}
