data "aws_acm_certificate" "server" {
  domain   = var.server_ca_domain
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "client" {
  domain   = var.client_ca_domain
  statuses = ["ISSUED"]
}

resource "aws_ec2_client_vpn_endpoint" "client-vpn-endpoint" {
  description            = "terraform-vpn-client-endpoint"
  server_certificate_arn = data.aws_acm_certificate.server.arn
  client_cidr_block      = "10.0.100.0/22"
  dns_servers = var.dns_servers
  security_group_ids = [aws_security_group.openvpn.id]
  vpc_id      = data.aws_vpc.main.id

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = data.aws_acm_certificate.client.arn
  }

  connection_log_options {
    enabled               = false
/*    cloudwatch_log_group  = aws_cloudwatch_log_group.lg.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.ls.name*/
  }
}

resource "aws_ec2_client_vpn_network_association" "client-vpn-network-association" {
  for_each      = toset(data.aws_subnets.private.ids)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client-vpn-endpoint.id
  subnet_id              = each.value
}

resource "aws_ec2_client_vpn_route" "client-vpn-route" {
  for_each      = toset(data.aws_subnets.private.ids)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client-vpn-endpoint.id
  destination_cidr_block = "0.0.0.0/0"
  target_vpc_subnet_id   = each.value
  description            = "Internet Access"

  depends_on = [
    aws_ec2_client_vpn_endpoint.client-vpn-endpoint,
    aws_ec2_client_vpn_network_association.client-vpn-network-association
  ]
}

resource "aws_ec2_client_vpn_authorization_rule" "vpc_authorization_rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client-vpn-endpoint.id
  target_network_cidr = data.aws_vpc.main.cidr_block
  authorize_all_groups = true
}

resource "aws_ec2_client_vpn_authorization_rule" "internet_authorization_rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client-vpn-endpoint.id
  target_network_cidr    = "0.0.0.0/0"
  authorize_all_groups   = true
}