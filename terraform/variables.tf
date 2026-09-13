variable "ami_id" {
  description = "Amazon Linux 2023 AMI ID"
  type        = string
  default     = "ami-0c0fd09cfe77b59dc"
}

variable "ingress_ports" {
  type    = list(number)
  default = [22, 80, 8080, 443, 9000, 3000]
}