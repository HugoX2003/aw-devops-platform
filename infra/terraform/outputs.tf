output "tf_nginx_service_hostname" {
  description = "DNS/hostname del LoadBalancer creado por el Service tf-nginx-service"
  value       = try(kubernetes_service.nginx.status.0.load_balancer.0.ingress.0.hostname, null)
}

output "tf_nginx_service_ip" {
  description = "IP del LoadBalancer (si aplica)"
  value       = try(kubernetes_service.nginx.status.0.load_balancer.0.ingress.0.ip, null)
}