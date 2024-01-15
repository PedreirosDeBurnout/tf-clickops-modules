variable "project" {
  description = "Environment Identifier"
  type        = string
}

variable "stage" {
  description = "Stage of the environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "rds_subnet_group_name" {
  description = "RDS Subnet Group Name"
  type        = string
}

variable "security_group_name" {
  description = "Security Group Name"
  type        = string
  default     = "rds-sg"
}
