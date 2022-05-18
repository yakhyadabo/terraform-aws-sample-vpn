variable "region" {
  type = string
  default = "us-east-1"
}

variable "environment" {
  type = string
  description = "Deployment Environment"
}

variable "vpc_name" {
  type = string
  description = "The name of the vpc"
}

variable "service_name" {
  type = string
  description = "The name of the service deployed with the ELB"
}

variable "dns_servers" {
  type = list
  default = [
    "8.8.8.8",
    "1.1.1.1"
  ]
}