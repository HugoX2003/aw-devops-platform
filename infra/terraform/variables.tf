variable "db_password" {
  description = "Password del usuario admin de Aurora"
  type        = string
  sensitive   = true
}

variable "eks_vpc_id" {
  type        = string
  description = "VPC ID creada por el stack EKS"
}

variable "eks_private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs creadas por el stack EKS"
}