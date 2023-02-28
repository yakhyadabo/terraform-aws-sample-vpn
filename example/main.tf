module "openvpn" {
  source               = "../module"
  region               = var.region
  environment          = var.project.environment
  vpc_name             = "${var.project.environment}-vpc"
  service_name         = var.service_name
  server_ca_domain     = var.server_ca_domain
  client_ca_domain     = var.client_ca_domain
}