output "dns_name" {
  description = "The dns name of the VPN server."
  value       = replace(aws_ec2_client_vpn_endpoint.client-vpn-endpoint.dns_name, "*.", "random.")
}
