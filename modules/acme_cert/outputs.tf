output "cert_pem" {
  value       = "${acme_certificate.certificate.certificate_pem}"
  sensitive   = true
  description = "Let's Encrypt managed cert that you provide to your load balancer config"
}

output "private_key_pem" {
  value       = "${acme_certificate.certificate.private_key_pem}"
  sensitive   = true
  description = "Let's Encrypt managed cert private key for generated certificate"
}

output "ca_cert_url" {
  value       = "${acme_certificate.certificate.certificate_url}"
  description = "Provides the CA and intermediate cert for Let's Encrypt"
}

output "issuer_pem" {
  value = "${acme_certificate.certificate.issuer_pem}"
}
