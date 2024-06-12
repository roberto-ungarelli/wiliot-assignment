resource "kubernetes_namespace" "wiliot-assignment" {
  metadata {
    name = "wiliot-assignment"
  }
  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "aws_route53_record" "env" {
  zone_id = var.route_53_zone_id
  name    = "*.${var.domain}"
  type    = "CNAME"
  ttl     = 300
  records = [var.loadbalancer_address]
}

